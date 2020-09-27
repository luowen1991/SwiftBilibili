//
//  LoadingManager.swift
//  SwiftBilibili
//
//  Created by luowen on 2020/9/22.
//  Copyright © 2020 luowen. All rights reserved.
//

import Foundation

class LoadingMnager: NSObject {

    static var `default` = LoadingMnager()

    let loadingIndictor = ActivityIndicator()

    override init() {
        super.init()

        loadingIndictor.asObservable()
            .subscribe { (isLoading) in
                debugPrint("加载状态: \(isLoading)")
            }
            .disposed(by: rx.disposeBag)
    }
}
