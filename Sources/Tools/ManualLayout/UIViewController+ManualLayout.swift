//
//  UIViewController+ManualLayout.swift
//  ManualLayout
//
//  Created by Baris Sencan on 25/02/15.
//  Copyright (c) 2015 Baris Sencan. All rights reserved.
//

import UIKit

public extension UIViewController {

    var bounds: CGRect {
        return view.bounds
    }

    // MARK: - Center

    var center: CGPoint {
        return view.center
    }

    var centerX: CGFloat {
        return view.centerX
    }

    var centerY: CGFloat {
        return view.centerY
    }

    // MARK: - Size

    var size: CGSize {
        return view.size
    }

    var width: CGFloat {
        return view.width
    }

    var height: CGFloat {
        return view.height
    }

    // MARK: - Edges

    var top: CGFloat {
        return topLayoutGuide.length
    }

    var right: CGFloat {
        return view.width
    }

    var bottom: CGFloat {
        return view.height - bottomLayoutGuide.length
    }

    var left: CGFloat {
        return 0
    }
}
