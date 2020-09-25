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
}
