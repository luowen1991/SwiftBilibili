//
//  CALayer+ManualLayout.swift
//  ManualLayout
//
//  Created by Baris Sencan on 23/02/15.
//  Copyright (c) 2015 Baris Sencan. All rights reserved.
//  

import UIKit

public extension CALayer {

    // MARK: - Position
    var origin: CGPoint {
        get {
            return frame.origin
        }
        set {
            x = newValue.x
            y = newValue.y
        }
    }

    var x: CGFloat {
        get { return frame.x }
        set { frame.x = newValue }
    }

    var y: CGFloat {
        get { return frame.y }
        set { frame.y = newValue }
    }

    var center: CGPoint {
        get { return frame.center }
        set { frame.center = newValue }
    }

    var centerX: CGFloat {
        get { return frame.centerX }
        set { frame.centerX = newValue }
    }

    var centerY: CGFloat {
        get { return frame.centerY }
        set { frame.centerY = newValue }
    }

    // MARK: - Size

    var size: CGSize {
        get {
            return frame.size
        }
        set {
            width = newValue.width
            height = newValue.height
        }
    }

    var width: CGFloat {
        get {
            return frame.size.width
        }
        set {
            frame.size.width = snapToPixel(pointCoordinate: newValue)
        }
    }

    var height: CGFloat {
        get {
            return frame.size.height
        }
        set {
            frame.size.height = snapToPixel(pointCoordinate: newValue)
        }
    }

    // MARK: - Edges

    var top: CGFloat {
        get { return frame.top }
        set { frame.top = newValue }
    }

    var right: CGFloat {
        get { return frame.right }
        set { frame.right = newValue }
    }

    var bottom: CGFloat {
        get { return frame.bottom }
        set { frame.bottom = newValue }
    }

    var left: CGFloat {
        get { return frame.left }
        set { frame.left = newValue }
    }

    // MARK: - Alternative Edges

    var top2: CGFloat {
        get { return frame.top2 }
        set { frame.top2 = newValue }
    }

    var right2: CGFloat {
        get { return frame.right2 }
        set { frame.right2 = newValue }
    }

    var bottom2: CGFloat {
        get { return frame.bottom2 }
        set { frame.bottom2 = newValue }
    }

    var left2: CGFloat {
        get { return frame.left2 }
        set { frame.left2 = newValue }
    }
}
