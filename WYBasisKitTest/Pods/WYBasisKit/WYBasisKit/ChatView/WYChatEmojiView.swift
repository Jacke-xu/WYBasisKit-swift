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
        collectionView.wy_register("WYEmojiViewCell", .cell)
        collectionView.wy_register("WYEmojiHeaderView", .headerView)
        collectionView.wy_register("UICollectionReusableView", .headerView)
        collectionView.wy_register("UICollectionReusableView", .footerView)
        collectionView.isPagingEnabled = emojiViewConfig.isPagingEnabled
        collectionView.showsVerticalScrollIndicator = !collectionView.isPagingEnabled
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        return collectionView
    }()
    
    lazy private var recentlyEmoji: [String] = {
        let recentlyEmoji: [String] = UserDefaults.standard.array(forKey: emojiViewRecentlyCountKey) as? [String] ?? []
        return recentlyEmoji
    }()
    
    lazy private var dataSource: [[String]] = {
        var dataSource: [[String]] = []
        if (emojiViewConfig.showRecently == true) && (recentlyEmoji.isEmpty == false) {
            dataSource.append(recentlyEmoji)
        }
        dataSource.append(emojiViewConfig.emojiSource)
        return dataSource
    }()
    
    init() {
        super.init(frame: .zero)
        self.collectionView.backgroundColor = emojiViewConfig.backgroundColor
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
        guard recentlyEmoji.isEmpty == false  else {
            return emojiViewConfig.sectionInset
        }
        return [emojiViewConfig.recentlySectionInset, emojiViewConfig.sectionInset][section]
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        guard recentlyEmoji.isEmpty == false  else {
            return CGSize.zero
        }
        return CGSize(width: wy_screenWidth, height: emojiViewConfig.headerHeight)
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource[section].count
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard recentlyEmoji.isEmpty == false  else {
            return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "UICollectionReusableView", for: indexPath)
        }
        
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView: WYEmojiHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "WYEmojiHeaderView", for: indexPath) as! WYEmojiHeaderView
            headerView.textView.text = [emojiViewConfig.recentlyHeaderText, emojiViewConfig.totalHeaderText][indexPath.section]
        }
        return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "UICollectionReusableView", for: indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: WYEmojiViewCell  = collectionView.dequeueReusableCell(withReuseIdentifier: "WYEmojiViewCell", for: indexPath) as! WYEmojiViewCell
        cell.emojiView.image = UIImage.wy_find(dataSource[indexPath.section][indexPath.item])
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize.zero
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let emojiName: String = dataSource[indexPath.section][indexPath.item]
        delegate?.didClick?(self, emojiName)
    }
}

public class WYEmojiFuncAreaView: UIView {
    
    init() {
        super.init(frame: .zero)
        backgroundColor = backgroundColor
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
    public var recentlyCount: Int = 7

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
    public var minimumLineCount: Int = 7

    /// 自定义Emoji控件单元格的Size
    public var itemSize: CGSize = CGSize(width: wy_screenWidth(36), height: wy_screenWidth(36))

    /// 自定义Emoji控件的sectionInset
    public var sectionInset: UIEdgeInsets = UIEdgeInsets(top: 0, left: wy_screenWidth(15), bottom: wy_screenWidth(15), right: wy_screenWidth(15))

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
    public init() {}
}
