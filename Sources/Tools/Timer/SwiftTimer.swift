//
//  SwiftTimer.swift
//  SwiftBilibili
//
//  Created by luowen on 2020/10/26.
//  Copyright © 2020 luowen. All rights reserved.
//

import Foundation

public class SwiftTimer {

    private let internalTimer: DispatchSourceTimer

    private var isRunning = false

    public let repeats: Bool

    public typealias SwiftTimerHandler = (SwiftTimer) -> Void

    private var handler: SwiftTimerHandler

    public init(interval: DispatchTimeInterval,
                repeats: Bool = false,
                leeway: DispatchTimeInterval = .seconds(0),
                queue: DispatchQueue = .main,
                handler: @escaping SwiftTimerHandler) {

        self.handler = handler
        self.repeats = repeats
        internalTimer = DispatchSource.makeTimerSource(queue: queue)
        internalTimer.setEventHandler { [weak self] in
            guard let self = self else { return }
            handler(self)
        }

        if repeats {
            internalTimer.schedule(deadline: .now() + interval, repeating: interval, leeway: leeway)
        } else {
            internalTimer.schedule(deadline: .now() + interval, leeway: leeway)
        }
    }

    public static func repeaticTimer(interval: DispatchTimeInterval,
                                     leeway: DispatchTimeInterval = .seconds(0),
                                     queue: DispatchQueue = .main,
                                     handler: @escaping SwiftTimerHandler ) -> SwiftTimer {
        return SwiftTimer(interval: interval, repeats: true, leeway: leeway, queue: queue, handler: handler)
    }

    deinit {
        if !isRunning {
            internalTimer.resume()
        }
    }

    public func fire() {
        if repeats {
            handler(self)
        } else {
            handler(self)
            internalTimer.cancel()
        }
    }

    public func start() {
        if !isRunning {
            internalTimer.resume()
            isRunning = true
        }
    }

    public func suspend() {
        if isRunning {
            internalTimer.suspend()
            isRunning = false
        }
    }

    public func rescheduleRepeating(interval: DispatchTimeInterval) {
        if repeats {
            internalTimer.schedule(deadline: .now() + interval, repeating: interval)
        }
    }

    public func rescheduleHandler(handler: @escaping SwiftTimerHandler) {
        self.handler = handler
        internalTimer.setEventHandler { [weak self] in
            guard let self = self else { return }
            handler(self)
        }
    }
}

// MARK: - Throttle
public extension SwiftTimer {

    private static var workItems = [String:DispatchWorkItem]()

    /// 在指定的间隔后将调用处理
    /// 在间隔中再次调用将取消上一个调用
    static func debounce(interval: DispatchTimeInterval, identifier: String, queue: DispatchQueue = .main , handler: @escaping () -> Void ) {

        if let item = workItems[identifier] {
            item.cancel()
        }

        let item = DispatchWorkItem {
            handler()
            workItems.removeValue(forKey: identifier)
        }
        workItems[identifier] = item
        queue.asyncAfter(deadline: .now() + interval, execute: item)
    }

    /// 在指定的间隔后将调用处理
    /// 在间隔时间内再次调用无效
    static func throttle(interval: DispatchTimeInterval, identifier: String, queue: DispatchQueue = .main , handler: @escaping () -> Void ) {

        if workItems[identifier] != nil {
            return
        }

        let item = DispatchWorkItem {
            handler()
            workItems.removeValue(forKey: identifier)
        }
        workItems[identifier] = item
        queue.asyncAfter(deadline: .now() + interval, execute: item)
    }

    static func cancelThrottlingTimer(identifier: String) {
        if let item = workItems[identifier] {
            item.cancel()
            workItems.removeValue(forKey: identifier)
        }
    }
}
