//
//  Save.swift
//  SwiftBilibili
//
//  Created by luowen on 2020/11/5.
//  Copyright © 2020 luowen. All rights reserved.
//

import RealmSwift

public extension LWRealm where T: Object {

    func save(update: Realm.UpdatePolicy = .modified) throws {
        try self.saved(update: update)
    }

    @discardableResult
    func saved(update: Realm.UpdatePolicy = .modified) throws -> T {
        return self.isManaged ? try managed_save(update: update) : try unmanaged_save(update: update)
    }

    func update() throws {
       _ = self.isManaged ? try managed_save(update: .all) : try unmanaged_save(update: .all)
    }

}

fileprivate extension LWRealm where T: Object {

    func managed_save(update: Realm.UpdatePolicy) throws -> T {
        let ref = ThreadSafeReference(to: self.base)
        guard let rq = LWRealmQueue() else {
            throw LWRealmError.realmQueueCantBeCreate
        }
        return try rq.queue.sync {
            guard let object = rq.realm.resolve(ref) else {
                throw LWRealmError.objectCantBeResolved
            }
            rq.realm.beginWrite()
            let ret = rq.realm.create(T.self, value: object, update: update)
            try rq.realm.commitWrite()
            return ret
        }
    }

    func unmanaged_save(update: Realm.UpdatePolicy) throws -> T {
        let realm = try Realm()
        realm.beginWrite()
        let ret = realm.create(T.self, value: self.base, update: update)
        try realm.commitWrite()
        return ret
    }

}
