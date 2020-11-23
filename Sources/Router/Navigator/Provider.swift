//
//  Provider.swift
//  SwiftBilibili
//
//  Created by luowen on 2020/11/17.
//  Copyright © 2020 luowen. All rights reserved.
//

import UIKit
import URLNavigator

public typealias URLConvertible = URLNavigator.URLConvertible

public class Provider<T: RouterTypeable> {

    typealias ViewControllerFactory = (_ url: URLConvertible, _ values: [String: Any], _ context: Any?) -> Routerable?

    private let navigator: Navigator
    private let plugins: [Plugin<T>]

    public init(navigator: Navigator = Navigator(), _ plugins: [Plugin<T>] = []) {
        self.navigator = navigator
        self.plugins = plugins

        // 注册处理
        T.allCases.forEach { registers($0) }
    }
}

extension Provider {

    /// 打开
    ///
    /// - Parameters:
    ///   - url: url
    ///   - completion: 打开完成回调
    /// - Returns: true or false
    @discardableResult
    public func open(_ url: URLConvertible,
                     completion: ((Bool) -> Void)? = .none) -> Bool {
        return navigator.open(url, context: Context(completion ?? { _ in }))
    }

    /// 获取视图控制器
    ///
    /// - Parameters:
    ///   - url: url
    ///   - context: context
    /// - Returns: 视图控制器
    public func viewController(_ url: URLConvertible, _ context: Any? = nil) -> Routerable? {
        return navigator.viewController(for: url, context: context) as? Routerable
    }
}

extension Provider {

    private func handle(_ url: T, _ factory: @escaping URLOpenHandlerFactory) {
        navigator.handle(url.pattern) { (url, values, context) -> Bool in
            return factory(url, values, context)
        }
    }

    private func register(_ url: T, _ factory: @escaping ViewControllerFactory) {
        navigator.register(url.pattern) { (url, values, context) -> UIViewController? in
            return factory(url, values, context)
        }
    }
}

extension Provider {
    private func registers(_ type: T) {
        self.register(type) { (url, values, _) -> Routerable? in
            return type.controller(url: url, values: values)
        }
        self.handle(type) { [weak self] (url, values, context) -> Bool in
            guard let self = self else { return false }
            let context = context as? Context

            if self.plugins.isEmpty {
                if let controller = self.viewController(url, context) {
                    controller.open {
                        context?.callback(true)
                    }

                } else {
                    type.handle(url: url, values: values) { (result) in
                        context?.callback(result)
                    }
                }

            } else {
                guard self.plugins.contains(where: { $0.should(open: type) }) else {
                    return false
                }

                var result = true
                let total = self.plugins.count
                var count = 0
                let group = DispatchGroup()
                self.plugins.forEach { p in
                    group.enter()
                    p.prepare(open: type) {
                        // 防止插件多次回调
                        defer { count += 1 }
                        guard count < total else { return }

                        result = $0 ? result : false
                        group.leave()
                    }
                }

                group.notify(queue: .main) { [weak self] in
                    guard let self = self else {
                        context?.callback(false)
                        return
                    }
                    guard result else {
                        context?.callback(false)
                        return
                    }

                    if let controller = self.viewController(url, context) {
                        self.plugins.forEach {
                            $0.will(open: type, controller: controller)
                        }

                        controller.open { [weak self] in
                            guard let self = self else { return }
                            self.plugins.forEach {
                                $0.did(open: type, controller: controller)
                            }
                            context?.callback(true)
                        }

                    } else {
                        type.handle(url: url, values: values) { (result) in
                            context?.callback(result)
                        }
                    }
                }
            }
            return true
        }
    }
}
