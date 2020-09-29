//
//  LaunchAdManager.swift
//  SwiftBilibili
//
//  Created by luowen on 2020/9/28.
//  Copyright © 2020 luowen. All rights reserved.
//

import UIKit
import RxSwift

class LaunchAdManager {

    static let `default` = LaunchAdManager()

    var disposeBag = DisposeBag()

    func display() {
        // 显示广告
        let showTime = UserDefaultsManager.app.adShowTime
        let minInterval = UserDefaultsManager.app.adMinInterval
        if let cacheAdItem = AdCacheManager.default.cachedShowItem(),
           Utils.currentAppTime() - showTime >= minInterval {
            UserDefaultsManager.app.adShowTime = Utils.currentAppTime()
            let config = LaunchAdConfig()
            config.duration = cacheAdItem.duration
            config.adType = cacheAdItem.videoUrl == nil ? .image : .video
            config.videoNameOrURLString = cacheAdItem.videoUrl
            config.imageNameOrURLString = cacheAdItem.thumb
            LaunchAd.display(with: config, delegate: self)
        }
        // 加载广告
        let loadTime = UserDefaultsManager.app.adLoadTime
        let pullInterval = UserDefaultsManager.app.adPullInterval
        if Utils.currentAppTime() - loadTime >= pullInterval {
            ConfigAPI.adList.request()
                .mapObject(AdInfoModel.self)
                .subscribe(onSuccess: { (adInfo) in
                    UserDefaultsManager.app.adPullInterval = adInfo.pullInterval
                    UserDefaultsManager.app.adMinInterval = adInfo.minInterval
                    UserDefaultsManager.app.adLoadTime = Utils.currentAppTime()
                    AdCacheManager.default.storeAdData(adInfo)
                })
                .disposed(by: disposeBag)
        }
    }

    func loadSplashInfo() {

        let loadTime = UserDefaultsManager.app.splashLoadTime
        let pullInterval = UserDefaultsManager.app.splashPullInterval

        if Utils.currentAppTime() - loadTime >= pullInterval {
            ConfigAPI.splashList
                .request()
                .mapObject(SplashInfoModel.self)
                .trackError(NetErrorManager.default.errorIndictor)
                .subscribe(onSuccess: { (splashInfo) in
                    UserDefaultsManager.app.splashLoadTime = Utils.currentAppTime()
                    UserDefaultsManager.app.splashPullInterval = splashInfo.pullInterval
                    SplashCacheManager.default.storeSplashData(splashInfo)
                })
                .disposed(by: disposeBag)
        }
    }
}

extension LaunchAdManager: LaunchAdDelegate {

    func launchAd(_ launchAd: LaunchAd, display imageView: UIImageView, forUrl url: String) {

    }

}
