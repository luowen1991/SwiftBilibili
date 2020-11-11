//
//  DefaultsKeys+UserDefaults.swift
//  SwiftBilibili
//
//  Created by luowen on 2020/9/4.
//  Copyright © 2020 luowen. All rights reserved.
//

import SwiftyUserDefaults

// MARK: Theme
extension DefaultsKeys {
    var themeStyle: DefaultsKey<ThemeStyle> { .init("themeStyle", defaultValue: .light) }
}

// MARK: Splash
extension DefaultsKeys {
    var agreePolicy: DefaultsKey<Bool> { .init("agreePolicy", defaultValue: false) }

    var splashLoadTime: DefaultsKey<Double> { .init("splashLoadTime", defaultValue: 0) }
    var splashPullInterval: DefaultsKey<Double> { .init("splashPullInterval", defaultValue: 0) }

    var adShowTime: DefaultsKey<Double> { .init("adShowTime", defaultValue: 0) }
    var adLoadTime: DefaultsKey<Double> { .init("adLoadTime", defaultValue: 0) }
    var adPullInterval: DefaultsKey<Double> { .init("adPullInterval", defaultValue: 0) }
    var adMinInterval: DefaultsKey<Double> { .init("adMinInterval", defaultValue: 0) }
}

// MARK: - App
extension DefaultsKeys {
    var activityTabId: DefaultsKey<String> { .init("activityTabId", defaultValue: "") }
    var activityTabIsClicked: DefaultsKey<Bool> { .init(UserDefaultsManager.activity.activityTabId, defaultValue: false) }
}

// MARK: - User
extension DefaultsKeys {
    var token: DefaultsKey<String> { .init("token", defaultValue: "") }
}
