//
//  LaunchUserDefaults.swift
//  SwiftBilibili
//
//  Created by luowen on 2021/10/19.
//  Copyright © 2021 luowen. All rights reserved.
//

import SwiftyUserDefaults

enum LaunchUserDefaults {

    @SwiftyUserDefault(keyPath: \.isAgreePolicy)
    static var isAgreePolicy: Bool

}

extension DefaultsKeys {
    // 是否同意过隐私协议
    var isAgreePolicy: DefaultsKey<Bool> { .init("isAgreePolicy", defaultValue: false) }
}
