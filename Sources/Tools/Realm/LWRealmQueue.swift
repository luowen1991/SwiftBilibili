//
//  LWRealmQueue.swift
//  SwiftBilibili
//
//  Created by luowen on 2020/11/5.
//  Copyright © 2020 luowen. All rights reserved.
//

import RealmSwift

struct LWRealmQueue {

    let realm: Realm
    let queue: DispatchQueue

    init?() {
        queue = DispatchQueue(label: UUID().uuidString)
        var tmp: Realm?
        queue.sync {
            tmp = try? Realm()
        }
        guard let vaild = tmp else { return nil }
        self.realm = vaild
    }

}
