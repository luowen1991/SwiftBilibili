//
//  CustomNavigationBar+Theme.swift
//  SwiftBilibili
//
//  Created by luowen on 2020/11/2.
//  Copyright © 2020 luowen. All rights reserved.
//

import RxSwift
import RxTheme
import HZNavigationBar

public extension ThemeProxy where Base: HZCustomNavigationBar {

    var barBackgroundColor: Observable<UIColor?> {
        get { return .empty() }
        set {
            let disposable = newValue
                .takeUntil(base.rx.deallocating)
                .observeOn(MainScheduler.instance)
                .bind(to: base.rx.barBackgroundColor)
            hold(disposable, for: "barBackgroundColor")
        }
    }

}
