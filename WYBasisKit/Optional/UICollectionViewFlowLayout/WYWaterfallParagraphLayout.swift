//
//  WYWaterfallParagraphLayout.swift
//  WYBasisKit
//
//  Created by jacke·xu on 2021/2/5.
//  Copyright © 2021 jacke·xu. All rights reserved.
//

import UIKit

@objc protocol WYWaterfallParagraphLayoutDelegate {
    
    /** item的高度 */
    @objc optional func waterfallsFlowLayout(_ waterfallsLayout: WYWaterfallParagraphLayout, heightForItemAt indexPath: IndexPath) -> CGFloat
    
    /** 头视图的高度 */
    @objc optional func waterfallsFlowLayout(_ waterfallsLayout: WYWaterfallParagraphLayout, heightForHeaderIn section: Int) -> CGFloat
    
    /** 尾视图的高度 */
    @objc optional func waterfallsFlowLayout(_ waterfallsLayout: WYWaterfallParagraphLayout, heightForFooterIn section: Int) -> CGFloat
    
    /** 列数，默认2 */
    @objc optional func waterfallsFlowLayout(_ waterfallsLayout: WYWaterfallParagraphLayout, numberOfColumnsIn section: Int) -> Int
    
    /** section内边距，默认0 */
    @objc optional func waterfallsFlowLayout(_ waterfallsLayout: WYWaterfallParagraphLayout, edgeInsetsIn section: Int) -> UIEdgeInsets
    
    /** item左右间距，默认0 */
    @objc optional func waterfallsFlowLayout(_ waterfallsLayout: WYWaterfallParagraphLayout, minimumInteritemSpacingIn section: Int) -> CGFloat
    
    /** item上下间距，，默认0 */
    @objc optional func waterfallsFlowLayout(_ waterfallsLayout: WYWaterfallParagraphLayout, minimumLineSpacingIn section: Int) -> CGFloat
    
    /** 分区header与上个分区footer之间的间距，默认0 */
    @objc optional func waterfallsFlowLayout(_ waterfallsLayout: WYWaterfallParagraphLayout, offsetIn section: Int) -> CGFloat
}

class WYWaterfallParagraphLayout: UICollectionViewFlowLayout {
    
    /** delegate */
    weak var delegate: WYWaterfallParagraphLayoutDelegate?
    
    /** 分区header是否悬停, 默认false(待完善) */
    var sectionHeaderHover: Bool = false
    
    init(delegate: WYWaterfallParagraphLayoutDelegate) {
        super.init()
        self.delegate = delegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension WYWaterfallParagraphLayout {
    
    override func prepare() {
        
        super.prepare()
        
        // 清除之前数组开始创建每一组cell的布局属性
        contentHeight = 0
        lastContentHeight = 0
        columnHeights.removeAll()
        attributesArray.removeAll()
        
        // 开始创建每一组cell的布局属性
        let sectionCount: Int = collectionView?.numberOfSections ?? 0
        // 遍历section
        for section in 0..<sectionCount {
            
            lastContentHeight = contentHeight
            
            let numberOfColumnsInSection: Int = (delegate?.waterfallsFlowLayout?(self, numberOfColumnsIn: section) ?? 2) > 0 ? (delegate?.waterfallsFlowLayout?(self, numberOfColumnsIn: section) ?? 2) : 2
            // 初始化分区 y 值
            for _ in 0..<numberOfColumnsInSection {
                columnHeights.append(contentHeight)
            }
            
            // 开始创建组内的每一个cell的布局属性
            let itemCount: Int = collectionView?.numberOfItems(inSection: section) ?? 0
            for item in 0..<itemCount {
                // 获取indexPath位置cell对应的布局属性
                let itemAttributes = layoutAttributesForItem(at: IndexPath(item: item, section: section))
                if itemAttributes != nil {
                    attributesArray.append(itemAttributes!)
                }
            }
            
            // 获取每一组头视图header的UICollectionViewLayoutAttributes
            let headerAttributes = layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, at: IndexPath(item: 0, section: section))
            if headerAttributes != nil {
                attributesArray.append(headerAttributes!)
                columnHeights.removeAll()
            }

            // 获取每一组尾视图footer的UICollectionViewLayoutAttributes
            let footerAttributes = layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, at: IndexPath(item: 0, section: section))
            if footerAttributes != nil {
                attributesArray.append(footerAttributes!)
            }
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attributesArray
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        let numberOfColumnsInSection: Int = (delegate?.waterfallsFlowLayout?(self, numberOfColumnsIn: indexPath.section) ?? 2) > 0 ? (delegate?.waterfallsFlowLayout?(self, numberOfColumnsIn: indexPath.section) ?? 2) : 2
        
        let lineSpacing: CGFloat = delegate?.waterfallsFlowLayout?(self, minimumLineSpacingIn: indexPath.section) ?? 0
        
        let interitemSpacing: CGFloat = delegate?.waterfallsFlowLayout?(self, minimumInteritemSpacingIn: indexPath.section) ?? 0
        
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        
        let collectionWidth: CGFloat = collectionView?.frame.size.width ?? 0.0
        
        let itemSpacing: CGFloat = CGFloat(numberOfColumnsInSection - 1) * interitemSpacing
        
        let sectionInsets: UIEdgeInsets = delegate?.waterfallsFlowLayout?(self, edgeInsetsIn: indexPath.section) ?? .zero
        
        let totalWidth: CGFloat = collectionWidth - sectionInsets.left - sectionInsets.right - itemSpacing
        
        let itemWidth: CGFloat = totalWidth / CGFloat(numberOfColumnsInSection)
        
        let itemHeight: CGFloat = delegate?.waterfallsFlowLayout?(self, heightForItemAt: indexPath) ?? 0.0
        
        let minColumnHeight: CGFloat = columnHeights.min() ?? 0.0
        
        let minColumnWidth: Int = columnHeights.firstIndex(of: minColumnHeight) ?? 0
        
        let itemOffsetx: CGFloat = sectionInsets.left + CGFloat(minColumnWidth) * (itemWidth + interitemSpacing)
        
        let sectionOffset: CGFloat = delegate?.waterfallsFlowLayout?(self, offsetIn: indexPath.section) ?? 0.0
        
        let headerSize: CGSize = CGSize(width: collectionView?.frame.size.width ?? 0.0, height: delegate?.waterfallsFlowLayout?(self, heightForHeaderIn: indexPath.section) ?? 0.0)
        
        let headerOffset = sectionOffset + sectionInsets.top + headerSize.height
        
        let itemOffsety: CGFloat = minColumnHeight + ((minColumnHeight != lastContentHeight) ? lineSpacing : 0) + ((indexPath.item < numberOfColumnsInSection) ? headerOffset : 0)
        
        contentHeight = (contentHeight < minColumnHeight) ? minColumnHeight : contentHeight
        
        attributes.frame = CGRect(x: itemOffsetx, y: itemOffsety, width: itemWidth, height: itemHeight)
        
        if columnHeights.isEmpty == false {
            columnHeights[minColumnWidth] = attributes.frame.maxY
        }
        
        contentHeight = ((columnHeights.max() ?? 0.0) > contentHeight) ? (columnHeights.max() ?? 0.0) : contentHeight
        
        return attributes
    }
    
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: elementKind, with: indexPath)
        
        let sectionInsets: UIEdgeInsets = delegate?.waterfallsFlowLayout?(self, edgeInsetsIn: indexPath.section) ?? .zero
        
        if elementKind == UICollectionView.elementKindSectionHeader {
            
            let headerSize: CGSize = CGSize(width: collectionView?.frame.size.width ?? 0.0, height: delegate?.waterfallsFlowLayout?(self, heightForHeaderIn: indexPath.section) ?? 0.0)
            
            let sectionOffset: CGFloat = delegate?.waterfallsFlowLayout?(self, offsetIn: indexPath.section) ?? 0.0
            
//            // 悬浮方案
//            let contentOffsety: CGFloat = collectionView?.contentOffset.y ?? 0.0
//            let minOffsety: CGFloat = max(sectionOffset + lastContentHeight, contentOffsety)
//            let maxOffsety: CGFloat = (columnHeights.max() ?? 0) + sectionInsets.bottom
//            let headerOffset: CGFloat = min(minOffsety, maxOffsety)
            
            // 不悬浮方案
            let headerOffset: CGFloat = sectionOffset + lastContentHeight
            
            attributes.frame = CGRect(x: 0, y: headerOffset, width: headerSize.width, height: headerSize.height)
            
            let itemCount: Int = collectionView?.numberOfItems(inSection: indexPath.section) ?? 0
            if itemCount == 0 {
                contentHeight = attributes.frame.maxY
            }
            
        } else if elementKind == UICollectionView.elementKindSectionFooter {
            
            let footerSize: CGSize = CGSize(width: collectionView?.frame.size.width ?? 0.0, height: delegate?.waterfallsFlowLayout?(self, heightForFooterIn: indexPath.section) ?? 0.0)
            
            contentHeight += sectionInsets.bottom
            
            attributes.frame = CGRect(x: 0, y: contentHeight, width: footerSize.width, height: footerSize.height)
            
            contentHeight += footerSize.height
        }
        return attributes
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: collectionView?.frame.size.width ?? 0.0, height: contentHeight)
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return sectionHeaderHover
    }
}

extension WYWaterfallParagraphLayout {
    
    /** 存放所有cell的布局属性 */
    private var attributesArray: [UICollectionViewLayoutAttributes] {
        set(newValue) {
            objc_setAssociatedObject(self, WYAssociatedKeys.wy_attributesArray, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, WYAssociatedKeys.wy_attributesArray) as? [UICollectionViewLayoutAttributes] ?? []
        }
    }
    
    /** 存放每个section中各个列的最后一个高度 */
    private var columnHeights: [CGFloat] {
        set(newValue) {
            objc_setAssociatedObject(self, WYAssociatedKeys.wy_columnHeights, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, WYAssociatedKeys.wy_columnHeights) as? [CGFloat] ?? []
        }
    }
    
    /** 内容的高度 */
    private var contentHeight: CGFloat {
        set(newValue) {
            objc_setAssociatedObject(self, WYAssociatedKeys.wy_contentHeight, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, WYAssociatedKeys.wy_contentHeight) as? CGFloat ?? 0.0
        }
    }
    
    /** 记录上个section高度最高一列的高度 */
    private var lastContentHeight: CGFloat {
        set(newValue) {
            objc_setAssociatedObject(self, WYAssociatedKeys.wy_lastContentHeight, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, WYAssociatedKeys.wy_lastContentHeight) as? CGFloat ?? 0.0
        }
    }
    
    private struct WYAssociatedKeys {
        
        static let wy_attributesArray = UnsafeRawPointer.init(bitPattern: "wy_attributesArray".hashValue)!
        static let wy_columnHeights = UnsafeRawPointer.init(bitPattern: "wy_columnHeights".hashValue)!
        static let wy_contentHeight = UnsafeRawPointer.init(bitPattern: "wy_contentHeight".hashValue)!
        static let wy_lastContentHeight = UnsafeRawPointer.init(bitPattern: "wy_lastContentHeight".hashValue)!
    }
}
