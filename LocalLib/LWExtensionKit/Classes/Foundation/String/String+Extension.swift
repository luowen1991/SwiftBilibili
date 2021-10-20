//
//  String+Extension.swift
//  LWExtensionKit
//
//  Created by luowen on 2021/10/19.
//

import Foundation
import CommonCrypto

public extension ExtensionNameSpace where Base == String {

    var toMD5: String {
        let str = base.cString(using: .utf8)
        let strLen = CUnsignedInt(base.lengthOfBytes(using: .utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<UInt8>.allocate(capacity: 16)
        defer { free(result) }
        CC_MD5(str!, strLen, result)
        return (0..<digestLen).reduce("") { $0 + String(format: "%02x", result[$1]) }
    }

}
