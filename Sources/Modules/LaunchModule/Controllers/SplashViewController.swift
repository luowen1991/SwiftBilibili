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
import LWNetwork
import BBNetworkEx

final class SplashViewController: UIViewController {

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
        attributes.positionConstraints.size = .init(width: .offset(value: 50.auto()), height: .intrinsic)
        return attributes
    }()

    private var disposeBag = DisposeBag()

    private let presentMainScreen: () -> Void

    private var hasCache: Bool = false

    init(presentMainScreen: @escaping () -> Void) {
        self.presentMainScreen = presentMainScreen
        super.init(nibName: nil, bundle: nil)
    }

    required convenience init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        showSplashImage()
    }

    private func showSplashImage() {
        if LaunchUserDefaults.isAgreePolicy {
            fetchData()
        } else {
            presentPrivacyPolicyView()
        }
    }

    private func presentPrivacyPolicyView() {
        let view = PrivacyPolicyView()
        view.agreeSubject
            .subscribe {[weak self] (_) in
                guard let self = self else { return }
                LaunchUserDefaults.isAgreePolicy = true
                SwiftEntryKit.dismiss()
                self.fetchData()
            }
            .disposed(by: disposeBag)
        SwiftEntryKit.display(entry: view, using: attributes)
    }

    private func fetchData() {
        LaunchAPI.splashInfo
            .onCacheObject(SplashInfoModel.self) { model in
                if model.showItems.isEmpty {
                    self.contentImageView.image = Image.Launch.content
                } else {
                    //let showItem = model.showItems[0]
                    //let selectedItem = model.totalItems.first(where: { $0.id == showItem.id })
                    //self.contentImageView.setImage(with: <#T##URL?#>, placeholder: <#T##UIImage?#>, completionHandler: <#T##((Result<RetrieveImageResult, KingfisherError>) -> Void)?##((Result<RetrieveImageResult, KingfisherError>) -> Void)?##(Result<RetrieveImageResult, KingfisherError>) -> Void#>)
                }
            }
            .requestObject(timeoutInterval: 1)
            .handleCustomError(config: NotReachableConfig(viewType: .text, isForceDisplay: true))
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                if self.contentImageView.image == nil {
                    self.contentImageView.image = Image.Launch.content
                }
            })
            .disposed(by: disposeBag)
    }

    private func showDefaultImage() {
        self.contentImageView.image = Image.Launch.content
        self.hidden(700)
    }

    private func hidden(_ duration: Double = Double(MAXFLOAT)) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+duration/1000) {[weak self] in
            guard let self = self else { return }
            self.presentMainScreen()
        }
    }

    private func contentImageSize() -> CGSize {

        guard let image = contentImageView.image else {
            return .zero
        }
        let scale = image.size.height / image.size.width
        let width = Screen.width
        let height = width * scale
        return CGSize(width: width, height: height)
    }

    func setupViews() {
        view.addSubview(contentImageView)
        view.addSubview(logoImageView)

        logoImageView.snp.remakeConstraints {
            $0.centerX.equalToSuperview()
            $0.size.equalTo(Const.splashLogoSize)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
        }

        contentImageView.snp.remakeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(Image.Launch.content?.size ?? .zero)
        }
    }

    private let logoImageView = UIImageView().then {
        $0.image = Image.Launch.pinkLogo
        $0.contentMode = .scaleAspectFit
    }

    private let contentImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
}
