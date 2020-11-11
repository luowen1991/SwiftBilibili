//
//  Edit.swift
//  SwiftBilibili
//
//  Created by luowen on 2020/11/5.
//  Copyright © 2020 luowen. All rights reserved.
//

import RealmSwift

extension LWRealm where T: Object {

    public func edit(_ closure: @escaping (_ T: T) -> Void) throws {
        self.isManaged ? try managed_edit(closure) : try unmanaged_edit(closure)
    }
}

fileprivate extension LWRealm where T: Object {

    func managed_edit(_ closure: @escaping (_ T: T) -> Void) throws {

        guard let rq = LWRealmQueue() else {
            throw LWRealmError.realmQueueCantBeCreate
        }
        let ref = ThreadSafeReference(to: self.base)
        try rq.queue.sync {
            guard let object = rq.realm.resolve(ref) else {
                throw LWRealmError.objectCantBeResolved
            }
            try rq.realm.write { closure(object) }
        }
    }

    func unmanaged_edit(_ closure: @escaping (_ T: T) -> Void) throws {
        closure(self.base)
    }
}
