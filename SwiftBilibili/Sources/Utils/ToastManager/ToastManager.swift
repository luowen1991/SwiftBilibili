//
//  ToastManager.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2020/9/4.
//  Copyright © 2020 luowen. All rights reserved.
//

import UIKit

import Toast_Swift

struct ToastManager {

    static func show(_ message: String) {
        guard let window = UIApplication.shared.windows.first else {
            debugPrint("window不存在")
            return
        }
        window.makeToast(message, duration: 1, position: .center)
    }

}
