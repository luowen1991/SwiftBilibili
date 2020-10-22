//
//  Font.swift
//  SwiftBilibili
//
//  Created by luowen on 2020/9/24.
//  Copyright © 2020 luowen. All rights reserved.
//

import UIKit

struct Font {

    // app的默认字体
    static func appFont(ofSize fontSize: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: fontSize.auto())
    }

}
