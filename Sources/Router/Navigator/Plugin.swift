//
//  Plugin.swift
//  SwiftBilibili
//
//  Created by luowen on 2020/11/13.
//  Copyright © 2020 luowen. All rights reserved.
//

import Foundation

open class Plugin<T: RouterTypeable>: RouterPluginable {

    public init() {

    }

    open func should(open type: T) -> Bool {
        return true
    }

    open func prepare(open type: T, completion: @escaping (Bool) -> Void) {
        completion(true)
    }

    open func will(open type: T, controller: Routerable) {

    }

    open func did(open type: T, controller: Routerable) {
    }
}
