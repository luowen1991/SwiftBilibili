//
//  Single+MoyaObjectMapper.swift
//  SwiftBilibili
//
//  Created by luowen on 2020/9/21.
//  Copyright © 2020 luowen. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import ObjectMapper

public extension PrimitiveSequence where Trait == SingleTrait, Element == Response {

    func mapObject<T: BaseMappable>(_ type: T.Type, context: MapContext? = nil) -> Single<T> {
        return flatMap { response -> Single<T> in
            return Single.just(try response.mapObject(type, context: context))
        }.do { (error) in
            if error is MapError {
                // swiftlint:disable force_cast
                print((error as! MapError).description)
            }
        }

    }

    func mapArray<T: BaseMappable>(_ type: T.Type, context: MapContext? = nil) -> Single<[T]> {
        return flatMap { response -> Single<[T]> in
            return Single.just(try response.mapArray(type, context: context))
        }

    }
}
