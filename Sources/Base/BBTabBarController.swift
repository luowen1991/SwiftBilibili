//
//  BBTabBarController.swift
//  SwiftBilibili
//
//  Created by luowen on 2020/9/4.
//  Copyright © 2020 luowen. All rights reserved.
//

import UIKit

import EachNavigationBar

final class BBTabBarController: UITabBarController {

    fileprivate struct Metric {
        static let tabBarHeight = 49.f
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.theme.barTintColor = themed { $0.mainColorModel.ga0S }

        addChildController(HomeMainViewController(), "首页", Image.TabBar.homeNormal, Image.TabBar.homeSelected)
        addChildController(ChannelViewController(), "频道", Image.TabBar.channelNormal, Image.TabBar.channelSelected)
        addChildController(DynamicViewController(), "动态", Image.TabBar.dynamicNormal, Image.TabBar.dynamicSelected)
        addChildController(MemberViewController(), "会员购", Image.TabBar.memberNormal, Image.TabBar.memberSelected)
        addChildController(MineViewController(), "我的", Image.TabBar.mineNormal, Image.TabBar.mineSelected)

    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if #available(iOS 11.0, *) {
            self.tabBar.height = Metric.tabBarHeight + self.view.safeAreaInsets.bottom
        } else {
            self.tabBar.height = Metric.tabBarHeight
        }
        self.tabBar.bottom = self.view.height
    }

    private func addChildController(_ child: UIViewController,
                                    _ title: String,
                                    _ normalImage: UIImage?,
                                    _ selectedImage: UIImage?) {

        if #available(iOS 13.0, *) {
            tabBar.tintColor = ThemeManager.shared.pinkStyleModel.colors.pi5
        } else {
            child.tabBarItem.setTitleTextAttributes([.foregroundColor : ThemeManager.shared.pinkStyleModel.colors.pi5], for: .selected)
        }

        child.tabBarItem.title = title
        child.tabBarItem.image = normalImage?.withRenderingMode(.alwaysOriginal)
        child.tabBarItem.selectedImage = selectedImage?.withRenderingMode(.alwaysOriginal)

        let navController = BBNavigationController(rootViewController: child)
        navController.navigation.configuration.isEnabled = true
        navController.navigation.configuration.isShadowHidden = true
        _ = themeService.attrsStream
            .subscribe(onNext: { (theme) in
                navController.navigation.configuration.titleTextAttributes = [.foregroundColor: theme.mainColorModel.wh0]
                navController.navigation.configuration.tintColor = theme.mainColorModel.wh0
            })
        addChild(navController)
    }

}
