//
//  LaunchAd.swift
//  SwiftBilibili
//
//  Created by luowen on 2020/9/27.
//  Copyright © 2020 luowen. All rights reserved.
//

import UIKit

public protocol LaunchAdDelegate: class {
    /// 跳过按钮点击(自定义跳过按钮 此方法不执行)
    func launchAd(_ launchAd: LaunchAd, didSelect skipButton: LaunchAdSkipButton)
    /// 将要显示
    func launchAdWillDisplay(_ launchAd: LaunchAd)
    /// 已经消失
    func launchAdDidDismiss(_ launchAd: LaunchAd)
}

extension LaunchAdDelegate {
    func launchAd(_ launchAd: LaunchAd, didSelect button: LaunchAdSkipButton) {}
    func launchAdWillDisplay(_ launchAd: LaunchAd) {}
    func launchAdDidDismiss(_ launchAd: LaunchAd) {}
}

public enum LaunchAdType {
    case image
    case video
}

public class LaunchAd {

    private static let `default` = LaunchAd()
    private weak var delegate: LaunchAdDelegate?
    private var duration: Int = 5
    private var timer: Timer?
    private var window: UIWindow?
    private var config: LaunchAdConfig! {
        didSet {
            setupAd()
        }
    }

    @discardableResult
    public static func display(with config: LaunchAdConfig = LaunchAdConfig(),
                               delegate: LaunchAdDelegate? = nil) -> LaunchAd {
        let launchAd = LaunchAd.default
        if launchAd.window == nil {
            launchAd.setupLaunchAd()
        }
        launchAd.config = config
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
        window.addSubview(adBottomView)
        adBottomView.frame = CGRect(x: 0, y: Screen.height-100-Screen.bottomSafeHeight, width: Screen.width, height: 100)
        self.window = window
    }

    private func setupAd() {
        switch config.adType {
        case .image:
            setupImageAd()
        case .video:
            setupVideoAd()
        }
    }

    /// 图片
    private func setupImageAd() {
        guard let window = self.window,
              let imageNameOrURLString = config.imageNameOrURLString,
              !imageNameOrURLString.isEmpty
        else {
            log.error("imageNameOrURLString or window miss")
            return
        }
        window.addSubview(adImageView)
        adImageView.frame = CGRect(x: 0, y: 0, width: Screen.width, height: adBottomView.frame.minY)
        adImageView.contentMode = config.contentMode
        // 网络图片
        if isNetUrl(imageNameOrURLString) {
            AdCacheManager.default.cachedImage(url: imageNameOrURLString) {[unowned self] (image) in
                self.adImageView.image = image
            }
        } else {
            adImageView.image = UIImage(named: imageNameOrURLString)
        }
        addSkipButton()
        startCountDown()
    }

    /// 视频
    private func setupVideoAd() {
        guard let window = self.window,
              let videoNameOrURLString = config.videoNameOrURLString,
              !videoNameOrURLString.isEmpty
        else {
            log.error("videoNameOrURLString or window miss")
            return
        }
        window.addSubview(adVideoView)
        adVideoView.frame = CGRect(x: 0, y: 0, width: Screen.width, height: adBottomView.frame.minY)
        adVideoView.videoGravity = config.videoGravity
        adVideoView.isMuted = config.isMuted
        if isNetUrl(videoNameOrURLString) {
            adVideoView.videoURL = AdCacheManager.default.cachedFileURL(url: videoNameOrURLString)
        } else {
            adVideoView.videoURL = URL(string: videoNameOrURLString)
        }
        addSkipButton()
        startCountDown()
    }

    private func removeSubviews() {
        window?.subviews.forEach {
            $0.removeFromSuperview()
        }
    }

    private func addSkipButton() {

        if let customSkipView = config.customSkipView {
            window?.addSubview(customSkipView)
        } else {
            duration = config.duration
            skipButton.updateRemainTime(duration)
            window?.addSubview(skipButton)
            skipButton.snp.makeConstraints {
                $0.centerY.equalTo(adBottomView)
                $0.width.equalTo(64)
                $0.height.equalTo(30)
                $0.right.equalTo(-20)
            }
        }
    }

    private func startCountDown() {
        if timer == nil {
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: {[weak self] (_) in
                guard let self = self else { return }
                self.duration -= 1
                if self.config.customSkipView == nil {
                    self.skipButton.updateRemainTime(self.duration)
                }
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
        switch config.animationType {
        case .none:
            remove()
        case .fadeIn:
            UIView.transition(with: window!, duration: TimeInterval(duration), options: .transitionCrossDissolve) {
                self.window?.alpha = 0
            } completion: { (_) in
                self.remove()
            }
        case .flipFromLeft:
            UIView.transition(with: window!, duration: TimeInterval(duration), options: .transitionFlipFromLeft) {
                self.window?.alpha = 0
            } completion: { (_) in
                self.remove()
            }
        }
    }

    private func remove() {
        if config.adType == .video {
            adVideoView.stop()
        }
        window?.subviews.forEach { $0.removeFromSuperview() }
        window?.isHidden = true
        window = nil
        delegate?.launchAdDidDismiss(self)
    }

    @objc private func skipButtonClick() {
        delegate?.launchAd(self, didSelect: skipButton)
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

    private lazy var skipButton: LaunchAdSkipButton = {
        let skipButton = LaunchAdSkipButton(config: config)
        skipButton.addTarget(self, action: #selector(skipButtonClick), for: .touchUpInside)
        return skipButton
    }()

}
