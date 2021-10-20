//
//  NetworkLoggerPlugin.swift
//  LWNetwork
//
//  Created by luowen on 2021/10/9.
//

import Moya

final class NetworkLoggerPlugin: PluginType {

    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        switch result {
        case .success(let response):
            var items: [String] = []
            items.append("  ┌─────────────────────────────────────────────────────────────────────────\n")
            items.append("  ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄🍎网络请求完成🍎┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄\n")
            items.append("  ├ 🍎请求类型: \(response.request?.httpMethod ?? "无") \n")
            items.append("  ├ 🍎请求地址: \((response.request?.url?.absoluteString ?? "")) \n")
            items.append("  ├ 🍎响应状态码: \(response.statusCode) \n")
            items.append("  ├ 🍎请求头部: \(response.request?.allHTTPHeaderFields ?? [:]) \n")
            items.append("  ├ 🍎请求参数: \(response.request?.httpBody?.stringValue ?? "无") \n")
            items.append("  ├ 🍎服务器返回数据:  \((try? response.mapString()) ?? "无") \n")
            items.append("  └──────────────────────────────────────────────────────────────────────── \n")
            outputItems(items)
        case .failure(let error):
            var items: [String] = []
            items.append("  ┌─────────────────────────────────────────────────────────────────────────\n")
            items.append("  ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄🍎网络请求完成🍎┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄\n")
            items.append("  ├ 🍎请求类型: \(target.method) \n")
            items.append("  ├ 🍎请求地址: \(target.baseURL.absoluteString + target.path) \n")
            items.append("  ├ 🍎请求头部: \(target.headers ?? [:]) \n")
            items.append("  ├ 🍎错误信息:  \(error.localizedDescription) \n")
            items.append("  └──────────────────────────────────────────────────────────────────────── \n")
            outputItems(items)
        }
    }

    private func outputItems(_ items: [String]) {
        #if DEBUG
        print(items.joined(separator: ""))
        #endif
    }

}

extension Data {
    var stringValue: String {
        return String(data: self, encoding: .utf8) ?? ""
    }
}

extension Dictionary {
    var stringValue: String {
        guard let data = try? JSONSerialization.data(withJSONObject: self, options: .fragmentsAllowed)
        else { return "" }
        return data.stringValue
    }
}
