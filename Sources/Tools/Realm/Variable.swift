//
//  Variable.swift
//  SwiftBilibili
//
//  Created by luowen on 2020/11/5.
//  Copyright © 2020 luowen. All rights reserved.
//

import RealmSwift

public extension LWRealm where T: Object {

    var isManaged: Bool {
        self.base.realm != nil
    }

    var managed: T? {
        guard let realm = try? Realm(),
              let key = T.primaryKey()
        else { return nil }
        let object = realm.object(ofType: T.self, forPrimaryKey: self.base.value(forKey: key))
        return object
    }

    var unmanaged: T {
        self.base.easyDetached()
    }
}

fileprivate extension Object {

    func easyDetached() -> Self {
        let detached = type(of: self).init()
        for property in objectSchema.properties {
            guard let value = value(forKey: property.name) else { continue }
            if let detachable = value as? Object {
                detached.setValue(detachable.easyDetached(), forKey: property.name)
            } else if let detachable = value as? LWRealmList {
                detached.setValue(detachable.children().compactMap { $0.easyDetached() },forKey: property.name)
            } else {
                detached.setValue(value, forKey: property.name)
            }
        }
        return detached
    }
}
