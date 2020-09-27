//
//  BBNavigationController.swift
//  SwiftBilibili
//
//  Created by luowen on 2020/9/4.
//  Copyright © 2020 luowen. All rights reserved.
//

import UIKit

class BBNavigationController: UINavigationController {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return self.topViewController?.preferredStatusBarStyle ?? .default
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationBar.isHidden = true
    }

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {

        if children.count > 1 {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        if #available(iOS 11.0, *) {
//            self.tabBar.height = Metric.tabBarHeight + self.view.safeAreaInsets.bottom
//        } else {
//            self.tabBar.height = Metric.tabBarHeight
//        }
//        self.tabBar.bottom = self.view.height
    }
}
