//
//  RouterType.swift
//  SwiftBilibili
//
//  Created by luowen on 2020/11/17.
//  Copyright © 2020 luowen. All rights reserved.
//

import Foundation

enum RouterType {
    /// http
    case http
    /// https
    case https
    /// 不存在地址
    case error
}

extension RouterType: RouterTypeable {

    var pattern: String {
        switch self {
        case .http:
            return "http://<path:_>"
        case .https:
            return "https://<path:_>"
        case .error:
            return "bilibili://<path:_>"
        }
    }
}
