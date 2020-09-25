//
//  ConfigAPI.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2020/9/5.
//  Copyright © 2020 luowen. All rights reserved.
//  swiftlint:disable variable_name

import Moya

/// app中的一些配置API 比如广告 开屏 上传
enum ConfigAPI {
    /// 开屏图列表
    case splashList
    /// 广告列表
    case adList
}

extension ConfigAPI: TargetType, Cacheable {

    var baseURL: URL {
        return URL(string: "http://app.bilibili.com")!
    }

    var path: String {
        switch self {
        case .splashList:
            return "/x/v2/splash/brand/list"
        case .adList:
            return "/x/v2/splash/lis"
        }
    }

    var method: Method {
        switch self {
        case .splashList,.adList:
            return .get
        }
    }

    var sampleData: Data {
        return Data()
    }

    var task: Task {
        switch self {
        case .splashList:
            return .requestParameters(parameters: ["network": "wifi","ts":"1599654579","sign":"771bec76d94dc13faa176663cc8954d4"], encoding: URLEncoding.default)
        case .adList:
            // swiftlint: disable line_length
            return .requestParameters(parameters: ["ad_extra":adExtra,"birth":"","height":"2436","width":"1125","ts":"1600087187","sign":"bae80cff2fa3d4de3ba2f9c7cad50929"], encoding: URLEncoding.default)
        }
    }

    var headers: [String : String]? {
        return nil
    }
}

extension ConfigAPI {
    // swiftlint: disable line_length
    var adExtra: String {
        return  "F6209EEC4D712ADB7AAF94480A782BC7DA2715C77FE25001F5FB49394B682198E786E46161C40B92AC5EF0BA4C1EB739E3F12AED4E2BF5D32A3FA3EBC23ED21100C43C049922D2E0A0F975D04A29EB11056B6CE74833E7D536C165634438CD9CA1F10C777100E28C088F4D7D8DB0357B234756C288FD4E8CCC7229D84F81614028BCB0BFDFCD5C23C0D46EFA89E36C7A2C9C10475268A264482DB9A230708C86DE8CDD4C68D547A4D5EE48BE8D5BB52E477E46C9100A8C1B09FBA458FD36012905C71CC354884D3BE08E87AB992C739432E35A0ACA8FF89CF58B0ED9A58D01548E335F5A254C1E54308AD8ACB8A0D331691484193653FFC27CD53B80BD1F868E020CDAACAA80B45EF6BBFF41D17FA2F3885068D3997C19846EE6F1F4DBE4F4B5691BC2CCF99B6D630565BCBE3C89900E26F543B7AB28637EF115A3902FE29968C50DC0CCCF652A000C5F56D4BEE328EF56CAC69D0C9AF16AEE129C53B6ED3F44DB3DB11FD27AE8C1C8621CAC8C48E2C747D0A013B0C397AFF98971E8BA669328B1E155FE1B619BFC9A6F47FB2CD569E3F2C103280FB8FB6694B4FB2445F87D458B36CD004610F7A3697926E6D58DFC30E9BEF35F32B4C2F4F030FBA2BA4A6F19E9E5DE9CFF0E155A368EA1EEEBDF020AA674A8FFCC8119ACF3B65445A059C85CD541242E09B72FD6747594B730CDF47271C88ED6C423EAF5C05390162D2073B1CE4D8DF2A3983D5797932B49FF54619D49ED994AC22F28D03323699AFBD6011B"
    }
}
