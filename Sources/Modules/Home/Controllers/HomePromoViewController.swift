//
//  HomePromoViewController.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2020/9/4.
//  Copyright © 2020 luowen. All rights reserved.
//  推荐控制器

import UIKit
import JXSegmentedView

struct EmptyConfig {

    static private let normal = EmptyDataSetConfigure(verticalOffset: -83, tipFont: UIFont.systemFont(ofSize: 15), tipColor: UIColor.white, allowScroll: false,verticalSpace: 25)

    //个人中心优惠券
    static let coupon = { () -> EmptyDataSetConfigure in
        var config = EmptyConfig.normal
        config.tipStr = "还没有优惠券哦～"
        config.tipImage = UIImage(named: "empty_coupon")
        return config
    }()
}

final class HomePromoViewController: BaseViewController, EmptyDataSetable {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.cyan
    }

    override func setupUI() {
        view.addSubview(tableView)
        //tableView.reloadData()

        self.lw.updateEmptyDataSet(tableView, config: EmptyConfig.coupon)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    }

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.frame, style: .plain)
        tableView.keyboardDismissMode = .onDrag
        tableView.estimatedRowHeight = 0
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.sectionHeaderHeight = 0.1
        tableView.sectionFooterHeight = 0.1
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        return tableView
    }()
}

extension HomePromoViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

extension HomePromoViewController: JXSegmentedListContainerViewListDelegate {

    func listView() -> UIView {
        return self.view
    }
}

extension HomePromoViewController: Routerable {}
