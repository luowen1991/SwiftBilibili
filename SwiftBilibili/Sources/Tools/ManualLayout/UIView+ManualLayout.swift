//
//  UIView+ManualLayout.swift
//  ManualLayout
//
//  Created by Baris Sencan on 23/02/15.
//  Copyright (c) 2015 Baris Sencan. All rights reserved.
//

import UIKit

// I wish there was an easier way to do this in Swift.
public extension UIView {

    // MARK: - Position

    var origin: CGPoint {
        get { return layer.origin }
        set { layer.origin = newValue }
    }

    var x: CGFloat {
        get { return layer.x }
        set { layer.x = newValue }
    }

    var y: CGFloat {
        get { return layer.y }
        set { layer.y = newValue }
    }

    var centerX: CGFloat {
        get { return layer.centerX }
        set { layer.centerX = newValue }
    }

    var centerY: CGFloat {
        get { return layer.centerY }
        set { layer.centerY = newValue }
    }

    // MARK: - Size

    var size: CGSize {
        get { return layer.size }
        set { layer.size = newValue }
    }

    var width: CGFloat {
        get { return layer.width }
        set { layer.width = newValue }
    }

    var height: CGFloat {
        get { return layer.height }
        set { layer.height = newValue }
    }

    // MARK: - Edges

    var top: CGFloat {
        get { return layer.top }
        set { layer.top = newValue }
    }

    var right: CGFloat {
        get { return layer.right }
        set { layer.right = newValue }
    }

    var bottom: CGFloat {
        get { return layer.bottom }
        set { layer.bottom = newValue }
    }

    var left: CGFloat {
        get { return layer.left }
        set { layer.left = newValue }
    }

    // MARK: - Alternative Edges

    var top2: CGFloat {
        get { return layer.top2 }
        set { layer.top2 = newValue }
    }

    var right2: CGFloat {
        get { return layer.right2 }
        set { layer.right2 = newValue }
    }

    var bottom2: CGFloat {
        get { return layer.bottom2 }
        set { layer.bottom2 = newValue }
    }

    var left2: CGFloat {
        get { return layer.left2 }
        set { layer.left2 = newValue }
    }

    // MARK: - Automatic Sizing

    @discardableResult
    func sizeToFit(_ width: CGFloat, _ height: CGFloat) -> CGSize {
        return sizeToFit(CGSize(width: width, height: height))
    }

    @discardableResult
    func sizeToFit(_ constrainedSize: CGSize) -> CGSize {
        var newSize = sizeThatFits(constrainedSize)
        newSize.width = min(newSize.width, constrainedSize.width)
        newSize.height = min(newSize.height, constrainedSize.height)
        size = newSize
        return newSize
    }
}
