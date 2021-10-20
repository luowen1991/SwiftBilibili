//
//  CachingKey+Moya.swift
//  LWNetwork
//
//  Created by luowen on 2021/10/9.
//

extension StoringKey where Self: SugarTargetType {

    public var stringValue: String {
        return cachedKey
    }
}

extension SugarTargetType {

    var cachedKey: String {
        if let dictionary = parameters?.values {
            var newDictionary: [String: Any] = [:]
            for key in dictionary.keys.sorted() {
                newDictionary.updateValue(dictionary[key], forKey: key)
            }
            let newData = try? JSONSerialization.data(withJSONObject: newDictionary, options: .fragmentsAllowed)
            let body = String(data: newData ?? Data(), encoding: .utf8) ?? ""
            return "\(method.rawValue):\(defaultURL.absoluteString)?\(body)"
        }

        return "\(method.rawValue):\(defaultURL.absoluteString)"
    }
}
