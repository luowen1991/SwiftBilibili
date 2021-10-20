//
//  Network.swift
//
//
//  Created by 罗文 on 2020/9/6.
//  Copyright © 2020 luowen. All rights reserved.
//

import Moya

public class Network {

    public static let shared = Network()

    public var timeoutInterval: TimeInterval?

    public let provider: MoyaSugarProvider<MultiSugarTarget>

    public init() {
        provider = MoyaSugarProvider(configuration: .shared)
    }
}

public extension MoyaSugarProvider {

    convenience init(configuration: Network.Configuration) {

        let endpointClosure = { (target: Target) -> Endpoint in
            return MoyaSugarProvider.defaultEndpointMapping(for: target)
                .adding(newHTTPHeaderFields: configuration.addingHeaders(target))
                .replacing(task: configuration.replacingTask(target))
        }

        let requestClosure = { (endpoint: Endpoint, closure: RequestResultClosure) -> Void in
            do {
                var request = try endpoint.urlRequest()
                request.timeoutInterval = Network.shared.timeoutInterval ?? configuration.timeoutInterval
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
