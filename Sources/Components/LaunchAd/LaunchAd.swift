//
//  LaunchAd.swift
//  SwiftBilibili
//
//  Created by luowen on 2020/9/27.
//  Copyright © 2020 luowen. All rights reserved.
//

import UIKit
import RxSwift
import RxGesture

protocol LaunchAdDelegate: class {
    /// 将要显示
    func launchAdWillDisplay(_ launchAd: LaunchAd)
    /// 已经消失
    func launchAdDidDismiss(_ launchAd: LaunchAd)
}

extension LaunchAdDelegate {
    func launchAdWillDisplay(_ launchAd: LaunchAd) {}
    func launchAdDidDismiss(_ launchAd: LaunchAd) {}
}

enum LaunchAdType {
    case image
    case video
}

class LaunchAd {

    private static let `default` = LaunchAd()
    private weak var delegate: LaunchAdDelegate?
    private var window: UIWindow?
    private var cacheAdItem: AdShowRealmModel!
    private var disposeBag = DisposeBag()
    private var cardType: AdCardType {
        return AdCardType(rawValue: cacheAdItem.cardType) ?? .topImage
    }

    @discardableResult
    static func display(with cacheAdItem: AdShowRealmModel,
                        delegate: LaunchAdDelegate? = nil) -> LaunchAd {

        let launchAd = LaunchAd.default
        launchAd.cacheAdItem = cacheAdItem
        if launchAd.window == nil {
            launchAd.setupWindow()
        }
        launchAd.setupAd()
        if let delegate = delegate {
            launchAd.delegate = delegate
            delegate.launchAdWillDisplay(launchAd)
        }
        return launchAd
    }

    private func setupWindow() {
        removeSubviews()
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = LaunchAdViewController()
        window.rootViewController?.view.backgroundColor = .white
        window.rootViewController?.view.isUserInteractionEnabled = false
        window.windowLevel = .statusBar + 1
        window.isHidden = false
        window.alpha = 1
        self.window = window
    }

    private func setupAd() {
        addSubviews()
        if cardType.isFull {
            window?.rx.tapGesture()
                .when(.recognized)
                .subscribe(onNext: {[unowned self] (_) in
                    self.gotoPreview()
                })
                .disposed(by: disposeBag)
        }
        cardType.isVideo ? setupVideoAd() : setupImageAd()

    }

    /// 图片
    private func setupImageAd() {
        if cardType.isFull {
            adImageView.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        } else {
            adImageView.snp.makeConstraints {
                $0.left.top.right.equalToSuperview()
                $0.bottom.equalTo(adBottomView.snp.top)
            }
        }
        AdCacheManager.default.cachedImage(url: cacheAdItem.thumb) {[unowned self] (image) in
            self.adImageView.image = image
        }
    }

    /// 视频
    private func setupVideoAd() {
        guard let videoUrl = cacheAdItem.videoUrl
        else { return }
        if cardType.isFull {
            adVideoView.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        } else {
            adVideoView.snp.makeConstraints {
                $0.left.top.right.equalToSuperview()
                $0.bottom.equalTo(adBottomView.snp.top)
            }
        }
        adVideoView.isMuted = true
        adVideoView.videoURL = AdCacheManager.default.cachedFileURL(url: videoUrl)
    }

    private func removeSubviews() {
        window?.subviews.forEach {
            $0.removeFromSuperview()
        }
    }

    private func addSubviews() {
        adBottomView.cardType = cardType
        adBottomView.duration = cacheAdItem.duration
        adBottomView.skipObservable
            .subscribe {[unowned self] (_) in
                self.dismissAnimate()
            }
            .disposed(by: disposeBag)
        cardType.isVideo ? window?.addSubview(adVideoView) : window?.addSubview(adImageView)
        window?.addSubview(adBottomView)
        adBottomView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(-Screen.bottomSafeHeight)
            $0.height.equalTo(100)
        }
        if !cacheAdItem.uriTitle.isEmpty {
            adTitleView.title = cacheAdItem.uriTitle
            adTitleView.tapObservable
                .subscribe {[unowned self] (_) in
                    self.gotoPreview()
                }
                .disposed(by: disposeBag)
            window?.addSubview(adTitleView)
            adTitleView.snp.makeConstraints {
                $0.left.right.equalToSuperview()
                $0.height.equalTo(44)
                $0.bottom.equalTo(adBottomView.snp.top)
            }
        }
    }

    private func dismissAnimate(duration: TimeInterval = 0.25) {
        guard let window = window else {
            return
        }
        UIView.transition(with: window, duration: duration, options: .transitionCrossDissolve) {
            self.window?.alpha = 0
        } completion: { (_) in
            self.remove()
        }
    }

    private func gotoPreview() {
        dismissAnimate(duration: 0)
        log.debug("点击跳转")
    }

    private func remove() {
        if cardType.isVideo {
            adVideoView.stop()
        }
        removeSubviews()
        window?.isHidden = true
        window = nil
        delegate?.launchAdDidDismiss(self)
    }

    private lazy var adImageView: UIImageView = {
        let adImageView = UIImageView()
        adImageView.contentMode = .scaleAspectFit
        adImageView.isUserInteractionEnabled = true
        return adImageView
    }()

    private lazy var adVideoView: LaunchAdVideoView = {
        LaunchAdVideoView()
    }()

    private lazy var adBottomView: LaunchAdBottomView = {
        let adBottomView = LaunchAdBottomView()
        adBottomView.countDownComplete = { [weak self] in
            guard let self = self else { return }
            self.dismissAnimate()
        }
        return adBottomView
    }()

    private var adTitleView: LaunchAdTitleView = {
        LaunchAdTitleView()
    }()
}
