//
//  Utils.swift
//  SwiftBilibili
//
//  Created by luowen on 2020/9/29.
//  Copyright © 2020 luowen. All rights reserved.
//
import UIKit
import SwiftDate

struct Utils {
    /// 当前app时间
    static func currentAppTime() -> Double {
        return Date().timeIntervalSince1970
    }
    /// 是否登录
    static var isLogin: Bool {
        return !UserDefaultsManager.user.token.isEmpty
    }
}
