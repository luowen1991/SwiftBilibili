//
//  Observable+ObjectMapper.swift
//  SwiftBilibili
//
//  Created by luowen on 2020/9/21.
//  Copyright © 2020 luowen. All rights reserved.
//

import Foundation
import Moya
import ObjectMapper

public extension Response {

    func mapObject<T: BaseMappable>(_ type: T.Type, context: MapContext? = nil) throws -> T {
        let jsonData = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
        guard let json = jsonData as? [String: Any] else {
            throw NetworkError.responseSerializationException(.jsonSerializationFailed(nil))
        }
        guard let data = json[Network.Configuration.default.mapperKeyValue.modelKey] else {
            throw NetworkError.responseSerializationException(.dataNotFound)
        }

        guard let object = Mapper<T>(context: context).map(JSONObject: data) else {
            throw NetworkError.ResponseSerializationException.objectFailed
        }
        return object
    }

    func mapArray<T: BaseMappable>(_ type: T.Type, context: MapContext? = nil) throws -> [T] {

        let jsonData = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
        guard let json = jsonData as? [String: Any] else {
            throw NetworkError.responseSerializationException(.jsonSerializationFailed(nil))
        }
        guard let data = json[Network.Configuration.default.mapperKeyValue.modelKey] else {
            throw NetworkError.responseSerializationException(.dataNotFound)
        }
        guard let array = data as? [[String: Any]] else {
            throw NetworkError.ResponseSerializationException.objectFailed
        }
        return Mapper<T>(context: context).mapArray(JSONArray: array)
    }
}
