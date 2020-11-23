//
//  Toast.swift
//  SwiftBilibili
//
//  Created by luowen on 2020/11/19.
//  Copyright © 2020 luowen. All rights reserved.
//

import Toast_Swift

struct Toast {
    static func show(title: String? = nil,
                     message: String? = nil,
                     on: UIView? = nil) {
        if let superview = on {
            superview.makeToast(message)
        } else {
            let superview = UIApplication.shared.windows.last
            superview?.makeToast(message)
        }
    }
}
