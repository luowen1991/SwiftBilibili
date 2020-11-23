//
//  HomeOptionalViewController.swift
//  SwiftBilibili
//
//  Created by luowen on 2020/10/22.
//  Copyright © 2020 luowen. All rights reserved.
//  可选控制器

import UIKit
import JXSegmentedView

final class HomeOptionalViewController: BaseViewController {

    private let id: Int

    init(id: Int) {
        self.id = id
        super.init()
        log.debug("当前的id:\(id)")
    }

    required convenience init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func setupUI() {}

}

extension HomeOptionalViewController: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return self.view
    }
}

extension HomeOptionalViewController: Routerable {}
