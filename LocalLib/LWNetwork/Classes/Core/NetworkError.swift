//
//  NetworkError.swift
//  LWNetwork
//
//  Created by luowen on 2021/10/8.
//

import Foundation
import Moya

public enum NetworkError: Swift.Error {

    /// 连接异常
    ///
    /// - networkException: 网络异常
    /// - invalidURL: 请求地址异常
    public enum RequestException {
        case networkException(Swift.Error?)
        case invalidURL(baseURL: String, path: String)
    }

    /// 响应异常
    ///
    /// - serverException: 服务器异常 500
    /// - notFound: 方法不存在 404
    /// - unacceptableContentType: ContentType 不被接受
    /// - unacceptableStatusCode: 响应状态异常
    public enum ResponseException {
        case serverException
        case notFound
        case unacceptableContentType(acceptableContentTypes: [String], responseContentType: String)
        case unacceptableStatusCode(code: Int, response: Moya.Response)
    }

    /// 序列化异常
    ///
    /// - dataNotFound: data缺失
    /// - jsonSerializationFailed: JSON序列化异常
    /// - objectFailed: 对象转换失败
    public enum ResponseSerializationException {
        case dataNotFound
        case jsonSerializationFailed(Error?)
        case objectFailed
    }

    /// 执行异常
    ///
    /// - executeFail: 执行结果异常，操作失败
    /// - unlegal: 执行结果状态吗不合理
    public enum ExecuteException {
        case executeFail(msg: String?, response: [String: Any])
        case unlegal
    }
    case requestException(_ exception: RequestException)
    case responseException(_ exception: ResponseException)
    case responseSerializationException(_ exception: ResponseSerializationException)
    case executeException(_ exception: ExecuteException)
}
