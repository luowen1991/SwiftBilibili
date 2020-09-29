//
//  AppDelegate.swift
//  SwiftBilibili
//
//  Created by luowen on 2020/9/2.
//  Copyright © 2020 luowen. All rights reserved.
//

import UIKit
import Tiercel

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    lazy var adSessionManager: SessionManager = {
        var configuration = SessionConfiguration()
        let path = Cache.defaultDiskCachePathClosure("ad")
        let cache = Cache("LaunchAdCacheManager", downloadPath: path)
        let manager = SessionManager("LaunchAdCacheManager", configuration: configuration, cache: cache, operationQueue: DispatchQueue(label: "com.Bilibili.SessionManager.operationQueue"))
        return manager
    }()

    var window: UIWindow?
    var dependency: AppDependency!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        self.dependency = self.dependency ?? CompositionRoot.resolve()
        self.window = self.dependency.window
        self.dependency.startNetworkStatusNotifier()
        self.dependency.loadLocalResource()
        self.dependency.setupRootViewController(window!)
        self.dependency.setupAppConfig()

        return true
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        LaunchAdManager.default.display()
        LaunchAdManager.default.loadSplashInfo()
    }

}
