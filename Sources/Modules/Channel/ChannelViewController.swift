//
//  ChannelViewController.swift
//  SwiftBilibili
//
//  Created by luowen on 2020/9/4.
//  Copyright © 2020 luowen. All rights reserved.
//

import UIKit

final class ChannelViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        themeService.typeStream
            .subscribe(onNext: { (style) in
                print(style.rawValue)
            })
            .disposed(by: disposeBag)
    }

    override func setupUI() {

    }

}
