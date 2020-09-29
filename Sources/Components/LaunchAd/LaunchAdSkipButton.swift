//
//  LaunchAdSkipButton.swift
//  SwiftBilibili
//
//  Created by luowen on 2020/9/28.
//  Copyright © 2020 luowen. All rights reserved.
//

import UIKit

public class LaunchAdSkipButton: UIButton {

    private let config: LaunchAdConfig

    init(config: LaunchAdConfig = LaunchAdConfig()) {

        self.config = config
        super.init(frame: config.skipButtonframe)

        backgroundColor = config.backgroundColor
        updateRemainTime(config.duration)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// 倒计时更新
    func updateRemainTime(_ remainTime: Int) {

        let time = "\(remainTime)"
        switch config.skipBtnType {
        case .none:
           isHidden = true
        case .textLeftTimerRight:
            let titleAtt = NSMutableAttributedString(string: "\(config.text) \(time)")
            titleAtt.addAttributes([.foregroundColor: config.textColor, .font: config.textFont], range: NSRange(location: 0, length: config.text.count))
            titleAtt.addAttributes([.foregroundColor: config.timeColor, .font: config.timeFont], range: NSRange(location: config.text.count+1, length: time.count))
            setAttributedTitle(titleAtt, for: .normal)
            layer.borderColor = config.borderColor.cgColor
            layer.borderWidth = config.borderWidth
            layer.cornerRadius = config.cornerRadius
        }
    }

}
