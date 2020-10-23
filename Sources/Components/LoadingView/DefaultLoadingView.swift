//
//  DefaultLoadingView.swift
//  SwiftBilibili
//
//  Created by luowen on 2020/10/22.
//  Copyright © 2020 luowen. All rights reserved.
//

import UIKit

final class DefaultLoadingView: BaseView {

    override func setupViews() {
        addSubview(animationImageView)
        addSubview(textLabel)
    }

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        animationImageView.startAnimating()
    }

    override func removeFromSuperview() {
        animationImageView.stopAnimating()
        super.removeFromSuperview()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        animationImageView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
        }

        textLabel.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalTo(animationImageView.snp.bottom).offset(20)
        }
    }

    let textLabel = UILabel().then {
        $0.text = "正在努力加载数据中..."
        $0.font = Font.appFont(ofSize: 15)
        $0.theme.textColor = themed { $0.mainColorModel.ga5 }
        $0.textAlignment = .center
    }

    let animationImageView = UIImageView().then {
        $0.animationRepeatCount = 0
        var animationImages: [UIImage] = []
        for i in 0..<3 {
            let imageName = "loading_\(i+1)_280x158_"
            let image = UIImage(named: imageName)!
            animationImages.append(image)
        }
        $0.animationImages = animationImages
    }

}
