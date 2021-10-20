//
//  TargetType+Cache.swift
//  LWNetwork
//
//  Created by luowen on 2021/10/9.
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

public extension SugarTargetType where Self: Cacheable, Self.ResponseType == Moya.Response {

    /// 获取缓存对象
    func onCacheObject<C: BaseMappable>(
        _ type: C.Type,
        modelKey: String? = nil,
        delimiter: String = ".",
        closure: (C) -> Void)
        -> OnCache<Self, C> {
        if let response = try? cachedResponse(),
            let object = try? response.mapObject(type, modelKey: modelKey, delimiter: delimiter) {
            closure(object)
        }
        return OnCache(target: self, modelKey: modelKey, delimiter: delimiter)
    }

    /// 获取缓存对象数组
    func onCacheArray<C: BaseMappable>(
        _ type: C.Type,
        modelKey: String? = nil,
        delimiter: String = ".",
        closure: ([C]) -> Void)
        -> OnCache<Self, C> {
        if let response = try? cachedResponse(),
            let objects = try? response.mapArray(type, modelKey: modelKey, delimiter: delimiter) {
            closure(objects)
        }
        return OnCache(target: self, modelKey: modelKey, delimiter: delimiter)
    }
}

public extension SugarTargetType where Self: Cacheable, Self.ResponseType == Moya.Response {

    var cache: Observable<Self> {
        return Observable.just(self)
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
