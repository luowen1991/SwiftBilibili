//
//  UIDevice+Extension.swift
//  LWExtensionKit
//
//  Created by luowen on 2021/10/15.
//

import UIKit

public extension ExtensionNameSpaceStatic where Base: UIDevice {

    var isIphoneX: Bool {
        UIApplication.shared.delegate?.window??.safeAreaInsets.bottom ?? 0 > 0
    }

    var screenScale: CGFloat { UIScreen.main.scale }

    var screenWidth: CGFloat { UIScreen.main.bounds.size.width }

    var screenHeight: CGFloat { UIScreen.main.bounds.size.height }

    var statusBarHeight: CGFloat { isIphoneX ? 44 : 20 }

    var navigationBarHeight: CGFloat { statusBarHeight + 44 }

    var bottomSafeAreaHeight: CGFloat { isIphoneX ? 34 : 0 }

    var tabBarHeight: CGFloat { bottomSafeAreaHeight + 49 }

}
