//
//  OnCache.swift
//  LWNetwork
//
//  Created by luowen on 2021/10/9.
//

import Moya
import RxSwift
import ObjectMapper

public struct OnCache<Target: SugarTargetType, C: BaseMappable>
where Target: Cacheable, Target.ResponseType == Moya.Response {

    public let target: Target
    public let modelKey: String?
    public let delimiter: String

    public init(target: Target,
                modelKey: String?,
                delimiter: String) {
        self.target = target
        self.modelKey = modelKey
        self.delimiter = delimiter
    }

    public func requestObject(timeoutInterval: TimeInterval? = nil,
                              callbackQueue: DispatchQueue? = nil) -> Observable<C> {
        return target.request(timeoutInterval: timeoutInterval, callbackQueue: callbackQueue)
            .storeCachedResponse(for: target)
            .asObservable()
            .mapObject(C.self, modelKey: modelKey, delimiter: delimiter)
    }

    public func requestArray(timeoutInterval: TimeInterval? = nil,
                             callbackQueue: DispatchQueue? = nil) -> Observable<[C]> {
        return target.request(timeoutInterval: timeoutInterval, callbackQueue: callbackQueue)
            .storeCachedResponse(for: target)
            .asObservable()
            .mapArray(C.self, modelKey: modelKey, delimiter: delimiter)
    }
}
