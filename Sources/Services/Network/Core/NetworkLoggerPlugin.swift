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

        print("************************ NetRequestStart ************************")

        if let url = netRequest?.description {
            print("url   :  \(url)")
        }

        if let httpMethod = netRequest?.httpMethod {
            print("METHOD   :  \(httpMethod)")
        }

        if let body = netRequest?.httpBody, let output = String(data: body, encoding: .utf8) {
            print("Body   :  \(output)")
        }

        if let headers = netRequest?.allHTTPHeaderFields {
            print("Headers   :  \(headers)\n")
        }
    }

    public func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {

        guard Network.Configuration.default.logEnable else { return }

        print("************************ NetRequestEnd ************************")

        let url = target.baseURL.absoluteString + target.path
        print("url   :  \(url)")

        switch result {
        case .success(let response):
            if let data = try? JSON(data: response.data).dictionaryObject {
                print("Data   :  \(data)\n")
            } else {
                print("Error  :  Can not formatter data\n")
            }
        case .failure(let error):
            print("Error   :  \(error.errorDescription ?? "无错误描述")\n")
        }

    }
}
