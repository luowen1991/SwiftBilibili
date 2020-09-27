//
//  BaseViewController.swift
//  SwiftBilibili
//
//  Created by luowen on 2020/9/4.
//  Copyright © 2020 luowen. All rights reserved.
//

import UIKit
import RxSwift
import EachNavigationBar

class BaseViewController: UIViewController {

    var disposeBag = DisposeBag()

    // MARK: Properties
    lazy private(set) var className: String = {
        return type(of: self).description().components(separatedBy: ".").last ?? ""
    }()

    private(set) var didSetupConstraints = false

    // MARK: Initializing
    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
    }

    deinit {
        log.verbose("DEINIT: \(self.className)")
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return themeService.attrs.isDark ? .lightContent : .default
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigation.bar.theme.barTintColor = themed { $0.mainColorModel.wh0T }
        setupUI()
        view.setNeedsUpdateConstraints()
        setupData()
        bindEvent()
        resetTheme()
    }

    override func updateViewConstraints() {
        if !self.didSetupConstraints {
            self.setupConstraints()
            self.didSetupConstraints = true
        }
        super.updateViewConstraints()
    }

    // MARK: 子类覆写

    /// 子类覆写添加视图
    func setupUI() {
        fatalError("add subview in this")
    }

    /// 子类覆写设置视图约束
    func setupConstraints() {
        // Override point
    }

    /// 子类覆写主题改变时设置样式
    func resetTheme() {

    }

    /// 子类覆写绑定事件
    func bindEvent() {

    }

    /// 子类覆写初始化数据
    func setupData() {}
}
