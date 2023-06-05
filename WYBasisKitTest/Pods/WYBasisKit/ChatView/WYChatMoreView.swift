//
//  WYChatMoreView.swift
//  WYBasisKit
//
//  Created by 官人 on 2023/4/3.
//  Copyright © 2023 官人. All rights reserved.
//

import UIKit

public struct WYMoreViewConfig {
    
    /// 自定义More控件背景色
    public var backgroundColor: UIColor = .wy_hex("#ECECEC")
    
    /// 自定义More控件数据源
    public var moreSource: [[String: String]] = []

    /// 自定义More控件的Inset
    public var contentInset: UIEdgeInsets = UIEdgeInsets(top: wy_screenWidth(10), left: wy_screenWidth(20), bottom: wy_screenWidth(20), right: wy_screenWidth(20))
    
    /// 自定义More控件内imageView的背景色
    public var imageViewBackgroundColor: UIColor = .white
    
    /// 自定义More控件内imageView的Size
    public var imageViewSize: CGSize = CGSize(width: wy_screenWidth(65), height: wy_screenWidth(60))
    
    /// 自定义More控件内imageView的圆角半径
    public var imageViewCornerRadius: CGFloat = wy_screenWidth(15)
    
    /// 自定义More控件内imageView的背景色
    public var imageBackgroundColor: UIColor = .white
    
    /// 自定义More控件内文本控件的字体、字号
    public var textViewFont: UIFont = .systemFont(ofSize: wy_screenWidth(13))
    
    /// 自定义More控件内文本控件的色值
    public var textColor: UIColor = .wy_hex("#1B1B1B")
    
    /// 自定义More控件内文本控件顶部距离图片控件底部的间距
    public var textTopOffset: CGFloat = wy_screenWidth(10)
    
    /// 自定义More控件内一行显示几个item
    public var itemMaxCountWithLine: NSInteger = 4
    
    /// 自定义More控件内一页最多显示几行
    public var itemMaxLineWithPage: NSInteger = 2
    
    /// 自定义More控件是否需要按照 itemMaxLineWithPage 来显示高度，false的话高度会自动计算
    public var maxHeightForever: Bool = false
    
    /// 自定义More控件内item的行间距
    public var minimumLineSpacing: CGFloat = wy_screenWidth(16)
    
    /// 分页控件原点位置(可选设置)
    public var pageControlPosition: CGPoint?
    
    public init() {}
}

public extension WYMoreViewConfig {
    
    /// 计算单个item的Size
    public func moreItemSize() -> CGSize {
        return CGSize(width: imageViewSize.width, height: imageViewSize.height + textTopOffset + textViewFont.lineHeight)
    }
    
    /// 计算每页需要显示几行item
    public func numberOfLinesInPage() -> NSInteger {
        return maxHeightForever ? itemMaxLineWithPage : min(itemMaxLineWithPage, NSInteger(ceil(CGFloat(moreSource.count) / CGFloat(itemMaxCountWithLine))))
    }
    
    /// 计算自定义more控件高度
    public func contentHeight() -> CGFloat {
        
        let lineSpace: CGFloat = (numberOfLinesInPage() > 1) ? (CGFloat((numberOfLinesInPage() - 1)) * minimumLineSpacing) : 0
        
        let moreHeight: CGFloat = contentInset.top + contentInset.bottom + lineSpace + (moreItemSize().height * CGFloat(numberOfLinesInPage()))
        
        return moreHeight
    }
}

@objc public protocol WYChatMoreViewDelegate {
    
    /// 监控item点击事件
    @objc optional func didClickMoreViewAt(_ itemIndex: NSInteger)
}

public class WYChatMoreView: UIView {
    
    /// 点击事件代理
    public weak var delegate: WYChatMoreViewDelegate?
    
    lazy var collectionView: UICollectionView = {
        
        let minimumInteritemSpacing: CGFloat = (wy_screenWidth - moreViewConfig.contentInset.left - moreViewConfig.contentInset.right - (moreViewConfig.moreItemSize().width * CGFloat(moreViewConfig.itemMaxCountWithLine))) / CGFloat(moreViewConfig.itemMaxCountWithLine - 1)
        
        let flowLayout: WYCollectionViewFlowLayout = WYCollectionViewFlowLayout(delegate: self)
        flowLayout.itemSize = moreViewConfig.moreItemSize()
        flowLayout.minimumLineSpacing = moreViewConfig.minimumLineSpacing
        flowLayout.minimumInteritemSpacing = minimumInteritemSpacing
        flowLayout.scrollDirection = .horizontal
        
        let collectionView: UICollectionView = UICollectionView.wy_shared(flowLayout: flowLayout, delegate: self, dataSource: self, superView: self)

        collectionView.register(WYMoreViewCell.self, forCellWithReuseIdentifier: "WYMoreViewCell")
        collectionView.isPagingEnabled = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        return collectionView
    }()
    
    init() {
        super.init(frame: .zero)
        backgroundColor = moreViewConfig.backgroundColor
        self.collectionView.backgroundColor = moreViewConfig.backgroundColor
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

extension WYChatMoreView: UICollectionViewDelegate, UICollectionViewDataSource, WYCollectionViewFlowLayoutDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return moreViewConfig.moreSource.count
    }
    
    public func wy_collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, numberOfLinesIn section: Int) -> Int {
        return moreViewConfig.numberOfLinesInPage()
    }
    
    public func wy_collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return moreViewConfig.contentInset
    }
    
    public func wy_collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, horizontalScrollItemArrangementDirectionForSectionAt section: Int) -> Bool {
        return true
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: WYMoreViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "WYMoreViewCell", for: indexPath) as! WYMoreViewCell
        
        let itemSource: [String: String] = moreViewConfig.moreSource[indexPath.item]
        cell.iconView.image = UIImage.wy_find(itemSource.values.first ?? "")
        cell.titleView.text = itemSource.keys.first ?? ""
        
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        delegate?.didClickMoreViewAt?(indexPath.item)
    }
}
