//
//  MineViewController.swift
//  SwiftBilibili
//
//  Created by luowen on 2020/9/4.
//  Copyright © 2020 luowen. All rights reserved.
//

import UIKit
import RxSwift

final class MineViewController: BaseViewController {

    var titles: [String] = []
    let tapSubject = PublishSubject<String?>()

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func setupData() {
        self.titles = ThemeManager.shared.mainStyleModels.map {
            $0.style.rawValue
        }
        button1.setTitle(titles[0], for: .normal)
        button2.setTitle(titles[1], for: .normal)
        button3.setTitle(titles[2], for: .normal)
    }

    override func bindEvent() {

        button1.rx.tap.map {[unowned self] in self.button1.title(for: .normal) }.bind(to: tapSubject).disposed(by: disposeBag)
        button2.rx.tap.map {[unowned self] in self.button2.title(for: .normal) }.bind(to: tapSubject).disposed(by: disposeBag)
        button3.rx.tap.map {[unowned self] in self.button3.title(for: .normal) }.bind(to: tapSubject).disposed(by: disposeBag)

        tapSubject.subscribe(onNext: {[weak self] (styleName) in
            if UserDefaultsManager.theme.style.rawValue == styleName { return }
            guard let styleName = styleName,
                  let style = ThemeStyle(rawValue: styleName)
            else {
                return
            }
            themeService.switch(style)
            UserDefaultsManager.theme.style = style
            self?.setNeedsStatusBarAppearanceUpdate()
            ToastManager.show("换主题成功")
        }).disposed(by: disposeBag)

        themeService.typeStream.subscribe(onNext: {[weak self] (style) in
            self?.button1.isSelected = style.rawValue == self?.button1.title(for: .normal)
            self?.button2.isSelected = style.rawValue == self?.button2.title(for: .normal)
            self?.button3.isSelected = style.rawValue == self?.button3.title(for: .normal)
        }).disposed(by: disposeBag)

    }

    override func setupUI() {
        view.addSubview(button1)
        view.addSubview(button2)
        view.addSubview(button3)
    }

    override func setupConstraints() {
        button1.snp.makeConstraints {
            $0.top.equalTo(120)
            $0.centerX.equalToSuperview()
        }

        button2.snp.makeConstraints {
            $0.top.equalTo(button1.snp.bottom).offset(40)
            $0.centerX.equalToSuperview()
        }

        button3.snp.makeConstraints {
            $0.top.equalTo(button2.snp.bottom).offset(40)
            $0.centerX.equalToSuperview()
        }
    }

    let button1 = UIButton().then {
        $0.setTitleColor(.black, for: .normal)
        $0.setTitleColor(.red, for: .selected)
    }

    let button2 = UIButton().then {
        $0.setTitleColor(.black, for: .normal)
        $0.setTitleColor(.red, for: .selected)
    }

    let button3 = UIButton().then {
        $0.setTitleColor(.black, for: .normal)
        $0.setTitleColor(.red, for: .selected)
    }

}
