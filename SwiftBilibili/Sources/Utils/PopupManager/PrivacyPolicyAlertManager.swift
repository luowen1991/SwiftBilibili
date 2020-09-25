//
//  PrivacyPolicyAlertManager.swift
//  SwiftBilibili
//
//  Created by luowen on 2020/9/22.
//  Copyright © 2020 luowen. All rights reserved.
//

import SwiftEntryKit

struct PrivacyPolicyAlertManager {

    static var attributes: EKAttributes {
        var attributes = EKAttributes()
        attributes.displayDuration = .infinity
        attributes.roundCorners = .all(radius: 8)
        attributes.positionConstraints = .float
        attributes.position = .center
        attributes.entranceAnimation = .none
        attributes.exitAnimation = .none
        attributes.positionConstraints.size = .init(width: .offset(value: 40), height: .intrinsic)
        return attributes
    }

    static func show() {
        SwiftEntryKit.display(entry: PrivacyPolicyAlertView(), using: attributes)
    }

}
