//
//  NetRequestManager.swift
//  SwiftBilibili
//
//  Created by luowen on 2020/9/16.
//  Copyright © 2020 luowen. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class NetErrorManager {

    static var `default` = NetErrorManager()

    let errorIndictor = ErrorTracker()

    let retrySubject = PublishSubject<Void>()

    private var disposeBag = DisposeBag()

    init() {

        errorIndictor.asObservable()
            .subscribe(onNext: {[weak self] (error) in
                guard let self = self else { return }
                switch error {
                case .requestException(.networkException):
                    self.showNoConnectionView()
                case let .executeException(.executeFail(_, msg)):
                    if let msg = msg {
                        ToastManager.show(msg)
                    }
                case .responseException(.unacceptableStatusCode(let code)):
                    // 在这里处理401等错误 code == 401
                    log.debug(code)
                default:
                    log.error(error.errorDescription ?? "没有错误描述")
                }
            })
            .disposed(by: disposeBag)
    }

    private func showNoConnectionView() {

        guard let superview = UIViewController.topMost?.view else {
            return
        }
        let view = NoConnectionView()
        superview.addSubview(view)
        view.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-40)
        }

        view.retrySubject
            .bind(to: retrySubject)
            .disposed(by: disposeBag)
    }

}
