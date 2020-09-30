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
