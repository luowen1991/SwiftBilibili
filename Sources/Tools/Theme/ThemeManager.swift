//
//  ThemeManager.swift
//  SwiftBilibili
//
//  Created by luowen on 2020/9/4.
//  Copyright © 2020 luowen. All rights reserved.
//

import UIKit

class ThemeManager {

    static var shared = ThemeManager()

    var mainStyleModels: [ThemeMainStyleModel] = []

    var currentStyleModel: ThemeMainStyleModel {
        switch UserDefaultsManager.theme.style {
        case .dark:
            return darkStyleModel
        case .light:
            return lightStyleModel
        case .pink:
            return pinkStyleModel
        }
    }

    var lightStyleModel: ThemeMainStyleModel {
        if _lightStyleModel == nil {
            _lightStyleModel = mainStyleModels.filter {$0.style == .light}.first!
        }
        return _lightStyleModel!
    }

    var darkStyleModel: ThemeMainStyleModel {
        if _darkStyleModel == nil {
            _darkStyleModel = mainStyleModels.filter {$0.style == .dark}.first!
        }
        return _darkStyleModel!
    }

    var pinkStyleModel: ThemeMainStyleModel {
        if _pinkStyleModel == nil {
            _pinkStyleModel = mainStyleModels.filter {$0.style == .pink}.first!
        }
        return _pinkStyleModel!
    }

    private var _lightStyleModel: ThemeMainStyleModel?
    private var _darkStyleModel: ThemeMainStyleModel?
    private var _pinkStyleModel: ThemeMainStyleModel?

}
