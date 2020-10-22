//
//  BBSegmentedTitleIOrImagetemModel.swift
//  SwiftBilibili
//
//  Created by luowen on 2020/10/19.
//  Copyright © 2020 luowen. All rights reserved.
//

import JXSegmentedView

final class BBSegmentedTitleOrImageItemModel: JXSegmentedTitleItemModel {
    var showImageInfo: String?
    var loadImageClosure: LoadImageClosure?
    var imageSize: CGSize = CGSize.zero
}
