//
//  BaseView.swift
//  SwiftBilibili
//
//  Created by luowen on 2020/9/24.
//  Copyright © 2020 luowen. All rights reserved.
//

import UIKit
import RxSwift

class BaseView: UIView {

    var disposeBag = DisposeBag()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
        setupEvents()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// 子类覆写添加子视图
    func setupViews() {
        fatalError("add subview in this")
    }

    func setupEvents() {}


}
