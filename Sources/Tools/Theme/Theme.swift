//
//  Theme.swift
//  SwiftBilibili
//
//  Created by luowen on 2020/9/4.
//  Copyright © 2020 luowen. All rights reserved.
//

import Foundation

import SwiftyUserDefaults
import RxSwift
import RxTheme

enum ThemeStyle: String,DefaultsSerializable,ThemeProvider {
    case light = "简洁白"
    case dark = "夜间模式"
    case pink = "少女粉"

    var associatedObject: Theme {
        switch self {
        case .light: return LightTheme()
        case .dark: return DarkTheme()
        case .pink: return PinkTheme()
        }
    }
}

protocol Theme {
    var mainColorModel: ThemeMainColorModel { get }
    var isDark: Bool { get }
}

struct LightTheme: Theme {

    var mainColorModel: ThemeMainColorModel = ThemeManager.shared.lightStyleModel.colors
    var isDark: Bool = ThemeManager.shared.lightStyleModel.isDark

}

struct DarkTheme: Theme {

    var mainColorModel: ThemeMainColorModel = ThemeManager.shared.darkStyleModel.colors
    var isDark: Bool = ThemeManager.shared.darkStyleModel.isDark
}

struct PinkTheme: Theme {

    var mainColorModel: ThemeMainColorModel = ThemeManager.shared.pinkStyleModel.colors
    var isDark: Bool = ThemeManager.shared.pinkStyleModel.isDark
}

let themeService = ThemeStyle.service(initial: UserDefaultsManager.theme.style)
func themed<T>(_ mapper: @escaping ((Theme) -> T)) -> Observable<T> {
    return themeService.attrStream(mapper)
}
