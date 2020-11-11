//
//  Screen.swift
//  SwiftBilibili
//
//  Created by luowen on 2020/9/7.
//  Copyright © 2020 luowen. All rights reserved.
//

import UIKit

struct Screen {

    static var isIphoneX: Bool {
        return UIApplication.shared.keyWindow!.safeAreaInsets.bottom > 0
    }
    static let width = UIScreen.main.bounds.width
    static let height = UIScreen.main.bounds.height
    static let statusBarHeight = isIphoneX ? 44.f : 20.f
    static let navigationBarHeight = isIphoneX ? 88.f : 64.f
    static let tabBarHeight = isIphoneX ? 83.f : 49.f
    static let bottomSafeHeight = isIphoneX ? 34.f : 0.f

}
