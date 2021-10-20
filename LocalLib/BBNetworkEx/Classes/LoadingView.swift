//
//  LoadingView.swift
//  SwiftBilibili
//
//  Created by luowen on 2021/10/13.
//  Copyright © 2021 luowen. All rights reserved.
//  发起请求后的加载视图

import Foundation
import UIKit
import Then

final class LoadingView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupViews() {
        addSubview(containerView)
        containerView.addSubview(animationImageView)
        containerView.addSubview(textLabel)
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

        containerView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }

        animationImageView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
        }

        textLabel.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalTo(animationImageView.snp.bottom).offset(20)
        }
    }

    private let containerView = UIView().then {
        $0.backgroundColor = .clear
    }

    private let textLabel = UILabel().then {
        $0.text = "正在努力加载数据中..."
        $0.font = .systemFont(ofSize: 15)
        $0.textColor = UIColor(hex: "FF999999")
        $0.textAlignment = .center
    }

    private let animationImageView = UIImageView().then {
        $0.animationRepeatCount = 0
        var animationImages: [UIImage] = []
        for i in 0..<3 {
            let imageName = "loading_\(i+1)"
            guard let image = ResourceLoader.imageNamed(imageName) else { continue }
            animationImages.append(image)
        }
        $0.animationImages = animationImages
    }
}
