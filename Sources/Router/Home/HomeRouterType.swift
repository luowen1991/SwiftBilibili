//
//  HomeRouterType.swift
//  SwiftBilibili
//
//  Created by luowen on 2020/11/18.
//  Copyright © 2020 luowen. All rights reserved.
//

import Foundation

enum HomeRouterType {
    /// 推荐
    case promo
    /// 直播
    case live
    /// 番剧
    case bangum
    /// 热门
    case hot
    /// 影院
    case cinema
    /// 活动
    case activity
    /// 配置
    case optional
    /// 测试
    case test
}

extension HomeRouterType: RouterTypeable {

    var pattern: String {
        switch self {
        case .promo:
            return "bilibili://pegasus/promo"
        case .live:
            return "bilibili://live/home"
        case .bangum:
            return "bilibili://pgc/home"
        case .hot:
            return "bilibili://pegasus/hottopic"
        case .cinema:
            return "bilibili://pgc/cinema-tab"
        case .activity:
            return "bilibili://pgc/activity-tab"
        case .optional:
            return "bilibili://pegasus/op/<int:id>"
        case .test:
            return "bilibili://test"
        }
    }
}
