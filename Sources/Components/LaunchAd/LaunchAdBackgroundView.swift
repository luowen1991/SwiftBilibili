//
//  LaunchAdBackgroundView.swift
//  SwiftBilibili
//
//  Created by luowen on 2020/9/27.
//  Copyright © 2020 luowen. All rights reserved.
//

import UIKit

public class LaunchAdBackgroundView: UIImageView {

    init() {
        super.init(frame: UIScreen.main.bounds)
        isUserInteractionEnabled = true
        backgroundColor = .white
        image = imageFromLaunchScreen()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func imageFromLaunchScreen() -> UIImage? {

        guard let launchStoryboardName = Bundle.main.infoDictionary?["UILaunchStoryboardName"] as? String,
              let launchScreenSb = UIStoryboard(name: launchStoryboardName, bundle: nil).instantiateInitialViewController(),
              let view = launchScreenSb.view
        else {
            return nil
        }
        return imageFromView(view)
    }

    private func imageFromView(_ view: UIView) -> UIImage? {

        guard !view.frame.isEmpty else {
            return nil
        }
        let size = view.bounds.size
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

}
