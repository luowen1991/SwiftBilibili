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
    }

    static var theme = Theme()
    static var app = App()
}
