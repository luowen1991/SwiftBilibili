//
//  LaunchAd.swift
//  SwiftBilibili
//
//  Created by luowen on 2020/9/27.
//  Copyright © 2020 luowen. All rights reserved.
//

import UIKit

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
    private var duration: Int = 5
    private var timer: Timer?
    private var window: UIWindow?
    private var cacheAdItem: AdShowRealmModel! {
        didSet {
            setupAd()
        }
    }
    private var isVideo: Bool = false


    @discardableResult
    static func display(with cacheAdItem: AdShowRealmModel,
                               delegate: LaunchAdDelegate? = nil) -> LaunchAd {
        let launchAd = LaunchAd.default
        if launchAd.window == nil {
            launchAd.setupLaunchAd()
        }
        launchAd.cacheAdItem = cacheAdItem
        launchAd.isVideo = cacheAdItem.videoUrl != nil
        if let delegate = delegate {
            launchAd.delegate = delegate
            delegate.launchAdWillDisplay(launchAd)
        }
        return launchAd
    }

    init() {
        setupLaunchAd()
    }

    private func setupLaunchAd() {
        removeSubviews()
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = LaunchAdViewController()
        window.rootViewController?.view.backgroundColor = .white
        window.rootViewController?.view.isUserInteractionEnabled = false
        window.windowLevel = .statusBar + 1
        window.isHidden = false
        window.alpha = 1
        self.window = window
        addSubviews()
    }

    private func setupAd() {
        isVideo ? setupVideoAd() : setupImageAd()
    }

    /// 图片
    private func setupImageAd() {
        guard let window = self.window
        else {
            log.error("window miss")
            return
        }
        window.addSubview(adImageView)
        adImageView.snp.makeConstraints {
            $0.left.top.right.equalToSuperview()
            $0.bottom.equalTo(adBottomView.snp.top)
        }
        AdCacheManager.default.cachedImage(url: cacheAdItem.thumb) {[unowned self] (image) in
            self.adImageView.image = image
        }
        addSkipButton()
        startCountDown()
    }

    /// 视频
    private func setupVideoAd() {
        guard let window = self.window,
              let videoUrl = cacheAdItem.videoUrl
        else {
            log.error("videoUrl or window miss")
            return
        }
        window.addSubview(adVideoView)
        adVideoView.frame = CGRect(x: 0, y: 0, width: Screen.width, height: adBottomView.frame.minY)
        adVideoView.isMuted = true
        adVideoView.videoURL = AdCacheManager.default.cachedFileURL(url: videoUrl)

        addSkipButton()
        startCountDown()
    }

    private func removeSubviews() {
        window?.subviews.forEach {
            $0.removeFromSuperview()
        }
    }

    private func addSubviews() {
        window?.addSubview(adBottomView)
        window?.addSubview(adTitleView)

        adBottomView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(-Screen.bottomSafeHeight)
            $0.height.equalTo(100)
        }

        adTitleView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.height.equalTo(50)
            $0.bottom.equalTo(adBottomView.snp.top)
        }
    }

    private func addSkipButton() {
        duration = cacheAdItem.duration
//        skipButton.updateRemainTime(duration)
//        window?.addSubview(skipButton)
//        skipButton.snp.makeConstraints {
//            $0.centerY.equalTo(adBottomView)
//            $0.width.equalTo(64)
//            $0.height.equalTo(30)
//            $0.right.equalTo(-20)
//        }

    }

    private func startCountDown() {
        if timer == nil {
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: {[weak self] (_) in
                guard let self = self else { return }
                self.duration -= 1
                //self.skipButton.updateRemainTime(self.duration)
                if self.duration == 0 {
                    self.clearTimer()
                    self.dismissAnimate()
                }
            })
        }
    }

    private func clearTimer() {
        timer?.invalidate()
        timer = nil
    }

    private func dismissAnimate() {
        UIView.transition(with: window!, duration: TimeInterval(duration), options: .transitionCrossDissolve) {
            self.window?.alpha = 0
        } completion: { (_) in
            self.remove()
        }
    }

    private func remove() {
        if isVideo {
            adVideoView.stop()
        }
        window?.subviews.forEach { $0.removeFromSuperview() }
        window?.isHidden = true
        window = nil
        delegate?.launchAdDidDismiss(self)
    }

    @objc private func skipButtonClick() {
        //delegate?.launchAd(self, didSelect: skipButton)
    }

    private func isNetUrl(_ url: String) -> Bool {
       return url.hasPrefix("http") || url.hasPrefix("https")
    }

    private lazy var adImageView: UIImageView = {
        let adImageView = UIImageView()
        adImageView.isUserInteractionEnabled = true
        return adImageView
    }()

    private lazy var adVideoView: LaunchAdVideoView = {
        LaunchAdVideoView()
    }()

    private lazy var adBottomView: LaunchAdBottomView = {
        LaunchAdBottomView()
    }()

    private lazy var adTitleView: LaunchAdTitleView = {
        LaunchAdTitleView()
    }()
}
