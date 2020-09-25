//
//  Network+Cache.swift
//  SwiftBilibili
//
//  Created by luowen on 2020/9/16.
//  Copyright © 2020 luowen. All rights reserved.
//

import Moya
import CommonCrypto

extension Storable where Self: TargetType {

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
        return cachedURL.appendingPathComponent(key.stringValue.toMD5)
    }

}

private extension String {

    var toMD5: String {
        let str = cString(using: .utf8)
        let strLen = CUnsignedInt(lengthOfBytes(using: .utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<UInt8>.allocate(capacity: 16)
        defer { free(result) }

        CC_MD5(str!, strLen, result)

        return (0..<digestLen).reduce("") { $0 + String(format: "%02x", result[$1]) }
    }
}
