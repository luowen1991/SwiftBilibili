//
//  OnCache.swift
//  SwiftBilibili
//
//  Created by luowen on 2020/9/15.
//  Copyright © 2020 luowen. All rights reserved.
//

import UIKit
import Moya
import RxSwift
import ObjectMapper

public struct OnCache<Target: TargetType, C: BaseMappable>
where Target: Cacheable, Target.ResponseType == Moya.Response {

    public let target: Target

    private let context: MapContext?

    public init(target: Target, context: MapContext?) {
        self.target = target
        self.context = context
    }

    public func requestObject() -> Single<C> {
        return target.request()
            .storeCachedResponse(for: target)
            .mapObject(C.self, context: context)
    }

    public func requestArray() -> Single<[C]> {
        return target.request()
            .storeCachedResponse(for: target)
            .mapArray(C.self, context: context)
    }
}
