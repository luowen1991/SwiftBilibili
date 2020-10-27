//
//  LaunchAdBottomView.swift
//  SwiftBilibili
//
//  Created by luowen on 2020/9/27.
//  Copyright © 2020 luowen. All rights reserved.
//

import UIKit
import RxSwift

class LaunchAdBottomView: BaseView {

    var countDownComplete: (() -> Void)?
    var skipObservable: Observable<Void> {
        return skipSubject.asObserver()
    }
    var cardType: AdCardType = .topImage {
        didSet {
            updateSubviewApperance()
        }
    }
    var duration: Int = 0 {
        didSet {
            updateSkipTitle(leftTimes: duration)
            setupTimer()
        }
    }
    private var countDownTimer: SwiftCountDownTimer?
    private var skipSubject = PublishSubject<Void>()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setupViews() {
        addSubview(logoImageView)
        addSubview(skipButton)

        skipButton.rx.tap
            .map({[unowned self] (_) -> Void in
                self.countDownTimer?.suspend()
                return ()
            })
            .bind(to: skipSubject)
            .disposed(by: disposeBag)
    }

    private func setupTimer() {
        countDownTimer = SwiftCountDownTimer(interval: .seconds(1), times: duration, handler: {[weak self] (_, leftTimes) in
            guard let self = self else { return }
            self.updateSkipTitle(leftTimes: leftTimes)
            if leftTimes == 0 {
                self.countDownComplete?()
            }
        })
        countDownTimer?.start()
    }

    private func updateSkipTitle(leftTimes: Int) {
        let title = "跳过 \(leftTimes)"
        skipButton.setTitle(title, for: .normal)
    }

    private func updateSubviewApperance() {

        if cardType.isFull {
            logoImageView.image = Image.Launch.shadowLogo
            skipButton.backgroundColor = ThemeManager.shared.pinkStyleModel.colors.ga6
            skipButton.setTitleColor(.white, for: .normal)
        } else {
            logoImageView.image = Image.Launch.pinkLogo
            skipButton.bbBorderWidth = 1
            skipButton.bbBorderColor = ThemeManager.shared.pinkStyleModel.colors.ga3
            skipButton.setTitleColor(skipButton.bbBorderColor, for: .normal)
        }
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        if cardType.isFull {
            logoImageView.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.left.equalTo(20)
                $0.size.equalTo(Const.shadowLogoSize)
            }
        } else {
            logoImageView.snp.makeConstraints {
                $0.center.equalToSuperview()
                $0.size.equalTo(Const.splashLogoSize)
            }
        }
        skipButton.snp.makeConstraints {
            $0.right.equalTo(-20)
            $0.centerY.equalTo(logoImageView)
            $0.height.equalTo(40)
            $0.width.equalTo(80)
        }
    }

    private let logoImageView = UIImageView()

    private let skipButton = UIButton().then {
        $0.bbCornerRadius = 20
        $0.titleLabel?.font = Font.appFont(ofSize: 15, style: .helvetica)
        $0.adjustsImageWhenHighlighted = false
    }
}
