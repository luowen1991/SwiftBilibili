//
//  SplashInfoModel.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2020/9/6.
//  Copyright © 2020 luowen. All rights reserved.
//

import ObjectMapper

import RealmSwift

enum SplashShowRule: String {
    case orderRule = "order"
}

class SplashInfoModel: Mappable {

    var pullInterval: Int = 1800
    var list: [SplashItemModel] = []
    var show: [SplashShowModel] = []
    var rule: SplashShowRule = .orderRule

    required convenience init?(map: Map) {
        self.init()
    }

    func mapping(map: Map) {
        rule <- map["rule"]
        pullInterval <- map["pull_interval"]
        list <- map["list"]
        show <- map["show"]
    }
}

class SplashItemModel: Mappable {
    var id: Int = 0
    var thumb: String = ""
    var logoUrl: String = ""

    required convenience init?(map: Map) {
        self.init()
    }

    func mapping(map: Map) {
        id <- map["id"]
        thumb <- map["thumb"]
        logoUrl <- map["logo_url"]
    }

}

class SplashShowModel: Mappable {
    var id: Int = 0
    var beginTime: Int = 0
    var endTime: Int = 0
    var duration: Int = 700

    required convenience init?(map: Map) {
        self.init()
    }

    func mapping(map: Map) {
        id <- map["id"]
        beginTime <- map["begin_time"]
        endTime <- map["end_time"]
        duration <- map["duration"]
    }
}

class SplashShowRealmModel: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var beginTime: Int = 0
    @objc dynamic var endTime: Int = 0
    @objc dynamic var thumb: String = ""
    @objc dynamic var logoUrl: String = ""
    @objc dynamic var isShow: Bool = false
    @objc dynamic var duration: Int = 700

    override class func primaryKey() -> String? {
        return "id"
    }
}
