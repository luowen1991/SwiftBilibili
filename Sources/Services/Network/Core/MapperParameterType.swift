//
//  MapperParameterType.swift
//  SwiftBilibili
//
//  Created by luowen on 2020/9/18.
//  Copyright © 2020 luowen. All rights reserved.
//

import Foundation

public protocol MapperKeyValueType {

    /// 请求成功时状态码对应的值
    var successValue: String { get set }
    /// 状态码对应的键
    var statusCodeKey: String { get set }
    /// 请求后的提示语对应的键
    var msgStrKey: String { get set }
    /// 请求后的主要模型数据的键
    var modelKey: String { get set }
}

public struct DefaultMapperKeyValue: MapperKeyValueType {
    public var successValue: String = "0"
    public var statusCodeKey: String = "code"
    public var msgStrKey: String = "message"
    public var modelKey: String = "data"
}
