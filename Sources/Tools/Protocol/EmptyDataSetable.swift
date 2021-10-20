//
//  EmptyDataSetable.swift
//  SwiftBilibili
//
//  Created by luowen on 2020/11/24.
//  Copyright © 2020 luowen. All rights reserved.
//

import UIKit
import EmptyKit
import RxSwift
import RxCocoa

public typealias EmptyViewTapBlock = ((UIView) -> Void)
public typealias EmptyButtonTapBlock = ((UIButton) -> Void)
public typealias EmptyLifeCycleBlock = (() -> Void)

private let defaultEmptyConfig = EmptyDataSetableConfigure.default.emptyDataSetConfigure

public struct EmptyDataSetConfigure {
    /// 纵向偏移(0)  CGFloat
    public var verticalOffset : CGFloat
    /// 提示语(暂无数据)  String
    public var tipStr : String
    /// 提示语的font(system15)  UIFont
    public var tipFont : UIFont
    /// 提示语颜色  UIColor
    public var tipColor : UIColor
    /// 提示图 UIImage
    public var tipImage : UIImage?
    /// 允许滚动(true) Bool
    public var allowScroll : Bool
    /// 竖直各元素之间的间距(10)
    public var verticalSpace : CGFloat
    /// 水平各元素之间的间距(10)
    public var horizontalSpace : CGFloat
    /// 按钮标题
    public var buttonTitle : NSAttributedString
    /// 按钮图片
    public var buttonImageBlock : ((UIControl.State) -> UIImage?)?
    /// 按钮背景颜色
    public var buttonBackgroundColor : UIColor
    /// 按钮背景图片
    public var buttonBackgroundImageBlock : ((UIControl.State) -> UIImage?)?
    /// image动画
    public var imageAnimation : CAAnimation?
    /// imageTintColor
    public var imageTintColor : UIColor?
    /// customView
    public var customEmptyView : UIView?
    /// shouldFade(true)
    public var shouldFade : Bool
    /// shouldBeForcedToDisplay(false)
    public var shouldBeForcedToDisplay : Bool
    /// shouldDisplay(true)
    public var shouldDisplay : Bool
    /// shouldAllowTouch(true)
    public var shouldAllowTouch : Bool
    /// shouldAnimateImageView(false)
    public var shouldAnimateImageView : Bool

    public init(
        verticalOffset: CGFloat = 0,
        tipStr: String = "",
        tipFont: UIFont = .systemFont(ofSize: 15),
        tipColor: UIColor = .lightGray,
        tipImage: UIImage? = nil,
        allowScroll: Bool = true,
        verticalSpace: CGFloat = 10,
        horizontalSpace: CGFloat = 10,
        buttonTitle : NSAttributedString = NSAttributedString(),
        buttonImageBlock : ((UIControl.State) -> UIImage?)? = nil,
        buttonBackgroundImageBlock : ((UIControl.State) -> UIImage?)? = nil,
        buttonBackgroundColor: UIColor = .clear,
        imageAnimation : CAAnimation? = nil, imageTintColor : UIColor? = nil,
        customEmptyView : UIView? = nil,
        shouldFade : Bool = true,
        shouldBeForcedToDisplay : Bool = false,
        shouldDisplay: Bool = true,
        shouldAllowTouch: Bool = true,
        shouldAnimateImageView : Bool = false
        ) {
        self.verticalOffset = verticalOffset
        self.tipStr = tipStr
        self.tipFont = tipFont
        self.tipColor = tipColor
        self.tipImage = tipImage
        self.allowScroll = allowScroll
        self.horizontalSpace = horizontalSpace
        self.verticalSpace = verticalSpace
        self.buttonTitle = buttonTitle
        self.buttonImageBlock = buttonImageBlock
        self.buttonBackgroundImageBlock = buttonBackgroundImageBlock
        self.buttonBackgroundColor = buttonBackgroundColor
        self.imageAnimation = imageAnimation
        self.imageTintColor = imageTintColor
        self.customEmptyView = customEmptyView
        self.shouldFade = shouldFade
        self.shouldBeForcedToDisplay = shouldBeForcedToDisplay
        self.shouldDisplay = shouldDisplay
        self.shouldAllowTouch = shouldAllowTouch
        self.shouldAnimateImageView = shouldAnimateImageView
    }
}

public class EmptyDataSetableConfigure: NSObject {
    static let `default` = EmptyDataSetableConfigure()
    private override init() {
        emptyDataSetConfigure = EmptyDataSetConfigure()
        super.init()
    }

    var emptyDataSetConfigure: EmptyDataSetConfigure

    public static func setDefaultEmptyDataSetConfigure(_ configure: EmptyDataSetConfigure) {
        EmptyDataSetableConfigure.default.emptyDataSetConfigure = configure
    }
}

extension UIScrollView: AssociatedObjectStore {
    /// 属性字典
    public var emptyDataSetConfig: EmptyDataSetConfigure? {
        get { return associatedObject(forKey: &emptyDataSetConfigureKey) }
        set { setAssociatedObject(newValue, forKey: &emptyDataSetConfigureKey) }
    }
    public var emptyViewTapBlock : EmptyViewTapBlock? {
        get { return associatedObject(forKey: &emptyViewTapBlockKey) }
        set { setAssociatedObject(newValue, forKey: &emptyViewTapBlockKey) }
    }
    public var emptyButtonTapBlock : EmptyButtonTapBlock? {
        get { return associatedObject(forKey: &emptyButtonTapBlockKey) }
        set { setAssociatedObject(newValue, forKey: &emptyButtonTapBlockKey) }
    }
    public var emptyDataSetWillAppearBlock : EmptyLifeCycleBlock? {
        get { return associatedObject(forKey: &emptyDataSetWillAppearKey) }
        set { setAssociatedObject(newValue, forKey: &emptyDataSetWillAppearKey) }
    }
    public var emptyDataSetDidAppearBlock : EmptyLifeCycleBlock? {
        get { return associatedObject(forKey: &emptyDataSetDidAppearKey) }
        set { setAssociatedObject(newValue, forKey: &emptyDataSetDidAppearKey) }
    }
    public var emptyDataSetWillDisappearBlock : EmptyLifeCycleBlock? {
        get { return associatedObject(forKey: &emptyDataSetWillDisappearKey) }
        set { setAssociatedObject(newValue, forKey: &emptyDataSetWillDisappearKey) }
    }
    public var emptyDataSetDidDisappearBlock : EmptyLifeCycleBlock? {
        get { return associatedObject(forKey: &emptyDataSetDidDisappearKey) }
        set { setAssociatedObject(newValue, forKey: &emptyDataSetDidDisappearKey) }
    }

    public func updateEmptyDataSet(_ config: EmptyDataSetConfigure?,base: NSObject? = nil) {
        self.emptyDataSetConfig = config
        self.ept.delegate = base ?? self
        if self.ept.dataSource == nil {
            self.ept.dataSource = base ?? self
        }
        self.ept.reloadData()
    }
}

public protocol EmptyDataSetable: LWProtocolCompatible {}

public extension LWProtocolNameSpace where Base: NSObject {

    func updateEmptyDataSet(_ scrollView: UIScrollView,
                            config: EmptyDataSetConfigure? = nil) {
        scrollView.updateEmptyDataSet(config, base: base)
    }

    func tapEmptyView(_ scrollView: UIScrollView,
                      block: @escaping EmptyViewTapBlock) {
        scrollView.emptyViewTapBlock = block
    }

    func tapEmptyButton(_ scrollView: UIScrollView,
                        block: @escaping EmptyButtonTapBlock) {
        scrollView.emptyButtonTapBlock = block
    }

    func emptyViewWillAppear(_ scrollView: UIScrollView,
                             block: @escaping EmptyLifeCycleBlock) {
        scrollView.emptyDataSetWillAppearBlock = block
    }
    func emptyViewDidAppear(_ scrollView: UIScrollView,
                            block: @escaping EmptyLifeCycleBlock) {
        scrollView.emptyDataSetDidAppearBlock = block
    }
    func emptyViewWillDisappear(_ scrollView: UIScrollView,
                                block: @escaping EmptyLifeCycleBlock) {
        scrollView.emptyDataSetWillDisappearBlock = block
    }
    func emptyViewDidDisappear(_ scrollView: UIScrollView,
                               block: @escaping EmptyLifeCycleBlock) {
        scrollView.emptyDataSetDidDisappearBlock = block
    }
}

extension NSObject: EmptyDelegate,EmptyDataSource {

    public func imageForEmpty(in view: UIView) -> UIImage? {
        guard let curConfig = (view as? UIScrollView)?.emptyDataSetConfig
        else { return defaultEmptyConfig.tipImage }
        return curConfig.tipImage
    }

    public func titleForEmpty(in view: UIView) -> NSAttributedString? {
        let curConfig = (view as? UIScrollView)?.emptyDataSetConfig
        let tipColor = curConfig?.tipColor != nil ? curConfig?.tipColor : defaultEmptyConfig.tipColor
        let tipText = curConfig?.tipStr != nil ? curConfig!.tipStr : defaultEmptyConfig.tipStr
        let tipFont = curConfig?.tipFont != nil ? curConfig!.tipFont : defaultEmptyConfig.tipFont
        let attrStr = NSAttributedString(
            string: tipText,
            attributes: [
            .font:tipFont,
            .foregroundColor:tipColor!
            ])
        return attrStr
    }

    public func verticalOffsetForEmpty(in view: UIView) -> CGFloat {
        guard let curConfig = (view as? UIScrollView)?.emptyDataSetConfig else {
            return defaultEmptyConfig.verticalOffset
        }
        return curConfig.verticalOffset
    }

    public func emptyShouldAllowScroll(in view: UIView) -> Bool {
        guard let curConfig = (view as? UIScrollView)?.emptyDataSetConfig else {
            return defaultEmptyConfig.allowScroll
        }
        return curConfig.allowScroll
    }

    public func verticalSpaceForEmpty(in view: UIView) -> CGFloat {
        guard let curConfig = (view as? UIScrollView)?.emptyDataSetConfig else {
            return defaultEmptyConfig.verticalSpace
        }
        return curConfig.verticalSpace
    }

    public func horizontalSpaceForEmpty(in view: UIView) -> CGFloat {
        guard let curConfig = (view as? UIScrollView)?.emptyDataSetConfig else {
            return defaultEmptyConfig.horizontalSpace
        }
        return curConfig.horizontalSpace
    }

    public func buttonImageForEmpty(forState state: UIControl.State, in view: UIView) -> UIImage? {
        guard let curConfig = (view as? UIScrollView)?.emptyDataSetConfig,
              let imageBlock = curConfig.buttonImageBlock
        else {
            return defaultEmptyConfig.buttonImageBlock?(state)
        }
        return imageBlock(state)
    }

    public func buttonTitleForEmpty(forState state: UIControl.State, in view: UIView) -> NSAttributedString? {
        guard let curConfig = (view as? UIScrollView)?.emptyDataSetConfig else {
            return defaultEmptyConfig.buttonTitle
        }
        return curConfig.buttonTitle
    }

    public func buttonBackgroundImageForEmpty(forState state: UIControl.State, in view: UIView) -> UIImage? {
        guard let curConfig = (view as? UIScrollView)?.emptyDataSetConfig,
              let imageBlock = curConfig.buttonBackgroundImageBlock
        else {
            return defaultEmptyConfig.buttonBackgroundImageBlock?(state)
        }
        return imageBlock(state)
    }

    public func buttonBackgroundColorForEmpty(in view: UIView) -> UIColor {
        guard let curConfig = (view as? UIScrollView)?.emptyDataSetConfig else {
            return defaultEmptyConfig.buttonBackgroundColor
        }
        return curConfig.buttonBackgroundColor
    }

    public func imageTintColorForEmpty(in view: UIView) -> UIColor? {
        guard let curConfig = (view as? UIScrollView)?.emptyDataSetConfig else {
            return defaultEmptyConfig.imageTintColor
        }
        return curConfig.imageTintColor
    }

    public func imageAnimationForEmpty(in view: UIView) -> CAAnimation? {
        guard let curConfig = (view as? UIScrollView)?.emptyDataSetConfig else {
            return defaultEmptyConfig.imageAnimation
        }
        return curConfig.imageAnimation
    }

    public func emptyView(_ emptyView: UIView, tappedIn view: UIView) {
        guard let block = (emptyView as? UIScrollView)?.emptyViewTapBlock else {
            return
        }
        block(view)
    }

    public func emptyButton(_ button: UIButton, tappedIn view: UIView) {
        guard let block = (view as? UIScrollView)?.emptyViewTapBlock else {
            return
        }
        block(button)
    }

    public func customViewForEmpty(in view: UIView) -> UIView? {
        guard let curConfig = (view as? UIScrollView)?.emptyDataSetConfig else {
            return defaultEmptyConfig.customEmptyView
        }
        return curConfig.customEmptyView
    }

    public func emptyWillAppear(in view: UIView) {
        guard let block = (view as? UIScrollView)?.emptyDataSetWillAppearBlock else {
            return
        }
        block()
    }

    public func emptyDidAppear(in view: UIView) {
        guard let block = (view as? UIScrollView)?.emptyDataSetDidAppearBlock else {
            return
        }
        block()
    }

    public func emptyWillDisAppear(in view: UIView) {
        guard let block = (view as? UIScrollView)?.emptyDataSetWillDisappearBlock else {
            return
        }
        block()
    }

    public func emptyDidDisAppear(in view: UIView) {
        guard let block = (view as? UIScrollView)?.emptyDataSetDidDisappearBlock else {
            return
        }
        block()
    }
}

private var emptyDataSetConfigureKey = "emptyDataSetConfigureKey"
private var emptyViewTapBlockKey = "emptyViewTapBlockKey"
private var emptyButtonTapBlockKey = "emptyButtonTapBlockKey"
private var emptyDataSetWillAppearKey = "emptyDataSetWillAppearKey"
private var emptyDataSetDidAppearKey = "emptyDataSetDidAppearKey"
private var emptyDataSetWillDisappearKey = "emptyDataSetWillDisappearKey"
private var emptyDataSetDidDisappearKey = "emptyDataSetDidDisappearKey"

// MARK: Rx
extension Reactive where Base: UIScrollView {
    public var emptyConfig: Binder<EmptyDataSetConfigure?> {
        return Binder(self.base) { (scrollView, config) in
            scrollView.updateEmptyDataSet(config)
        }
    }
}

public extension Reactive where Base: NSObject, Base: EmptyDataSetable {
    enum TapType {
        case emptyView(_ view: UIView)
        case emptyButton(_ button: UIButton)
    }

    func tapEmptyView(_ scrollView: UIScrollView) -> Observable<UIView> {
        return Observable<UIView>.create { observer -> Disposable in
            self.base.lw.tapEmptyView(scrollView) { observer.onNext($0) }
            return Disposables.create { }
        }
    }

    func tapEmptyButton(_ scrollView: UIScrollView) -> Observable<UIButton> {
        return Observable<UIButton>.create { observer -> Disposable in
            self.base.lw.tapEmptyButton(scrollView) { observer.onNext($0) }
            return Disposables.create { }
        }
    }

    func tap(_ scrollView: UIScrollView) -> Observable<TapType> {
        return Observable<TapType>.create { observer -> Disposable in
            self.base.lw.tapEmptyView(scrollView) { observer.onNext(.emptyView($0)) }
            self.base.lw.tapEmptyButton(scrollView) { observer.onNext(.emptyButton($0)) }
            return Disposables.create { }
        }
    }

    func emptyViewWillAppear(_ scrollView: UIScrollView) -> Observable<Void> {
        return Observable<Void>.create { observer -> Disposable in
            self.base.lw.emptyViewWillAppear(scrollView) { observer.onNext(()) }
            return Disposables.create { }
        }
    }

    func emptyViewDidAppear(_ scrollView: UIScrollView) -> Observable<Void> {
        return Observable<Void>.create { observer -> Disposable in
            self.base.lw.emptyViewDidAppear(scrollView) { observer.onNext(()) }
            return Disposables.create { }
        }
    }

    func emptyViewWillDisappear(_ scrollView: UIScrollView) -> Observable<Void> {
        return Observable<Void>.create { observer -> Disposable in
            self.base.lw.emptyViewWillDisappear(scrollView) { observer.onNext(()) }
            return Disposables.create { }
        }
    }

    func emptyViewDidDisappear(_ scrollView: UIScrollView) -> Observable<Void> {
        return Observable<Void>.create { observer -> Disposable in
            self.base.lw.emptyViewDidDisappear(scrollView) { observer.onNext(()) }
            return Disposables.create { }
        }
    }
}
