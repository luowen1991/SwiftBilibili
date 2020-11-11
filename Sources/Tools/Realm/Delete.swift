//
//  Delete.swift
//  SwiftBilibili
//
//  Created by luowen on 2020/11/5.
//  Copyright © 2020 luowen. All rights reserved.
//

import Foundation
import RealmSwift

public enum LWRealmDeleteMethod {
    case simple
    case cascade
}

public extension LWRealmStatic where T: Object {

    func deleteAll() throws {
        let realm = try Realm()
        try realm.write {
            realm.delete(realm.objects(self.baseType))
        }
    }
}

public extension LWRealm where T: Object {

    func delete(with method: LWRealmDeleteMethod = .simple) throws {
        switch method {
        case .simple:     self.isManaged ? try managedSimpleDelete() : try unmanagedSimpleDelete()
        case .cascade:    self.isManaged ? try managedCascadeDelete() : try unmanagedCascadeDelete()
        }
    }
}

// Normal Way
fileprivate extension LWRealm where T: Object {

    func managedSimpleDelete() throws {
        guard let rq = LWRealmQueue() else { throw LWRealmError.realmQueueCantBeCreate }
        let ref = ThreadSafeReference(to: self.base)
        try rq.queue.sync {
            guard let object = rq.realm.resolve(ref) else { throw LWRealmError.objectCantBeResolved }
            try rq.realm.write {
                LWRealm.simpleDelete(this: object, in: rq)
            }
        }
    }

    func unmanagedSimpleDelete() throws {
        guard let rq = LWRealmQueue() else { throw LWRealmError.realmQueueCantBeCreate }
        guard let key = T.primaryKey() else { throw LWRealmError.objectCantBeResolved }

        try rq.queue.sync {
            let value = self.base.value(forKey: key)
            if let object = rq.realm.object(ofType: T.self, forPrimaryKey: value) {
                try rq.realm.write {
                    LWRealm.simpleDelete(this: object, in: rq)
                }
            }
        }
    }

    static func simpleDelete(this object:Object, in queue:LWRealmQueue) {
        queue.realm.delete(object)
    }
}

// Cascade Way
fileprivate extension LWRealm where T: Object {

    func managedCascadeDelete() throws {
        guard let rq = LWRealmQueue() else { throw LWRealmError.realmQueueCantBeCreate }
        let ref = ThreadSafeReference(to: self.base)
        try rq.queue.sync {
            guard let object = rq.realm.resolve(ref) else { throw LWRealmError.objectCantBeResolved }
            try rq.realm.write {
                LWRealm.cascadeDelete(this: object, in: rq)
            }
        }
    }

    func unmanagedCascadeDelete() throws {
        guard let rq = LWRealmQueue() else { throw LWRealmError.realmQueueCantBeCreate }
        guard let key = T.primaryKey() else { throw LWRealmError.objectCantBeResolved }

        try rq.queue.sync {
            let value = self.base.value(forKey: key)
            if let object = rq.realm.object(ofType: T.self, forPrimaryKey: value) {
                try rq.realm.write {
                    LWRealm.cascadeDelete(this: object, in: rq)
                }
            }
        }
    }

    static func cascadeDelete(this object:Object, in queue:LWRealmQueue) {
        for property in object.objectSchema.properties {
            guard let value = object.value(forKey: property.name) else { continue }
            if let object = value as? Object {
                LWRealm.cascadeDelete(this: object, in: queue)
            }
            if let list = value as? LWRealmList {
                list.children().forEach {
                    LWRealm.cascadeDelete(this: $0, in: queue)
                }
            }
        }
        queue.realm.delete(object)
    }
}
