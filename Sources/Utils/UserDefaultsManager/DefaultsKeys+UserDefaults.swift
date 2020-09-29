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
    var themeStyle: DefaultsKey<ThemeStyle> { .init("themeStyle", defaultValue: .pink) }
}

// MARK: App
extension DefaultsKeys {
    var agreePolicy: DefaultsKey<Bool> { .init("agreePolicy", defaultValue: false) }

    var splashLoadTime: DefaultsKey<Int> { .init("splashLoadTime", defaultValue: 0) }
    var splashPullInterval: DefaultsKey<Int> { .init("splashPullInterval", defaultValue: 0) }

    var adShowTime: DefaultsKey<Int> { .init("adShowTime", defaultValue: 0) }
    var adLoadTime: DefaultsKey<Int> { .init("adLoadTime", defaultValue: 0) }
    var adPullInterval: DefaultsKey<Int> { .init("adPullInterval", defaultValue: 0) }
    var adMinInterval: DefaultsKey<Int> { .init("adMinInterval", defaultValue: 0) }
}
