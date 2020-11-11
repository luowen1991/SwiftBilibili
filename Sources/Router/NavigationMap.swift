//
//  NavigationMap.swift
//  SwiftBilibili
//
//  Created by luowen on 2020/10/27.
//  Copyright © 2020 luowen. All rights reserved.
//

import URLNavigator

enum NavigationMap {

    static func initialize(navigator: NavigatorType) {
        navigator.register("http://<path:_>", self.webViewControllerFactory)
        navigator.register("https://<path:_>", self.webViewControllerFactory)
        navigator.register("bilibili://pegasus/op/<int:id>") { _, values, _ in
            guard let id = values["id"] as? Int else { return nil }
            return HomeOptionalViewController(id: id)
        }
        navigator.register("bilibili://live/home") { _, _, _ in
            return HomeLiveViewController()
        }
        navigator.register("bilibili://pegasus/promo") { _, _, _ in
            return HomePromoViewController()
        }
        navigator.register("bilibili://pegasus/hottopic") { _, _, _ in
            return HomeHotViewController()
        }
        navigator.register("bilibili://pgc/home") { _, _, _ in
            return HomeBangumiViewController()
        }
        navigator.register("bilibili://pgc/cinema-tab") { _, _, _ in
            return HomeCinemaViewController()
        }
        navigator.register("bilibili://pgc/activity-tab") { _, _, _ in
            return HomeActivityViewController()
        }
        navigator.handle("bilibili://alert", self.alert(navigator: navigator))
        navigator.handle("bilibili://<path:_>") { (_, _, _) -> Bool in
            // No navigator match, do analytics or fallback function here
            print("[Navigator] NavigationMap.\(#function):\(#line) - global fallback function is called")
            return true
        }
    }

    private static func webViewControllerFactory(
        url: URLConvertible,
        values: [String: Any],
        context: Any?
    ) -> UIViewController? {
        guard let url = url.urlValue else { return nil }
        return BaseWebViewController(url: url.absoluteString)
    }

    private static func alert(navigator: NavigatorType) -> URLOpenHandlerFactory {
        return { url, values, context in
            guard let title = url.queryParameters["title"] else { return false }
            let message = url.queryParameters["message"]
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            navigator.present(alertController)
            return true
        }
    }

}
