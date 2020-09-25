//
//  UIColor+Hex.swift
//  SwiftBilibili
//
//  Created by luowen on 2020/9/4.
//  Copyright © 2020 luowen. All rights reserved.
//

import UIKit

public extension UIColor {

    convenience init(_ r:CGFloat,_ g:CGFloat,_ b:CGFloat,_ alpha:CGFloat = 1.0) {
        self.init(red:r/255.0,green:g/255.0,blue:b/255.0,alpha:alpha)
    }

    convenience init?(_ hex : String, _ alpha : CGFloat = 1.0) {

        var hex = hex
        if hex.hasPrefix("#") {
            let index = hex.index(hex.startIndex, offsetBy: 1)
            hex = String(hex[index...])
        }

        var red:   UInt32 = 0
        var green: UInt32 = 0
        var blue:  UInt32 = 0
        var alpha: UInt32 = UInt32(alpha) * 255

        switch hex.count {
        case 6:
            let redIndex = hex.index(hex.startIndex, offsetBy: 2)
            let greenIndex = hex.index(redIndex, offsetBy: 2)
            Scanner(string: String(hex[..<redIndex])).scanHexInt32(&red)
            Scanner(string: String(hex[redIndex..<greenIndex])).scanHexInt32(&green)
            Scanner(string: String(hex[greenIndex...])).scanHexInt32(&blue)
        case 8:
            let alphaIndex = hex.index(hex.startIndex, offsetBy: 2)
            let redIndex = hex.index(alphaIndex, offsetBy: 2)
            let greenIndex = hex.index(redIndex, offsetBy: 2)
            Scanner(string: String(hex[..<alphaIndex])).scanHexInt32(&alpha)
            Scanner(string: String(hex[alphaIndex..<redIndex])).scanHexInt32(&red)
            Scanner(string: String(hex[redIndex..<greenIndex])).scanHexInt32(&green)
            Scanner(string: String(hex[greenIndex...])).scanHexInt32(&blue)
        default:
            print("暂不支持其它格式")
        }
        self.init(CGFloat(red), CGFloat(green), CGFloat(blue), CGFloat(alpha / 255))
    }
}
