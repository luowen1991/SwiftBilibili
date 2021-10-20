//
//  Loading+Rx.swift
//  SwiftBilibili
//
//  Created by luowen on 2021/10/12.
//  Copyright © 2021 luowen. All rights reserved.
//

/*
   此类的作用是方便统一控制LoadingView的显示与隐藏,支持设置间距以及父视图

   ex: HomeAPI.request().showLoading()

   tip: LoadingView的superview默认会取当前控制器的view,但是如果当前控制器是一个父控制器，则需要当前显示的子控制器的view

 */

import UIKit
import LWNetwork
import RxSwift
import Moya
import SnapKit
import LWExtensionKit

private class LoadingActivityHelper {

    var superview: UIView?
    var edgeInset: UIEdgeInsets = .zero

    func reset() {
        superview = nil
        edgeInset = .zero
    }
}

private class LoadingActivity {

    var tempSuperview: UIView?

    static let shared = LoadingActivity()
    static let helper = LoadingActivityHelper()

    let activityIndicator = ActivityIndicator()

    init() {
        _ = activityIndicator.asObservable()
            .skip(1)
            .subscribe(onNext: { [unowned self] isLoading in
                self.showLoading(isLoading)
            })
    }

    static func setup(superview: UIView?, edgeInset: UIEdgeInsets) {
        LoadingActivity.helper.superview = superview
        LoadingActivity.helper.edgeInset = edgeInset
    }

    // 此处设置app统一的loadingView样式
    func showLoading(_ isLoading: Bool) {
        tempSuperview = LoadingActivity.helper.superview
        guard let superview = tempSuperview else { return }
        if isLoading {
            var edgeInset = LoadingActivity.helper.edgeInset
            let loadingView = LoadingView()
            if let scrollView = superview as? UIScrollView {
                let contentInset = scrollView.contentInset
                let top = contentInset.top + edgeInset.top
                let left = contentInset.left + edgeInset.left
                let bottom = contentInset.bottom + edgeInset.bottom
                let right = contentInset.right + edgeInset.right
                edgeInset = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
            }
            superview.addSubview(loadingView)
            loadingView.snp.makeConstraints {
                $0.edges.equalTo(edgeInset)
            }
        } else {
            guard let loadingView = superview.subviews.first(where: { $0 is LoadingView }) else { return }
            loadingView.removeFromSuperview()
            tempSuperview = nil
            LoadingActivity.helper.reset()
        }
    }
}

// 对外公开的api
extension Observable where Element == Moya.Response {

    public func showLoading(_ show: Bool = true,
                            superview: UIView? = nil,
                            edgeInset: UIEdgeInsets = .zero) -> Observable<Element> {

        guard show else { return self }

        guard let superview = superview ?? UIViewController.ex.topMost?.view else {
            return .empty()
        }
        LoadingActivity.setup(superview: superview, edgeInset: edgeInset)

        return self.trackActivity(LoadingActivity.shared.activityIndicator)
    }
}
