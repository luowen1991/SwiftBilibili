//
//  LWRealmList.swift
//  SwiftBilibili
//
//  Created by luowen on 2020/11/5.
//  Copyright © 2020 luowen. All rights reserved.
//

import RealmSwift

protocol LWRealmList {
    func children() -> [Object]
}

extension List: LWRealmList {
    func children() -> [Object] {
        return self.compactMap { return $0 as? Object }
    }
}
