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

    func storeAdData(_ adInfo: AdInfoModel) throws {
//        guard let showList = adInfo.show else {
//            log.debug("没有需要显示的广告")
//            return
//        }
//        // 如果新的数据和数据库的数据不一样，就清空数据库
//        let items = try AdShowRealmModel.lw.all()
//        if !items.isEmpty,
//           !showList.contains(where: {$0.id == items.first?.id}) {
//            try AdShowRealmModel.lw.deleteAll()
//            adSessionManager.totalRemove()
//            items.filter { $0.videoUrl == nil }.forEach { ImageCache.default.removeImage(forKey: $0.thumb) }
//        }
//        // 没有缓存数据时 缓存数据
//        if items.isEmpty, let list = adInfo.list {
//            for showInfo in showList {
//                if let itemInfo = list.first(where: { $0.id == showInfo.id }) {
//                    downloadResource(itemInfo, compltetionHandler: {[weak self] isSuccess in
//                        guard let self = self,isSuccess else { return }
//                        try? self.storeData(itemInfo, showInfo)
//                    })
//                }
//            }
//        }
    }

//    func cachedShowItem() -> AdShowRealmModel? {
//
//        guard let items = try? AdShowRealmModel.lw.all(),
//              !items.isEmpty else {
//            return nil
//        }
//        let now = Utils.currentAppTime()
//        let showItem = items.filter { $0.beginTime < now && $0.endTime > now }.first
//        return showItem
//    }

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

    private func downloadResource(_ itemInfo: AdItemModel, compltetionHandler: @escaping (Bool) -> Void) {
        if itemInfo.videoUrl != nil {
           downloadVideo(itemInfo, compltetionHandler: compltetionHandler)
        } else {
           downloadImage(itemInfo, compltetionHandler: compltetionHandler)
        }
    }

    private func downloadVideo(_ itemInfo: AdItemModel, compltetionHandler: @escaping (Bool) -> Void) {
        guard let videoUrl = itemInfo.videoUrl
        else { return }
        adSessionManager.download(videoUrl)?
            .success(handler: { (downloadTask) in
                log.info("广告视频下载成功: \(downloadTask.filePath)")
                compltetionHandler(true)
            })
            .failure(handler: { (downloadTask) in
                log.error("广告视频下载失败: \(downloadTask.error?.localizedDescription ?? "")")
                compltetionHandler(false)
            })
    }

    private func downloadImage(_ itemInfo: AdItemModel, compltetionHandler: @escaping (Bool) -> Void) {
        if !ImageCache.default.isCached(forKey: itemInfo.thumb) {
            ImageDownloader.default.downloadImage(with: URL(string: itemInfo.thumb)!, completionHandler: { (result) in
                switch result {
                case .success(let loadResult):
                    ImageCache.default.store(loadResult.image, forKey: itemInfo.thumb)
                    log.info("广告图下载成功: \(ImageCache.default.cachePath(forKey: itemInfo.thumb))")
                    compltetionHandler(true)
                case .failure(let error):
                    log.error(error.errorDescription ?? "广告图片加载失败")
                    compltetionHandler(false)
                }
            })
        }
    }

    // 保存数据
//    private func storeData(_ itemInfo: AdItemModel,
//                           _ showInfo: AdShowModel) throws {
//        let showItem = AdShowRealmModel()
//        showItem.beginTime = showInfo.stime
//        showItem.endTime = showInfo.etime
//        showItem.id = itemInfo.id
//        showItem.duration = itemInfo.duration
//        showItem.uri = itemInfo.uri
//        showItem.thumb = itemInfo.thumb
//        showItem.uriTitle = itemInfo.uriTitle
//        showItem.skip = itemInfo.skip
//        showItem.isAd = itemInfo.isAd
//        showItem.videoUrl = itemInfo.videoUrl
//        showItem.cardType = itemInfo.cardType.rawValue
//        try showItem.lw.save(update: .all)
//    }

    private var adSessionManager: SessionManager = appDelegate.adSessionManager
}
