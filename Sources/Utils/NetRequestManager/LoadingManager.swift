//
//  LoadingManager.swift
//  SwiftBilibili
//
//  Created by luowen on 2020/9/22.
//  Copyright © 2020 luowen. All rights reserved.
//

import Foundation
import RxSwift

class LoadingManager: NSObject {

    static var `default` = LoadingManager()

    let loadingIndictor = ActivityIndicator()

    var containerView: UIView?

    private var disposeBag = DisposeBag()

    override init() {
        super.init()

        loadingIndictor.asObservable()
            .subscribe(onNext: {[weak self] (isLoading) in
                guard let self = self else { return }
                self.showLoadingView(isLoading)
            })
            .disposed(by: disposeBag)

    }

    private func showLoadingView(_ isLoading: Bool) {

        guard let superview = containerView ?? UIViewController.topMost?.view else {
            log.debug("loadingView superview not exist")
            return
        }

        if isLoading {
            let loadingView = DefaultLoadingView()
            superview.addSubview(loadingView)
            loadingView.snp.makeConstraints {
                $0.center.equalToSuperview()
            }
        } else {
            if let loadingView = superview.subviews.filter({ $0 is DefaultLoadingView }).first {
                loadingView.removeFromSuperview()
                self.containerView = nil
            }
        }
    }
}
