//
//  Network+Cache.swift
//  SwiftBilibili
//
//  Created by luowen on 2021/10/9.
//  Copyright © 2021 luowen. All rights reserved.
//

import Moya
import LWNetwork
import LWExtensionKit


extension Storable where Self: SugarTargetType {

    private var cachedURL: URL {
        guard let path = NSSearchPathForDirectoriesInDomains(
            .cachesDirectory,
            .userDomainMask,
            true).last
        else {
            fatalError("Couldn't search cache's directory.")
        }
        return URL(fileURLWithPath: path)
    }

    public var allowsStorage: (Response) -> Bool {
        return { _ in true }
    }

    public func cachedResponse(for key: CachingKey) throws -> Response {
        let data = try Data(contentsOf: md5Key(key))
        return Response(statusCode: 200, data: data)
    }

    public func storeCachedResponse(_ cachedResponse: Response, for key: CachingKey) throws {
        try cachedResponse.data.write(to: md5Key(key))
    }

    public func removeCachedResponse(for key: CachingKey) throws {
        try FileManager.default.removeItem(at: md5Key(key))
    }

    public func removeAllCachedResponses() throws {
        try FileManager.default.removeItem(at: cachedURL)
    }

    private func md5Key(_ key: CachingKey) -> URL {
        return cachedURL.appendingPathComponent(key.stringValue.ex.toMD5)
    }

}
