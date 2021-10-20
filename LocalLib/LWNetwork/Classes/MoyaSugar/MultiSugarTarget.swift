//
//  MultiSugarTarget.swift
//  LWNetworking
//
//  Created by luowen on 2021/10/8.
//

import Foundation
import Moya

public enum MultiSugarTarget: SugarTargetType {
    case target(SugarTargetType)

    public init(_ target: SugarTargetType) {
        self = .target(target)
    }

    public var target: SugarTargetType {
        switch self {
        case let .target(target):
            return target
        }
    }

    public var baseURL: URL {
        return target.baseURL
    }

    public var url: URL {
        return target.url
    }

    public var defaultURL: URL {
        return target.defaultURL
    }

    public var route: Route {
        return target.route
    }

    public var parameters: Parameters? {
        return target.parameters
    }

    public var headers: [String: String]? {
        return target.headers
    }

    public var task: Task {
        return target.task
    }

    public var validationType: ValidationType {
        return target.validationType
    }

    public var sampleData: Data {
        return target.sampleData
    }
}
