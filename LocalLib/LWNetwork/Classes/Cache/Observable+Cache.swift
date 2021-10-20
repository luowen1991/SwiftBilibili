//
//  Observable+Cache.swift
//  LWNetwork
//
//  Created by luowen on 2021/10/9.
//

import RxSwift
import Moya

extension ObservableType
where Element: SugarTargetType, Element: Cacheable, Element.ResponseType == Moya.Response {

    public func request(timeoutInterval: TimeInterval? = nil,
                        callbackQueue: DispatchQueue? = nil)
    -> Observable<Moya.Response> {

        return flatMap { target -> Observable<Moya.Response> in
            let source = target.request()
                .storeCachedResponse(for: target)

            if let response = try? target.cachedResponse(),
                target.allowsStorage(response) {
                return source.startWith(response)
            }

            return source
        }
    }
}
