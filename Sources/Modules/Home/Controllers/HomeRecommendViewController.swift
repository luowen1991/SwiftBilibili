//
//  HomeRecommendViewController.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2020/9/4.
//  Copyright © 2020 luowen. All rights reserved.
//

import UIKit
import JXSegmentedView

/// 推荐控制器
final class HomeRecommendViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func setupUI() {
    }

}

extension HomeRecommendViewController: JXSegmentedListContainerViewListDelegate {

    func listView() -> UIView {
        return self.view
    }
}
