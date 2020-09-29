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

struct AppDependency {

    let window: UIWindow
    let startNetworkStatusNotifier: () -> Void
    let loadLocalResource: () -> Void
    let setupRootViewController: (UIWindow) -> Void
    let setupAppConfig: () -> Void
}

final class CompositionRoot {

    static func resolve() -> AppDependency {

        let window = UIWindow(frame: UIScreen.main.bounds)
        window.backgroundColor = .white
        window.makeKeyAndVisible()

        return AppDependency(window: window,
                             startNetworkStatusNotifier: startNetworkStatusNotifier,
                             loadLocalResource: loadLocalResource,
                             setupRootViewController: setupRootViewController,
                             setupAppConfig: setupAppConfig)
    }

    static func loadLocalResource() {

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
        NetStatusManager.default.startNetworkStatusNotifier()
    }

    static func setupRootViewController(_ window: UIWindow) {

        var presentMainScreen: () -> Void

        presentMainScreen = {
            let tabBar = BBTabBarController()
            window.rootViewController = tabBar
        }

        let splashViewController = SplashViewController(presentMainScreen: presentMainScreen)

        window.rootViewController = splashViewController
    }

    static func setupAppConfig() {

        // 设置网络偏好设置
        // 添加全局默认参数
        Network.Configuration.default.replacingTask = { target in
            switch target.task {
            case .requestParameters(var parameters, let encoding):
                let additionalParameters = RequestParamsManager.defaultParameters()
                additionalParameters.forEach { parameters[$0.key] = $0.value }
                return .requestParameters(parameters: parameters, encoding: encoding)
            default:
                return target.task
            }
        }

        // 设置全局toast的样式

        // 设置时区
    }
}
