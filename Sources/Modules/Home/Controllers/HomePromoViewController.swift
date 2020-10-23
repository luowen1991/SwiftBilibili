//
//  HomePromoViewController.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2020/9/4.
//  Copyright © 2020 luowen. All rights reserved.
//  推荐控制器

import UIKit
import JXSegmentedView

final class HomePromoViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func setupUI() {
    }

}

extension HomePromoViewController: JXSegmentedListContainerViewListDelegate {

    func listView() -> UIView {
        return self.view
    }
}
