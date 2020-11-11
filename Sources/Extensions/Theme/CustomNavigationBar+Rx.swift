//
//  CustomNavigationBar+Rx.swift
//  SwiftBilibili
//
//  Created by luowen on 2020/11/2.
//  Copyright © 2020 luowen. All rights reserved.
//

import RxCocoa
import RxSwift
import HZNavigationBar

public extension Reactive where Base: HZCustomNavigationBar {

    /// Bindable sink for `tintColor` property
    var barBackgroundColor: Binder<UIColor?> {
        return Binder(self.base) { bar, attr in
            bar.barBackgroundColor = attr
        }
    }

}
