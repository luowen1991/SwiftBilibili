//
//  LaunchAd.swift
//  SwiftBilibili
//
//  Created by luowen on 2020/9/27.
//  Copyright © 2020 luowen. All rights reserved.
//

import UIKit
import Tiercel
import Kingfisher

public protocol LaunchAdDelegate: class {
    /// 跳过按钮点击(自定义跳过按钮 此方法不执行)
    func launchAd(_ launchAd: LaunchAd, didSelect skipButton: LaunchAdSkipButton)
    /// 显示广告图片
    func launchAd(_ launchAd: LaunchAd, display imageView: UIImageView, forUrl url: String)
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
            switch config.adType {
            case .image:
                setupImageAd()
            case .video:
                setupVideoAd()
            }
        }
    }

    @discardableResult
    public static func display(with config: LaunchAdConfig = LaunchAdConfig(),
                               delegate: LaunchAdDelegate) -> LaunchAd {
        let launchAd = LaunchAd.default
        launchAd.delegate = delegate
        launchAd.config = config
        delegate.launchAdWillDisplay(launchAd)
        return launchAd
    }

    init() {
        setupLaunchAd()
    }

    private func setupLaunchAd() {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = LaunchAdViewController()
        window.rootViewController?.view.backgroundColor = .clear
        window.rootViewController?.view.isUserInteractionEnabled = false
        window.windowLevel = .statusBar + 1
        window.isHidden = false
        window.alpha = 1
        window.addSubview(LaunchAdBackgroundView())
        self.window = window
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
        removeSubviews()
        window.addSubview(adImageView)
        adImageView.frame = config.adFrame
        adImageView.contentMode = config.contentMode
        // 网络图片
        if isNetUrl(imageNameOrURLString) {
            adImageView.setImage(with: URL(string: imageNameOrURLString))
        }
        // 本地图片
        else {
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
        removeSubviews()
        window.addSubview(adVideoView)
        adVideoView.frame = config.adFrame
        adVideoView.videoGravity = config.videoGravity
        if isNetUrl(videoNameOrURLString) {
            let sessionManager = AdCacheManager.default.appDelegate.adSessionManager
            if sessionManager.cache.fileExists(url: videoNameOrURLString),
               let task = sessionManager.fetchTask(videoNameOrURLString) {
                adVideoView.isMuted = config.isMuted
                adVideoView.videoURL = URL(fileURLWithPath: task.filePath)
            }
        }
        addSkipButton()
        startCountDown()
    }

    private func removeSubviews() {
        window?.subviews.filter { !($0 is LaunchAdBackgroundView) }.forEach {
            $0.removeFromSuperview()
        }
    }

    private func addSkipButton() {

        if let customSkipView = config.customSkipView {
            window?.addSubview(customSkipView)
        } else {
            if skipButton == nil {
                skipButton = LaunchAdSkipButton(config: config)
                skipButton?.addTarget(self, action: #selector(skipButtonClick), for: .touchUpInside)
            }
            window?.addSubview(skipButton!)
        }
    }

    private func startCountDown() {
        duration = config.duration
        if timer == nil {
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: {[weak self] (_) in
                guard let self = self else { return }
                self.duration -= 1
                if self.config.customSkipView == nil {
                    self.skipButton?.updateRemainTime(self.duration)
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
            self.remove()
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
        skipButton?.removeFromSuperview()
        skipButton = nil
        if config.adType == .video {
            adVideoView.stop()
        }
        window?.subviews.forEach { $0.removeFromSuperview() }
        window?.isHidden = true
        window = nil
        delegate?.launchAdDidDismiss(self)
    }

    @objc private func skipButtonClick() {
        delegate?.launchAd(self, didSelect: skipButton!)
    }

    private func isNetUrl(_ url: String) -> Bool {
       return url.hasPrefix("http") || url.hasPrefix("https")
    }

    private var skipButton: LaunchAdSkipButton?

    private lazy var adImageView: UIImageView = {
        let adImageView = UIImageView()
        adImageView.isUserInteractionEnabled = true
        return adImageView
    }()

    private lazy var adVideoView: LaunchAdVideoView = {
        LaunchAdVideoView()
    }()
}
