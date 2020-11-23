//
//  HomeTabModel.swift
//  SwiftBilibili
//
//  Created by luowen on 2020/10/14.
//  Copyright © 2020 luowen. All rights reserved.
//

import UIKit
import ObjectMapper

struct HomeTabInfoModel: ImmutableMappable {

    var top: [HomeTabItemModel]
    var tab: [HomeTabItemModel]
    var bottom: [HomeTabItemModel]

    init(map: Map) throws {
        top = try map.value("top")
        tab = try map.value("tab")
        bottom = try map.value("bottom")
    }
}

struct HomeTabItemModel: ImmutableMappable {

    var id: Int
    var name: String
    var url: String
    var tabId: String
    var pos: Int
    var icon: String?
    var `extension`: HomeTabExtensionModel?
    var defaultSelected: Int?

    init(map: Map) throws {
        id = try map.value("id")
        name = try map.value("name")
        url = try map.value("uri")
        tabId = try map.value("tab_id")
        pos = try map.value("pos")
        icon = try? map.value("icon")
        `extension` = try? map.value("extension")
        defaultSelected = try? map.value("default_selected")
    }
}

struct HomeTabExtensionModel: ImmutableMappable {

    var inactiveIcon: String
    var activeIcon: String

    init(map: Map) throws {
        inactiveIcon = try map.value("inactive_icon")
        activeIcon = try map.value("active_icon")
    }
}
