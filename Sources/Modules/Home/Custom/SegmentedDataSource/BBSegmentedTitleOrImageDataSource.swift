//
//  BBSegmentedTitleOrImageDataSource.swift
//  SwiftBilibili
//
//  Created by luowen on 2020/10/19.
//  Copyright © 2020 luowen. All rights reserved.
//

import JXSegmentedView

final class BBSegmentedTitleOrImageDataSource: JXSegmentedTitleDataSource {

    /// 数量需要和item的数量保持一致。可以是ImageName或者图片地址。选中时不显示图片就填nil
    var showImageInfos: [String?]?
    /// 内部默认通过UIImage(named:)加载图片。如果传递的是图片地址或者想自己处理图片加载逻辑，可以通过该闭包处理。
    var loadImageClosure: LoadImageClosure?
    /// 图片尺寸
    var imageSize: CGSize = CGSize(width: 60, height: 40)

    override func preferredItemModelInstance() -> JXSegmentedBaseItemModel {
        return BBSegmentedTitleOrImageItemModel()
    }

    override func reloadData(selectedIndex: Int) {
        selectedAnimationDuration = 0.1

        super.reloadData(selectedIndex: selectedIndex)
    }

    override func preferredRefreshItemModel( _ itemModel: JXSegmentedBaseItemModel, at index: Int, selectedIndex: Int) {
        super.preferredRefreshItemModel(itemModel, at: index, selectedIndex: selectedIndex)

        guard let itemModel = itemModel as? BBSegmentedTitleOrImageItemModel else {
            return
        }

        itemModel.showImageInfo = showImageInfos?[index]
        itemModel.loadImageClosure = loadImageClosure
        itemModel.imageSize = imageSize
    }

    // MARK: - JXSegmentedViewDataSource
    override func registerCellClass(in segmentedView: JXSegmentedView) {
        segmentedView.collectionView.register(BBSegmentedTitleOrImageCell.self, forCellWithReuseIdentifier: "cell")
    }

    override func segmentedView(_ segmentedView: JXSegmentedView, cellForItemAt index: Int) -> JXSegmentedBaseCell {
        let cell = segmentedView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        return cell
    }
}
