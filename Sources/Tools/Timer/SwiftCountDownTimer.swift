//
//  SwiftCountDownTimer.swift
//  SwiftBilibili
//
//  Created by luowen on 2020/10/26.
//  Copyright © 2020 luowen. All rights reserved.
//

import Foundation

public class SwiftCountDownTimer {

    private let internalTimer: SwiftTimer

    private var leftTimes: Int

    private let originalTimes: Int

    private let handler: (SwiftCountDownTimer, _ leftTimes: Int) -> Void

    /// 初始化倒计时
    /// - Parameters:
    ///   - interval: 间隔
    ///   - times: 剩余时间
    ///   - queue: 队列
    ///   - handler: 回调
    public init(interval: DispatchTimeInterval,
                times: Int,
                queue: DispatchQueue = .main,
                handler:  @escaping (SwiftCountDownTimer, _ leftTimes: Int) -> Void ) {

        self.leftTimes = times
        self.originalTimes = times
        self.handler = handler
        self.internalTimer = SwiftTimer.repeaticTimer(interval: interval, queue: queue, handler: { _ in
        })
        self.internalTimer.rescheduleHandler { [weak self] swiftTimer in
            guard let self = self else {
                return
            }
            if self.leftTimes > 0 {
                self.leftTimes -= 1
                self.handler(self, self.leftTimes)
            } else {
                swiftTimer.suspend()
            }
        }
    }

    public func start() {
        self.internalTimer.start()
    }

    public func suspend() {
        self.internalTimer.suspend()
    }

    public func reCountDown() {
        self.leftTimes = self.originalTimes
    }

}
