//
//  Utils.swift
//  SwiftBilibili
//
//  Created by luowen on 2020/9/29.
//  Copyright © 2020 luowen. All rights reserved.
//
import UIKit

struct Utils {
    /// 当前app时间
    static func currentAppTime() -> Int {
        return Int(Date().timeIntervalSince1970 / 1000)
    }
}
