//
//  SugarTargetType.swift
//  LWNetworking
//
//  Created by luowen on 2021/10/8.
//

import Moya
import Foundation

public protocol SugarTargetType: TargetType {

    var url: URL { get }
    var route: Route { get }
    var parameters: Parameters? { get }
}

extension SugarTargetType {

    public var url: URL { defaultURL }

    public var defaultURL: URL {
        return path.isEmpty ? baseURL : baseURL.appendingPathComponent(self.path)
    }

    public var path: String { route.path }

    public var method: Moya.Method { route.method }

    public var task: Task {
        guard let parameters = parameters else { return .requestPlain }
        return .requestParameters(parameters: parameters.values, encoding: parameters.encoding)
    }

    public var sampleData: Data {  Data() }

    public var headers: [String : String]? { nil }
}
