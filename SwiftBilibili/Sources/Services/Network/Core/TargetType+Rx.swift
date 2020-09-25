//
//  TargetType+Rx.swift
//  SwiftBilibili
//
//  Created by luowen on 2020/9/21.
//  Copyright © 2020 luowen. All rights reserved.
//

import RxSwift
import Moya

public extension TargetType {
    func request() -> Single<Moya.Response> {
        return Network.default.provider.rx.request(.target(self))
            .map({ (response) -> Response in
                let jsonData = try JSONSerialization.jsonObject(with: response.data, options: .allowFragments)
                guard let json = jsonData as? [String: Any] else {
                    throw NetworkError.responseSerializationException(.jsonSerializationFailed(nil))
                }
                guard let status = json[Network.Configuration.default.mapperKeyValue.statusCodeKey] else {
                    throw NetworkError.executeException(.unlegal)
                }
                guard "\(status)" == Network.Configuration.default.mapperKeyValue.successValue else {
                    throw NetworkError.executeException(.executeFail(code: "\(status)", msg: json[Network.Configuration.default.mapperKeyValue.msgStrKey] as? String))
                }
                return response
            }).do(onError: { (error) in
                if error is MoyaError {
                    switch error as! MoyaError {
                    case .statusCode(let response):
                        if response.statusCode == 500 {
                            throw NetworkError.responseException(.serverException)
                        }
                        if response.statusCode == 404 {
                            throw NetworkError.responseException(.notFound)
                        }
                        throw NetworkError.responseException(.unacceptableStatusCode(code: response.statusCode))
                    case let .underlying(error, _):
                        throw NetworkError.requestException(.networkException(error))
                    default:break
                    }
                }
            })

    }
}
