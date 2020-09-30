//
//  Utils.swift
//  SwiftBilibili
//
//  Created by luowen on 2020/9/29.
//  Copyright © 2020 luowen. All rights reserved.
//
import UIKit
import SwiftDate

enum AppTimeType {
    case second
    case millsecond
}

struct Utils {
    /// 当前app时间
    static func currentAppTime(_ type: AppTimeType = .second) -> Double {
        switch type {
        case .second:
            return floor(Date().timeIntervalSince1970 / 1000)
        case .millsecond:
            return floor(Date().timeIntervalSince1970)
        }
    }
}
