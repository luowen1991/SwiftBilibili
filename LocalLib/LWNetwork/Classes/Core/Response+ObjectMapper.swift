//
//  Response+ObjectMapper.swift
//  LWNetwork
//
//  Created by luowen on 2021/10/9.
//

import Moya
import ObjectMapper

extension Moya.Response {

    /// 转字典
    /// - Parameters:
    ///   - modelKey: 解析的key 空则是全量解析 nil则以全局设置的解析key为准 默认为data
    ///   - delimiter: 嵌套解析的标识符 比如"data.model" 则是直接取data下的key model
    /// - Returns: 字典
    public func mapDictionary(modelKey: String? = nil,
                              delimiter: String = ".") throws -> [String: Any] {

        guard let dictionary = try? mapJSON() as? [String: Any] else {
            return [:]
        }

        // modelKey为空字符串 则字典全量转模型
        if modelKey == "" { return dictionary }

        // modelKey存在且不为空字符串时
        if let modelKey = modelKey {
            // 如果modelKey包含delimiter
            if modelKey.contains(delimiter) {
                guard let modelJSON = valueFor(ArraySlice(modelKey.components(separatedBy: delimiter)), dictionary: dictionary) as? [String: Any] else {
                    throw NetworkError.responseSerializationException(.dataNotFound)
                }
                return modelJSON
            } else {
                guard let modelJSON = dictionary[modelKey] as? [String: Any] else {
                    throw NetworkError.responseSerializationException(.dataNotFound)
                }
                return modelJSON
            }
        }

        // 采用全局模型key的配置解析
        guard let modelJSON = Network.Configuration.shared.mapperKeyValue.modelKeys.map { dictionary[$0] }.compactMap { $0 }.first as? [String: Any] else {
            throw NetworkError.responseSerializationException(.dataNotFound)
        }
        return modelJSON
    }


    /// 转对象模型
    /// - Parameters:
    ///   - type: 对象模型的类型
    ///   - modelKey: 解析的key 空则是全量解析 nil则以全局设置的解析key为准 默认为data
    ///   - delimiter: 嵌套解析的标识符 比如"data.model" 则是直接取data下的key model来转模型
    /// - Returns: 模型对象
    public func mapObject<T: BaseMappable>(_ type: T.Type,
                                           modelKey: String? = nil,
                                           delimiter: String = ".") throws -> T {

        guard let dictionary = try? mapJSON() as? [String: Any] else {
            throw NetworkError.responseSerializationException(.jsonSerializationFailed(nil))
        }

        // modelKey为空字符串 则字典全量转模型
        if modelKey == "" {
            guard let object = Mapper<T>().map(JSONObject: dictionary) else {
                throw NetworkError.responseSerializationException(.objectFailed)
            }
            return object
        }

        // modelKey存在且不为空字符串时
        if let modelKey = modelKey {
            // 如果modelKey包含delimiter
            if modelKey.contains(delimiter) {
                guard let modelJSON = valueFor(ArraySlice(modelKey.components(separatedBy: delimiter)), dictionary: dictionary) else {
                    throw NetworkError.responseSerializationException(.dataNotFound)
                }
                guard let object = Mapper<T>().map(JSONObject: modelJSON) else {
                    throw NetworkError.responseSerializationException(.objectFailed)
                }
                return object
            } else {
                guard let modelJSON = dictionary[modelKey] as? [String: Any] else {
                    throw NetworkError.responseSerializationException(.dataNotFound)
                }
                guard let object = Mapper<T>().map(JSONObject: modelJSON) else {
                    throw NetworkError.responseSerializationException(.objectFailed)
                }
                return object
            }
        }

        // 采用全局模型key的配置解析
        guard let modelJSON = Network.Configuration.shared.mapperKeyValue.modelKeys.map { dictionary[$0] }.compactMap { $0 }.first else {
            throw NetworkError.responseSerializationException(.dataNotFound)
        }
        guard let object = Mapper<T>().map(JSONObject: modelJSON) else {
            throw NetworkError.responseSerializationException(.objectFailed)
        }
        return object
    }

    /// 转对象数组
    /// - Parameters:
    ///   - type: 模型的类型
    ///   - modelKey: 解析的key nil则以全局设置的解析key为准 默认为data
    ///   - delimiter: 嵌套解析的标识符 比如"data.model" 则是直接取data下的key model来转模型
    /// - Returns: 模型对象
    public func mapArray<T: BaseMappable>(_ type: T.Type,
                                          modelKey: String? = nil,
                                          delimiter: String = ".") throws -> [T] {

        guard let dictionary = try? mapJSON() as? [String: Any] else {
            throw NetworkError.responseSerializationException(.jsonSerializationFailed(nil))
        }

        // modelKey存在
        if let modelKey = modelKey {
            // 如果modelKey包含delimiter
            if modelKey.contains(delimiter) {
                guard let modelJSON = valueFor(ArraySlice(modelKey.components(separatedBy: delimiter)), dictionary: dictionary) else {
                    throw NetworkError.responseSerializationException(.dataNotFound)
                }
                guard let objects = Mapper<T>().mapArray(JSONObject: modelJSON) else {
                    throw NetworkError.responseSerializationException(.objectFailed)
                }
                return objects
            } else {
                guard let modelJSON = dictionary[modelKey] else {
                    throw NetworkError.responseSerializationException(.dataNotFound)
                }
                guard let objects = Mapper<T>().mapArray(JSONObject: modelJSON) else {
                    throw NetworkError.responseSerializationException(.objectFailed)
                }
                return objects
            }
        }

        // 采用全局模型key的配置解析
        guard let modelJSON = Network.Configuration.shared.mapperKeyValue.modelKeys.map { dictionary[$0] }.compactMap { $0 }.first else {
            throw NetworkError.responseSerializationException(.dataNotFound)
        }
        guard let objects = Mapper<T>().mapArray(JSONObject: modelJSON) else {
            throw NetworkError.responseSerializationException(.objectFailed)
        }
        return objects
    }

    private func defaultModelJSON(_ dictionary: [String: Any]) -> [String: Any]? {
        return Network.Configuration.shared.mapperKeyValue.modelKeys.map { dictionary[$0] as? [String: Any] }.compactMap { $0 }.first
    }

    private func valueFor(_ keyPathComponents: ArraySlice<String>, dictionary: [String: Any]) -> Any? {

        if let keyPath = keyPathComponents.first {
            let object = dictionary[keyPath]
            if object == nil {
                return nil
            } else if keyPathComponents.count > 1, let dict = object as? [String: Any] {
                let tail = keyPathComponents.dropFirst()
                return valueFor(tail, dictionary: dict)
            } else if keyPathComponents.count > 1, let array = object as? [Any] {
                let tail = keyPathComponents.dropFirst()
                return valueFor(tail, array: array)
            } else {
                return object
            }
        }

        return nil
    }

    private func valueFor(_ keyPathComponents: ArraySlice<String>, array: [Any]) -> Any? {

        //Try to convert keypath to Int as index
        if let keyPath = keyPathComponents.first,
            let index = Int(keyPath) , index >= 0 && index < array.count {
            let object = array[index]

            if keyPathComponents.count > 1, let array = object as? [Any]  {
                let tail = keyPathComponents.dropFirst()
                return valueFor(tail, array: array)
            } else if keyPathComponents.count > 1, let dict = object as? [String: Any] {
                let tail = keyPathComponents.dropFirst()
                return valueFor(tail, dictionary: dict)
            } else {
                return object
            }
        }

        return nil
    }
}
