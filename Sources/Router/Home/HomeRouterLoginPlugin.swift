//
//  HomeRouterLoginPlugin.swift
//  SwiftBilibili
//
//  Created by luowen on 2020/11/18.
//  Copyright © 2020 luowen. All rights reserved.
//

import UIKit

class HomeRouterLoginPlugin: Plugin<HomeRouterType> {

    override func prepare(open type: HomeRouterType, completion: @escaping (Bool) -> Void) {
        guard type.needLogin else {
            completion(true)
            return
        }
        guard !Utils.isLogin else {
            completion(true)
            return
        }
        guard let controller = UIViewController.topMost else {
            completion(true)
            return
        }
        let loginController = LoginViewController()
        controller.present(loginController, animated: true) {
            completion(true)
        }
    }
}
