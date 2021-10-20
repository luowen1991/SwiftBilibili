//
//  LaunchAPI.swift
//  SwiftBilibili
//
//  Created by luowen on 2021/10/19.
//  Copyright © 2021 luowen. All rights reserved.
//

import LWNetwork

enum LaunchAPI {
    // 开屏图
    case splashInfo
    // 广告图
    case adInfo
}

extension LaunchAPI: SugarTargetType, Cacheable {

    var baseURL: URL {
        switch self {
        case .splashInfo, .adInfo:
            return URL(string: "https://app.bilibili.com")!
        }
    }

    var route: Route {
        switch self {
        case .splashInfo:
            return .get("x/v2/splash/brand/list")
        case .adInfo:
            return .get("x/v2/splash/list")
        }
    }

    var parameters: Parameters? {
        switch self {
        case .splashInfo:
            return ["last_read_at": -1,"network": "wifi","screen_height": 2532,"screen_width": 1170,"sign": "480c2bdb137ed9e0b41dc0ccf4343f7c","ts": 1634623698]
        case .adInfo:
            return nil
        }
    }
}
