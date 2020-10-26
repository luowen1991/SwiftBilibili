//
//  Font.swift
//  SwiftBilibili
//
//  Created by luowen on 2020/9/24.
//  Copyright © 2020 luowen. All rights reserved.
//

import UIKit

enum FontStyle: String {
    case system = "San Fransico"
    case helvetica = "Helvetica"
}

struct Font {
    // app的字体
    static func appFont(ofSize fontSize: CGFloat,
                        style: FontStyle = .system,
                        weight: UIFont.Weight = .regular) -> UIFont {

        switch style {
        case .system:
            return UIFont.systemFont(ofSize: fontSize.auto(), weight: weight)
        case .helvetica:
            return UIFont.monospacedDigitSystemFont(ofSize: fontSize.auto(), weight: weight)
        }

    }

}
