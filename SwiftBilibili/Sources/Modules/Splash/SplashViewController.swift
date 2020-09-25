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
import Kingfisher

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
            .disposed(by: disposeBag)
        SwiftEntryKit.display(entry: view, using: attributes)
    }

    private func loadOrShowContentImage() {

        if let showItem = splashCacheManager.getShowItem() {
            ImageCache.default.retrieveImage(forKey: showItem.thumb) {[weak self] (result) in
                guard let self = self else { return }
                switch result {
                case .success(let cache):
                    self.contentImageView.image = cache.image
                    self.setupConstraints()
                    self.hidden(Double(showItem.duration))
                case .failure:
                    log.error("获取缓存图片失败")
                }
            }
        }

        NetStatusManager.default.reachabilityConnection
            .skip(1)
            .subscribe(onNext: {[weak self] (_) in
                guard let self = self else { return }
                self.startRequest()
            })
            .disposed(by: disposeBag)
    }

    private func startRequest() {

        ConfigAPI.splashList
            .request()
            .mapObject(SplashInfoModel.self)
            .trackError(NetErrorManager.default.errorIndictor)
            .subscribe(onSuccess: {[weak self] (splashInfo) in
                guard let self = self else { return }
                if self.contentImageView.image == nil {
                    self.contentImageView.image = Image.Launch.content
                    self.hidden(700)
                }
                self.splashCacheManager.saveSplashData(splashInfo)
            })
            .disposed(by: disposeBag)
    }

    private func retryRequest() {
        NetErrorManager.default.retrySubject
            .subscribe {[unowned self] (_) in
                self.startRequest()
            }
            .disposed(by: disposeBag)
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

        contentImageView.snp.remakeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-50)
            if let image = contentImageView.image {
                let scale = image.size.height / image.size.width
                let width = Screen.width * 0.9
                let height = width * scale
                $0.size.equalTo(CGSize(width: width, height: height))
            }

        }
    }

    private let logoImageView = UIImageView().then {
        $0.image = Image.Launch.logo
        $0.contentMode = .scaleAspectFit
    }

    private let contentImageView = UIImageView()
}
