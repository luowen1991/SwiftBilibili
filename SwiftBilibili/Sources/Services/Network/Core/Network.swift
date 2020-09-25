//
//  Networking.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2020/9/6.
//  Copyright © 2020 luowen. All rights reserved.
//

import Moya

open class Network {

    public static let `default`: Network = {
        Network(configuration: Configuration.default)
    }()

    public let provider: MoyaProvider<MultiTarget>

    public init(configuration: Configuration) {
        provider = MoyaProvider(configuration: configuration)
    }
}

public extension MoyaProvider {

    convenience init(configuration: Network.Configuration) {

        let endpointClosure = { target -> Endpoint in
            MoyaProvider.defaultEndpointMapping(for: target)
                .adding(newHTTPHeaderFields: configuration.addingHeaders(target))
                .replacing(task: configuration.replacingTask(target))
        }

        let requestClosure = { (endpoint: Endpoint, closure: RequestResultClosure) -> Void in
            do {
                var request = try endpoint.urlRequest()
                request.timeoutInterval = configuration.timeoutInterval

                // 在实际开发中不需要 抓包的参数已经转义了 而moya内部会再转义一遍 所以需要去掉moya的转义
                request.url = URL(string: request.url?.absoluteString.removingPercentEncoding ?? "")
                closure(.success(request))
            } catch MoyaError.requestMapping(let url) {
                closure(.failure(.requestMapping(url)))
            } catch MoyaError.parameterEncoding(let error) {
                closure(.failure(.parameterEncoding(error)))
            } catch {
                closure(.failure(.underlying(error, nil)))
            }
        }

        self.init(
            endpointClosure: endpointClosure,
            requestClosure: requestClosure,
            plugins: configuration.plugins
        )
    }
}
