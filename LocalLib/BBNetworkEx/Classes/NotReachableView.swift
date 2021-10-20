//
//  NotReachableView.swift
//  SwiftBilibili
//
//  Created by luowen on 2021/10/13.
//  Copyright © 2021 luowen. All rights reserved.
//  无网显示的视图

import UIKit
import RxSwift
import LWExtensionKit
import Then
import SnapKit

public enum NotReachableViewType {
    case text
    case image
}

final class NotReachableView: UIView {

    var retryClosure: (() -> Void)?

    var viewType: NotReachableViewType = .image {
        didSet {
            switch viewType {
            case .text:
                imageView.isHidden = true
                tipLabel.text = "连接失败，重试一下"
                retryButton.setTitle("重试", for: .normal)
            case .image:
                imageView.isHidden = false
                tipLabel.text = "似乎已断开与互联网的连接"
                retryButton.setTitle("刷新一下", for: .normal)
            }
        }
    }

    private var disposeBag = DisposeBag()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        bindEvents()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        addSubview(vStackView)
        vStackView.addArrangedSubview(imageView)
        vStackView.addArrangedSubview(tipLabel)
        vStackView.addArrangedSubview(retryButton)
        vStackView.setCustomSpacing(20, after: imageView)
        vStackView.setCustomSpacing(10, after: tipLabel)
    }

    private func bindEvents() {
        retryButton.rx.tap
            .map {[unowned self] _ in self.removeFromSuperview()}
            .subscribe(onNext: { [unowned self] _ in
                self.retryClosure?()
            })
            .disposed(by: disposeBag)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        vStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

//        imageView.snp.makeConstraints {
//            $0.width.equalTo(184)
//            $0.height.equalTo(140)
//            $0.left.right.top.equalToSuperview()
//        }
//
//        tipLabel.snp.makeConstraints {
//            $0.left.right.equalToSuperview()
//            $0.top.equalTo(imageView.snp.bottom).offset(20)
//        }
//
//        retryButton.snp.makeConstraints {
//            $0.bottom.equalToSuperview()
//            $0.top.equalTo(tipLabel.snp.bottom).offset(10)
//            $0.centerX.equalToSuperview()
//        }
    }

    private lazy var vStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .center
        $0.distribution = .fill
    }

    private let imageView = UIImageView().then {
        $0.image = ResourceLoader.imageNamed("load_error_2")
    }

    private let tipLabel = UILabel().then {
        $0.textColor = UIColor(hex: "999999")
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.textAlignment = .center
    }

    private let retryButton = UIButton().then {
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        $0.backgroundColor = UIColor(hex: "FB7299")
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 4
        $0.layer.masksToBounds = true
        $0.contentEdgeInsets = UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12)
    }
}
