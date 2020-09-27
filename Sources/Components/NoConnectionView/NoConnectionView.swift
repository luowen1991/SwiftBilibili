//
//  NoConnectionView.swift
//  SwiftBilibili
//
//  Created by luowen on 2020/9/16.
//  Copyright © 2020 luowen. All rights reserved.
//  无网显示的

import UIKit
import RxSwift

enum NoConnectShowType {
    case `default`
    case splash
}

/// 无网显示的视图
final class NoConnectionView: UIView {

    let retrySubject = PublishSubject<Void>()

    private var showType: NoConnectShowType = .default {
        didSet {
           updateUI()
        }
    }

    deinit {
        debugPrint("NoConnectionView销毁了")
    }

    init(showType: NoConnectShowType = .default) {
        super.init(frame: .zero)

        self.showType = showType

        setupViews()
        setupEvents()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {

        addSubview(imageView)
        addSubview(tipLabel)
        addSubview(retryButton)
    }

    private func setupEvents() {
        retryButton.rx.tap
            .bind(to: retrySubject)
            .disposed(by: rx.disposeBag)
    }

    private func updateUI() {

    }

    override func layoutSubviews() {
        super.layoutSubviews()

        imageView.snp.makeConstraints {
            $0.width.equalTo(184)
            $0.height.equalTo(140)
            $0.left.right.top.equalToSuperview()
        }

        tipLabel.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(imageView.snp.bottom).offset(20)
        }

        retryButton.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.top.equalTo(tipLabel.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
    }

    private let imageView = UIImageView().then {
        $0.image = Image.NetError.default
    }

    private let tipLabel = UILabel().then {
        $0.theme.textColor = themed { $0.mainColorModel.ga5 }
        $0.text = "似乎已断开与互联网的连接"
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.textAlignment = .center
    }

    private let retryButton = UIButton().then {
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        $0.theme.backgroundColor = themed { $0.mainColorModel.pi5 }
        $0.setTitle("刷新一下", for: .normal)
        $0.theme.titleColor(from: themed {$0.mainColorModel.wh0}, for: .normal)
        $0.bbCornerRadius = 4
        $0.contentEdgeInsets = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
    }
}
