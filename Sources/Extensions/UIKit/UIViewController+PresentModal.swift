//
//  UIViewController+PresentModal.swift
//  SwiftBilibili
//
//  Created by luowen on 2020/11/19.
//  Copyright © 2020 luowen. All rights reserved.
//

import UIKit

extension UIViewController {

    static func swizzlePresent() {
        let orginalSelector = #selector(present(_: animated: completion:))
        let swizzledSelector = #selector(swizzledPresent)

        guard let orginalMethod = class_getInstanceMethod(self, orginalSelector),
              let swizzledMethod = class_getInstanceMethod(self, swizzledSelector)
        else { return }

        let didAddMethod = class_addMethod(self,
                                           orginalSelector,
                                           method_getImplementation(swizzledMethod),
                                           method_getTypeEncoding(swizzledMethod))

        if didAddMethod {
            class_replaceMethod(self,
                                swizzledSelector,
                                method_getImplementation(orginalMethod),
                                method_getTypeEncoding(orginalMethod))
        } else {
            method_exchangeImplementations(orginalMethod, swizzledMethod)
        }
    }

    @objc private func swizzledPresent(_ viewControllerToPresent: UIViewController,
                                       animated flag: Bool,
                                       completion: (() -> Void)? = nil) {
        if #available(iOS 13.0, *) {
            if viewControllerToPresent.modalPresentationStyle == .automatic || viewControllerToPresent.modalPresentationStyle == .pageSheet {
                viewControllerToPresent.modalPresentationStyle = .fullScreen
            }
        }
        swizzledPresent(viewControllerToPresent, animated: flag, completion: completion)
    }
}
