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

struct SplashCacheManager {

    func saveSplashData(_ splashInfo: SplashInfoModel) {
        for showInfo in splashInfo.show {
            if let itemInfo = splashInfo.list.first(where: { $0.id == showInfo.id }) {
                downloadImage(itemInfo)
                saveData(showInfo, itemInfo)
            }
        }
    }

    func getShowItem() -> SplashShowRealmModel? {
        let items = RealmManager.default.selectByAll(SplashShowRealmModel.self)
        if items.isEmpty { return nil }
        let now = Int(Date().timeIntervalSince1970)
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

    // 下载图片
    private func downloadImage(_ itemInfo: SplashItemModel) {
        if !ImageCache.default.isCached(forKey: itemInfo.thumb) {
            ImageDownloader.default.downloadImage(with: URL(string: itemInfo.thumb)!, completionHandler: { (result) in
                switch result {
                case .success(let loadResult):
                    ImageCache.default.store(loadResult.image, forKey: itemInfo.thumb)
                case .failure(let error):
                    log.error(error.errorDescription ?? "开屏图加载失败")
                }
            })
        }
    }

    // 保存数据
    private func saveData(_ showInfo: SplashShowModel,
                          _ itemInfo: SplashItemModel) {
        let showItem = SplashShowRealmModel()
        showItem.beginTime = showInfo.beginTime
        showItem.endTime = showInfo.endTime
        showItem.id = showInfo.id
        showItem.logoUrl = itemInfo.logoUrl
        showItem.thumb = itemInfo.thumb
        showItem.duration = showInfo.duration
        RealmManager.default.add(showItem)
    }
}
