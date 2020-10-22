//
//  HomeLiveViewController.swift
//  SwiftBilibili
//
//  Created by luowen on 2020/10/14.
//  Copyright © 2020 luowen. All rights reserved.
//

import UIKit
import JXSegmentedView

/// 直播控制器
final class HomeLiveViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.blue
    }

    override func setupUI() {}
}

extension HomeLiveViewController: JXSegmentedListContainerViewListDelegate {

    func listView() -> UIView {
        return self.view
    }
}
