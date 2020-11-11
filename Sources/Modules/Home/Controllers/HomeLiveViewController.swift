//
//  HomeLiveViewController.swift
//  SwiftBilibili
//
//  Created by luowen on 2020/10/14.
//  Copyright © 2020 luowen. All rights reserved.
//  直播控制器

import UIKit
import JXSegmentedView

final class HomeLiveViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func setupUI() {}
}

extension HomeLiveViewController: JXSegmentedListContainerViewListDelegate {

    func listView() -> UIView {
        return self.view
    }
}
