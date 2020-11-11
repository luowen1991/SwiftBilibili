//
//  LWRealm.swift
//  SwiftBilibili
//
//  Created by luowen on 2020/11/5.
//  Copyright © 2020 luowen. All rights reserved.
//

import UIKit
import RealmSwift

public final class LWRealm<T> {

    internal var base: T

    public init(_ instance: T) {
        self.base = instance
    }
}

public final class LWRealmStatic<T> {

    internal var baseType: T.Type

    public init(_ instance: T.Type) {
        self.baseType = instance
    }
}

public protocol LWRealmCompatible {}

public extension LWRealmCompatible {

    var lw: LWRealm<Self> {
       return LWRealm(self)
    }

    static var lw: LWRealmStatic<Self> {
       return LWRealmStatic(Self.self)
    }
}

extension Object: LWRealmCompatible {}
