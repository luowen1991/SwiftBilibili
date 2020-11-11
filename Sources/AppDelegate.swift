//
//  AppDelegate.swift
//  SwiftBilibili
//
//  Created by luowen on 2020/9/2.
//  Copyright © 2020 luowen. All rights reserved.
//

import UIKit
import Tiercel
// swiftlint:disable force_cast
let appDelegate = UIApplication.shared.delegate as! AppDelegate
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var dependency: AppDependency!
    var adSessionManager: SessionManager!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        self.dependency = self.dependency ?? CompositionRoot.resolve()
        self.window = self.dependency.window
        self.adSessionManager = self.dependency.adSessionManager
        self.dependency.startNetworkStatusNotifier()
        self.dependency.loadLocalResource()
        self.dependency.setupAppConfig()
        self.dependency.setupRootViewController(window!)
        return true
    }

    func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {

        if adSessionManager.identifier == identifier {
            adSessionManager.completionHandler = completionHandler
        }
    }

}
