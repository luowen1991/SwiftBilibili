//
//  HomeActivityViewController.swift
//  SwiftBilibili
//
//  Created by luowen on 2020/10/22.
//  Copyright © 2020 luowen. All rights reserved.
//  活动控制器

import UIKit
import JXSegmentedView

final class HomeActivityViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func setupUI() {}
}

extension HomeActivityViewController: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return self.view
    }
}
