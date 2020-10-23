//
//  LaunchAdTitleView.swift
//  SwiftBilibili
//
//  Created by luowen on 2020/10/23.
//  Copyright © 2020 luowen. All rights reserved.
//

import UIKit

final class LaunchAdTitleView: BaseView {

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = UIColor.black.withAlphaComponent(0.5)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setupViews() {
        addSubview(arrowImageView)
        addSubview(titleLabel)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        arrowImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalTo(-15)
        }

        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(15)
        }
    }

    let titleLabel = UILabel().then {
        $0.textColor = .white
        $0.font = Font.appFont(ofSize: 15)
    }

    let arrowImageView = UIImageView().then {
        $0.image = Image.Common.whiteArrow
    }
}
