//
//  File.swift
//  LWExtensionKit
//
//  Created by luowen on 2021/10/14.
//

import UIKit

private extension UIViewController {
    class var sharedApplication: UIApplication? {
        let selector = NSSelectorFromString("sharedApplication")
        return UIApplication.perform(selector)?.takeUnretainedValue() as? UIApplication
    }

    @objc static func swizzledPresent(_ viewControllerToPresent: UIViewController,
                                       animated flag: Bool,
                                       completion: (() -> Void)? = nil) {
        if #available(iOS 13.0, *) {
            if viewControllerToPresent.modalPresentationStyle == .automatic || viewControllerToPresent.modalPresentationStyle == .pageSheet {
                viewControllerToPresent.modalPresentationStyle = .fullScreen
            }
        }
        swizzledPresent(viewControllerToPresent, animated: flag, completion: completion)
    }
}

public extension ExtensionNameSpaceStatic where Base: UIViewController {

    var topMost: UIViewController? {
        guard let currentWindows = UIViewController.sharedApplication?.windows else { return nil }
        var rootViewController: UIViewController?
        for window in currentWindows {
            if let windowRootViewController = window.rootViewController, window.isKeyWindow {
                rootViewController = windowRootViewController
                break
            }
        }

        return baseType.ex.topMost(of: rootViewController)
    }

    func topMost(of viewController: UIViewController?) -> UIViewController? {
        // presented view controller
        if let presentedViewController = viewController?.presentedViewController {
            return baseType.ex.topMost(of: presentedViewController)
        }

        // UITabBarController
        if let tabBarController = viewController as? UITabBarController,
           let selectedViewController = tabBarController.selectedViewController {
            return baseType.ex.topMost(of: selectedViewController)
        }

        // UINavigationController
        if let navigationController = viewController as? UINavigationController,
           let visibleViewController = navigationController.visibleViewController {
            return baseType.ex.topMost(of: visibleViewController)
        }

        // UIPageController
        if let pageViewController = viewController as? UIPageViewController,
           pageViewController.viewControllers?.count == 1 {
            return baseType.ex.topMost(of: pageViewController.viewControllers?.first)
        }

        // child view controller
        for subview in viewController?.view?.subviews ?? [] {
            if let childViewController = subview.next as? UIViewController {
                return baseType.ex.topMost(of: childViewController)
            }
        }
        return viewController
    }

    func swizzlePresent() {
        let orginalSelector = #selector(UIViewController.present(_: animated: completion:))
        let swizzledSelector = #selector(UIViewController.swizzledPresent)

        guard let orginalMethod = class_getInstanceMethod(baseType, orginalSelector),
              let swizzledMethod = class_getInstanceMethod(baseType, swizzledSelector)
        else { return }

        let didAddMethod = class_addMethod(baseType,
                                           orginalSelector,
                                           method_getImplementation(swizzledMethod),
                                           method_getTypeEncoding(swizzledMethod))

        if didAddMethod {
            class_replaceMethod(baseType,
                                swizzledSelector,
                                method_getImplementation(orginalMethod),
                                method_getTypeEncoding(orginalMethod))
        } else {
            method_exchangeImplementations(orginalMethod, swizzledMethod)
        }
    }

}
