//
//  CGFloatLiteral.swift
//  SwiftBilibili
//
//  Created by luowen on 2020/9/4.
//  Copyright © 2020 luowen. All rights reserved.
//

import CoreGraphics

public extension IntegerLiteralType {
  var f: CGFloat {
    return CGFloat(self)
  }
}

public extension FloatLiteralType {
  var f: CGFloat {
    return CGFloat(self)
  }
}
