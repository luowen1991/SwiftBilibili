//
//  AdInfoModel.swift
//  SwiftBilibili
//
//  Created by luowen on 2020/9/14.
//  Copyright © 2020 luowen. All rights reserved.
//

import UIKit
import ObjectMapper

struct AdInfoModel: ImmutableMappable {

    let minInterval: Int
    let list: [AdItemModel]
    let show: [AdShowModel]

    init(map: Map) throws {
        minInterval = try map.value("min_interval")
        list = try map.value("list")
        show = try map.value("show")
    }
}

struct AdItemModel: ImmutableMappable {

    let id: Int
    let cardType: Int
    let duration: Int
    let beginTime: Int
    let endTime: Int
    let thumb: String
    let hash: String
    let skip: Bool
    let isAd: Bool
    let enablePreDownload: Bool
    let enableBackgroundDownload: Bool
    let uri: String
    let uriTitle: String
    let videoUrl: String?
    let videoWidth: Int?
    let videoHeight: Int?

    init(map: Map) throws {
        id = try map.value("id")
        cardType = try map.value("card_type")
        duration = try map.value("duration")
        beginTime = try map.value("begin_time")
        endTime = try map.value("end_time")
        thumb = try map.value("thumb")
        hash = try map.value("hash")
        skip = try map.value("skip")
        isAd = try map.value("is_ad")
        enablePreDownload = try map.value("enable_pre_download")
        enableBackgroundDownload = try map.value("enable_background_download")
        uri = try map.value("uri")
        uriTitle = try map.value("uri_title")
        videoUrl = try? map.value("video_url")
        videoWidth = try map.value("video_width")
        videoHeight = try map.value("video_height")
    }
}

struct AdShowModel: ImmutableMappable {
    let id: Int
    let stime: Int
    let etime: Int

    init(map: Map) throws {
        id = try map.value("id")
        stime = try map.value("stime")
        etime = try map.value("etime")
    }
}
