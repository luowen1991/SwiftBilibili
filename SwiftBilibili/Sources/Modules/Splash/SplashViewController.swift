//
//  SplashViewController.swift
//  SwiftBilibili
//
//  Created by luowen on 2020/9/4.
//  Copyright © 2020 luowen. All rights reserved.
//

import UIKit

import SwiftEntryKit
import RxSwift

final class SplashViewController: BaseViewController {

    private lazy var attributes: EKAttributes = {
        var attributes = EKAttributes()
        attributes.screenBackground = .color(color: EKColor.black.with(alpha: 0.5))
        attributes.entryBackground = .color(color: .white)
        attributes.displayDuration = .infinity
        attributes.roundCorners = .all(radius: 8)
        attributes.positionConstraints = .float
        attributes.position = .center
        attributes.entranceAnimation = .none
        attributes.exitAnimation = .none
        attributes.screenInteraction = .absorbTouches
        attributes.entryInteraction = .absorbTouches
        attributes.scroll = .disabled
        attributes.positionConstraints.size = .init(width: .offset(value: 50), height: .intrinsic)
        return attributes
    }()

    private let presentMainScreen: () -> Void

    private let splashCacheManager = SplashCacheManager()

    init(presentMainScreen: @escaping () -> Void) {
        self.presentMainScreen = presentMainScreen
        super.init()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        startRequest()
    }

    required convenience init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        UserDefaultsManager.app.agreePolicy ?
            loadOrShowContentImage() :
            presentPrivacyAlert()
    }

    private func presentPrivacyAlert() {

        let view = PrivacyPolicyAlertView()
        view.agreeSubject
            .subscribe {[unowned self] (_) in
                UserDefaultsManager.app.agreePolicy = true
                SwiftEntryKit.dismiss()
                self.startRequest()
            }
            .disposed(by: rx.disposeBag)
        SwiftEntryKit.display(entry: view, using: attributes)
    }

    private func loadOrShowContentImage() {

        if let showItem = splashCacheManager.getShowItem() {
            contentImageView.setImage(with: URL(string: showItem.thumb))
            self.hidden(Double(showItem.duration))
        } else {
            NetStatusManager.default.reachabilityConnection
                .skip(1)
                .subscribe(onNext: {[weak self] (_) in
                    guard let self = self else { return }
                    self.startRequest()
                })
                .disposed(by: rx.disposeBag)
        }
    }

    private func startRequest() {

        ConfigAPI.splashList
            .request()
            .mapObject(SplashInfoModel.self)
            .trackError(NetErrorManager.default.errorIndictor)
            .subscribe(onSuccess: {[weak self] (splashInfo) in
                guard let self = self else { return }
                self.contentImageView.image = Image.Launch.content
                self.splashCacheManager.saveSplashData(splashInfo)
                self.hidden(700)
            })
            .disposed(by: rx.disposeBag)
    }

    private func retryRequest() {
        NetErrorManager.default.retrySubject
            .subscribe {[unowned self] (_) in
                self.startRequest()
            }
            .disposed(by: rx.disposeBag)
    }

    private func hidden(_ duration: Double = Double(MAXFLOAT)) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+duration/1000) {[weak self] in
            guard let self = self else { return }
            self.presentMainScreen()
        }
    }

    override func setupUI() {
        view.addSubview(logoImageView)
        view.addSubview(contentImageView)
    }

    override func setupConstraints() {

        logoImageView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.height.equalTo(50)
            if #available(iOS 11.0, *) {
                $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            } else {
                $0.bottom.equalToSuperview()
            }
        }

        contentImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(logoImageView.snp.top)
            if #available(iOS 11.0, *) {
                $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            } else {
                $0.top.equalToSuperview()
            }
        }
    }

    private let logoImageView = UIImageView().then {
        $0.image = Image.Launch.logo
        $0.contentMode = .scaleAspectFit
    }

    private let contentImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
}
