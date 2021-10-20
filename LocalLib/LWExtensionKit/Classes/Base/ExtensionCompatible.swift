//
//  LWExtensionCompatible.swift
//  LWExtensionKit
//
//  Created by luowen on 2021/10/14.
//

public protocol ExtensionCompatible {}

public extension ExtensionCompatible {

    var ex: ExtensionNameSpace<Self> {
        ExtensionNameSpace(self)
    }

    static var ex: ExtensionNameSpaceStatic<Self> {
        ExtensionNameSpaceStatic(Self.self)
    }
}

public class ExtensionNameSpace<Base> {
    var base: Base
    init(_ instance: Base) {
        self.base = instance
    }
}

public class ExtensionNameSpaceStatic<Base> {
    var baseType: Base.Type
    init(_ instance: Base.Type) {
        self.baseType = instance
    }
}

extension String: ExtensionCompatible {}

extension UIColor: ExtensionCompatible {}
extension UIDevice: ExtensionCompatible {}
extension UIViewController: ExtensionCompatible {}
