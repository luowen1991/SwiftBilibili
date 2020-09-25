//
//  NetworkLoggerPlugin.swift
//  SwiftBilibili
//
//  Created by luowen on 2020/9/21.
//  Copyright © 2020 luowen. All rights reserved.
//

import Moya
import SwiftyJSON

public class NetworkLoggerPlugin: PluginType {

    public func willSend(_ request: RequestType, target: TargetType) {

        guard Network.Configuration.default.logEnable else { return }

        let netRequest = request.request

        if let url = netRequest?.description {
            log.info(url)
        }

        if let httpMethod = netRequest?.httpMethod {
            log.info("METHOD:\(httpMethod)")
        }

        if let body = netRequest?.httpBody, let output = String(data: body, encoding: .utf8) {
            log.info("Body:\(output)")
        }

        if let headers = netRequest?.allHTTPHeaderFields {
            log.info("Headers:\(headers)")
        }
    }

    public func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {

        guard Network.Configuration.default.logEnable else { return }

        switch result {
        case .success(let response):
            if let data = try? JSON(data: response.data).dictionary {
                log.info("Return Data:")
                log.info("\(data)")
            } else {
                log.error("Can not formatter data")
            }
        case .failure(let error):
            log.error("\(error.errorDescription ?? "无错误描述")")
        }

    }
}
