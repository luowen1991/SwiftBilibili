//
//  LaunchAdConfiguration.swift
//  SwiftBilibili
//
//  Created by luowen on 2020/9/27.
//  Copyright © 2020 luowen. All rights reserved.
//

import UIKit
import AVFoundation

public enum LaunchAdAnimationType {
    case none
    case fadeIn
    case flipFromLeft
}

public enum LaunchAdSkipButtonType {
    case none
    case textLeftTimerRight
}

public class LaunchAdConfig {

    /// 广告类型
    public var adType: LaunchAdType = .image

    /// 停留时间
    public var duration: Int = 5

    /// 完成动画类型
    public var animationType: LaunchAdAnimationType = .fadeIn

    /// 完成动画时间
    public var animationDuration: CGFloat = 0.8

    /// 设置开屏广告的frame
    public var adFrame: CGRect = .init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 100)

    /// 程序从后台恢复时,是否需要展示广告
    public var showEnterForeground: Bool = true

    /// 点击打开页面参数
    public var openModel: Any?

    /// 自定义跳过按钮(若定义此视图,将会自定替换系统跳过按钮)
    public var customSkipView: UIView?

    /// 子视图(若定义此属性,这些视图将会被自动添加在广告视图上,frame相对于window)
    public var subviews: [UIView] = []

    /// image本地图片名(jpg/gif图片请带上扩展名)或网络图片URL
    public var imageNameOrURLString: String?

    /// 图片广告缩放模式
    public var contentMode: UIView.ContentMode = .scaleToFill

    /// 设置GIF动图是否只循环播放一次
    public var GIFImageCycleOnce: Bool = false

    /// video本地名或URL
    public var videoNameOrURLString: String?

    /// 视频填充模式
    public var videoGravity: AVLayerVideoGravity = .resizeAspectFill

    /// 设置视频是否只循环播放一次
    public var videoCycleOnce: Bool = false

    /// 是否静音
    public var isMuted: Bool = false

    /// frame
    public var skipButtonframe = CGRect(x: UIScreen.main.bounds.width - 70,y: UIScreen.main.bounds.height - 49, width: 60,height: 30)

    /// 背景颜色
    public var backgroundColor = UIColor.black.withAlphaComponent(0.4)

    /// 文字
    public var text: String = "跳过"

    /// 字体大小
    public var textFont = UIFont.systemFont(ofSize: 14)

    /// 字体颜色
    public var textColor = UIColor.white

    /// 数字大小
    public var timeFont = UIFont.systemFont(ofSize: 15)

    /// 数字颜色
    public var timeColor = UIColor.red

    /// 跳过按钮类型
    public var skipBtnType: LaunchAdSkipButtonType = .textLeftTimerRight

    /// 圆角
    public var cornerRadius: CGFloat = 5

    /// 边框颜色
    public var borderColor: UIColor = UIColor.clear

    /// 边框宽度
    public var borderWidth: CGFloat = 1

    public init() {}
}
