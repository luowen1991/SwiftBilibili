//
//  Base.swift
//  SwiftBilibili
//
//  Created by luowen on 2020/11/24.
//  Copyright © 2020 luowen. All rights reserved.
//

import Foundation

public final class LWProtocolNameSpace<Base> {
    public let base: Base
    public init(_ base: Base) {
        self.base = base
    }
}

public protocol LWProtocolCompatible {
    associatedtype LWProtocolCompatibleType
    var lw: LWProtocolCompatibleType { get }
}

public extension LWProtocolCompatible {
    var lw: LWProtocolNameSpace<Self> {
       LWProtocolNameSpace(self)
    }
}
