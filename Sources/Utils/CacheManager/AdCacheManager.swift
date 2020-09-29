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

struct AdCacheManager {

    static let `default` = AdCacheManager()

    // swiftlint:disable force_cast weak_delegate
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

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
            appDelegate.adSessionManager.totalRemove()
            items.filter { $0.videoUrl == nil }.forEach { ImageCache.default.removeImage(forKey: $0.thumb) }
        }
        // 没有缓存数据时 缓存数据
        if items.isEmpty {
            for showInfo in showList {
                if let itemInfo = adInfo.list.first(where: { $0.id == showInfo.id }) {
                    let cacheItem = storeData(itemInfo, showInfo)
                    downloadResource(itemInfo, cacheItem)
                }
            }
        }
    }

    func cachedShowItem() -> AdShowRealmModel? {
        let items = RealmManager.default.selectByAll(AdShowRealmModel.self)
        if items.isEmpty { return nil }
        let now = Int(Date().timeIntervalSince1970)
        let showItem = items.filter { $0.beginTime < now && $0.endTime > now }.first
        return showItem
    }

    private func downloadResource(_ itemInfo: AdItemModel, _ cacheItem: AdShowRealmModel) {
        if itemInfo.videoUrl != nil {
           downloadVideo(itemInfo, cacheItem)
        } else {
           downloadImage(itemInfo)
        }
    }

    private func downloadVideo(_ itemInfo: AdItemModel, _ cacheItem: AdShowRealmModel) {
        guard let videoUrl = itemInfo.videoUrl else { return }
        let task = appDelegate.adSessionManager.download(videoUrl)
        task?.success(handler: { (downloadTask) in
            log.info("广告视频下载成功: \(downloadTask.filePath)")
        })
        task?.failure(handler: { (downloadTask) in
            log.error("广告视频下载失败: \(downloadTask.filePath)")
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
                           _ showInfo: AdShowModel)
    -> AdShowRealmModel {
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
        return showItem
    }

}
