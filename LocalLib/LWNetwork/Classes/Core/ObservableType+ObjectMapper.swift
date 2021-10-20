//
//  Response+ObjectMapper.swift
//  LWNetwork
//
//  Created by luowen on 2021/10/8.
//

import Moya
import ObjectMapper
import RxSwift

extension ObservableType where Element == Response {

    /// 转字典
    /// - Parameters:
    ///   - modelKey: 解析的key 空则是全量解析 nil则以全局设置的解析key为准 默认为data
    ///   - delimiter: 嵌套解析的标识符 比如"data.model" 则是直接取data下的key model
    /// - Returns: 字典
    public func mapDictionary(modelKey: String? = nil,
                              delimiter: String = ".")

    -> Observable<[String: Any]> {

        return flatMap { response -> Observable<[String: Any]> in
            return Observable.just(try response.mapDictionary(modelKey: modelKey, delimiter: delimiter))
        }
    }

    /// 转对象模型
    /// - Parameters:
    ///   - type: 对象模型的类型
    ///   - modelKey: 解析的key 空则是全量解析 nil则以全局设置的解析key为准 默认为data
    ///   - delimiter: 嵌套解析的标识符 比如"data.model" 则是直接取data下的key model来转模型
    /// - Returns: 模型对象
    public func mapObject<T: BaseMappable>(_ type: T.Type,
                                           modelKey: String? = nil,
                                           delimiter: String = ".")
    -> Observable<T> {

        return flatMap { response -> Observable<T> in
            return Observable.just(try response.mapObject(type, modelKey: modelKey, delimiter: delimiter))
        }
    }

    /// 转对象数组
    /// - Parameters:
    ///   - type: 模型的类型
    ///   - modelKey: 解析的key nil则以全局设置的解析key为准 默认为data
    ///   - delimiter: 嵌套解析的标识符 比如"data.model" 则是直接取data下的key model来转模型
    /// - Returns: 模型对象
    public func mapArray<T: BaseMappable>(_ type: T.Type,
                                          modelKey: String? = nil,
                                          delimiter: String = ".")
    -> Observable<[T]> {

        return flatMap { response -> Observable<[T]> in
            return Observable.just(try response.mapArray(type, modelKey: modelKey, delimiter: delimiter))
        }
    }

}
