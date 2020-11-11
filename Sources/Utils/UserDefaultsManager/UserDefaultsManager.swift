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

    struct Splash {
        /// 是否同意隐私协议
        @SwiftyUserDefault(keyPath: \.agreePolicy)
        var agreePolicy: Bool
        /// 广告加载的时差 s作为单位
        @SwiftyUserDefault(keyPath: \.adPullInterval)
        var adPullInterval: Double
        /// 广告显示的时差 s作为单位
        @SwiftyUserDefault(keyPath: \.adMinInterval)
        var adMinInterval: Double
        /// 广告加载的时间 s作为单位
        @SwiftyUserDefault(keyPath: \.adLoadTime)
        var adLoadTime: Double
        /// 广告展示的时间 s作为单位
        @SwiftyUserDefault(keyPath: \.adShowTime)
        var adShowTime: Double

        /// 开屏加载的时差 s作为单位
        @SwiftyUserDefault(keyPath: \.splashPullInterval)
        var splashPullInterval: Double
        /// 开屏加载的时间 s作为单位
        @SwiftyUserDefault(keyPath: \.splashLoadTime)
        var splashLoadTime: Double

    }

    struct Activity {
        /// 首页活动标签Id
        @SwiftyUserDefault(keyPath: \.activityTabId)
        var activityTabId: String
    }

    struct App {
        /// 首页活动标签是否点击
        @SwiftyUserDefault(keyPath: \.activityTabIsClicked)
        var activityTabIsClicked: Bool
    }

    struct User {
        @SwiftyUserDefault(keyPath: \.token)
        var token: String
    }

    static var theme = Theme()
    static var splash = Splash()
    static var activity = Activity()
    static var app = App()
    static var user = User()
}
