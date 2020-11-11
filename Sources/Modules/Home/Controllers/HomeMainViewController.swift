//
//  HomeMainViewController.swift
//  SwiftBilibili
//
//  Created by luowen on 2020/9/4.
//  Copyright © 2020 luowen. All rights reserved.
//  首页主控制器

import UIKit
import JXSegmentedView
import SwiftyImage
import Kingfisher
import HZNavigationBar

final class HomeMainViewController: BaseViewController {

    private struct Metric {
        static let barItemSpace = 20.f
        static let segmentedViewHeight = 40.f
    }

    private var tabItems: [HomeTabItemModel] = []

    private var topItems: [HomeTabItemModel] = []

    private var haveTabCache: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        loadData()
    }

    // MARK: Private Method
    private func setupNavigationBar() {
        ImageDownloader.default.downloadImage(with: URL(string: Const.unLoginAvatarUrl)!, completionHandler: {[unowned self] (result) in
            switch result {
            case .success(let info):
                let avatarItem = HZNavigationBarItem.create(normalImage: info.image) { (_) in

                }
                avatarItem?.bbCornerRadius = 20
                self.navigationBar.hz.setItemsToLeft([avatarItem])
            default:break
            }
        })
//        let imItem = UIBarButtonItem(customView: UIImageView(image: Image.Home.topIM))
//        let gameItem = UIBarButtonItem(customView: UIImageView(image: Image.Home.topGame))
//        let spaceItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
//        spaceItem.width = Metric.barItemSpace
        //navigation.item.rightBarButtonItems = [imItem,spaceItem,gameItem]
    }

    private func updateNavigationBar() {
        var rightBarItems: [UIBarButtonItem] = []
        for (index,item) in topItems.enumerated() {
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 22, height: 22))
            imageView.contentMode = .scaleAspectFit
            imageView.setImage(with: URL(string: item.icon ?? ""))
            let barItem = UIBarButtonItem(customView: imageView)
            rightBarItems.append(barItem)
            if index != topItems.count - 1 {
                let spaceItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
                spaceItem.width = Metric.barItemSpace
                rightBarItems.append(spaceItem)
            }
        }
        //navigation.item.rightBarButtonItems = rightBarItems
    }

    private func loadData() {

        // 缓存策略是只显示缓存 加载的数据替换缓存
        ConfigAPI.tabList
            .onCacheObject(HomeTabInfoModel.self) {[weak self] (info) in
                guard let self = self else { return }
                self.haveTabCache = true
                self.reloadSegmentView(info)
                self.updateNavigationBar()
                self.updateTheme()

            }
            .requestObject()
            .subscribe(onSuccess: {[weak self] (info) in
                guard let self = self,
                      !self.haveTabCache
                else { return }
                self.reloadSegmentView(info)
                self.updateNavigationBar()
                self.updateTheme()
            })
            .disposed(by: disposeBag)

//        缓存策略是先显示缓存再显示网络数据 加载两遍
//        ConfigAPI.tabList
//            .cache
//            .request()
//            .mapObject(HomeTabInfoModel.self)
//            .subscribe { (_) in
//
//            }
//            .disposed(by: disposeBag)
    }

    private func reloadSegmentView(_ info: HomeTabInfoModel) {
        tabItems = info.tab.sorted { $0.pos < $1.pos }
        topItems = info.top.sorted { $0.pos > $1.pos }
        let defaultSelectedIndex = tabItems.compactMap { $0.defaultSelected }.first ?? 1
        if !UserDefaultsManager.app.activityTabIsClicked {
            UserDefaultsManager.activity.activityTabId = tabItems.filter { $0.extension != nil }.first?.tabId ?? ""
            self.segmentedDataSource.showImageInfos = tabItems.map { $0.extension?.activeIcon }
            self.segmentedDataSource.loadImageClosure = { (imageView, imageUrl) in
                imageView.setImage(with: URL(string: imageUrl))
            }
        }
        self.segmentedDataSource.titles = tabItems.map { $0.name }
        self.segmentedDataSource.reloadData(selectedIndex: defaultSelectedIndex)
        self.segmentedView.defaultSelectedIndex = defaultSelectedIndex
        self.segmentedView.reloadData()
        self.listContainerView.defaultSelectedIndex = defaultSelectedIndex
        self.listContainerView.reloadData()
        self.separatorLine.isHidden = false
    }

    private func updateTheme() {
        themeService.attrsStream
            .subscribe(onNext: {[weak self] (theme) in
                guard let self = self else { return }
                self.separatorLine.backgroundColor = theme.mainColorModel.ga0
                self.indicator.indicatorColor = theme.mainColorModel.pi5
                self.segmentedView.backgroundColor = theme.mainColorModel.wh0
                self.segmentedDataSource.titleNormalColor = theme.mainColorModel.ga6
                self.segmentedDataSource.titleSelectedColor = theme.mainColorModel.pi6

//                let barItems = self.navigationItem.rightBarButtonItems?.filter { $0.customView != nil }
//                for (index,item) in self.topItems.enumerated() {
//                    guard let icon = item.icon,
//                          let buttonItem = barItems?[index],
//                          let imageView = buttonItem.customView as? UIImageView
//                    else { continue }
//
//                    ImageCache.default.retrieveImage(forKey: icon) { (result) in
//                        switch result {
//                        case .success(let cache):
//                            imageView.image = cache.image?.with(color: theme.mainColorModel.ga7T)
//                        default:break
//                        }
//                    }
//                }
            })
            .disposed(by: disposeBag)
    }

    override func setupUI() {
        view.addSubview(segmentedView)
        view.addSubview(separatorLine)
        view.addSubview(listContainerView)
    }

    override func setupConstraints() {
        segmentedView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.height.equalTo(Metric.segmentedViewHeight)
        }

        separatorLine.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(segmentedView.snp.bottom)
            $0.height.equalTo(1)
        }

        listContainerView.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalTo(separatorLine.snp.bottom)
        }
    }

    // MARK: Lazy Load
    private lazy var separatorLine = UIView().then {
        $0.isHidden = true
    }

    private lazy var segmentedView = JXSegmentedView().then {
        $0.delegate = self
        $0.dataSource = segmentedDataSource
        $0.indicators = [indicator]
        $0.contentScrollView = listContainerView.scrollView
        $0.contentEdgeInsetLeft = 30
        $0.contentEdgeInsetRight = 30
    }

    private lazy var indicator = JXSegmentedIndicatorLineView().then {
        $0.isIndicatorWidthSameAsItemContent = true
        $0.indicatorWidthIncrement = 16
        $0.indicatorCornerRadius = 2
    }

    private lazy var segmentedDataSource: BBSegmentedTitleOrImageDataSource = {
        let segmentedDataSource = BBSegmentedTitleOrImageDataSource()
        segmentedDataSource.isItemSpacingAverageEnabled = false
        segmentedDataSource.itemSpacing = 36
        segmentedDataSource.titleNormalFont = Font.appFont(ofSize: 15)
        segmentedDataSource.titleSelectedFont = Font.appFont(ofSize: 17,weight: .medium)
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

        if tabItems[index].extension != nil, !UserDefaultsManager.app.activityTabIsClicked {
            UserDefaultsManager.app.activityTabIsClicked = true
        } else {
            if UserDefaultsManager.app.activityTabIsClicked {
                var temp: [String?] = []
                tabItems.forEach { _ in temp.append(nil) }
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
        let itemModel = tabItems[index]
        guard let controller = navigator.viewController(for: itemModel.uri) as? JXSegmentedListContainerViewListDelegate else {
            fatalError("controller not confirm to JXSegmentedListContainerViewListDelegate")
        }
        return controller
    }
}
