//
//  MapAt.swift
//  SwiftBilibili
//
//  Created by luowen on 2020/9/16.
//  Copyright © 2020 luowen. All rights reserved.
//

import RxSwift
import RxCocoa

extension ObservableType {

    /**
     Returns an observable sequence containing as many elements as its input but all of them are mapped to the result at the given keyPath
     
     - parameter keyPath: A key path whose root type matches the element type of the input sequence
     - returns: An observable squence containing the values pointed to by the key path
     */
    public func mapAt<Result>(_ keyPath: KeyPath<Element, Result>) -> Observable<Result> {
        return self.map { $0[keyPath: keyPath] }
    }
}

extension SharedSequenceConvertibleType {

    public func mapAt<Result>(_ keyPath: KeyPath<Element, Result>) -> SharedSequence<SharingStrategy, Result> {
        return self.map { $0[keyPath: keyPath] }
    }
}
