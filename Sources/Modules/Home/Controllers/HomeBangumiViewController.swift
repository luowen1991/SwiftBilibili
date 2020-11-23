//
//  HomeBangumiViewController.swift
//  SwiftBilibili
//
//  Created by luowen on 2020/10/14.
//  Copyright © 2020 luowen. All rights reserved.
//  追番控制器

import UIKit
import JXSegmentedView

final class HomeBangumiViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func setupUI() {}
}

extension HomeBangumiViewController: JXSegmentedListContainerViewListDelegate {

    func listView() -> UIView {
        return self.view
    }
}

extension HomeBangumiViewController: Routerable {}
