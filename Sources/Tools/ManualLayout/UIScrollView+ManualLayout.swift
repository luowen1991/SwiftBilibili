//
//  UIScrollView+ManualLayout.swift
//  ManualLayout
//
//  Created by Baris Sencan on 06/03/15.
//  Copyright (c) 2015 Baris Sencan. All rights reserved.
//

import UIKit

public extension UIScrollView {

    // MARK: - Content Size

    var contentWidth: CGFloat {
        get {
            return contentSize.width
        }
        set {
            contentSize.width = snapToPixel(pointCoordinate: newValue)
        }
    }

    var contentHeight: CGFloat {
        get {
            return contentSize.height
        }
        set {
            contentSize.height = snapToPixel(pointCoordinate: newValue)
        }
    }

    // MARK: - Content Edges (For Convenience)

    var contentTop: CGFloat {
        return 0
    }

    var contentLeft: CGFloat {
        return 0
    }

    var contentBottom: CGFloat {
        get {
            return contentHeight
        }
        set {
            contentHeight = newValue
        }
    }

    var contentRight: CGFloat {
        get {
            return contentWidth
        }
        set {
            contentWidth = newValue
        }
    }

    // MARK: - Viewport Edges

    var viewportTop: CGFloat {
        get {
            return contentOffset.y
        }
        set {
            contentOffset.y = snapToPixel(pointCoordinate: newValue)
        }
    }

    var viewportLeft: CGFloat {
        get {
            return contentOffset.x
        }
        set {
            contentOffset.x = snapToPixel(pointCoordinate: newValue)
        }
    }

    var viewportBottom: CGFloat {
        get {
            return contentOffset.y + height
        }
        set {
            contentOffset.y = snapToPixel(pointCoordinate: newValue - height)
        }
    }

    var viewportRight: CGFloat {
        get {
            return contentOffset.x + width
        }
        set {
            contentOffset.x = snapToPixel(pointCoordinate: newValue - width)
        }
    }
}
