//
//  CompositionRoot.swift
//  SwiftBilibili
//
//  Created by luowen on 2020/9/4.
//  Copyright © 2020 luowen. All rights reserved.
//  swiftlint:disable force_try

import UIKit
import SwiftyUserDefaults
import Then
import ObjectMapper
import SnapKit
import Toast_Swift
import Moya
import SwiftDate
import URLNavigator
import Tiercel
import LWNetwork
import LWExtensionKit
import BBNetworkEx

struct AppDependency {

    let window: UIWindow
    let adSessionManager: SessionManager
    let startNetworkStatusNotifier: () -> Void
    let loadLocalResource: () -> Void
    let setupAppConfig: () -> Void
    let setupRootViewController: (UIWindow) -> Void

}

final class CompositionRoot {

    static func resolve() -> AppDependency {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.backgroundColor = .white
        window.makeKeyAndVisible()

        var configuration = SessionConfiguration()
        configuration.allowsCellularAccess = true
        let path = Cache.defaultDiskCachePathClosure("ad")
        let cache = Cache("LaunchAdCacheManager", downloadPath: path)
        let manager = SessionManager("LaunchAdCacheManager", configuration: configuration, cache: cache, operationQueue: DispatchQueue(label: "com.Bilibili.SessionManager.operationQueue"))

        let navigator = Navigator()
        Router.initialize(navigator: navigator)
        HomeRouter.initialize(navigator: navigator)

        return AppDependency(window: window,
                             adSessionManager: manager,
                             startNetworkStatusNotifier: startNetworkStatusNotifier,
                             loadLocalResource: loadLocalResource,
                             setupAppConfig: setupAppConfig,
                             setupRootViewController: setupRootViewController
        )
    }

    static func loadLocalResource() {

        print("沙盒地址: \(NSHomeDirectory())")

        let path = Bundle.main.path(forResource: "MainStyle", ofType: "json")
        let url = URL(fileURLWithPath: path!)
        let data = try! Data(contentsOf: url)
        let jsonData = try! JSONSerialization.jsonObject(with: data, options: .mutableContainers)
        guard let jsonDic = jsonData as? [String : Any] else {
            return
        }
        let styleData = jsonDic["style"]
        let models = try! Mapper<ThemeMainStyleModel>().mapArray(JSONObject: styleData!)
        ThemeManager.shared.mainStyleModels = models
    }

    static func startNetworkStatusNotifier() {
        NetworkReachabilityManager.startListening { status in
            print("当前的网络状态: \(status)")
        }
    }

    static func setupRootViewController(_ window: UIWindow) {

        var presentMainScreen: () -> Void

        presentMainScreen = {
            let tabBar = BaseTabBarController()
            window.rootViewController = tabBar
        }

        let splashViewController = SplashViewController(presentMainScreen: presentMainScreen)

        window.rootViewController = splashViewController
    }

    static func setupAppConfig() {

        // 适配ios13，将present变为全屏
        UIViewController.ex.swizzlePresent()

        // 设置网络通用参数
        Network.Configuration.shared.replacingTask = { target in
            let additionDictionary = ParamrtersUtils.commonParameters
            if let parameters = target.parameters {
                var requestDictionary = parameters.values
                additionDictionary.forEach { requestDictionary[$0.key] = $0.value }
                return .requestParameters(parameters: requestDictionary, encoding: parameters.encoding)
            } else {
                let encoding: ParameterEncoding = target.method == .post ? JSONEncoding.default : URLEncoding.default
                return .requestParameters(parameters: additionDictionary, encoding: encoding)
            }
        }

        // 设置全局toast的样式
        var style = ToastStyle()
        style.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        style.cornerRadius = 6
        style.horizontalPadding = 10
        style.verticalPadding = 12
        style.messageAlignment = .center
        style.titleAlignment = .center
        style.titleFont = Font.appFont(ofSize: 17)
        style.messageFont = Font.appFont(ofSize: 15)
        ToastManager.shared.style = style

        // 设置时区
        let china = Region(calendar: Calendars.chinese, zone: Zones.asiaShanghai, locale: Locales.chinese)
        SwiftDate.defaultRegion = china
    }
}
