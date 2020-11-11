//
//  LaunchAdVideoView.swift
//  SwiftBilibili
//
//  Created by luowen on 2020/9/27.
//  Copyright © 2020 luowen. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer
import AVKit

class LaunchAdVideoView: UIView {

    lazy var videoPlayer: AVPlayerViewController = {
        let videoPlayer = AVPlayerViewController()
        videoPlayer.showsPlaybackControls = false
        videoPlayer.videoGravity = .resizeAspectFill
        videoPlayer.view.frame = self.bounds
        videoPlayer.view.backgroundColor = .clear

        // 注册通知控制是否循环播放
        NotificationCenter.default.addObserver(self, selector: #selector(runLoopTheMovie), name: .AVPlayerItemDidPlayToEndTime, object: nil)

        // 获取音频焦点
        try? AVAudioSession.sharedInstance().setCategory(.playback)
        try? AVAudioSession.sharedInstance().setActive(true)

        return videoPlayer
    }()

    var videoGravity: AVLayerVideoGravity = .resizeAspectFill {
        didSet {
            videoPlayer.videoGravity = videoGravity
        }
    }

    var isMuted: Bool = false {
        didSet {
            videoPlayer.player?.isMuted = isMuted
        }
    }

    var videoCycleOnce: Bool = false

    var videoURL: URL? {
        didSet {
            guard let url = videoURL else {
                return
            }
            let movieAsset = AVURLAsset(url: url)
            playerItem = AVPlayerItem(asset: movieAsset)
            videoPlayer.player = AVPlayer(playerItem: playerItem)
            videoPlayer.player?.play()
            // 监听播放失败状态
            //playerItem?.addObserver(self, forKeyPath: "", options: .new, context: nil)
        }
    }

    var playerItem: AVPlayerItem?

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .clear
        addSubview(videoPlayer.view)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func stop() {
        videoPlayer.player?.pause()
        videoPlayer.player = nil
        try? AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        videoPlayer.view.frame = self.frame
    }

    @objc private func runLoopTheMovie(noti: Notification) {

        guard let playerItem = noti.object as? AVPlayerItem else { return }

        if !videoCycleOnce {
            playerItem.seek(to: .zero) {[weak self] (_) in
                guard let self = self else { return }
                self.videoPlayer.player?.play()
            }
        }
    }

}
