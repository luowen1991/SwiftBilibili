//
//  Context.swift
//  SwiftBilibili
//
//  Created by luowen on 2020/11/17.
//  Copyright © 2020 luowen. All rights reserved.
//

import Foundation

struct Context {
    let callback: (Bool) -> Void

    init(_ completion: @escaping (Bool) -> Void = { _ in }) {
        callback = completion
    }
}
