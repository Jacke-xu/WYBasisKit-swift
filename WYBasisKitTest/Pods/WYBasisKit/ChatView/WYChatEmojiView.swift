//
//  WYChatEmojiView.swift
//  WYBasisKit
//
//  Created by 官人 on 2023/4/3.
//  Copyright © 2023 官人. All rights reserved.
//

private let emojiViewRecentlyCountKey: String = "emojiViewRecentlyCountKey"

import UIKit

@objc public protocol WYChatEmojiViewDelegate {
    
    /// 监控Emoji点击事件
    @objc optional func didClick(_ emojiView: WYChatEmojiView, _ emoji: String)
    
    /// 监控Emoji长按事件
    @objc optional func didLongPress(_ emojiView: WYChatEmojiView, _ emoji: String)
    
    /// 点击了删除按钮
    @objc optional func didClickEmojiDeleteView()
    
    /// 点击了发送按钮
    @objc optional func sendMessage()
}

public class WYChatEmojiView: UIView {
    
    /// 点击或长按事件代理
    public weak var delegate: WYChatEmojiViewDelegate?
    
    lazy var collectionView: UICollectionView = {
        
        let emojiViewMinimumInteritemSpacing: CGFloat = (wy_screenWidth - emojiViewConfig.sectionInset.left - emojiViewConfig.sectionInset.right - (CGFloat(emojiViewConfig.minimumLineCount) * emojiViewConfig.itemSize.width)) / (CGFloat(emojiViewConfig.minimumLineCount) - 1.0)
        let collectionView = UICollectionView.wy_shared(scrollDirection: emojiViewConfig.scrollDirection, minimumLineSpacing: emojiViewConfig.minimumLineSpacing, minimumInteritemSpacing: emojiViewMinimumInteritemSpacing, itemSize: emojiViewConfig.itemSize, delegate: self, dataSource: self, superView: self)
        
        collectionView.register(WYEmojiViewCell.self, forCellWithReuseIdentifier: "WYEmojiViewCell")
        collectionView.register(WYEmojiHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "WYEmojiHeaderView")
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "UICollectionReusableView")
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "UICollectionReusableView")
        collectionView.isPagingEnabled = emojiViewConfig.isPagingEnabled
        collectionView.showsVerticalScrollIndicator = !collectionView.isPagingEnabled
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        return collectionView
    }()
    
    lazy var funcAreaView: WYEmojiFuncAreaView = {
        let funcAreaView: WYEmojiFuncAreaView = WYEmojiFuncAreaView()
        addSubview(funcAreaView)
        funcAreaView.snp.makeConstraints { make in
            make.size.equalTo(emojiViewConfig.funcAreaConfig.areaSize)
            make.right.equalToSuperview().offset(-emojiViewConfig.funcAreaConfig.areaRightOffset)
            make.bottom.equalToSuperview().offset(-emojiViewConfig.funcAreaConfig.areaBottomOffset)
        }
        return funcAreaView
    }()
    
    lazy private var recentlyEmoji: [String] = {
        let recentlyEmoji: [String] = UserDefaults.standard.array(forKey: emojiViewRecentlyCountKey) as? [String] ?? []
        return recentlyEmoji
    }()
    
    private var appendEmoji: [String] = []
    
    lazy private var dataSource: [[String]] = {
        var dataSource: [[String]] = []
        if (emojiViewConfig.showRecently == true) && (recentlyEmoji.isEmpty == false) {
            dataSource.append(recentlyEmoji)
        }
        
        if emojiViewConfig.showFuncArea == true {
            
            let flowLayout: UICollectionViewFlowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
            
            var leftx: CGFloat = emojiViewConfig.sectionInset.left
            var line: Int = 0
            for index: Int in 0..<emojiViewConfig.minimumLineCount {
                leftx += emojiViewConfig.itemSize.width
                if leftx > (self.wy_width - emojiViewConfig.funcAreaConfig.areaRightOffset - emojiViewConfig.funcAreaConfig.sendViewRightOffset - emojiViewConfig.funcAreaConfig.sendViewSize.width - emojiViewConfig.funcAreaConfig.deleteViewSize.width - emojiViewConfig.funcAreaConfig.sendViewLeftOffsetWithDeleteView) {
                    break
                }
                leftx += flowLayout.minimumInteritemSpacing
                line += 1
            }
            
            var offsetCount: Int = 0
            let residual: Int = (emojiViewConfig.emojiSource.count % emojiViewConfig.minimumLineCount)
            
            if residual > line {
                offsetCount = (residual - line)
            }
            if residual == 0 {
                offsetCount = (emojiViewConfig.minimumLineCount - line)
            }
            
            var emojiSource: [String] = []
            emojiSource.append(contentsOf: emojiViewConfig.emojiSource)
            for _ in 0..<offsetCount {
                let lastEmoji: String = emojiSource.last ?? ""
                emojiSource.removeLast()
                appendEmoji.append(lastEmoji)
            }
            dataSource.append(emojiSource)
            if appendEmoji.isEmpty == false {
                dataSource.append(appendEmoji)
            }
            
        }else {
            dataSource.append(emojiViewConfig.emojiSource)
        }
        return dataSource
    }()
    
    public init() {
        super.init(frame: .zero)
        self.collectionView.backgroundColor = emojiViewConfig.backgroundColor
        if emojiViewConfig.showFuncArea == true {
            self.funcAreaView.gradualView.wy_makeVisual { make in
                make.wy_gradualColors([emojiViewConfig.backgroundColor.withAlphaComponent(0), emojiViewConfig.backgroundColor])
                make.wy_gradientDirection(.topToBottom)
            }
        }
    }
    
    public class func updateRecentlyEmoji(_ emoji: String) {
        guard emojiViewConfig.showRecently == true else {
            return
        }
        var recentlyEmoji: [String] = UserDefaults.standard.array(forKey: emojiViewRecentlyCountKey) as? [String] ?? []
        if recentlyEmoji.contains(emoji) {
            recentlyEmoji.remove(at: recentlyEmoji.firstIndex(of: emoji)!)
        }
        recentlyEmoji.insert(emoji, at: 0)
        if recentlyEmoji.count > emojiViewConfig.recentlyCount {
            recentlyEmoji.removeLast()
        }
        UserDefaults.standard.setValue(Array(recentlyEmoji), forKey: emojiViewRecentlyCountKey)
        UserDefaults.standard.synchronize()
    }
    
    private func sectionInset(_ section: Int) -> UIEdgeInsets {
        
        if appendEmoji.isEmpty == true {
            return emojiViewConfig.sectionInset
        }else {
            if section == (dataSource.count - 1) {
                return UIEdgeInsets(top: emojiViewConfig.minimumLineSpacing, left: emojiViewConfig.sectionInset.left, bottom: emojiViewConfig.sectionInset.bottom, right: emojiViewConfig.sectionInset.right)
            }else {
                return UIEdgeInsets(top: emojiViewConfig.sectionInset.top, left: emojiViewConfig.sectionInset.left, bottom: 0, right: emojiViewConfig.sectionInset.right)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

extension WYChatEmojiView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        if (recentlyEmoji.isEmpty == false) && (emojiViewConfig.showRecently == true) {
            if (section == 0) {
                return emojiViewConfig.recentlySectionInset
            }else {
                return sectionInset(section)
            }
        }else {
            return sectionInset(section)
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        guard (recentlyEmoji.isEmpty == false) && (emojiViewConfig.showRecently == true)  else {
            return CGSize.zero
        }
        return CGSize(width: wy_width, height: (appendEmoji.isEmpty ? emojiViewConfig.headerHeight : (section == 1 ? emojiViewConfig.headerHeight : 0)))
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource[section].count
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard (recentlyEmoji.isEmpty == false) && (emojiViewConfig.showRecently == true)  else {
            return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "UICollectionReusableView", for: indexPath)
        }
        
        if (kind == UICollectionView.elementKindSectionHeader) && (indexPath.section < 2) {
            let headerView: WYEmojiHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "WYEmojiHeaderView", for: indexPath) as! WYEmojiHeaderView
            headerView.textView.text = [emojiViewConfig.recentlyHeaderText, emojiViewConfig.totalHeaderText][indexPath.section]
        }
        
        return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "UICollectionReusableView", for: indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: WYEmojiViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "WYEmojiViewCell", for: indexPath) as! WYEmojiViewCell
        
        cell.emojiView.image = UIImage.wy_find(dataSource[indexPath.section][indexPath.item])
        
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return .zero
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let emojiName: String = dataSource[indexPath.section][indexPath.item]
        delegate?.didClick?(self, emojiName)
    }
}

public class WYEmojiFuncAreaView: UIView {
    
    var sendView: UIButton!
    var deleteView: UIButton!
    
    public let gradualView: UIView = UIView()
    
    public init() {
        super.init(frame: .zero)
        
        addSubview(gradualView)
        gradualView.snp.makeConstraints { make in
            make.top.right.equalToSuperview()
            make.height.equalTo(emojiViewConfig.funcAreaConfig.sendViewAndDeleteViewTopOffset)
            make.left.equalToSuperview().offset(emojiViewConfig.funcAreaConfig.areaSize.width - emojiViewConfig.funcAreaConfig.sendViewRightOffset - emojiViewConfig.funcAreaConfig.sendViewSize.width - emojiViewConfig.funcAreaConfig.deleteViewSize.width - emojiViewConfig.funcAreaConfig.sendViewLeftOffsetWithDeleteView)
        }

        let contentView: UIView = UIView()
        contentView.backgroundColor = emojiViewConfig.backgroundColor
        addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.right.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(emojiViewConfig.funcAreaConfig.sendViewAndDeleteViewTopOffset)
            make.left.equalTo(gradualView)
        }

        sendView = createFuncButton(text: emojiViewConfig.funcAreaConfig.sendViewText, textColorWithUnenable: emojiViewConfig.funcAreaConfig.sendViewTextColorWithUnenable, textColorWithEnable: emojiViewConfig.funcAreaConfig.sendViewTextColorWithEnable, textColorWithHighly: emojiViewConfig.funcAreaConfig.sendViewTextColorWithHighly, backgroundImageWithUnenable: emojiViewConfig.funcAreaConfig.sendViewImageWithUnenable, backgroundImageWithEnable: emojiViewConfig.funcAreaConfig.sendViewImageWithEnable, backgroundImageWithHighly: emojiViewConfig.funcAreaConfig.sendViewImageWithHighly, selector: #selector(didClickSendView))
        sendView.wy_titleFont = emojiViewConfig.funcAreaConfig.sendViewFont
        contentView.addSubview(sendView)
        sendView.snp.makeConstraints { make in
            make.size.equalTo(emojiViewConfig.funcAreaConfig.sendViewSize)
            make.right.equalToSuperview().offset(-emojiViewConfig.funcAreaConfig.sendViewRightOffset)
            make.top.equalToSuperview()
        }

        deleteView = createFuncButton(text: emojiViewConfig.funcAreaConfig.deleteViewText, textColorWithUnenable: emojiViewConfig.funcAreaConfig.deleteViewTextColorWithUnenable, textColorWithEnable: emojiViewConfig.funcAreaConfig.deleteViewTextColorWithEnable, textColorWithHighly: emojiViewConfig.funcAreaConfig.deleteViewTextColorWithHighly, backgroundImageWithUnenable: emojiViewConfig.funcAreaConfig.deleteViewImageWithUnenable, backgroundImageWithEnable: emojiViewConfig.funcAreaConfig.deleteViewImageWithEnable, backgroundImageWithHighly: emojiViewConfig.funcAreaConfig.deleteViewImageWithHighly, selector: #selector(didClickDeleteView))
        deleteView.wy_titleFont = emojiViewConfig.funcAreaConfig.deleteViewFont
        contentView.addSubview(deleteView)
        deleteView.snp.makeConstraints { make in
            make.size.equalTo(emojiViewConfig.funcAreaConfig.deleteViewSize)
            make.right.equalTo(sendView.snp.left).offset(-emojiViewConfig.funcAreaConfig.sendViewLeftOffsetWithDeleteView)
            make.top.equalToSuperview()
        }
    }
    
    @objc func didClickSendView() {
        wy_print("点击了功能区发送按钮")
    }

    @objc func didClickDeleteView() {
        wy_print("点击了功能区删除按钮")
    }

    private func createFuncButton(text: String, textColorWithUnenable: UIColor, textColorWithEnable: UIColor, textColorWithHighly: UIColor, backgroundImageWithUnenable: UIImage, backgroundImageWithEnable: UIImage, backgroundImageWithHighly: UIImage, selector: Selector) -> UIButton {

        let button: UIButton = UIButton(type: .custom)
        button.wy_sTitle = text
        button.wy_nTitle = text
        button.wy_hTitle = text
        button.wy_title_sColor = textColorWithUnenable
        button.wy_title_nColor = textColorWithEnable
        button.wy_title_hColor = textColorWithHighly
        button.setBackgroundImage(backgroundImageWithUnenable, for: .selected)
        button.setBackgroundImage(backgroundImageWithEnable, for: .normal)
        button.setBackgroundImage(backgroundImageWithHighly, for: .highlighted)
        button.wy_cornerRadius(emojiViewConfig.funcAreaConfig.deleteViewAndSendViewCornerRadius).wy_showVisual()
        button.addTarget(self, action: selector, for: .touchUpInside)

        return button
    }

    func updateFuncAreaStyle() {
        sendView.isSelected = isUserInteractionEnabled
        deleteView.isSelected = sendView.isSelected
    }

    public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView: UIView? = super.hitTest(point, with: event)
        return (hitView == gradualView) ? nil : hitView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public struct WYEmojiViewConfig {
    
    /// 自定义Emoji控件滚动方向
    public var scrollDirection: UICollectionView.ScrollDirection = .vertical

    /// 自定义Emoji控件背景色
    public var backgroundColor: UIColor = .wy_hex("#ECECEC")

    /// 自定义Emoji控件的高度
    public var contentHeight: CGFloat = wy_screenWidth(350)

    /// 自定义Emoji数据源，示例：["[玫瑰](表情图片名)","[色](表情图片名)","[嘻嘻](表情图片名)"]
    public var emojiSource: [String] = []

    /// 自定义Emoji控件是否需要翻页模式
    public var isPagingEnabled: Bool = false

    /// 自定义Emoji控件实现需要显示最近使用的表情
    public var showRecently: Bool = true

    /// 自定义Emoji控件最近使用的表情显示几个(表情默认显示7列)
    public var recentlyCount: Int = 8

    /// 自定义Emoji控件最近使用表情Header文本(设置后会显示一个Header，仅scrollDirection为vertical模式时生效)
    public var recentlyHeaderText: String = "最近使用"

    /// 自定义Emoji控件所有表情Header文本(设置后会显示一个Header，仅scrollDirection为vertical模式时生效)
    public var totalHeaderText: String = "所有表情"

    /// 自定义Emoji控件Header文本字体、字号
    public var headerTextFont: UIFont = .systemFont(ofSize: wy_screenWidth(13))

    /// 自定义Emoji控件Header文本字体颜色
    public var headerTextColor: UIColor = .wy_hex("#1B1B1B")

    /// 自定义Emoji控件HeaderView背景色
    public var headerBackgroundColor: UIColor = .wy_hex("#ECECEC")

    /// 自定义Emoji控件HeaderView高度
    public var headerHeight: CGFloat = wy_screenWidth(30)

    /// 自定义Emoji控件HeaderView中TextView的偏移量
    public var headerTextOffset: CGPoint = CGPoint(x: wy_screenWidth(15), y: wy_screenWidth(0))

    /// 自定义Emoji控件每行显示几个表情
    public var minimumLineCount: Int = 8

    /// 自定义Emoji控件单元格的Size
    public var itemSize: CGSize = CGSize(width: wy_screenWidth(30), height: wy_screenWidth(30))

    /// 自定义Emoji控件全部表情的sectionInset
    public var sectionInset: UIEdgeInsets = UIEdgeInsets(top: 0, left: wy_screenWidth(15), bottom: wy_screenWidth(20), right: wy_screenWidth(15))

    /// 自定义Emoji控件最近使用分区的sectionInset
    public var recentlySectionInset: UIEdgeInsets = UIEdgeInsets(top: wy_screenWidth(30), left: wy_screenWidth(15), bottom: wy_screenWidth(20), right: wy_screenWidth(15))

    /// 自定义Emoji控件的行间距
    public var minimumLineSpacing: CGFloat = wy_screenWidth(16)
    
    /// 是否需要在右下角显示功能区(内含删除按钮和发送按钮)
    public var showFuncArea: Bool = true

    /// 自定义Emoji控件右下角功能区配置
    public var funcAreaConfig: WYEmojiFuncAreaConfig = WYEmojiFuncAreaConfig()
    
    public init() {}
}

public struct WYEmojiFuncAreaConfig {
    
    /// 整个功能区size
    public var areaSize: CGSize = CGSize(width: wy_screenWidth(152), height: wy_screenWidth(90))
    
    /// 整个功能区距离emoji控件右侧的间距
    public var areaRightOffset: CGFloat = wy_screenWidth(15)
    
    /// 整个功能区距离emoji控件底部的间距
    public var areaBottomOffset: CGFloat = 0
    
    /// 发送按钮size
    public var sendViewSize: CGSize = CGSize(width: wy_screenWidth(60), height: wy_screenWidth(50))
    
    /// 删除按钮size
    public var deleteViewSize: CGSize = CGSize(width: wy_screenWidth(60), height: wy_screenWidth(50))
    
    /// 发送按钮左侧和删除按钮右侧之间的间距
    public var sendViewLeftOffsetWithDeleteView: CGFloat = wy_screenWidth(8)
    
    /// 发送按钮距离功能区右侧间距
    public var sendViewRightOffset: CGFloat = 0
    
    /// 发送按钮和删除按钮距离功能区顶部的间距
    public var sendViewAndDeleteViewTopOffset: CGFloat = wy_screenWidth(30)
    
    /// 删除按钮和发送按钮的圆角半径
    public var deleteViewAndSendViewCornerRadius: CGFloat = wy_screenWidth(5)
    
    /// 删除按钮不可点击时背景图
    public var deleteViewImageWithUnenable: UIImage = UIImage.wy_createImage(from: .white, size: CGSize(width: wy_screenWidth(60), height: wy_screenWidth(50)))
    
    /// 发送按钮不可点击时背景图
    public var sendViewImageWithUnenable: UIImage = UIImage.wy_createImage(from: .white, size: CGSize(width: wy_screenWidth(60), height: wy_screenWidth(50)))
    
    /// 删除按钮可点击时背景图
    public var deleteViewImageWithEnable: UIImage = UIImage.wy_createImage(from: .white, size: CGSize(width: wy_screenWidth(60), height: wy_screenWidth(50)))
    
    /// 发送按钮可点击时背景图
    public var sendViewImageWithEnable: UIImage = UIImage.wy_createImage(from: .wy_rgb(64, 118, 246), size: CGSize(width: wy_screenWidth(60), height: wy_screenWidth(50)))
    
    /// 删除按钮按压状态背景图
    public var deleteViewImageWithHighly: UIImage = UIImage.wy_createImage(from: .white, size: CGSize(width: wy_screenWidth(60), height: wy_screenWidth(50)))
    
    /// 发送按钮按压状态背景图
    public var sendViewImageWithHighly: UIImage = UIImage.wy_createImage(from: .wy_rgb(64, 118, 246), size: CGSize(width: wy_screenWidth(60), height: wy_screenWidth(50)))
    
    /// 删除按钮文本
    public var deleteViewText: String = WYLocalized("删除")
    
    /// 发送按钮文本
    public var sendViewText: String = WYLocalized("发送")
    
    /// 删除按钮字体字号
    public var deleteViewFont: UIFont = .boldSystemFont(ofSize: wy_screenWidth(16.5))
    
    /// 发送按钮字体字号
    public var sendViewFont: UIFont = .boldSystemFont(ofSize: wy_screenWidth(16.5))
    
    /// 删除按钮不可点击时文本颜色
    public var deleteViewTextColorWithUnenable: UIColor = .wy_hex("#E5E5E5")
    
    /// 发送按钮不可点击时文本颜色
    public var sendViewTextColorWithUnenable: UIColor = .wy_hex("#E5E5E5")
    
    /// 删除按钮可点击时文本颜色
    public var deleteViewTextColorWithEnable: UIColor = .blue
    
    /// 发送按钮可点击时文本颜色
    public var sendViewTextColorWithEnable: UIColor = .white
    
    /// 删除按钮按压状态文本颜色
    public var deleteViewTextColorWithHighly: UIColor = .blue
    
    /// 发送按钮按压状态文本颜色
    public var sendViewTextColorWithHighly: UIColor = .white
    
    public init() {}
}
