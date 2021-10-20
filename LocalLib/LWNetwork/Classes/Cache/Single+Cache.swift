//
//  Single+Cache.swift
//  LWNetwork
//
//  Created by luowen on 2021/10/9.
//

import RxSwift
import Moya

extension ObservableType where Element == Moya.Response {

    public func storeCachedResponse<Target>(for target: Target)
        -> Observable<Element>
        where Target: SugarTargetType, Target: Cacheable, Target.ResponseType == Element {
        return map { response -> Element in
            if target.allowsStorage(response) {
                try? target.storeCachedResponse(response)
            }
            return response
        }
    }
}
