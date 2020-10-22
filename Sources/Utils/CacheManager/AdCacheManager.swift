//
//  AdCacheManager.swift
//  SwiftBilibili
//
//  Created by luowen on 2020/9/28.
//  Copyright © 2020 luowen. All rights reserved.
//

import Foundation
import Kingfisher
import Tiercel

class AdCacheManager {

    static let `default` = AdCacheManager()

    func storeAdData(_ adInfo: AdInfoModel) {
        guard let showList = adInfo.show else {
            log.debug("没有需要显示的广告")
            return
        }
        // 如果新的数据和数据库的数据不一样，就清空数据库
        let items = RealmManager.default.selectByAll(AdShowRealmModel.self)
        if !items.isEmpty,
           !showList.contains(where: {$0.id == items.first?.id}) {
            RealmManager.default.deleteAll()
            adSessionManager.totalRemove()
            items.filter { $0.videoUrl == nil }.forEach { ImageCache.default.removeImage(forKey: $0.thumb) }
        }
        // 没有缓存数据时 缓存数据
        if items.isEmpty {
            for showInfo in showList {
                if let itemInfo = adInfo.list.first(where: { $0.id == showInfo.id }) {
                    storeData(itemInfo, showInfo)
                    downloadResource(itemInfo)
                }
            }
        }
    }

    func cachedShowItem() -> AdShowRealmModel? {
        let items = RealmManager.default.selectByAll(AdShowRealmModel.self)
        if items.isEmpty { return nil }
        let now = Utils.currentAppTime()
        let showItem = items.filter { $0.beginTime < now && $0.endTime > now }.first
        return showItem
    }

    func cachedImage(url: String, completionHandler: ((UIImage?) -> Void)?) {
        ImageCache.default.retrieveImage(forKey: url) { (result) in
            switch result {
            case .success(let cache):
                completionHandler?(cache.image)
            case .failure:
                completionHandler?(nil)
            }
        }
    }

    func cachedFileURL(url: String) -> URL? {
        guard let filePath = adSessionManager.cache.filePath(url: url) else {
            return nil
        }
        return URL(fileURLWithPath: filePath)
    }

    private func downloadResource(_ itemInfo: AdItemModel) {
        if itemInfo.videoUrl != nil {
           downloadVideo(itemInfo)
        } else {
           downloadImage(itemInfo)
        }
    }

    private func downloadVideo(_ itemInfo: AdItemModel) {
        guard let videoUrl = itemInfo.videoUrl,
              adSessionManager.cache.filePath(url: videoUrl) == nil
        else { return }
        adSessionManager.download(videoUrl)?
            .success(handler: { (downloadTask) in
                log.info("广告视频下载成功: \(downloadTask.filePath)")
            })
            .failure(handler: { (downloadTask) in
                log.error("广告视频下载失败: \(downloadTask.error?.localizedDescription ?? "")")
            })
    }

    private func downloadImage(_ itemInfo: AdItemModel) {
        if !ImageCache.default.isCached(forKey: itemInfo.thumb) {
            ImageDownloader.default.downloadImage(with: URL(string: itemInfo.thumb)!, completionHandler: { (result) in
                switch result {
                case .success(let loadResult):
                    ImageCache.default.store(loadResult.image, forKey: itemInfo.thumb)
                    log.info("广告图下载成功: \(ImageCache.default.cachePath(forKey: itemInfo.thumb))")
                case .failure(let error):
                    log.error(error.errorDescription ?? "广告图片加载失败")
                }
            })
        }
    }

    // 保存数据
    private func storeData(_ itemInfo: AdItemModel,
                           _ showInfo: AdShowModel) {
        let showItem = AdShowRealmModel()
        showItem.beginTime = showInfo.stime
        showItem.endTime = showInfo.etime
        showItem.id = itemInfo.id
        showItem.duration = itemInfo.duration
        showItem.uri = itemInfo.uri
        showItem.thumb = itemInfo.thumb
        showItem.uriTitle = itemInfo.uriTitle
        showItem.skip = itemInfo.skip
        showItem.isAd = itemInfo.isAd
        showItem.videoUrl = itemInfo.videoUrl
        RealmManager.default.add(showItem)
    }

    private lazy var adSessionManager: SessionManager = {
        var configuration = SessionConfiguration()
        let path = Cache.defaultDiskCachePathClosure("ad")
        let cache = Cache("LaunchAdCacheManager", downloadPath: path)
        let manager = SessionManager("LaunchAdCacheManager", configuration: configuration, cache: cache, operationQueue: DispatchQueue(label: "com.Bilibili.SessionManager.operationQueue"))
        return manager
    }()
}
