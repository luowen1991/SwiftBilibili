//
//  Refreshable.swift
//  SwiftBilibili
//
//  Created by luowen on 2020/11/24.
//  Copyright © 2020 luowen. All rights reserved.
//

import UIKit
import ESPullToRefresh
import RxSwift
import RxCocoa

typealias RefreshHeader = ESRefreshHeaderView
typealias RefreshFooter = ESRefreshFooterView
typealias RefreshAnimator = (ESRefreshProtocol & ESRefreshAnimatorProtocol)

public typealias RespectiveRefreshStatus = (RefreshStatus, Int)

public enum RefreshType {
    case header
    case footer
}

public enum RefreshStatus {
    case none
    case beginHeaderRefresh
    case endHeaderRefresh
    case beginFooterRefresh(Bool)
    case endFooterRefresh
    case noMoreData
    case resetNoMoreData
    case hiddenHeader
    case hiddenFooter
    case showHeader
    case showFooter
}

private enum TagType: Int {
    case `default` = 0
    case indiscrimination = -1
}

/* =========================== RefreshControllable =========================== */
// viewModel中使用
private var refreshStatusKey = "refreshStatusKey"
private var refreshStatusRespectivelyKey = "refreshStatusRespectivelyKey"

public protocol RefreshControllable: AnyObject, AssociatedObjectStore, LWProtocolCompatible {}
public extension LWProtocolNameSpace where Base: RefreshControllable {
    /// 告诉外界的 scrollView 当前的刷新状态
    var refreshStatus : BehaviorRelay<RefreshStatus> {
        return base.associatedObject(
            forKey: &refreshStatusKey,
            default: BehaviorRelay<RefreshStatus>(value: .none))
    }
    /// 同 refreshStatus，但可以针对不同 scrollView 做出控制
    var refreshStatusRespective : BehaviorRelay<RespectiveRefreshStatus> {
        return base.associatedObject(
            forKey: &refreshStatusRespectivelyKey,
            default: BehaviorRelay<RespectiveRefreshStatus>(value: (.none,TagType.default.rawValue)))
    }

    fileprivate func autoSetRefreshStatus(
        header: RefreshHeader?,
        footer: RefreshFooter?
        ) -> Disposable {

        return Observable.of(
            refreshStatusRespective.asObservable(),
            refreshStatus.asObservable().flatMap { Observable.just(($0,TagType.indiscrimination.rawValue)) }
            )
            .merge()
            .subscribe(onNext: { (status, tag) in
                var isHeader = true
                var isFooter = true
                if tag != TagType.indiscrimination.rawValue {
                    isHeader = tag == header?.tag ?? TagType.default.rawValue
                    isFooter = tag == footer?.tag ?? TagType.default.rawValue
                }
                switch status {
                case .beginHeaderRefresh:
                    if isHeader { header?.startRefreshing() }
                case .endHeaderRefresh:
                    if isHeader { header?.stopRefreshing() }
                case .beginFooterRefresh:
                    if isFooter { footer?.startRefreshing() }
                case .endFooterRefresh:
                    if isFooter { footer?.stopRefreshing() }
                case .noMoreData:
                    if isFooter {
                        footer?.stopRefreshing()
                        footer?.noMoreData = true
                    }
                case .resetNoMoreData:
                    if isFooter { footer?.noMoreData = false }
                case .hiddenHeader:
                    if isHeader { header?.isHidden = true }
                case .hiddenFooter:
                    if isFooter { footer?.isHidden = true }
                case .showHeader:
                    if isHeader { header?.isHidden = false }
                case .showFooter:
                    if isFooter { footer?.isHidden = false }
                case .none: break
                }
            })
    }
}

/* =========================== Refreshable =========================== */
// 需要使用 「刷新功能」 时使用

// MARK: 设置默认配置
public class RefreshableConfigure {
    static let shared = RefreshableConfigure()

    fileprivate var headerConfig: RefreshableHeaderConfig?
    fileprivate var footerConfig: RefreshableFooterConfig?

    /// 获取默认下拉配置
    ///
    /// - Returns: RefreshableHeaderConfig
    fileprivate static func defaultHeaderConfig() -> RefreshableHeaderConfig? {
        return RefreshableConfigure.shared.headerConfig
    }

    /// 获取默认上拉配置
    ///
    /// - Returns: RefreshableFooterConfig
    fileprivate static func defaultFooterConfig() -> RefreshableFooterConfig? {
        return RefreshableConfigure.shared.footerConfig
    }

    /// 设置默认上拉配置
    ///
    /// - Parameters:
    ///   - headerConfig: RefreshableHeaderConfig
    ///   - footerConfig: RefreshableFooterConfig
    public static func setDefaultConfig(
        headerConfig: RefreshableHeaderConfig?,
        footerConfig: RefreshableFooterConfig? = nil
    ) {
        RefreshableConfigure.shared.headerConfig = headerConfig
        RefreshableConfigure.shared.footerConfig = footerConfig
    }
}

public protocol Refreshable: LWProtocolCompatible {}
public extension Reactive where Base: Refreshable {

    /// 下拉控件
    ///
    /// - Parameters:
    ///   - vm: 遵守 RefreshControllable 协议的对象
    ///   - scrollView: UIScrollView 及子类
    ///   - headerConfig: 下拉控件配置
    /// - Returns: Observable<Void>
    func headerRefresh<T: RefreshControllable>(
        _ vm: T,
        _ scrollView: UIScrollView,
        headerConfig: RefreshableHeaderConfig? = nil
        ) -> Observable<Void> {

        return .create { observer -> Disposable in
            vm.lw.autoSetRefreshStatus(
                header: base.lw.initRefreshHeader(
                    scrollView,
                    config: headerConfig) { observer.onNext(()) },
                footer: nil)
        }
    }

    /// 上拉控件
    ///
    /// - Parameters:
    ///   - vm: 遵守 RefreshControllable 协议的对象
    ///   - scrollView: UIScrollView 及子类
    ///   - footerConfig: 上拉控件配置
    /// - Returns: Observable<Void>
    func footerRefresh<T: RefreshControllable>(
        _ vm: T,
        _ scrollView: UIScrollView,
        footerConfig: RefreshableFooterConfig? = nil
        ) -> Observable<Void> {

        return .create { observer -> Disposable in
            vm.lw.autoSetRefreshStatus(
                header: nil,
                footer: base.lw.initRefreshFooter(
                    scrollView,
                    config: footerConfig) { observer.onNext(()) }
            )
        }
    }

    /// 上下拉控件
    ///
    /// - Parameters:
    ///   - vm: 遵守 RefreshControllable 协议的对象
    ///   - scrollView: UIScrollView 及子类
    ///   - headerConfig: 下拉控件配置
    ///   - footerConfig: 上拉控件配置
    /// - Returns: Observable<RefreshType>
    func refresh<T: RefreshControllable>(
        _ vm: T,
        _ scrollView: UIScrollView,
        headerConfig: RefreshableHeaderConfig? = nil,
        footerConfig: RefreshableFooterConfig? = nil
        ) -> Observable<RefreshType> {

        return Observable.create { observer -> Disposable in
            vm.lw.autoSetRefreshStatus(
                header: base.lw.initRefreshHeader(
                    scrollView,
                    config: headerConfig) { observer.onNext(.header) },
                footer: base.lw.initRefreshFooter(
                    scrollView,
                    config: footerConfig) { observer.onNext(.footer) }
            )
        }
    }
}

extension LWProtocolNameSpace where Base: Refreshable {

    fileprivate func initRefreshHeader(
        _ scrollView: UIScrollView,
        config: RefreshableHeaderConfig? = nil,
        _ action: @escaping ESRefreshHandler
        ) -> RefreshHeader? {

        var header: RefreshHeader?
        if config == nil {
            if let headerConfig = RefreshableConfigure.defaultHeaderConfig() {
                let animator = createHeaderAnimator(scrollView, config: headerConfig)
                header = scrollView.es.addPullToRefresh(animator: animator, handler: action)
            } else {
                header = scrollView.es.addPullToRefresh(handler: action)
            }
        } else {
            let animator = createHeaderAnimator(scrollView, config: config!)
            header = scrollView.es.addPullToRefresh(animator: animator, handler: action)
        }
        header?.tag = scrollView.tag
        return header
    }

    fileprivate func initRefreshFooter(
        _ scrollView: UIScrollView,
        config: RefreshableFooterConfig? = nil,
        _ action: @escaping ESRefreshHandler
        ) -> RefreshFooter? {

        var footer: RefreshFooter?
        if config == nil {
            if let footerConfig = RefreshableConfigure.defaultFooterConfig() {
                let animator = createFooterAnimator(scrollView, config: footerConfig)
                footer = scrollView.es.addInfiniteScrolling(animator: animator, handler: action)
            } else {
                footer = scrollView.es.addInfiniteScrolling(handler: action)
            }
        } else {
            let animator = createFooterAnimator(scrollView, config: config!)
            footer = scrollView.es.addInfiniteScrolling(animator: animator, handler: action)
        }
        footer?.tag = scrollView.tag
        return footer
    }

    fileprivate func createHeaderAnimator(
            _ scrollView: UIScrollView,
            config: RefreshableHeaderConfig
    ) -> RefreshAnimator {
        switch config.type {
        case .normal:
            let headerAnimator = ESRefreshHeaderAnimator()
            if let idleTitle = config.idleTitle {
                headerAnimator.pullToRefreshDescription = idleTitle
            }
            if let pullingTitle = config.pullingTitle {
                headerAnimator.releaseToRefreshDescription = pullingTitle
            }
            if let refreshingTitle = config.refreshingTitle {
                headerAnimator.loadingDescription = refreshingTitle
            }
            return headerAnimator
        case .diy(let animator):
            return animator
        }
    }

    fileprivate func createFooterAnimator(
            _ scrollView: UIScrollView,
            config: RefreshableFooterConfig
    ) -> RefreshAnimator {

        switch config.type {
        case .normal:
            let footerAnimator = ESRefreshFooterAnimator()
            if let idleTitle = config.idleTitle {
                footerAnimator.loadingDescription = idleTitle
            }
            if let refreshingTitle = config.refreshingTitle {
                footerAnimator.loadingMoreDescription = refreshingTitle
            }
            if let norMoreDataTitle = config.norMoreDataTitle {
                footerAnimator.noMoreDataDescription = norMoreDataTitle
            }
            return footerAnimator
        case .diy(let animator):
            return animator
        }
    }

}

/* =========================== RefreshableConfig =========================== */
public enum RefreshHeaderType {
    case normal
    case diy(animator: (ESRefreshProtocol & ESRefreshAnimatorProtocol))
}

public enum RefreshFooterType {
    case normal
    case diy(animator: (ESRefreshProtocol & ESRefreshAnimatorProtocol))
}

public struct RefreshableHeaderConfig {
    /// 当type为diy时，其它属性就不用再传递了
    var type : RefreshHeaderType = .normal

    // title
    var idleTitle : String? // Pull down to refresh
    var pullingTitle : String? // Release to refresh
    var refreshingTitle : String? // Loading ...

    public init(
        type: RefreshHeaderType = .normal,
        idleTitle: String? = nil,
        pullingTitle: String? = nil,
        refreshingTitle: String? = nil
    ) {
        self.type = type
        self.idleTitle = idleTitle
        self.pullingTitle = pullingTitle
        self.refreshingTitle = refreshingTitle
    }
}

public struct RefreshableFooterConfig {
    /// 当type为diy时，其它属性就不用再传递了
    var type : RefreshFooterType = .normal

    // title
    var idleTitle : String? // Click or drag up to refresh
    var refreshingTitle : String? // Loading more ...
    var norMoreDataTitle : String? // No more data

    public init(
        type: RefreshFooterType = .normal,
        idleTitle: String? = nil,
        refreshingTitle: String? = nil,
        norMoreDataTitle: String? = nil
    ) {
        self.type = type
        self.idleTitle = idleTitle
        self.refreshingTitle = refreshingTitle
        self.norMoreDataTitle = norMoreDataTitle
    }
}
