//
//  HomeRouterOpener.swift
//  SwiftBilibili
//
//  Created by luowen on 2020/11/18.
//  Copyright © 2020 luowen. All rights reserved.
//

import Foundation

extension HomeRouterType {

    func controller(url: URLConvertible, values: [String : Any]) -> Routerable? {
        switch self {
        case .live:
            return HomeLiveViewController()
        case .promo:
            return HomePromoViewController()
        case .bangum:
            return HomeBangumiViewController()
        case .cinema:
            return HomeCinemaViewController()
        case .activity:
            return HomeActivityViewController()
        case .hot:
            return HomeHotViewController()
        case .optional:
            guard let id = values["id"] as? Int else { return nil }
            return HomeOptionalViewController(id: id)
        case .test:
            return nil
        }
    }

    func handle(url: URLConvertible, values: [String : Any], completion: @escaping (Bool) -> Void) {
        log.debug("没有返回控制器")
        completion(true)
    }
}
