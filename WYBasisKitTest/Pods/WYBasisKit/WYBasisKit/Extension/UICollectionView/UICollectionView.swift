//
//  UICollectionView.swift
//  WYBasisKit
//
//  Created by 官人 on 2021/8/28.
//  Copyright © 2021 官人. All rights reserved.
//

import UIKit

/// UICollectionView注册类型
public enum WYCollectionViewRegisterStyle {
    
    /// 注册Cell
    case cell
    /// 注册HeaderView
    case headerView
    /// 注册FooterView
    case footerView
}

public extension UICollectionView {
    
    /**
     *  创建一个UICollectionView
     *  @param frame: collectionView的frame, 如果是约束布局，请直接使用默认值：.zero
     *  @param flowLayout: UICollectionViewLayout 或继承至 UICollectionViewLayout 的流式布局
     *  @param delegate: delegate
     *  @param dataSource: dataSource
     *  @param backgroundColor: 背景色
     *  @param superView: 父view
     */
    class func wy_shared(frame: CGRect = .zero,
                         flowLayout: UICollectionViewLayout,
                         delegate: UICollectionViewDelegate,
                         dataSource: UICollectionViewDataSource,
                         backgroundColor: UIColor = .white,
                         superView: UIView? = nil) -> UICollectionView {
        
        let collectionview = UICollectionView(frame: frame, collectionViewLayout: flowLayout)
        collectionview.delegate = delegate
        collectionview.dataSource = dataSource
        collectionview.backgroundColor = backgroundColor
        superView?.addSubview(collectionview)
        
        return collectionview
    }
    
    /**
     *  创建一个UICollectionView
     *  @param frame: collectionView的frame, 如果是约束布局，请直接使用默认值：.zero
     *  @param scrollDirection: 滚动方向
     *  @param sectionInset: 分区 上、左、下、右 的间距(该设置仅适用于一个分区或者每个分区sectionInset都相同的情况，多个分区请调用相关代理进行针对性设置)
     *  @param minimumLineSpacing: item 上下行间距
     *  @param minimumInteritemSpacing: item 左右列间距
     *  @param itemSize: item 大小(该设置仅适用于一个分区或者每个分区itemSize都相同的情况，多个分区请调用相关代理进行针对性设置)
     *  @param delegate: delegate
     *  @param dataSource: dataSource
     *  @param backgroundColor: 背景色
     *  @param superView: 父view
     */
    class func wy_shared(frame: CGRect = .zero,
                         scrollDirection: UICollectionView.ScrollDirection = .vertical,
                         sectionInset: UIEdgeInsets = .zero,
                         minimumLineSpacing: CGFloat = 0,
                         minimumInteritemSpacing: CGFloat = 0,
                         itemSize: CGSize? = nil,
                         delegate: UICollectionViewDelegate,
                         dataSource: UICollectionViewDataSource,
                         backgroundColor: UIColor = .white,
                         superView: UIView? = nil) -> UICollectionView {
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = scrollDirection
        flowLayout.sectionInset = sectionInset
        flowLayout.minimumLineSpacing = minimumLineSpacing
        flowLayout.minimumInteritemSpacing = minimumInteritemSpacing
        if let itemSize = itemSize {
            flowLayout.itemSize = itemSize
        }
        
        let collectionview = UICollectionView(frame: frame, collectionViewLayout: flowLayout)
        collectionview.delegate = delegate
        collectionview.dataSource = dataSource
        collectionview.backgroundColor = backgroundColor
        superView?.addSubview(collectionview)
        
        return collectionview
    }
    
    /**
     *  创建一个UICollectionView
     *  @param flowLayout: 瀑布流配置
     *  @param frame: collectionView的frame, 如果是约束布局，请直接使用默认值：.zero
     *  @param delegate: delegate
     *  @param dataSource: dataSource
     *  @param backgroundColor: 背景色
     *  @param superView: 父view
     */
    class func wy_shared(frame: CGRect = .zero,
                         flowLayout: UICollectionViewFlowLayout,
                         delegate: UICollectionViewDelegate,
                         dataSource: UICollectionViewDataSource,
                         backgroundColor: UIColor = .white,
                         superView: UIView? = nil) -> UICollectionView {
        
        let collectionview = UICollectionView(frame: frame, collectionViewLayout: flowLayout)
        collectionview.delegate = delegate
        collectionview.dataSource = dataSource
        collectionview.backgroundColor = backgroundColor
        superView?.addSubview(collectionview)
        
        return collectionview
    }
    
    /// 批量注册UICollectionView的Cell或Header/FooterView
    func wy_register(_ classNames: [String], _ styles: [WYCollectionViewRegisterStyle]) {
        for index in 0..<classNames.count {
            wy_register(classNames[index], styles[index])
        }
    }
    
    /// 注册UICollectionView的Cell或Header/FooterView
    func wy_register(_ className: String, _ style: WYCollectionViewRegisterStyle) {
        
        guard className.isEmpty == false else {
            fatalError("调用注册方法前必须创建与 \(className) 对应的类文件")
        }
        
        let registerClass = (className == "UICollectionViewCell") ? className : (wy_projectName + "." + className)
        
        switch style {
        case .cell:
            guard let cellClass = NSClassFromString(registerClass) as? UICollectionViewCell.Type else {
                return
            }
            register(cellClass.self, forCellWithReuseIdentifier: className)
            break
            
        case .headerView:
            guard let headerViewClass = NSClassFromString(registerClass) as? UICollectionReusableView.Type else {
                return
            }
            register(headerViewClass.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: className)
            break
            
        case .footerView:
            guard let footerViewClass = NSClassFromString(registerClass) as? UICollectionReusableView.Type else {
                return
            }
            register(footerViewClass.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: className)
            break
        }
    }
    
    /// 滑动或点击收起键盘
    func wy_swipeOrTapCollapseKeyboard(target: Any? = nil, action: Selector? = nil) {
        self.keyboardDismissMode = .onDrag
        let gesture = UITapGestureRecognizer(target: ((target == nil) ? self : target!), action: ((action == nil) ? action : #selector(keyboardHide)))
        gesture.numberOfTapsRequired = 1
        // 设置成 false 表示当前控件响应后会传播到其他控件上，默认为 true
        gesture.cancelsTouchesInView = false
        self.addGestureRecognizer(gesture)
    }
    
    @objc private func keyboardHide() {
        self.endEditing(true)
        self.superview?.endEditing(true)
    }
}

/// 瀑布流布局风格
@objc public enum WYWaterfallsFlowLayoutStyle: NSInteger {
    
    /** 宽、高均相等 */
    case widthAndHeightEqual = 0
    
    /** 等宽不等高 */
    case widthEqualHeightIsNotEqual = 1
    
    /** 等高不等宽 */
    case heightEqualWidthIsNotEqual = 2
}

/// 瀑布流对齐方式
@objc public enum WYFlowLayoutAlignment: NSInteger {
    
    /// 居中对齐
    case center = 0
    
    /// 左对齐
    case left = 1
    
    /// 右对齐
    case right = 2
}

@objc public protocol WYCollectionViewFlowLayoutDelegate {
    
    /** item.size */
    @objc optional func wy_collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    
    /** header.size */
    @objc optional func wy_collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: NSInteger) -> CGSize
    
    /** footer.size */
    @objc optional func wy_collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: NSInteger) -> CGSize
    
    /** number of lines(scrollDirection == .horizontal时需设置) */
    @objc optional func wy_collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, numberOfLinesIn section: NSInteger) -> NSInteger
    
    /** number of columns(scrollDirection == .vertical时需设置) */
    @objc optional func wy_collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, numberOfColumnsIn section: NSInteger) -> NSInteger
    
    /** inset for section */
    @objc optional func wy_collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: NSInteger) -> UIEdgeInsets
    
    /** item.leftRightSpacing */
    @objc optional func wy_collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: NSInteger) -> CGFloat
    
    /** item.upDownSpacing */
    @objc optional func wy_collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: NSInteger) -> CGFloat
    
    /** 分区header与上个分区footer之间的间距 */
    @objc optional func wy_collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, spacingBetweenHeaderAndLastPartitionFooter section: NSInteger) -> CGFloat
    
    /** 布局风格 */
    @objc optional func wy_collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, flowLayoutStyleForSectionAt section: NSInteger) -> WYWaterfallsFlowLayoutStyle
    
    /** 分区item对齐方式 */
    @objc optional func wy_collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, flowLayoutAlignmentForSectionAt section: NSInteger) -> WYFlowLayoutAlignment
    
    /** 当控件所需宽度超过 分区最大的显示宽度 时，最多能显示几行, 默认0(无限换行) */
    @objc optional func wy_collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, itemNumberOfLinesForSectionAt section: NSInteger) -> NSInteger
    
    /** 水平滚动时，分区的item排列方式是否需要调整为水平排列(系统默认为竖向排列) */
    @objc optional func wy_collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, horizontalScrollItemArrangementDirectionForSectionAt section: NSInteger) -> Bool
    
    /** 分区header是否需要悬停 */
    @objc optional func wy_collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, hoverForHeaderForSectionAt section: NSInteger) -> Bool
}

public class WYCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    /** delegate */
    public weak var delegate: WYCollectionViewFlowLayoutDelegate?
    
    public override init() {
        super.init()
    }
    
    public init(delegate: WYCollectionViewFlowLayoutDelegate) {
        self.delegate = delegate
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public extension WYCollectionViewFlowLayout {
    
    override func prepare() {
        
        super.prepare()
        
        // 清除之前数组开始创建每一组cell的布局属性
        contentSize = .zero
        lastContentWidth = 0
        lastContentHeight = 0
        columnWidths.removeAll()
        columnHeights.removeAll()
        attributesArray.removeAll()
        
        // 开始创建每一组cell的布局属性
        let sectionCount: NSInteger = collectionView?.numberOfSections ?? 0
        // 遍历section
        for section in 0..<sectionCount {
            
            lastContentWidth = contentSize.width
            lastContentHeight = contentSize.height
            
            
            // 初始化分区 x 值
            let numberOfLinesInSection: NSInteger = numberOfLinesIn(section)
            for _ in 0..<numberOfLinesInSection {
                columnWidths.append(contentSize.width)
            }
            
            // 初始化分区 y 值
            let numberOfColumnsInSection: NSInteger = numberOfColumnsIn(section)
            for _ in 0..<numberOfColumnsInSection {
                columnHeights.append(contentSize.height)
            }
            
            
            // 开始创建组内的每一个cell的布局属性
            let itemCount: NSInteger = collectionView?.numberOfItems(inSection: section) ?? 0
            let flowLayoutStyle: WYWaterfallsFlowLayoutStyle = flowLayoutStyleIn(section)
            
            // 在居中对齐的时候需要知道这行所有cell的宽度总和
            var cellTotalWidth: CGFloat = 0.0
            var previousAttr: UICollectionViewLayoutAttributes? = nil
            var layoutAttributes_t : [UICollectionViewLayoutAttributes] = [UICollectionViewLayoutAttributes]()
            var cellAddHeight: CGFloat = 0
            for item in 0..<itemCount {
                
                let itemAttributes = layoutAttributesForItem(at: IndexPath(item: item, section: section))
                
                if flowLayoutStyle == .heightEqualWidthIsNotEqual {
                    
                    if let currentAttr = itemAttributes {
                        
                        let nextAttr = (item + 1) == itemCount ?
                        nil : layoutAttributesForItem(at: IndexPath(item: item + 1, section: section))
                        
                        layoutAttributes_t.append(currentAttr)
                        cellTotalWidth += currentAttr.frame.size.width
                        
                        let previousY :CGFloat = previousAttr == nil ? 0 : previousAttr!.frame.maxY
                        let currentY :CGFloat = currentAttr.frame.maxY
                        let nextY:CGFloat = nextAttr == nil ? 0 : nextAttr!.frame.maxY
                        
                        if currentY != previousY && currentY != nextY {
                            // 如果当前cell是单独一行
                            if ((currentAttr.representedElementKind == UICollectionView.elementKindSectionHeader) || (currentAttr.representedElementKind == UICollectionView.elementKindSectionFooter)) {
                                layoutAttributes_t.removeAll()
                                cellTotalWidth = 0.0
                            }else{
                                updateCellAttributes(layoutAttributes: layoutAttributes_t, indexPath: IndexPath(item: item, section: section), cellTotalWidth: cellTotalWidth, cellAddHeight: &cellAddHeight)
                                layoutAttributes_t.removeAll()
                                cellTotalWidth = 0.0
                            }
                        }else if currentY != nextY {
                            // 如果下一个cell在本行，这开始调整frame位置
                            updateCellAttributes(layoutAttributes: layoutAttributes_t, indexPath: IndexPath(item: item, section: section), cellTotalWidth: cellTotalWidth, cellAddHeight: &cellAddHeight)
                            layoutAttributes_t.removeAll()
                            cellTotalWidth = 0.0
                        }
                        
                        // 从新计算下一个cell的原点
                        var nextlayoutAttributesFrame: CGRect = nextAttr?.frame ?? .zero
                        nextlayoutAttributesFrame.origin.y = nextlayoutAttributesFrame.origin.y + cellAddHeight
                        nextAttr?.frame = nextlayoutAttributesFrame
                        
                        previousAttr = currentAttr
                    }
                }
                // 获取indexPath位置cell对应的布局属性
                if itemAttributes != nil {
                    attributesArray.append(itemAttributes!)
                }
            }
            
            // 获取每一组头视图header的UICollectionViewLayoutAttributes
            let headerAttributes = layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, at: IndexPath(item: 0, section: section))
            if headerAttributes != nil {
                attributesArray.append(headerAttributes!)
                columnWidths.removeAll()
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
        
        let flowLayoutStyle: WYWaterfallsFlowLayoutStyle = flowLayoutStyleIn(indexPath.section)
        
        switch flowLayoutStyle {
        case .widthAndHeightEqual:
            return attributesWithWidthAndHeightEqual(indexPath: indexPath)
            break
        case .widthEqualHeightIsNotEqual:
            return attributesWithWidthEqualHeightIsNotEqual(indexPath: indexPath)
            break
        case .heightEqualWidthIsNotEqual:
            return attributesWithHeightEqualWidthIsNotEqual(indexPath: indexPath)
            break
        }
    }
    
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: elementKind, with: indexPath)
        
        let sectionInsets: UIEdgeInsets = insetForSectionAt(indexPath.section)
        
        let footerSize: CGSize = referenceSizeForFooterIn(indexPath.section)
        
        if elementKind == UICollectionView.elementKindSectionHeader {
            
            let headerSize: CGSize = referenceSizeForHeaderIn(indexPath.section)
            
            let sectionOffset: CGFloat = spacingBetweenHeaderAndLastPartitionFooter(indexPath.section)
            
            var headerOffset: CGFloat = 0.0
            
            let sectionHeaderHover: Bool = hoverForHeaderIn(indexPath.section)
            
            if sectionHeaderHover == true {
                // 悬浮方案
                let contentOffsety: CGFloat = collectionView?.contentOffset.y ?? 0.0
                let minOffsety: CGFloat = max(sectionOffset + lastContentHeight, contentOffsety)
                let maxOffsety: CGFloat = max((columnHeights.max() ?? 0.0) - sectionInsets.bottom - footerSize.height - sectionOffset, sectionOffset)
                headerOffset = min(minOffsety, maxOffsety)
                
                // 设置headerView在最上层
                let headerView: UICollectionReusableView? = collectionView?.supplementaryView(forElementKind: UICollectionView.elementKindSectionHeader, at: indexPath)
                if headerView != nil {
                    collectionView?.bringSubviewToFront(headerView!)
                }
                
            }else {
                
                // 不悬浮方案
                headerOffset = sectionOffset + lastContentHeight
            }
            attributes.frame = CGRect(x: 0, y: headerOffset, width: headerSize.width, height: headerSize.height)
            
            let itemCount: NSInteger = collectionView?.numberOfItems(inSection: indexPath.section) ?? 0
            if itemCount == 0 {
                contentSize.height = attributes.frame.maxY
            }
            
        } else if elementKind == UICollectionView.elementKindSectionFooter {
            
            contentSize.height += sectionInsets.bottom
            
            attributes.frame = CGRect(x: 0, y: contentSize.height, width: footerSize.width, height: footerSize.height)
            
            contentSize.height += footerSize.height
        }
        return attributes
    }
    
    override var collectionViewContentSize: CGSize {
        if scrollDirection == .vertical {
            return CGSize(width: collectionView?.frame.size.width ?? 0, height: contentSize.height)
        }else {
            return CGSize(width: contentSize.width, height: collectionView?.frame.size.height ?? 0)
        }
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        
        let visibleSections: [IndexPath]? = collectionView?.indexPathsForVisibleSupplementaryElements(ofKind: UICollectionView.elementKindSectionHeader)
        
        if visibleSections?.isEmpty == false {
            let firstVisibleSection: NSInteger = (visibleSections?.first?.section == 0) ? 0 : (visibleSections?.last!.section)!
            return hoverForHeaderIn(firstVisibleSection)
            
        }else {
            return false
        }
    }
}

extension WYCollectionViewFlowLayout {
    
    private func attributesWithWidthAndHeightEqual(indexPath: IndexPath) -> UICollectionViewLayoutAttributes {
        return attributesWithWidthEqualHeightIsNotEqual(indexPath: indexPath)
    }
    
    private func attributesWithWidthEqualHeightIsNotEqual(indexPath: IndexPath) -> UICollectionViewLayoutAttributes {
        
        // item.attributes
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        
        // itemSize
        let itemLayoutSize: CGSize = sizeForItemAt(indexPath)
        
        // section.Insets
        let sectionInsets: UIEdgeInsets = insetForSectionAt(indexPath.section)
        
        // 分区header与上个分区footer之间的间距
        let sectionOffset: CGFloat = spacingBetweenHeaderAndLastPartitionFooter(indexPath.section)
        
        // headerSize
        let headerSize: CGSize = referenceSizeForHeaderIn(indexPath.section)
        
        // headerOffset
        let headerOffset = sectionOffset + sectionInsets.top + headerSize.height
        
        if scrollDirection == .vertical {
            
            // 分区列数
            let numberOfColumns: NSInteger = numberOfColumnsIn(indexPath.section)
            
            // 布局宽度
            let collectionWidth: CGFloat = headerSize.width - sectionInsets.left - sectionInsets.right
            
            // 总的item宽度
            let totalItemWidth: CGFloat = CGFloat(numberOfColumns) * itemLayoutSize.width
            
            // 列间距
            var columnsSpacing: CGFloat = minimumInteritemSpacingForSectionAt(indexPath.section)
            if CGFloat(numberOfColumns) * (itemLayoutSize.width + columnsSpacing) > collectionWidth {
                columnsSpacing = (CGFloat(numberOfColumns - 1) > 0) ? ((collectionWidth - totalItemWidth) / CGFloat(numberOfColumns - 1)) : (collectionWidth - totalItemWidth)
            }
            
            // 行间距
            let lineSpacing: CGFloat = minimumLineSpacingForSectionAt(indexPath.section)
            
            // 最小的列高
            let minColumnHeight: CGFloat = columnHeights.min() ?? 0.0
            
            // 最小的列
            let minColumn: NSInteger = columnHeights.firstIndex(of: minColumnHeight) ?? 0
            
            // item的x值
            let itemOffsetx: CGFloat = sectionInsets.left + (CGFloat(minColumn) * (itemLayoutSize.width + columnsSpacing))
            
            // item的y值
            let itemOffsety: CGFloat = minColumnHeight + ((minColumnHeight != lastContentHeight) ? lineSpacing : 0) + ((indexPath.item < numberOfColumns) ? headerOffset : 0)
            
            attributes.frame = CGRect(x: itemOffsetx, y: itemOffsety, width: itemLayoutSize.width, height: itemLayoutSize.height)
            
            contentSize.height = (contentSize.height < minColumnHeight) ? minColumnHeight : contentSize.height
            
            if columnHeights.isEmpty == false {
                columnHeights[minColumn] = attributes.frame.maxY
            }
            
            contentSize.height = ((columnHeights.max() ?? 0.0) > contentSize.height) ? (columnHeights.max() ?? 0.0) : contentSize.height
            
        }else {
            // 分区行数
            let numberOfLines: NSInteger = numberOfLinesIn(indexPath.section)
            
            // 布局高度
            let collectionHeight: CGFloat = (collectionView?.frame.size.height ?? 0.0) - sectionInsets.top - sectionInsets.bottom
            
            // 布局宽度
            let collectionWidth: CGFloat = (collectionView?.frame.size.width ?? 0) - sectionInsets.left - sectionInsets.right
            
            // 总的item高度
            let totalItemHeight: CGFloat = CGFloat(numberOfLines) * itemLayoutSize.height
            
            // 行间距
            var lineSpacing: CGFloat = minimumLineSpacingForSectionAt(indexPath.section)
            if CGFloat(numberOfLines) * (itemLayoutSize.height + lineSpacing) > collectionHeight {
                lineSpacing = (CGFloat(numberOfLines - 1) > 0) ? ((collectionHeight - totalItemHeight) / CGFloat(numberOfLines - 1)) : (collectionHeight - totalItemHeight)
            }
            
            // 列间距
            var columnsSpacing: CGFloat = minimumInteritemSpacingForSectionAt(indexPath.section)
            
            // 计算每页可以显示几列
            var numberOfColumns: NSInteger = NSInteger(round(((collectionWidth + columnsSpacing) / (columnsSpacing + itemLayoutSize.width))))
            
            // 每页总的item宽度
            let totalItemWidth: CGFloat = CGFloat(numberOfColumns) * itemLayoutSize.width
            
            // 总页数
            let pageNumber: NSInteger = indexPath.item / (numberOfLines * numberOfColumns)
            
            // 最短的行宽
            var minLineWidth: CGFloat = columnWidths.min() ?? 0.0
            
            // 最短的行
            let minLine: NSInteger = columnWidths.firstIndex(of: minLineWidth) ?? 0
            
            // 最小的列高
            let minColumnHeight: CGFloat = columnHeights.min() ?? 0.0
            
            // item的x值
            var itemOffsetx: CGFloat = 0
            // item的y值
            var itemOffsety: CGFloat = 0
            
            // 每页可以显示多少个item
            let totalItemInPage: NSInteger = numberOfLines * numberOfColumns
            
            // 水平滚动时，分区的item排列方式是否需要调整为水平排列(系统默认为竖向排列)
            if horizontalScrollItemArrangementDirectionIn(indexPath.section) == true {
                
                if collectionView?.isPagingEnabled == false {
                    
                    // 总共有多少个item需要显示
                    let totalItem: NSInteger = collectionView?.numberOfItems(inSection: indexPath.section) ?? 0
                    
                    if totalItem > totalItemInPage {
                        numberOfColumns = NSInteger(ceil(CGFloat(totalItem) / CGFloat(numberOfLines)))
                    }
                }
                
                if (CGFloat(numberOfColumns) * (itemLayoutSize.width + columnsSpacing) > collectionWidth) {
                    if (collectionView?.isPagingEnabled == true) || (numberOfColumns <= 1) {
                        columnsSpacing = (CGFloat(numberOfColumns - 1) > 0) ? ((collectionWidth - totalItemWidth) / CGFloat(numberOfColumns - 1)) : (collectionWidth - totalItemWidth)
                    }
                }
                
                // 该页中item的序号
                let itemInPage: NSInteger = indexPath.item % (numberOfLines * numberOfColumns)
                
                // item的所在列
                let itemInColumns: NSInteger = itemInPage % numberOfColumns
                
                // item的所在行
                let itemInLines: NSInteger = itemInPage / numberOfColumns
                
                itemOffsetx = sectionInsets.left + (itemLayoutSize.width + columnsSpacing) * CGFloat(itemInColumns) + ((collectionView?.isPagingEnabled ?? false) ? CGFloat(pageNumber) : 0.0) * (collectionView?.frame.size.width ?? 0)
                
                itemOffsety = sectionInsets.top + (itemLayoutSize.height + lineSpacing) * CGFloat(itemInLines)
                
            }else {
                
                if (CGFloat(numberOfColumns) * (itemLayoutSize.width + columnsSpacing) > collectionWidth) {
                    if (collectionView?.isPagingEnabled == true) || (numberOfColumns <= 1) {
                        columnsSpacing = (CGFloat(numberOfColumns - 1) > 0) ? ((collectionWidth - totalItemWidth) / CGFloat(numberOfColumns - 1)) : (collectionWidth - totalItemWidth)
                    }
                }
                
                if collectionView?.isPagingEnabled == true {
                    
                    itemOffsetx = (((indexPath.item % totalItemInPage) < numberOfLines) ? sectionInsets.left : 0) + minLineWidth + (((indexPath.item % totalItemInPage) < numberOfLines) ? 0 : columnsSpacing) + ((((indexPath.item % totalItemInPage) < numberOfLines) && (minLineWidth > 0)) ? sectionInsets.right : 0)
                    
                }else {
                    itemOffsetx = ((minLineWidth == 0) ? sectionInsets.left : 0) + minLineWidth + ((minLineWidth == 0) ? 0 : columnsSpacing)
                }
                
                itemOffsety = sectionInsets.top + minColumnHeight + (CGFloat(minLine) * (itemLayoutSize.height + lineSpacing))
            }
            
            attributes.frame = CGRect(x: itemOffsetx, y: itemOffsety, width: itemLayoutSize.width, height: itemLayoutSize.height)
            
            if columnWidths.isEmpty == false {
                columnWidths[minLine] = attributes.frame.maxX
            }
            
            if ((indexPath.item + 1) == collectionView?.numberOfItems(inSection: indexPath.section) && (collectionView?.isPagingEnabled == true)) {
                
                // 总页数
                let lastPageNumber: NSInteger = NSInteger(ceil(CGFloat(indexPath.item + 1) / CGFloat((numberOfLines * numberOfColumns))))
                
                minLineWidth = CGFloat(lastPageNumber) * (collectionView?.frame.size.width ?? 0) - sectionInsets.right
            }
            
            contentSize.width = (contentSize.width < minLineWidth) ? minLineWidth : contentSize.width
            
            contentSize.width = ((columnWidths.max() ?? 0.0) > contentSize.width) ? (columnWidths.max() ?? 0.0) : contentSize.width
            
            if (indexPath.item + 1) == collectionView?.numberOfItems(inSection: indexPath.section) {
                contentSize.width += sectionInsets.right
            }
        }
        
        return attributes
    }
    
    private func attributesWithHeightEqualWidthIsNotEqual(indexPath: IndexPath) -> UICollectionViewLayoutAttributes {
        return UICollectionViewLayoutAttributes(forCellWith: indexPath)
    }
    
    // 调整属于同一行的cell的位置frame
    private func updateCellAttributes(layoutAttributes: [UICollectionViewLayoutAttributes], indexPath: IndexPath, cellTotalWidth: CGFloat, cellAddHeight: inout CGFloat) {
        var nowWidth : CGFloat = 0.0
        let layoutAlignment: WYFlowLayoutAlignment = flowLayoutAlignmentIn(indexPath.section)
        
        // section.Insets
        let sectionInsets: UIEdgeInsets = insetForSectionAt(indexPath.section)
        // headerSize
        let headerSize: CGSize = referenceSizeForHeaderIn(indexPath.section)
        let itemSpacing: CGFloat = minimumInteritemSpacingForSectionAt(indexPath.section)
        let flowLayoutMaxWidth: CGFloat = (headerSize.width - sectionInsets.left - sectionInsets.right)
        switch layoutAlignment {
        case .right:
            nowWidth = headerSize.width - sectionInsets.left - sectionInsets.right
            for var index in 0 ..< layoutAttributes.count {
                index = layoutAttributes.count - 1 - index
                let attributes = layoutAttributes[index]
                var nowFrame = attributes.frame
                nowFrame.origin.x = nowWidth - nowFrame.size.width
                attributes.frame = calculateWrapHeight(attributes: &nowFrame, flowLayoutMaxWidth: flowLayoutMaxWidth, indexPath: indexPath, cellAddHeight: &cellAddHeight)
                updateContentSize(attributes: attributes, indexPath: indexPath)
                nowWidth = nowWidth - nowFrame.size.width - itemSpacing
            }
            break
        default:
            nowWidth = (layoutAlignment == .left) ? (sectionInsets.left) : ((flowLayoutMaxWidth - cellTotalWidth - (CGFloat(layoutAttributes.count - 1) * itemSpacing)) / 2)
            for attributes in layoutAttributes {
                var nowFrame = attributes.frame
                nowFrame.origin.x = nowWidth
                attributes.frame = calculateWrapHeight(attributes: &nowFrame, flowLayoutMaxWidth: flowLayoutMaxWidth, indexPath: indexPath, cellAddHeight: &cellAddHeight)
                updateContentSize(attributes: attributes, indexPath: indexPath)
                nowWidth += nowFrame.size.width + itemSpacing
            }
            break
        }
    }
    
    /// 调整换行显示时的高度
    private func calculateWrapHeight(attributes: inout CGRect, flowLayoutMaxWidth: CGFloat, indexPath: IndexPath, cellAddHeight: inout CGFloat) -> CGRect {
        
        let itemNumberOfLines: NSInteger = itemNumberOfLines(indexPath.section)
        
        if attributes.size.width > flowLayoutMaxWidth {
            if itemNumberOfLines != 1 {
                
                let maxNumberOfLines: NSInteger = NSInteger(ceil(Double(attributes.size.width) / Double(flowLayoutMaxWidth)))
                
                let numberOfLines: NSInteger = (itemNumberOfLines == 0) ? maxNumberOfLines : ((maxNumberOfLines > itemNumberOfLines) ? itemNumberOfLines : maxNumberOfLines)
                
                let addHeight: CGFloat = (minimumLineSpacingForSectionAt(indexPath.section) * CGFloat(numberOfLines - 1))
                
                cellAddHeight = cellAddHeight + addHeight
            }
            attributes.size.width = flowLayoutMaxWidth
        }
        return attributes
    }
    
    private func updateContentSize(attributes: UICollectionViewLayoutAttributes, indexPath: IndexPath) {
        
        if scrollDirection == .vertical {
            
            // 最小的列高
            let minColumnHeight: CGFloat = columnHeights.min() ?? 0.0
            
            // 最小的列
            let minColumn: NSInteger = columnHeights.firstIndex(of: minColumnHeight) ?? 0
            
            contentSize.height = (contentSize.height < minColumnHeight) ? minColumnHeight : contentSize.height
            
            if columnHeights.isEmpty == false {
                columnHeights[minColumn] = attributes.frame.maxY
            }
            
            contentSize.height = ((columnHeights.max() ?? 0.0) > contentSize.height) ? (columnHeights.max() ?? 0.0) : contentSize.height
            
        }else {
            
            // 分区行数
            let numberOfLines: NSInteger = numberOfLinesIn(indexPath.section)
            
            // 行间距
            let lineSpacing: CGFloat = minimumLineSpacingForSectionAt(indexPath.section)
            
            // 最短的行宽
            let minLineWidth: CGFloat = columnWidths.min() ?? 0.0
            
            // 分区header与上个分区footer之间的间距
            let sectionOffset: CGFloat = spacingBetweenHeaderAndLastPartitionFooter(indexPath.section)
            
            // section.Insets
            let sectionInsets: UIEdgeInsets = insetForSectionAt(indexPath.section)
            
            // headerSize
            let headerSize: CGSize = referenceSizeForHeaderIn(indexPath.section)
            
            // headerOffset
            let headerOffset = sectionOffset + sectionInsets.top + headerSize.height
            
            // 最短的行
            let minLine: NSInteger = columnWidths.firstIndex(of: minLineWidth) ?? 0
            
            // item的y值
            var itemOffsety: CGFloat = minLineWidth + ((minLineWidth != lastContentWidth) ? lineSpacing : 0) + ((indexPath.item < numberOfLines) ? headerOffset : 0)
            
            // 水平滚动时，分区的item排列方式是否需要调整为水平排列(系统默认为竖向排列)
            if horizontalScrollItemArrangementDirectionIn(indexPath.section) == true {
                if indexPath.item % (indexPath.item * numberOfLines) < numberOfLines {
                    itemOffsety += lineSpacing
                }else {
                    itemOffsety -= lineSpacing
                }
            }
            
            contentSize.width = (contentSize.width < minLineWidth) ? minLineWidth : contentSize.width
            
            if columnWidths.isEmpty == false {
                columnWidths[minLine] = attributes.frame.maxX
            }
            
            contentSize.width = ((columnWidths.max() ?? 0.0) > contentSize.width) ? (columnWidths.max() ?? 0.0) : contentSize.width
        }
    }
    
    private func itemOffset(alignment: WYFlowLayoutAlignment, sectionInsets: UIEdgeInsets) -> CGPoint {
        return .zero
    }
    
    private func sizeForItemAt(_ indexPath: IndexPath) -> CGSize {
        guard let collectionView = collectionView else { return itemSize }
        return delegate?.wy_collectionView?(collectionView, layout: self, sizeForItemAt: indexPath) ?? itemSize
    }
    
    private func referenceSizeForHeaderIn(_ section: NSInteger) -> CGSize {
        
        if scrollDirection == .vertical {
            
            guard let collectionView = collectionView else { return headerReferenceSize }
            return delegate?.wy_collectionView?(collectionView, layout: self, referenceSizeForHeaderInSection: section) ?? ((headerReferenceSize == .zero) ? CGSize(width: collectionView.frame.size.width, height: 0) : headerReferenceSize)
            
        }else {
            
            guard let collectionView = collectionView else { return headerReferenceSize }
            return delegate?.wy_collectionView?(collectionView, layout: self, referenceSizeForHeaderInSection: section) ?? ((headerReferenceSize == .zero) ? CGSize(width: 0, height: collectionView.frame.size.height) : headerReferenceSize)
        }
    }
    
    private func referenceSizeForFooterIn(_ section: NSInteger) -> CGSize {
        
        if scrollDirection == .vertical {
            
            guard let collectionView = collectionView else { return footerReferenceSize }
            return delegate?.wy_collectionView?(collectionView, layout: self, referenceSizeForFooterInSection: section) ?? ((footerReferenceSize == .zero) ? CGSize(width: collectionView.frame.size.width, height: 0) : footerReferenceSize)
            
        }else {
            guard let collectionView = collectionView else { return footerReferenceSize }
            return delegate?.wy_collectionView?(collectionView, layout: self, referenceSizeForFooterInSection: section) ?? ((footerReferenceSize == .zero) ? CGSize(width: 0, height: collectionView.frame.size.height) : footerReferenceSize)
        }
    }
    
    private func numberOfLinesIn(_ section: NSInteger) -> NSInteger {
        guard let collectionView = collectionView else { return 1 }
        return delegate?.wy_collectionView?(collectionView, layout: self, numberOfLinesIn: section) ?? 1
    }
    
    private func numberOfColumnsIn(_ section: NSInteger) -> NSInteger {
        guard let collectionView = collectionView else { return 1 }
        return delegate?.wy_collectionView?(collectionView, layout: self, numberOfColumnsIn: section) ?? 1
    }
    
    private func insetForSectionAt(_ section: NSInteger) -> UIEdgeInsets {
        guard let collectionView = collectionView else { return sectionInset }
        return delegate?.wy_collectionView?(collectionView, layout: self, insetForSectionAt: section) ?? sectionInset
    }
    
    private func minimumInteritemSpacingForSectionAt(_ section: NSInteger) -> CGFloat {
        guard let collectionView = collectionView else { return minimumInteritemSpacing }
        return delegate?.wy_collectionView?(collectionView, layout: self, minimumInteritemSpacingForSectionAt: section) ?? minimumInteritemSpacing
    }
    
    private func minimumLineSpacingForSectionAt(_ section: NSInteger) -> CGFloat {
        guard let collectionView = collectionView else { return minimumLineSpacing }
        return delegate?.wy_collectionView?(collectionView, layout: self, minimumLineSpacingForSectionAt: section) ?? minimumLineSpacing
    }
    
    private func spacingBetweenHeaderAndLastPartitionFooter(_ section: NSInteger) -> CGFloat {
        guard let collectionView = collectionView else { return 0.0 }
        return delegate?.wy_collectionView?(collectionView, layout: self, spacingBetweenHeaderAndLastPartitionFooter: section) ?? 0.0
    }
    
    private func flowLayoutStyleIn(_ section: NSInteger) -> WYWaterfallsFlowLayoutStyle {
        guard let collectionView = collectionView else { return .widthAndHeightEqual }
        return delegate?.wy_collectionView?(collectionView, layout: self, flowLayoutStyleForSectionAt: section) ?? .widthAndHeightEqual
    }
    
    private func flowLayoutAlignmentIn(_ section: NSInteger) -> WYFlowLayoutAlignment {
        guard let collectionView = collectionView else { return .center }
        return delegate?.wy_collectionView?(collectionView, layout: self, flowLayoutAlignmentForSectionAt: section) ?? .center
    }
    
    private func itemNumberOfLines(_ section: NSInteger) -> NSInteger {
        guard let collectionView = collectionView else { return 0 }
        return delegate?.wy_collectionView?(collectionView, layout: self, itemNumberOfLinesForSectionAt: section) ?? 0
    }
    
    private func horizontalScrollItemArrangementDirectionIn(_ section: NSInteger) -> Bool {
        guard let collectionView = collectionView else { return false }
        return delegate?.wy_collectionView?(collectionView, layout: self, horizontalScrollItemArrangementDirectionForSectionAt: section) ?? false
    }
    
    private func hoverForHeaderIn(_ section: NSInteger) -> Bool {
        guard let collectionView = collectionView else { return false }
        return delegate?.wy_collectionView?(collectionView, layout: self, hoverForHeaderForSectionAt: section) ?? false
    }
    
    /** 存放所有cell的布局属性 */
    private var attributesArray: [UICollectionViewLayoutAttributes] {
        set(newValue) {
            objc_setAssociatedObject(self, WYAssociatedKeys.wy_attributesArray, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, WYAssociatedKeys.wy_attributesArray) as? [UICollectionViewLayoutAttributes] ?? []
        }
    }
    
    /** 存放每个section中各个行的最后一个宽度 */
    private var columnWidths: [CGFloat] {
        set(newValue) {
            objc_setAssociatedObject(self, WYAssociatedKeys.wy_columnWidths, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, WYAssociatedKeys.wy_columnWidths) as? [CGFloat] ?? []
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
    
    /** 内容的宽高 */
    private var contentSize: CGSize {
        set(newValue) {
            objc_setAssociatedObject(self, WYAssociatedKeys.wy_contentSize, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, WYAssociatedKeys.wy_contentSize) as? CGSize ?? .zero
        }
    }
    
    /** 记录上个section宽度最宽一列的宽度 */
    private var lastContentWidth: CGFloat {
        set(newValue) {
            objc_setAssociatedObject(self, WYAssociatedKeys.wy_lastContentWidth, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, WYAssociatedKeys.wy_lastContentWidth) as? CGFloat ?? 0.0
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
        
        static let wy_attributesArray = UnsafeRawPointer(bitPattern: "wy_attributesArray".hashValue)!
        static let wy_columnWidths = UnsafeRawPointer(bitPattern: "wy_columnWidths".hashValue)!
        static let wy_columnHeights = UnsafeRawPointer(bitPattern: "wy_columnHeights".hashValue)!
        static let wy_contentSize = UnsafeRawPointer(bitPattern: "wy_contentSize".hashValue)!
        static let wy_lastContentWidth = UnsafeRawPointer(bitPattern: "wy_lastContentWidth".hashValue)!
        static let wy_lastContentHeight = UnsafeRawPointer(bitPattern: "wy_lastContentHeight".hashValue)!
    }
}
