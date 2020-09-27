//
//  Single+Cache.swift
//  SwiftBilibili
//
//  Created by luowen on 2020/9/15.
//  Copyright © 2020 luowen. All rights reserved.
//

import RxSwift
import Moya

public extension PrimitiveSequence where Trait == SingleTrait, Element == Moya.Response {

    func storeCachedResponse<Target>(for target: Target) -> Single<Element>
        where Target: TargetType, Target: Cacheable, Target.ResponseType == Element {

            return map { (response) -> Element in
                if target.allowsStorage(response) {
                    try? target.storeCachedResponse(response)
                }
                return response
            }

    }

}
