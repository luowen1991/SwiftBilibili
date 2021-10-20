//
//  Network+Error.swift
//  SwiftBilibili
//
//  Created by luowen on 2021/10/13.
//  Copyright © 2021 luowen. All rights reserved.
//

import RxSwift
import UIKit
import LWNetwork
import Toast_Swift
import LWExtensionKit
import ESPullToRefresh

public struct NotReachableConfig {

    public var superview: UIView?
    public var viewType: NotReachableViewType
    // 是否强制显示错误视图
    public var isForceDisplay: Bool
    public var verticalOffest: CGFloat

    public init(superview: UIView? = nil,
                viewType: NotReachableViewType = .image,
                isForceDisplay: Bool = false,
                verticalOffest: CGFloat = 0) {
        self.superview = superview
        self.viewType = viewType
        self.isForceDisplay = isForceDisplay
        self.verticalOffest = verticalOffest
    }
}

extension Notification.Name {
    public static let tokenExpired = Notification.Name.init(rawValue: "TokenExpiredNotification")
}

extension ObservableType {

    /// 处理自定义的网络错误
    public func handleCustomError(config: NotReachableConfig = NotReachableConfig(),
                                  bussinessErrorClosure: (([String: Any]) -> Void)? = nil)
    -> Observable<Element> {

        catchError { error -> Observable<Element> in

            guard let superview = config.superview ?? UIViewController.ex.topMost?.view else {
                return .empty()
            }

            // 停止刷新
            if let scrollView = superview as? UIScrollView {
                stopRefreshOrLoadMore(scrollView)
            } else if let scrollView = superview.subviews.first(where: { $0 is UIScrollView }) as? UIScrollView {
                stopRefreshOrLoadMore(scrollView)
            }

            // 处理请求错误
            guard let networkError = error as? NetworkError else { return .empty() }

            return Observable.create { observer in
                switch networkError {
                // 无网
                case .requestException(.networkException):
                    if viewIsEmpty(superview) || config.isForceDisplay {
                        // 显示无网重新加载视图
                        handleNotReachable(config: config) {
                            observer.on(.error(networkError))
                        }
                    } else {
                        superview.makeToast("网络连接失败", duration: 1, position: .center)
                        observer.on(.completed)
                    }
                // 业务错误
                case let .executeException(.executeFail(msg, response)):
                    // token过期 弹出登录页
                    if let tokenExpired = response["tokenExpired"] as? Bool, !tokenExpired {
                        // 登录模块接受通知弹出登录界面
                        NotificationCenter.default.post(name: .tokenExpired, object: nil)
                    }
                    // 业务方自己处理业务错误
                    else if let bussinessErrorClosure = bussinessErrorClosure {
                        bussinessErrorClosure(response)
                    }
                    // 通用业务错误提示
                    else if let msg = msg {
                        superview.makeToast(msg, duration: 1, position: .center)
                    }
                    observer.on(.completed)
                default:
                    print(networkError.localizedDescription)
                    observer.on(.completed)
                }
                return Disposables.create {}
            }
        }
        .retry()
    }

    private func stopRefreshOrLoadMore(_ scrollView: UIScrollView) {
        if let header = scrollView.header,
           header.isRefreshing {
            header.stopRefreshing()
        }
        if let footer = scrollView.footer, footer.isRefreshing {
            footer.stopRefreshing()
        }
    }

    private func handleNotReachable(config: NotReachableConfig,
                                    retryClosure: @escaping () -> Void) {

        guard let superview = config.superview ?? UIViewController.ex.topMost?.view else { return }
        let notReachableView = NotReachableView()
        notReachableView.viewType = config.viewType
        superview.addSubview(notReachableView)
        notReachableView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(config.verticalOffest)
        }
        notReachableView.retryClosure = retryClosure
    }

    private func viewIsEmpty(_ superview: UIView) -> Bool {

        // 如果承载视图是UIScrollView子类
        if let scrollView = superview as? UIScrollView {
            return scrollView.contentSize.height > 1 && !scrollView.isHidden
        }
        // 如果承载视图的子类里有UIScrollView子类
        if let scrollView = superview.subviews.first(where: { $0 is UIScrollView }) as? UIScrollView {
            return scrollView.contentSize.height > 1 && !scrollView.isHidden
        }
        // 如果承载视图就是UIView的子类
        return superview.subviews.count < 2
    }

}
