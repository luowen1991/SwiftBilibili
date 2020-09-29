//
//  UserDefaultsManager.swift
//  SwiftBilibili
//
//  Created by luowen on 2020/9/4.
//  Copyright © 2020 luowen. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

struct UserDefaultsManager {

    struct Theme {
        @SwiftyUserDefault(keyPath: \.themeStyle)
        var style: ThemeStyle
    }

    struct App {
        /// 是否同意隐私协议
        @SwiftyUserDefault(keyPath: \.agreePolicy)
        var agreePolicy: Bool
        /// 广告加载的时差 s作为单位
        @SwiftyUserDefault(keyPath: \.adPullInterval)
        var adPullInterval: Int
        /// 广告显示的时差 s作为单位
        @SwiftyUserDefault(keyPath: \.adMinInterval)
        var adMinInterval: Int
        /// 广告加载的时间 s作为单位
        @SwiftyUserDefault(keyPath: \.adLoadTime)
        var adLoadTime: Int
        /// 广告展示的时间 s作为单位
        @SwiftyUserDefault(keyPath: \.adShowTime)
        var adShowTime: Int

        /// 开屏加载的时差 s作为单位
        @SwiftyUserDefault(keyPath: \.splashPullInterval)
        var splashPullInterval: Int
        /// 开屏加载的时间 s作为单位
        @SwiftyUserDefault(keyPath: \.splashLoadTime)
        var splashLoadTime: Int
    }

    static var theme = Theme()
    static var app = App()
}
