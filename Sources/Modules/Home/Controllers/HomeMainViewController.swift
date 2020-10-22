//
//  HomeMainViewController.swift
//  SwiftBilibili
//
//  Created by luowen on 2020/9/4.
//  Copyright © 2020 luowen. All rights reserved.
//

import UIKit
import JXSegmentedView

/// 首页主控制器
final class HomeMainViewController: BaseViewController {

    private var tabItems: [HomeTabItemModel] = []
    private var selecteExtension: Bool = false

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // 加载tab
        loadData()
    }

    // MARK: Private Method
    private func loadData() {
        ConfigAPI.tabList.request()
            .mapObject(HomeTabInfoModel.self)
            .subscribe(onSuccess: {[weak self] (info) in
                guard let self = self else { return }
                let sortedItems = info.tab.sorted { (pre, next) -> Bool in
                    pre.pos < next.pos
                }
                self.tabItems = sortedItems
                let defaultSelectedIndex = sortedItems.compactMap { $0.defaultSelected }.first ?? 1
                self.segmentedDataSource.showImageInfos = sortedItems.map { $0.extension?.activeIcon }
                self.segmentedDataSource.loadImageClosure = { (imageView, imageUrl) in
                    imageView.setImage(with: URL(string: imageUrl))
                }
                self.segmentedDataSource.titles = sortedItems.map { $0.name }
                self.segmentedDataSource.reloadData(selectedIndex: defaultSelectedIndex)
                self.segmentedView.defaultSelectedIndex = defaultSelectedIndex
                self.segmentedView.reloadData()
                self.listContainerView.defaultSelectedIndex = defaultSelectedIndex
                self.listContainerView.reloadData()
                self.segmentedView.selectItemAt(index: defaultSelectedIndex)
            })
            .disposed(by: disposeBag)
    }

    // MARK: Super Method
    override func resetTheme() {
        themeService.attrsStream
            .subscribe(onNext: {[weak self] (theme) in
                guard let self = self else { return }
                self.indicator.indicatorColor = theme.mainColorModel.pi5
                self.segmentedDataSource.titleNormalColor = theme.mainColorModel.ba0
                self.segmentedDataSource.titleSelectedColor = theme.mainColorModel.pi5
            })
            .disposed(by: disposeBag)
    }

    override func setupUI() {
        view.addSubview(segmentedView)
        view.addSubview(listContainerView)
    }

    override func setupConstraints() {
        segmentedView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(Screen.navigationBarHeight)
            $0.height.equalTo(40)
        }

        listContainerView.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalTo(segmentedView.snp.bottom)
        }
    }

    // MARK: Lazy Load
    private lazy var segmentedView = JXSegmentedView().then {
        $0.delegate = self
        $0.dataSource = segmentedDataSource
        $0.indicators = [indicator]
        $0.contentScrollView = listContainerView.scrollView
        $0.contentEdgeInsetLeft = 20
        $0.contentEdgeInsetRight = 20
    }

    private lazy var indicator = JXSegmentedIndicatorLineView().then {
        $0.isIndicatorWidthSameAsItemContent = true
        $0.indicatorWidthIncrement = 4
    }

    private lazy var segmentedDataSource: BBSegmentedTitleOrImageDataSource = {
        let segmentedDataSource = BBSegmentedTitleOrImageDataSource()
        segmentedDataSource.isItemSpacingAverageEnabled = false
        segmentedDataSource.itemSpacing = 36
        segmentedDataSource.titleNormalFont = Font.appFont(ofSize: 15)
        segmentedDataSource.titleSelectedFont = Font.appFont(ofSize: 17)
        return segmentedDataSource
    }()

    private lazy var listContainerView: JXSegmentedListContainerView = {
        JXSegmentedListContainerView(dataSource: self)
    }()
}

// MARK: Delegate

// MARK: JXSegmentedViewDelegate
extension HomeMainViewController: JXSegmentedViewDelegate {

    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
        listContainerView.didClickSelectedItem(at: index)

        guard let showImageInfos = segmentedDataSource.showImageInfos,
              !showImageInfos.filter({ $0 != nil }).isEmpty
        else { return }

        if tabItems[index].extension != nil, !selecteExtension {
           selecteExtension = true
        } else {
            if selecteExtension {
                var temp: [String?] = []
                for _ in tabItems {
                    temp.append(nil)
                }
                segmentedDataSource.showImageInfos = temp
                segmentedView.reloadData()
            }
        }
    }
}

// MARK: JXSegmentedListContainerViewDataSource
extension HomeMainViewController: JXSegmentedListContainerViewDataSource {

    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        return segmentedDataSource.titles.count
    }

    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        return HomeRecommendViewController()
    }
}
