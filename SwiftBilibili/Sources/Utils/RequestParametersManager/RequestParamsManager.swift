//
//  RequestParamsManager.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2020/9/6.
//  Copyright © 2020 luowen. All rights reserved.
//

import Foundation

/// 请求的通用参数
struct RequestParamsManager {

    static let appKey = "27eb53fc9058f8c3"
    /// 当前时间戳
//    static var ts: String {
//        let timeInterval = Date().timeIntervalSince1970
//        let millisecond = CLongLong(round(timeInterval*1000))
//        return "\(millisecond)"
//    }

    static let build = 10270

    static let device = "phone"

    static let mobiApp = "iphone"

    static let platform = "ios"

    static let statistics = "%7B%22appId%22%3A1%2C%22version%22%3A%226.9.1%22%2C%22abtest%22%3A%22%22%2C%22platform%22%3A1%7D"

    /// 当前的系统语言
    static var locale: String {
//        let allLanguages = UserDefaults.standard.object(forKey: "AppleLanguages") as! [String]
//        let currentLanguages = allLanguages.first ?? "zh-Hans_CN"
//        return currentLanguages
        return "zh-Hans_CN"
    }

    static func defaultParameters() -> [String : Any] {
        let parameters: [String : Any] = ["actionKey": "appkey", "appkey": appKey, "build": build, "device": device, "mobi_app": mobiApp, "platform": platform, "s_locale": locale, "statistics": statistics]
        return parameters
    }

}
