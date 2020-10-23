//
//  HomeCinemaViewController.swift
//  SwiftBilibili
//
//  Created by luowen on 2020/10/22.
//  Copyright © 2020 luowen. All rights reserved.
//  影视控制器

import UIKit
import JXSegmentedView

final class HomeCinemaViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func setupUI() {}
}

extension HomeCinemaViewController: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return self.view
    }
}
