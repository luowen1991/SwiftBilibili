//
//  HomeAPI.swift
//  SwiftBilibili
//
//  Created by luowen on 2020/9/25.
//  Copyright © 2020 luowen. All rights reserved.
//

// swiftlint:disable line_length

import Moya

enum HomeAPI {
    /// 首页展示数据列表
    case feedList
}

extension HomeAPI: TargetType {

    var baseURL: URL {
        return URL(string: "http://app.bilibili.com")!
    }

    var path: String {
        switch self {
        case .feedList:
            return "/x/v2/feed/index"
        }
    }

    var method: Method {
        switch self {
        case .feedList:
            return .get
        }
    }

    var sampleData: Data {
        return Data()
    }

    var task: Task {
        switch self {
        case .feedList:
            return .requestParameters(parameters: ["ad_extra":adExtra,"appver":"10300","build":"10300","autoplay_card":"0","banner_hash":"","device_name":"iPhone%20X","fnver":"0","fourk":"1","network":"wifi","sign":"ecd8c89a378fee736e579b5c4fe24e42","filtered":"1","flush":"0","guidance":"1","https_url_req":"0","fnval":"208","idx":"0","login_event":"1","column":"0","pull":"1","qn":"32","recsys_mode":"0","open_event":"cold","statistics":"%7B%22appId%22%3A1%2C%22version%22%3A%226.10.0%22%2C%22abtest%22%3A%22%22%2C%22platform%22%3A1%7D"], encoding: URLEncoding.default)
        }
    }

    var headers: [String : String]? {
        return nil
    }
}

extension HomeAPI {
    var adExtra: String {
        return  "F6209EEC4D712ADB7AAF94480A782BC7DA2715C77FE25001F5FB49394B682198E786E46161C40B92AC5EF0BA4C1EB739E3F12AED4E2BF5D32A3FA3EBC23ED21100C43C049922D2E0A0F975D04A29EB11056B6CE74833E7D536C165634438CD9CA1F10C777100E28C088F4D7D8DB0357B234756C288FD4E8CCC7229D84F81614028BCB0BFDFCD5C23C0D46EFA89E36C7A2C9C10475268A264482DB9A230708C86DE8CDD4C68D547A4D5EE48BE8D5BB52E477E46C9100A8C1B09FBA458FD36012905C71CC354884D3BE08E87AB992C739432E35A0ACA8FF89CF58B0ED9A58D01548E335F5A254C1E54308AD8ACB8A0D331691484193653FFC27CD53B80BD1F868E020CDAACAA80B45EF6BBFF41D17FA2F35F395DAB1907FB427103CF7D9DBA0508FD1CF2827FDBB805FE317C3FB59A33444333012BCA1EE34FAFD5F7EDFE3C77448B05B49DCCEE860769E15408631C033325C6F4BE951400EE2D24F2440475B644E0AAFCCB8FD5FF732D8CCEE55A5CB8587A4A6C1F7738F747BD2C9734C162FE3F292850CB6AB3FCE9B835B4A51285F73F55C7410E67A5AEAF20B2B23B6939FA62E9D95588482B2EA2F9BAEC2AFC207FDF5A1088F7CACFB28AFD88E63465A22C56112345541A46B1B2AC62F81A0D202CD3F6C917EC923F724441B9535161F5FB841B635DF87F75C97148885980B7368F76C3A2D08276845F9D82B7753CDBA1977456C642071F7E6D1F0C3C08A0E0720FECE72BC9B4A8633AB593DFB51251169413"
    }
}
