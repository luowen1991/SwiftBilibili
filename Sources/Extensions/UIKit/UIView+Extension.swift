//
//  UIView+Extension.swift
//  SwiftBilibili
//
//  Created by luowen on 2020/9/22.
//  Copyright © 2020 luowen. All rights reserved.
//

import UIKit

extension UIView {

    @IBInspectable public var bbCornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    @IBInspectable public var bbBorderWidth: CGFloat {
        get { return layer.borderWidth }
        set { layer.borderWidth = newValue }
    }
    @IBInspectable public var bbBorderColor: UIColor? {
        get { return UIColor(cgColor: layer.borderColor!) }
        set { layer.borderColor = newValue?.cgColor }
    }

}
