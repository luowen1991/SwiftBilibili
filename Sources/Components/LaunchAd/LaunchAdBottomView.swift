//
//  LaunchAdBottomView.swift
//  SwiftBilibili
//
//  Created by luowen on 2020/9/27.
//  Copyright © 2020 luowen. All rights reserved.
//

import UIKit

class LaunchAdBottomView: BaseView {

    var cacheAdItem: AdShowRealmModel? {
        didSet {
           updateViews()
        }
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setupViews() {
        addSubview(logoImageView)
        addSubview(skipButton)
    }

    func updateViews() {
        guard let cacheAdItem = cacheAdItem else { return }
        let title = "跳过 \(cacheAdItem.duration)"
        skipButton.setTitle(title, for: .normal)
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        logoImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        skipButton.snp.makeConstraints {
            $0.right.equalTo(-15)
            $0.centerY.equalTo(logoImageView)
            $0.height.equalTo(40)
        }
    }

    private let logoImageView = UIImageView().then {
        $0.image = Image.Launch.logo
    }

    private let skipButton = UIButton().then {
        $0.bbCornerRadius = 20
        $0.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
}
