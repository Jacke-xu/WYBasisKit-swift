//
//  WYWaterfallsFlowLayout.swift
//  WYBasisKit
//
//  Created by Jacke·xu on 2021/1/18.
//  Copyright © 2021 Jacke·xu. All rights reserved.
//

import UIKit

/// WaterfallsFlowLayoutStyle
enum WYWaterfallsFlowLayoutStyle {
    
    /** 竖向瀑布流 item等宽不等高 支持头尾视图 */
    case verticalEqualWidth
    /** 竖向瀑布流 item等高不等宽 支持头尾视图 */
    case verticalEqualHeight
    /** 水平瀑布流 item等高不等宽 不支持头尾视图*/
    case horizontalEqualHeight
    /** 水平栅格瀑布流 不支持头尾视图*/
    case horizontalGrid
}

/**
 返回item的大小
 注意：根据当前的瀑布流样式需知的事项：
 当样式为 verticalEqualWidth 时 传入的size.width无效 ，所以可以是任意值，因为内部会根据样式自己计算布局
 当样式为 verticalEqualHeight 时 传入的size宽高都有效， 此时返回列数、行数的代理方法无效
 当样式为 horizontalEqualHeight 时 传入的size.height无效 ，所以可以是任意值 ，因为内部会根据样式自己计算布局
 当样式为 horizontalGrid  时 传入的size宽高都有效， 此时返回列数、行数的代理方法无效，
 */
@objc protocol WYWaterfallsFlowLayoutDelegate {
    
    /** item的size */
    @objc optional func waterfallsFlowLayout(_ waterfallsLayout: WYWaterfallsFlowLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    
    /** 头视图size */
    @objc optional func waterfallsFlowLayout(_ waterfallsLayout: WYWaterfallsFlowLayout, sizeForHeaderIn section: Int) -> CGSize
    
    /** 尾视图size */
    @objc optional func waterfallsFlowLayout(_ waterfallsLayout: WYWaterfallsFlowLayout, sizeForFooterIn section: Int) -> CGSize
    
    /** 列数，竖向或水平布局时选传，竖向默认2， 横向默认1(也可以通过numberOfColumns属性设置) */
    @objc optional func numberOfColumnsInWaterfallsFlowLayout() -> Int
}

class WYWaterfallsFlowLayout: UICollectionViewFlowLayout {
    
    /** delegate */
    weak var delegate: WYWaterfallsFlowLayoutDelegate?
    
    /** 瀑布流样式, 默认verticalEqualWidth */
    var waterfallsFlowStyle: WYWaterfallsFlowLayoutStyle = .verticalEqualWidth
    
    /** 列数，竖向或水平布局时选传，竖向默认2， 横向默认1 */
    var numberOfColumns: Int {
        set(newValue) {
            defaultNumberOfColumns = newValue
        }
        get {
            return delegate?.numberOfColumnsInWaterfallsFlowLayout?() ?? defaultNumberOfColumns
        }
    }
    
    init(delegate: WYWaterfallsFlowLayoutDelegate) {
        super.init()
        self.delegate = delegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension WYWaterfallsFlowLayout {
    
    override func prepare() {

        super.prepare()

        switch waterfallsFlowStyle {
        case .verticalEqualWidth:
            maxColumnHeight = 0
            columnHeights.removeAll()
            for _ in 0..<numberOfColumns {
                columnHeights.append(sectionInset.top)
            }
        case .verticalEqualHeight:
            maxColumnHeight = 0
            maxRowWidth = 0
            columnHeights.removeAll()
            rowWidths.removeAll()
            columnHeights.append(sectionInset.top)
            rowWidths.append(sectionInset.left)
        case .horizontalEqualHeight:
            maxRowWidth = 0
            rowWidths.removeAll()
            for _ in 0..<numberOfColumns {
                rowWidths.append(sectionInset.left)
            }
        case .horizontalGrid:
            maxColumnHeight = 0
            maxRowWidth = 0
            rowWidths.removeAll()
            for _ in 0..<2 {
                rowWidths.append(sectionInset.left)
            }
        }

        // 清除之前数组开始创建每一组cell的布局属性
        attributesArray.removeAll()

        // 开始创建每一组cell的布局属性
        let sectionCount: Int = collectionView?.numberOfSections ?? 0
        for section in 0..<sectionCount {
            
            // 获取每一组头视图header的UICollectionViewLayoutAttributes
            let headerAttributes = layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, at: IndexPath(item: 0, section: section))
            if headerAttributes != nil {
                attributesArray.append(headerAttributes!)
            }

            // 开始创建组内的每一个cell的布局属性
            let itemCount: Int = collectionView?.numberOfItems(inSection: section) ?? 0
            for itemIndex in 0..<itemCount {
                // 获取indexPath位置cell对应的布局属性
                let itemAttributes = layoutAttributesForItem(at: IndexPath(item: itemIndex, section: section))
                if itemAttributes != nil {
                    attributesArray.append(itemAttributes!)
                }
            }

            // 获取每一组尾视图footer的UICollectionViewLayoutAttributes
            let footerAttributes = layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, at: IndexPath(item: 0, section: section))
            if footerAttributes != nil {
                attributesArray.append(footerAttributes!)
            }
        }
    }
    
    // 决定一段区域所有cell和头尾视图的布局属性
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attributesArray
    }
    
    // 返回indexPath位置cell对应的布局属性
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        // 设置布局属性
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        
        switch waterfallsFlowStyle {
        case .verticalEqualWidth:
            attributes.frame = itemFrameOfVerticalEqualWidth(indexPath)
        case .verticalEqualHeight:
            attributes.frame = itemFrameOfVerticalEqualHeight(indexPath)
        case .horizontalEqualHeight:
            attributes.frame = itemFrameOfHorizontalEqualHeight(indexPath)
        case .horizontalGrid:
            attributes.frame = itemFrameOfHorizontalGrid(indexPath)
        }
        return attributes
    }
    
    // 返回indexPath位置头和尾视图对应的布局属性
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        var attributes: UICollectionViewLayoutAttributes? = nil
        if elementKind == UICollectionView.elementKindSectionHeader {
            attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, with: indexPath)
            attributes?.frame = headerFrame(indexPath)
        }
        if elementKind == UICollectionView.elementKindSectionFooter {
            attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, with: indexPath)
            attributes?.frame = footerFrame(indexPath)
        }
        return attributes
    }
    
    // 返回内容高度
    override var collectionViewContentSize: CGSize {
        switch waterfallsFlowStyle {
        case .verticalEqualWidth:
            return CGSize(width: 0, height: maxColumnHeight+sectionInset.bottom)
        case .verticalEqualHeight:
            return CGSize(width: 0, height: maxColumnHeight+sectionInset.bottom)
        case .horizontalEqualHeight:
            return CGSize(width: maxRowWidth+sectionInset.right, height: 0)
        case .horizontalGrid:
            return CGSize(width: maxRowWidth+sectionInset.right, height: collectionView?.frame.size.height ?? 0.0)
        }
    }
    
    private func itemFrameOfVerticalEqualWidth(_ indexPath: IndexPath) -> CGRect {
        
        // collectionView的宽度
        let collectionWidth: CGFloat = collectionView?.frame.size.width ?? 0.0
        
        // 找出高度最短的那一列
        let minColumnHeight: CGFloat = columnHeights.min() ?? 0.0
        let destColumn: Int = columnHeights.firstIndex(of: minColumnHeight) ?? 0
        
        // 设置布局属性item的frame
        let itemWidth: CGFloat = (collectionWidth - sectionInset.left - sectionInset.right - (CGFloat(numberOfColumns - 1)) * minimumInteritemSpacing) / CGFloat(numberOfColumns)
        let itemHeight: CGFloat = delegate?.waterfallsFlowLayout?(self, sizeForItemAt: indexPath).height ?? itemSize.height
        
        let itemx: CGFloat = sectionInset.left + CGFloat(destColumn) * (itemWidth + minimumInteritemSpacing)
        let itemy: CGFloat = (minColumnHeight != sectionInset.top) ? (minColumnHeight + minimumLineSpacing) : minColumnHeight
        
        // 更新最短那列的高度
        columnHeights[destColumn] = CGRect(x: itemx, y: itemy, width: itemWidth, height: itemHeight).maxY
        // 记录内容的高度
        let columnHeight: CGFloat = columnHeights[destColumn]
        maxColumnHeight = (maxColumnHeight < columnHeight) ? columnHeight : maxColumnHeight
        
        return CGRect(x: itemx, y: itemy, width: itemWidth, height: itemHeight)
    }
    
    private func itemFrameOfVerticalEqualHeight(_ indexPath: IndexPath) -> CGRect {
        
        // collectionView的宽度
        let collectionWidth: CGFloat = collectionView?.frame.size.width ?? 0.0
        
        let headViewSize: CGSize = delegate?.waterfallsFlowLayout?(self, sizeForHeaderIn: indexPath.section) ?? headerReferenceSize
        let itemWidth: CGFloat = delegate?.waterfallsFlowLayout?(self, sizeForItemAt: indexPath).width ?? itemSize.width
        let itemHeight: CGFloat = delegate?.waterfallsFlowLayout?(self, sizeForItemAt: indexPath).height ?? itemSize.height
        
        var itemx: CGFloat = 0.0
        var itemy: CGFloat = 0.0
        // 记录最后一行的内容的横坐标和纵坐标
        if collectionWidth - (rowWidths.first ?? 0.0) > itemWidth + sectionInset.right {
            itemx = ((rowWidths.first ?? 0.0) == sectionInset.left) ? sectionInset.left : ((rowWidths.first ?? 0.0) + minimumInteritemSpacing)
            if (columnHeights.first ?? 0.0) == sectionInset.top {
                itemy = sectionInset.top
            }else if (columnHeights.first ?? 0.0) == (sectionInset.top + headViewSize.height) {
                itemy = sectionInset.top + headViewSize.height + minimumLineSpacing
            }else {
                itemy = (columnHeights.first ?? 0.0) - itemHeight
            }
            if rowWidths.isEmpty == false {
                rowWidths[0] = itemx + itemWidth
            }
        }else if collectionWidth - (rowWidths.first ?? 0.0) == itemWidth + sectionInset.right {
            itemx = sectionInset.left
            itemy = (columnHeights.first ?? 0.0) + minimumLineSpacing
            if rowWidths.isEmpty == false {
                rowWidths[0] = itemx + itemWidth
            }
            if columnHeights.isEmpty == false {
                columnHeights[0] = itemy + itemHeight
            }
        }else {
            itemx = sectionInset.left
            itemy = (columnHeights.first ?? 0.0) + minimumLineSpacing
            if rowWidths.isEmpty == false {
                rowWidths[0] = itemx + itemWidth
            }
            if columnHeights.isEmpty == false {
                columnHeights[0] = itemy + itemHeight
            }
        }
        // 记录内容的高度
        maxColumnHeight = (columnHeights.first ?? 0.0)
        return CGRect(x: itemx, y: itemy, width: itemWidth, height: itemHeight)
    }
    
    private func itemFrameOfHorizontalEqualHeight(_ indexPath: IndexPath) -> CGRect {
        
        // collectionView的宽度
        let collectionHeight: CGFloat = collectionView?.frame.size.height ?? 0.0
        let itemWidth = delegate?.waterfallsFlowLayout?(self, sizeForItemAt: indexPath).width ?? itemSize.width
        let itemHeight = (collectionHeight - sectionInset.top - sectionInset.bottom - (CGFloat((numberOfColumns - 1)) * minimumLineSpacing)) / CGFloat(numberOfColumns)
        
        // 找出宽度最短的那一行
        let minRowWidth: CGFloat = rowWidths.min() ?? 0.0
        let destRow: Int = rowWidths.firstIndex(of: minRowWidth) ?? 0
        
        let itemx = (minRowWidth != sectionInset.left) ? (minRowWidth + minimumInteritemSpacing) : minRowWidth
        let itemy = sectionInset.top + CGFloat(destRow) * (itemHeight + minimumLineSpacing)
        
        // 更新最短那行的宽度
        rowWidths[destRow] = CGRect(x: itemx, y: itemy, width: itemWidth, height: itemHeight).maxX
        // 记录内容的宽度
        maxRowWidth = (maxRowWidth < rowWidths[destRow]) ? rowWidths[destRow] : maxRowWidth
        
        return CGRect(x: itemx, y: itemy, width: itemWidth, height: itemHeight)
    }
    
    private func itemFrameOfHorizontalGrid(_ indexPath: IndexPath) -> CGRect {
        
        // collectionView的高度
        let collectionHeight: CGFloat = collectionView?.frame.size.height ?? 0.0
        // 设置布局属性item的frame
        let itemWidth: CGFloat = delegate?.waterfallsFlowLayout?(self, sizeForItemAt: indexPath).width ?? itemSize.width
        let itemHeight: CGFloat = delegate?.waterfallsFlowLayout?(self, sizeForItemAt: indexPath).height ?? itemSize.height
        
        // 找出宽度最短的那一行
        let minRowWidth: CGFloat = rowWidths.min() ?? 0.0
        let destRow: Int = rowWidths.firstIndex(of: minRowWidth) ?? 0
        
        var itemx = (rowWidths[destRow] == sectionInset.left) ? sectionInset.left : (rowWidths[destRow] + minimumInteritemSpacing)
        let itemy: CGFloat = (destRow == 0) ? sectionInset.top : (sectionInset.top + itemHeight + minimumLineSpacing)
        // 更新最短那行的宽度
        if (itemHeight >= collectionHeight - sectionInset.bottom - sectionInset.top) {
            itemx = (rowWidths[destRow] == sectionInset.left) ? sectionInset.left : (maxRowWidth + minimumInteritemSpacing)
            for index in 0..<2 {
                rowWidths[index] = itemx + itemWidth
            }
        }else {
            rowWidths[destRow] = itemx + itemWidth
        }
        // 记录最大宽度
        maxRowWidth = (maxRowWidth < itemx + itemWidth) ? (itemx + itemWidth) : maxRowWidth
        
        return CGRect(x: itemx, y: itemy, width: itemWidth, height: itemHeight)
    }
    
    private func headerFrame(_ indexPath: IndexPath) -> CGRect {
        
        let headerSize = delegate?.waterfallsFlowLayout?(self, sizeForHeaderIn: indexPath.section) ?? headerReferenceSize
        
        if waterfallsFlowStyle == .verticalEqualWidth {
            var headery = (maxColumnHeight == 0) ? sectionInset.top : maxColumnHeight
            if delegate?.waterfallsFlowLayout?(self, sizeForFooterIn: indexPath.section).height == 0 {
                headery = (maxColumnHeight == 0) ? sectionInset.top : (maxColumnHeight + minimumLineSpacing)
            }
            maxColumnHeight = headery + headerSize.height
            columnHeights.removeAll()
            for _ in 0..<numberOfColumns {
                columnHeights.append(maxColumnHeight)
            }
            return CGRect(x: 0, y: headery, width: headerSize.width, height: headerSize.height)
        }
        
        if waterfallsFlowStyle == .verticalEqualHeight {
            var headery = (maxColumnHeight == 0) ? sectionInset.top : maxColumnHeight
            if delegate?.waterfallsFlowLayout?(self, sizeForFooterIn: indexPath.section).height == 0 {
                headery = (maxColumnHeight == 0) ? sectionInset.top : (maxColumnHeight + minimumLineSpacing)
            }
            maxColumnHeight = headery + headerSize.height
            rowWidths[0] = collectionView?.frame.size.width ?? 0.0
            columnHeights[0] = maxColumnHeight
            return CGRect(x: 0, y: headery, width: collectionView?.frame.size.width ?? 0.0, height: headerSize.height)
        }
        return CGRect.zero
    }
    
    private func footerFrame(_ indexPath: IndexPath) -> CGRect {
        
        let footerSize = delegate?.waterfallsFlowLayout?(self, sizeForFooterIn: indexPath.section) ?? footerReferenceSize
        
        if waterfallsFlowStyle == .verticalEqualWidth {
            let footery = (footerSize.height == 0) ? maxColumnHeight : (maxColumnHeight + minimumLineSpacing)
            maxColumnHeight = footery + footerSize.height
            
            columnHeights.removeAll()
            for _ in 0..<numberOfColumns {
                columnHeights.append(maxColumnHeight)
            }
            return CGRect(x: 0, y: footery, width: collectionView?.frame.size.width ?? 0.0, height: footerSize.height)
        }
        
        if waterfallsFlowStyle == .verticalEqualHeight {
            let footery = (footerSize.height == 0) ? maxColumnHeight : (maxColumnHeight + minimumLineSpacing)
            maxColumnHeight = footery + footerSize.height
            rowWidths[0] = collectionView?.frame.size.width ?? 0.0
            columnHeights[0] = maxColumnHeight
            
            return CGRect(x: 0, y: footery, width: collectionView?.frame.size.width ?? 0.0, height: footerSize.height)
        }
        return CGRect.zero
    }
}

extension WYWaterfallsFlowLayout {
    
    /** 存放所有cell的布局属性 */
    private var attributesArray: [UICollectionViewLayoutAttributes] {
        set(newValue) {
            objc_setAssociatedObject(self, WYAssociatedKeys.wy_attributesArray, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, WYAssociatedKeys.wy_attributesArray) as? [UICollectionViewLayoutAttributes] ?? []
        }
    }
    
    /** 存放每一列的最大X值 */
    private var rowWidths: [CGFloat] {
        set(newValue) {
            objc_setAssociatedObject(self, WYAssociatedKeys.wy_rowWidths, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, WYAssociatedKeys.wy_rowWidths) as? [CGFloat] ?? []
        }
    }
    
    /** 存放每一列的最大Y值 */
    private var columnHeights: [CGFloat] {
        set(newValue) {
            objc_setAssociatedObject(self, WYAssociatedKeys.wy_columnHeights, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, WYAssociatedKeys.wy_columnHeights) as? [CGFloat] ?? []
        }
    }
    
    /** 列数，竖向或水平布局时选传，竖向默认2， 横向默认1 */
    private var defaultNumberOfColumns: Int {
        set(newValue) {
            objc_setAssociatedObject(self, WYAssociatedKeys.wy_defaultNumberOfColumns, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, WYAssociatedKeys.wy_defaultNumberOfColumns) as? Int ?? ((waterfallsFlowStyle == .verticalEqualWidth) || ((waterfallsFlowStyle == .verticalEqualHeight)) ? 2 : 1)
        }
    }
    
    /** 内容的高度 */
    private var maxColumnHeight: CGFloat {
        set(newValue) {
            objc_setAssociatedObject(self, WYAssociatedKeys.wy_maxColumnHeight, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, WYAssociatedKeys.wy_maxColumnHeight) as? CGFloat ?? 0.0
        }
    }
    
    /** 内容的宽度 */
    private var maxRowWidth: CGFloat {
        set(newValue) {
            objc_setAssociatedObject(self, WYAssociatedKeys.wy_maxRowWidth, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, WYAssociatedKeys.wy_maxRowWidth) as? CGFloat ?? 0.0
        }
    }
    
    private struct WYAssociatedKeys {
        
        static let wy_attributesArray = UnsafeRawPointer.init(bitPattern: "wy_attributesArray".hashValue)!
        static let wy_columnHeights = UnsafeRawPointer.init(bitPattern: "wy_columnHeights".hashValue)!
        static let wy_rowWidths = UnsafeRawPointer.init(bitPattern: "wy_rowWidths".hashValue)!
        static let wy_defaultNumberOfColumns = UnsafeRawPointer.init(bitPattern: "wy_defaultNumberOfColumns".hashValue)!
        static let wy_maxColumnHeight = UnsafeRawPointer.init(bitPattern: "wy_maxColumnHeight".hashValue)!
        static let wy_maxRowWidth = UnsafeRawPointer.init(bitPattern: "wy_maxRowWidth".hashValue)!
    }
}

