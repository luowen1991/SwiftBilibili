//
//  BaseWebViewController.swift
//  SwiftBilibili
//
//  Created by luowen on 2020/9/22.
//  Copyright © 2020 luowen. All rights reserved.
//

import UIKit
import dsBridge

final class BaseWebViewController: BaseViewController {

    private let url: String
    private let webTitle: String?
    private let showProgress: Bool
    private let showNavBar: Bool

    private var progressObservation: NSKeyValueObservation?

    init(url: String,
         title: String? = nil,
         showProgress: Bool = true,
         showNavBar: Bool = true) {
        log.debug("加载的网页地址: \(url)")
        self.url = url
        self.webTitle = title
        self.showProgress = showProgress
        self.showNavBar = showNavBar
        super.init()
    }

    required convenience init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        customLeftNavItem()
        loadUrl()
    }

    private func loadUrl() {
        dwkWebView.loadUrl(url)
        dwkWebView.addJavascriptObject(nil, namespace: nil)
        dwkWebView.navigationDelegate = self
    }

    private func customLeftNavItem() {

        if !self.showNavBar { return }

        let backItem = UIBarButtonItem(image: Image.Common.whiteBack, style: .plain, target: nil, action: nil)
        let closeItem = UIBarButtonItem(title: "关闭", style: .plain, target: nil, action: nil)

        //self.navigation.item.leftBarButtonItems = [backItem, closeItem]

        closeItem.rx.tap
            .subscribe {[weak self] (_) in
                self?.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)

        backItem.rx.tap
            .subscribe {[weak self] (_) in
                guard let self = self else { return }
                if self.dwkWebView.canGoBack {
                    self.dwkWebView.goBack()
                } else {
                    self.navigationController?.popViewController(animated: true)
                }
            }
            .disposed(by: disposeBag)
    }

    override func setupUI() {
        view.addSubview(dwkWebView)
        if showProgress {
            view.addSubview(progressView)
        }
    }

    override func bindEvent() {
        if showProgress {
            progressObservation = dwkWebView.observe(\.estimatedProgress) {[weak self] (webView,_) in
                guard let self = self else { return }
                self.progressView.alpha = 1
                let progress = webView.estimatedProgress
                log.debug(progress)
                self.progressView.setProgress(Float(progress), animated: true)
                if progress >= 1.0 {
                    UIView.animate(withDuration: 0.1, animations: {
                        self.progressView.alpha = 0
                    }) { (_) in
                        self.progressView.setProgress(0, animated: true)
                    }
                }
            }
        }
    }

    override func setupConstraints() {
        dwkWebView.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalTo(showNavBar ? Screen.navigationBarHeight : 0)
        }
        if showProgress {
            progressView.snp.makeConstraints {
                $0.left.right.top.equalTo(dwkWebView)
                $0.height.equalTo(6)
            }
        }
    }

    private lazy var dwkWebView: DWKWebView = {
        DWKWebView()
    }()

    private lazy var progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.theme.progressTintColor = themed { $0.mainColorModel.pi6 }
        progressView.trackTintColor = .clear
        return progressView
    }()

}

extension BaseWebViewController: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if showNavBar {
            //self.navigation.item.title = webView.title
        }
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
    }

}
