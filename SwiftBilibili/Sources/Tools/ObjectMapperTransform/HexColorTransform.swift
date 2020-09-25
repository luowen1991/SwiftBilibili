//
//  HexColorTransform.swift
//  SwiftBilibili
//
//  Created by luowen on 2020/9/4.
//  Copyright © 2020 luowen. All rights reserved.
//

import ObjectMapper

final class HexColorTransform: TransformType {

    typealias Object = UIColor
    typealias JSON = String

    func transformToJSON(_ value: UIColor?) -> String? {
        return nil
    }

    func transformFromJSON(_ value: Any?) -> UIColor? {

        guard let hex = value as? String else {
            return nil
        }
        let color = UIColor(hex)
        return color
    }

}
