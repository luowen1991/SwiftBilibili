//
//  CommonParamters.swift
//  BBNetworkEx
//
//  Created by luowen on 2021/10/19.
//

import LWExtensionKit

// 由于sing是根据所有参数md5加密而来 在不知道盐值的情况下只能按抓包的写死
public enum ParamrtersUtils {

    // token 如果存在必须在第一个参数
    public static let accessKey: String? = nil

    public static var commonParameters: [String: Any] = [
        "appkey": "27eb53fc9058f8c3",
        "actionKey": "appkey",
        "build": 64400100,
        "c_locale": "zh-Hans_CN",
        "device": "phone",
        "mobi_app": "iphone",
        "platform": "ios",
        "s_locale": "zh-Hans_CN",
        "statistics": "%7B%22appId%22%3A1%2C%22version%22%3A%226.44.0%22%2C%22abtest%22%3A%22%22%2C%22platform%22%3A1%7D"
    ]

}

extension ParamrtersUtils {

    static var language: String {
        guard let languages = UserDefaults.standard.object(forKey: "AppleLanguages") as? [String],
              let defaultLanguage = languages.first
        else { return "zh-Hans_CN" }
        return defaultLanguage
    }

    static var statistics: String {
        let dict: [String: Any] = ["abtest": "","appId": 1,"platform": 1,"version": "6.44.0"]
        guard let data = try? JSONSerialization.data(withJSONObject: dict, options: .fragmentsAllowed),
              let str = String(data: data, encoding: .utf8)
        else {
            return ""
        }
        return str
    }
}
