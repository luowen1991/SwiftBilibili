//
//  RouterOpener.swift
//  SwiftBilibili
//
//  Created by luowen on 2020/11/17.
//  Copyright © 2020 luowen. All rights reserved.
//

import Foundation

extension RouterType {

    func controller(url: URLConvertible, values: [String: Any]) -> Routerable? {

        switch self {
        case .http,.https:
            guard let url = url.urlValue else { return nil }
            return BaseWebViewController(url: url.absoluteString)
        case .error:
            return nil
        }
    }

    func handle(url: URLConvertible, values: [String : Any], completion: @escaping (Bool) -> Void) {
        log.debug("错误的url: \(url)")
        completion(true)
    }

}
