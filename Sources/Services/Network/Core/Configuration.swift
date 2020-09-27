//
//  Configuration.swift
//  SwiftBilibili
//
//  Created by luowen on 2020/9/15.
//  Copyright © 2020 luowen. All rights reserved.
//

import Moya

public extension Network {

    class Configuration {

        public static var `default`: Configuration = Configuration()

        public var addingHeaders: (TargetType) -> [String: String] = { _ in [:] }

        public var replacingTask: (TargetType) -> Task = { $0.task }

        public var timeoutInterval: TimeInterval = 60

        public var plugins: [PluginType] = [NetworkLoggerPlugin()]

        public var mapperKeyValue: MapperKeyValueType = DefaultMapperKeyValue()

        public var logEnable: Bool = true

        public init() {}
    }
}
