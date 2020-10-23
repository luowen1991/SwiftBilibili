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

    var enterForegroundProtocol: NSObjectProtocol?

    init() {
        enterForegroundProtocol = NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: OperationQueue.main) { (_) in
            LaunchAdManager.default.display()
            LaunchAdManager.default.loadSplashInfo()
        }
    }

    deinit {
        enterForegroundProtocol = nil
    }

    func display() {
        // 显示广告
        let showTime = UserDefaultsManager.splash.adShowTime
        let minInterval = UserDefaultsManager.splash.adMinInterval
        if let cacheAdItem = AdCacheManager.default.cachedShowItem(),
           Utils.currentAppTime() - showTime >= minInterval {
            UserDefaultsManager.splash.adShowTime = Utils.currentAppTime()
            let config = LaunchAdConfig()
            config.duration = cacheAdItem.duration
            config.adType = cacheAdItem.videoUrl == nil ? .image : .video
            config.videoNameOrURLString = cacheAdItem.videoUrl
            config.imageNameOrURLString = cacheAdItem.thumb
            LaunchAd.display(with: config, delegate: self)
        }
        // 加载广告
        let loadTime = UserDefaultsManager.splash.adLoadTime
        let pullInterval = UserDefaultsManager.splash.adPullInterval
        if Utils.currentAppTime() - loadTime >= pullInterval {
            ConfigAPI.adList.request()
                .mapObject(AdInfoModel.self)
                .subscribe(onSuccess: { (adInfo) in
                    UserDefaultsManager.splash.adPullInterval = adInfo.pullInterval
                    UserDefaultsManager.splash.adMinInterval = adInfo.minInterval
                    UserDefaultsManager.splash.adLoadTime = Utils.currentAppTime()
                    AdCacheManager.default.storeAdData(adInfo)
                })
                .disposed(by: disposeBag)
        }
    }

    func loadSplashInfo() {

        let loadTime = UserDefaultsManager.splash.splashLoadTime
        let pullInterval = UserDefaultsManager.splash.splashPullInterval

        if Utils.currentAppTime() - loadTime >= pullInterval {
            ConfigAPI.splashList
                .request()
                .mapObject(SplashInfoModel.self)
                .subscribe(onSuccess: { (splashInfo) in
                    UserDefaultsManager.splash.splashLoadTime = Utils.currentAppTime()
                    UserDefaultsManager.splash.splashPullInterval = splashInfo.pullInterval
                    SplashCacheManager.default.storeSplashData(splashInfo)
                })
                .disposed(by: disposeBag)
        }
    }
}

extension LaunchAdManager: LaunchAdDelegate {

}
