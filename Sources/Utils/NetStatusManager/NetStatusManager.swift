//
//  NetStatusManager.swift
//  SwiftBilibili
//
//  Created by luowen on 2020/9/7.
//  Copyright © 2020 luowen. All rights reserved.
//

import Foundation
import RxReachability
import Reachability
import RxSwift
import RxCocoa

struct NetStatusManager {

    static let `default` = NetStatusManager()

    private var disposeBag = DisposeBag()

    let reachability: Reachability? = {
        Reachability()
    }()

    let reachabilityConnection = BehaviorRelay(value: Reachability.Connection.cellular)

    func startNetworkStatusNotifier() {

        try? reachability?.startNotifier()

        reachability?.rx.reachabilityChanged
            .mapAt(\.connection)
            .bind(to: reachabilityConnection)
            .disposed(by: disposeBag)
    }
}
