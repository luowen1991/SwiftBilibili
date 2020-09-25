//
//  PrivacyPolicyAlertView.swift
//  SwiftBilibili
//
//  Created by luowen on 2020/9/22.
//  Copyright © 2020 luowen. All rights reserved.
//

import UIKit
import ActiveLabel
import RxSwift

final class PrivacyPolicyAlertView: BaseView {

    let agreeSubject = PublishSubject<Void>()

    private var isTapUnAgree = false

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupActiveLabel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setupViews() {
        addSubview(titleLabel)
        addSubview(scrollView)
        addSubview(tipLabel)
        addSubview(unAgreeButton)
        addSubview(agreeButton)
    }

    private func setupActiveLabel() {

        let oneType = ActiveType.custom(pattern: "\\《哔哩哔哩弹幕网用户使用协议》")
        let twoType = ActiveType.custom(pattern: "\\《哔哩哔哩隐私政策》")

        tipLabel.enabledTypes = [oneType,twoType]
        tipLabel.customColor[oneType] = .blue
        tipLabel.customColor[twoType] = .blue
        tipLabel.customize({
            $0.textColor = UIColor.gray
            $0.font = UIFont.systemFont(ofSize: 13)
            $0.text = "您可通过阅读完整的《哔哩哔哩弹幕网用户使用协议》和《哔哩哔哩隐私政策》来了解详细信息。"
        })
        tipLabel.handleCustomTap(for: oneType) {[unowned self] (_) in
            self.openURL("https://www.bilibili.com/blackboard/account-useragreement.html")
        }
        tipLabel.handleCustomTap(for: twoType) {[unowned self] (_) in
            self.openURL("https://www.bilibili.com/blackboard/privacy-h5.html")
        }
    }

    override func setupEvents() {

        unAgreeButton.rx.tap
            .subscribe {[weak self] (_) in
                guard let self = self else { return }
                self.isTapUnAgree ? self.exitApp() : self.updateUI()
            }
            .disposed(by: disposeBag)

        agreeButton.rx.tap
            .bind(to: agreeSubject)
            .disposed(by: disposeBag)
    }

    private func openURL(_ url: String) {
        guard let URL = URL(string: url) else { return }
        if UIApplication.shared.canOpenURL(URL) {
            UIApplication.shared.open(URL)
        }
    }

    private func updateUI() {
        unAgreeButton.setTitle("不同意并退出", for: .normal)
        scrollView.snp.updateConstraints {
            $0.height.equalTo(120)
        }
        isTapUnAgree = true
    }

    private func exitApp() {
        exit(0)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        titleLabel.snp.makeConstraints {
            $0.left.top.equalTo(15)
            $0.right.equalTo(-15)
        }

        scrollView.snp.makeConstraints {
            $0.left.right.equalTo(titleLabel)
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.height.equalTo(240)
        }

        tipLabel.snp.makeConstraints {
            $0.left.right.equalTo(titleLabel)
            $0.top.equalTo(scrollView.snp.bottom).offset(10)
        }

        unAgreeButton.snp.makeConstraints {
            $0.left.right.equalTo(titleLabel)
            $0.height.equalTo(40)
            $0.top.equalTo(tipLabel.snp.bottom)
        }

        agreeButton.snp.makeConstraints {
            $0.left.right.equalTo(titleLabel)
            $0.height.equalTo(unAgreeButton)
            $0.top.equalTo(unAgreeButton.snp.bottom)
            $0.bottom.equalTo(-15)
        }
    }

    private let titleLabel = UILabel().then {
        $0.text = "用户协议与隐私政策提示"
        $0.font = UIFont.systemFont(ofSize: 17,weight: .medium)
        $0.textColor = .black
        $0.textAlignment = .center
    }

    private let scrollView = UIScrollView().then {
        $0.backgroundColor = .red
    }

    private let tipLabel = ActiveLabel().then {
        $0.numberOfLines = 0
    }

    private let unAgreeButton = UIButton().then {
        $0.adjustsImageWhenHighlighted = false
        $0.setTitle("不同意", for: .normal)
        $0.setTitleColor(.gray, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 13)
    }

    private let agreeButton = UIButton().then {
        $0.adjustsImageWhenHighlighted = false
        $0.setTitle("同意并使用", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        $0.backgroundColor = .red
        $0.bbCornerRadius = 4
    }

}
