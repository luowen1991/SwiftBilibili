//
//  LaunchAdBottomView.swift
//  SwiftBilibili
//
//  Created by luowen on 2020/9/27.
//  Copyright © 2020 luowen. All rights reserved.
//

import UIKit

public class LaunchAdBottomView: UIView {

    public override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(logoImageView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        logoImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }

    private let logoImageView = UIImageView().then {
        $0.image = Image.Launch.logo
    }

}
