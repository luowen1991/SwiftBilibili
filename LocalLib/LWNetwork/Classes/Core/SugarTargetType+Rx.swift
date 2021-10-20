//
//  TargetType+Rx.swift
//  LWNetwork
//
//  Created by luowen on 2021/10/8.
//

import RxSwift
import Moya

extension SugarTargetType {

    public func request(timeoutInterval: TimeInterval? = nil,
                        callbackQueue: DispatchQueue? = nil) -> Observable<Moya.Response> {

        // 设置单个请求的超时时间 如果没有设置则以全局的超时时间为准
        Network.shared.timeoutInterval = timeoutInterval

        // 发起网络请求
        return Network.shared.provider.rx.request(.target(self),
                                                  callbackQueue: callbackQueue)
                .do(onError: { error in
                    guard let moyaError = error as? MoyaError else { return }
                    switch moyaError {
                    case .statusCode(let response):
                        switch response.statusCode {
                        case 500:
                            throw NetworkError.responseException(.serverException)
                        case 404:
                            throw NetworkError.responseException(.notFound)
                        default:
                            NetworkError.responseException(.unacceptableStatusCode(code: response.statusCode, response: response))
                        }
                    case .underlying(let error, _):
                        throw NetworkError.requestException(.networkException(error))
                    default:
                        throw NetworkError.responseSerializationException(.jsonSerializationFailed(nil))
                    }
                })
                .map { response -> Moya.Response in
                    // 1. JSON序列化 失败抛出错误
                    guard let json = try? response.mapJSON() as? [String: Any] else {
                        throw NetworkError.responseSerializationException(.jsonSerializationFailed(nil))
                    }

                    // 2. 检验状态码key是否正确 不对则抛出错误
                    let statusCodeKeys = Network.Configuration.shared.mapperKeyValue.statusCodeKeys
                    let successValues = statusCodeKeys.map { json[$0] }.compactMap { $0 }
                    guard let successValue = successValues.first else {
                        throw NetworkError.executeException(.unlegal)
                    }

                    // 3. 检验状态码是否正确 不对则抛出错误
                    let defaultSuccessValues = Network.Configuration.shared.mapperKeyValue.successValues
                    guard defaultSuccessValues.contains(where: { $0 == "\(successValue)" }) else {
                        let msg = Network.Configuration.shared.mapperKeyValue.msgStrKeys.map { json[$0] as? String }.compactMap { $0 }.first
                        let data = Network.Configuration.shared.mapperKeyValue.modelKeys.map { json[$0] }.compactMap { $0 }.first
                        throw NetworkError.executeException(.executeFail(msg: msg, response: json))
                    }

                    return response
                }
                .asObservable()
    }
}
