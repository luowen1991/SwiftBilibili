//
//  Query.swift
//  SwiftBilibili
//
//  Created by luowen on 2020/11/5.
//  Copyright © 2020 luowen. All rights reserved.
//

import Foundation
import RealmSwift

public extension LWRealmStatic where T: Object {

    func fromRealm<K>(with primaryKey: K) throws -> T {
        let realm = try Realm()
        if let object = realm.object(ofType: self.baseType, forPrimaryKey: primaryKey) {
            return object
        } else {
            throw LWRealmError.objectWithPrimaryKeyNotFound
        }
    }

    func all() throws -> Results<T> {
        let realm = try Realm()
        return realm.objects(self.baseType)
    }

}
