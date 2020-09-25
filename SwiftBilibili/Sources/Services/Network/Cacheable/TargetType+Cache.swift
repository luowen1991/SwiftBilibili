//
//  TargetType+Cache.swift
//  SwiftBilibili
//
//  Created by luowen on 2020/9/15.
//  Copyright © 2020 luowen. All rights reserved.
//

import Moya
import RxSwift
import ObjectMapper

public typealias CachingKey = StoringKey
public typealias Cacheable = Storable & StoringKey & Expirable

public extension Expirable {
    var expiry: Expiry {
        return .never
    }
}

public extension TargetType where Self: Cacheable, Self.ResponseType == Moya.Response {

    func onCacheObject<C: BaseMappable>(
        _ type: C.Type,
        context: MapContext? = nil,
        _ closure: (C) -> Void)
        -> OnCache<Self,C> {
        if let object = try? cachedResponse()
            .mapObject(C.self, context: context) {
            closure(object)
        }

        return OnCache(target: self, context: context)
    }

    func onCacheArray<C: BaseMappable>(
        _ type: C.Type,
        context: MapContext? = nil,
        _ closure: ([C]) -> Void)
        -> OnCache<Self,C> {
        if let array = try? cachedResponse()
            .mapArray(C.self, context: context) {
            closure(array)
        }
        return OnCache(target: self, context: context)
    }
}

public extension TargetType where Self: Cacheable, Self.ResponseType == Moya.Response {

    var cache: Observable<Self> {
        Observable.just(self)
    }

    func cachedResponse() throws -> Moya.Response {
        let expiry = try self.expiry(for: self)

        guard expiry.isExpired else {
            let response = try cachedResponse(for: self)
            return Response(statusCode: response.statusCode, data: response.data)
        }

        throw Expiry.Error.expired(expiry.date)
    }

    func storeCachedResponse(_ cachedResponse: Moya.Response) throws {
        try storeCachedResponse(cachedResponse, for: self)
        update(expiry: expiry, for: self)
    }

    func removeCachedResponse() throws {
        try removeCachedResponse(for: self)

        removeExpiry(for: self)
    }
}
