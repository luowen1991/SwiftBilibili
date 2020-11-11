//
//  UIButton+Kingfisher.swift
//  SwiftBilibili
//
//  Created by luowen on 2020/11/2.
//  Copyright © 2020 luowen. All rights reserved.
//

import UIKit
import Kingfisher
import RxSwift
import RxCocoa

extension UIButton {
    @discardableResult
    func setImage(
        with resource: URL?,
        for state: UIControl.State = .normal,
        placeholder: UIImage? = nil,
        completionHandler: ((Result<RetrieveImageResult, KingfisherError>) -> Void)? = nil
    ) -> DownloadTask? {

        let options: KingfisherOptionsInfo = [.transition(.fade(0.2)),.scaleFactor(UIScreen.main.scale)]
        return self.kf.setImage(with: resource, for: state, placeholder: placeholder, options: options, completionHandler: completionHandler)
    }

    @discardableResult
    func setBackgroundImage(
        with resource: URL?,
        for state: UIControl.State = .normal,
        placeholder: UIImage? = nil,
        completionHandler: ((Result<RetrieveImageResult, KingfisherError>) -> Void)? = nil
    ) -> DownloadTask? {

        let options: KingfisherOptionsInfo = [.transition(.fade(0.2)),.scaleFactor(UIScreen.main.scale)]
        return self.kf.setBackgroundImage(with: resource, for: state, placeholder: placeholder, options: options, completionHandler: completionHandler)
    }
}

extension Reactive where Base: UIButton {

    var image: Binder<URL?> {
        return Binder(self.base) { button,resource in
            button.setImage(with: resource)
        }
    }

    var backgroundImage: Binder<URL?> {
        return Binder(self.base) { button,resource in
            button.setBackgroundImage(with: resource)
        }
    }
}
