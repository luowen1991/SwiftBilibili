//
//  Configuration.swift
//  
//
//  Created by luowen on 2020/9/15.
//  Copyright © 2020 luowen. All rights reserved.
//

/*
 网络配置 支持统一配置header以及公共参数 设置统一的超时时间

 DefaultMapperKeyValue 配置接口返回的参数key

 */

import Moya

extension Network {

    public class Configuration {

        public static let shared = Configuration()

        public var addingHeaders: (SugarTargetType) -> [String: String] = { _ in [:] }

        public var replacingTask: (SugarTargetType) -> Task = { $0.task }

        public var timeoutInterval: TimeInterval = 20

        public var plugins: [PluginType] = [NetworkLoggerPlugin()]

        public var mapperKeyValue: MapperKeyValueType = DefaultMapperKeyValue()

        public init() {}
    }
}

public protocol MapperKeyValueType {

    /// 请求成功时状态码对应的值
    var successValues: [String] { get set }
    /// 状态码对应的键
    var statusCodeKeys: [String] { get set }
    /// 请求后的提示语对应的键
    var msgStrKeys: [String] { get set }
    /// 请求后的主要模型数据的键
    var modelKeys: [String] { get set }
}

public struct DefaultMapperKeyValue: MapperKeyValueType {
    public var successValues: [String] = ["0"]
    public var statusCodeKeys: [String] = ["code"]
    public var msgStrKeys: [String] = ["message"]
    public var modelKeys: [String] = ["data"]
}
