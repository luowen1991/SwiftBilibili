//
//  UIImageView+Kingfisher.swift
//  SwiftBilibili
//
//  Created by luowen on 2020/9/11.
//  Copyright © 2020 luowen. All rights reserved.
//

import UIKit
import Kingfisher
import RxSwift
import RxCocoa

extension UIImageView {
    @discardableResult
    func setImage(
        with resource: URL?,
        placeholder: UIImage? = nil,
        completionHandler: ((Result<RetrieveImageResult, KingfisherError>) -> Void)? = nil
    ) -> DownloadTask? {

        let options: KingfisherOptionsInfo = [.transition(.fade(0.2)),.scaleFactor(UIScreen.main.scale)]
        return self.kf.setImage(with: resource, placeholder: placeholder, options: options, completionHandler: completionHandler)
    }
}

extension Reactive where Base: UIImageView {

    var image: Binder<URL?> {
        return Binder(self.base) { imageView,resource in
            imageView.setImage(with: resource)
        }
    }
}
