//
//  ErrorTracker.swift
//  
//
//  Created by 罗文 on 2019/7/22.
//

import UIKit
import RxSwift
import RxCocoa
import Moya

public class ErrorTracker: SharedSequenceConvertibleType {

    public typealias SharingStrategy = DriverSharingStrategy
    private let _subject = PublishSubject<NetworkError>()

    public init() {}

    func trackError<O: ObservableConvertibleType>(from source: O) -> Observable<O.Element> {
        return source.asObservable().do(onError: {[unowned self] (error) in
            if error is NetworkError {
                // swiftlint: disable force_cast
                self.onError(error as! NetworkError)
            } else {
                self.onError(NetworkError.requestException(.networkException(error)))
            }
        })
    }

    public func asSharedSequence() -> SharedSequence<SharingStrategy, NetworkError> {
        return _subject.asObservable().asDriver(onErrorRecover: { (_) -> SharedSequence<DriverSharingStrategy, NetworkError> in
            return Driver.empty()
        })
    }

    public func asObservable() -> Observable<NetworkError> {
        return _subject.asObservable()
    }

    private func onError(_ error: NetworkError) {
        _subject.onNext(error)
    }

    deinit {
        _subject.onCompleted()
    }
}

extension ObservableConvertibleType {
    public func trackError(_ errorTracker: ErrorTracker) -> Single<Element> {
        return errorTracker.trackError(from: self).asSingle()
    }
}
