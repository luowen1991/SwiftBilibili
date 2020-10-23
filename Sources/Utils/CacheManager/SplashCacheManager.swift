//
//  SplashCacheManager.swift
//  SwiftBilibili
//
//  Created by luowen on 2020/9/11.
//  Copyright © 2020 luowen. All rights reserved.
//

import Foundation

import Kingfisher
import RealmSwift
import RxRealm
import RxSwift

enum CacheImageType {
    case logo
    case content
}

struct SplashCacheManager {

    static let `default` = SplashCacheManager()

    func storeSplashData(_ splashInfo: SplashInfoModel) {
        // 如果新的数据和数据库的数据不一样，就清空数据库
        let items = RealmManager.default.selectByAll(SplashShowRealmModel.self)
        if !items.isEmpty,
           !splashInfo.show.contains(where: {$0.id == items.first?.id}) {
            RealmManager.default.deleteAll()
            items.forEach { ImageCache.default.removeImage(forKey: $0.thumb) }
        }

        // 没有缓存数据时 缓存数据
        if items.isEmpty {
            for showInfo in splashInfo.show {
                if let itemInfo = splashInfo.list.first(where: { $0.id == showInfo.id }) {
                    downloadImage(itemInfo)
                    storeData(showInfo, itemInfo)
                }
            }
        }
    }

    func cachedShowItem() -> SplashShowRealmModel? {
        let items = RealmManager.default.selectByAll(SplashShowRealmModel.self)
        if items.isEmpty { return nil }
        let now = Utils.currentAppTime()
        var showItem = items.filter { $0.beginTime < now && $0.endTime > now && !$0.isShow }.first
        if showItem != nil {
            RealmManager.default.addCanUpdate { () -> (SplashShowRealmModel) in
                showItem!.isShow = true
                return showItem!
            }
        } else { // 全部都显示过了 那就取出第一个
            RealmManager.default.realm.beginWrite()
            for (index, item) in items.enumerated() {
                item.isShow = index == 0
                RealmManager.default.realm.add(item)
            }
            do {
                try RealmManager.default.realm.commitWrite()
            } catch {}
            showItem = items.first
        }
        return showItem
    }

    func cachedImage(_ type: CacheImageType, completionHandler: ((UIImage?,SplashLogoPosition,SplashShowType,Double) -> Void)?) {
        if let cachedShowItem = self.cachedShowItem() {
            let logoPosition = SplashLogoPosition(rawValue: cachedShowItem.logoPosition) ?? .center
            let showType = SplashShowType(rawValue: cachedShowItem.mode) ?? .half
            switch type {
            case .content:
                ImageCache.default.retrieveImage(forKey: cachedShowItem.thumb) { (result) in
                    switch result {
                    case .success(let cache):
                        completionHandler?(cache.image,logoPosition,showType, Double(cachedShowItem.duration))
                    case .failure:
                        completionHandler?(nil,logoPosition,showType,Double(cachedShowItem.duration))
                    }
                }
            case .logo:
                ImageCache.default.retrieveImage(forKey: cachedShowItem.logoUrl) { (result) in
                    switch result {
                    case .success(let cache):
                        completionHandler?(cache.image,logoPosition,showType, Double(cachedShowItem.duration))
                    case .failure:
                        completionHandler?(nil,logoPosition,showType,Double(cachedShowItem.duration))
                    }
                }
            }
        } else {
            completionHandler?(nil,.center,.half,700)
        }
    }

    // 下载图片
    private func downloadImage(_ itemInfo: SplashItemModel) {
        if !ImageCache.default.isCached(forKey: itemInfo.thumb) {
            ImageDownloader.default.downloadImage(with: URL(string: itemInfo.thumb)!, completionHandler: { (result) in
                switch result {
                case .success(let loadResult):
                    ImageCache.default.store(loadResult.image, forKey: itemInfo.thumb)
                    log.info("开屏图下载成功: \(ImageCache.default.cachePath(forKey: itemInfo.thumb))")
                case .failure(let error):
                    log.error(error.errorDescription ?? "开屏图加载失败")
                }
            })
        }
        if !ImageCache.default.isCached(forKey: itemInfo.logoUrl) {
            ImageDownloader.default.downloadImage(with: URL(string: itemInfo.logoUrl)!, completionHandler: { (result) in
                switch result {
                case .success(let loadResult):
                    ImageCache.default.store(loadResult.image, forKey: itemInfo.logoUrl)
                    log.info("开屏logo图下载成功: \(ImageCache.default.cachePath(forKey: itemInfo.logoUrl))")
                case .failure(let error):
                    log.error(error.errorDescription ?? "开屏logo图下载成功")
                }
            })
        }
    }

    // 保存数据
    private func storeData(_ showInfo: SplashShowModel,
                           _ itemInfo: SplashItemModel) {
        let showItem = SplashShowRealmModel()
        showItem.beginTime = showInfo.beginTime
        showItem.endTime = showInfo.endTime
        showItem.id = showInfo.id
        showItem.logoUrl = itemInfo.logoUrl
        showItem.thumb = itemInfo.thumb
        showItem.duration = showInfo.duration
        showItem.mode = itemInfo.mode.rawValue
        showItem.logoPosition = showInfo.logoPosition.rawValue
        RealmManager.default.add(showItem)
    }
}
