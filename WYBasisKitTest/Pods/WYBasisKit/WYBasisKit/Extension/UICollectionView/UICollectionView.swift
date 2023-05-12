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
    
    /** 宽、高均相等(支持横向和竖向瀑布流) */
    case widthAndHeightEqual = 0
    
    /** 等宽不等高(仅支持竖向瀑布流) */
    case widthEqualHeightIsNotEqual = 1
    
    /** 等高不等宽(仅支持横向瀑布流) */
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
            for item in 0..<itemCount {
                
                let itemAttributes = layoutAttributesForItem(at: IndexPath(item: item, section: section))
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
        return attributesAt(indexPath: indexPath)
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
                let contentOffsetx: CGFloat = collectionView?.contentOffset.x ?? 0.0
                let contentOffsety: CGFloat = collectionView?.contentOffset.y ?? 0.0
                
                let minOffsetx: CGFloat = max(sectionOffset + lastContentWidth, contentOffsetx)
                let minOffsety: CGFloat = max(sectionOffset + lastContentHeight, contentOffsety)
                
                let maxOffsetx: CGFloat = max((columnWidths.max() ?? 0.0) - sectionInsets.right - footerSize.width - sectionOffset, sectionOffset)
                let maxOffsety: CGFloat = max((columnHeights.max() ?? 0.0) - sectionInsets.bottom - footerSize.height - sectionOffset, sectionOffset)
                
                if scrollDirection == .vertical {
                    headerOffset = min(minOffsety, maxOffsety)
                }else {
                    headerOffset = min(minOffsetx, maxOffsetx)
                }
                
                // 设置headerView在最上层
                let headerView: UICollectionReusableView? = collectionView?.supplementaryView(forElementKind: UICollectionView.elementKindSectionHeader, at: indexPath)
                if headerView != nil {
                    collectionView?.bringSubviewToFront(headerView!)
                }
                
            }else {
                
                // 不悬浮方案
                headerOffset = (scrollDirection == .vertical) ? (sectionOffset + lastContentHeight) : (sectionOffset + lastContentWidth)
            }
            attributes.frame = CGRect(x: headerOffset, y: headerOffset, width: headerSize.width, height: headerSize.height)
            
            let itemCount: NSInteger = collectionView?.numberOfItems(inSection: indexPath.section) ?? 0
            if itemCount == 0 {
                contentSize.height = attributes.frame.maxY
            }
            
        } else if elementKind == UICollectionView.elementKindSectionFooter {
            
            contentSize.height += sectionInsets.bottom
            
            attributes.frame = CGRect(x: contentSize.width, y: contentSize.height, width: footerSize.width, height: footerSize.height)
            
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
    
    private func attributesAt(indexPath: IndexPath) -> UICollectionViewLayoutAttributes {
        
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
            
            let adjustColumns: NSInteger = (collectionView?.numberOfItems(inSection: indexPath.section) ?? 0) < numberOfColumns ? (collectionView?.numberOfItems(inSection: indexPath.section) ?? 0) : numberOfColumns
            
            // 总的item宽度
            let totalItemWidth: CGFloat = CGFloat(adjustColumns) * itemLayoutSize.width
            
            // 列间距
            var columnsSpacing: CGFloat = minimumInteritemSpacingForSectionAt(indexPath.section)
            if (CGFloat(adjustColumns) * (itemLayoutSize.width + columnsSpacing)) > (collectionWidth + columnsSpacing) {
                columnsSpacing = (CGFloat(adjustColumns - 1) > 0) ? ((collectionWidth - totalItemWidth) / CGFloat(adjustColumns - 1)) : (collectionWidth - totalItemWidth)
            }
            
            // 行间距
            var lineSpacing: CGFloat = minimumLineSpacingForSectionAt(indexPath.section)
            
            // 最小的列高
            var minColumnHeight: CGFloat = columnHeights.min() ?? 0.0
            
            // 最小的列
            let minColumn: NSInteger = columnHeights.firstIndex(of: minColumnHeight) ?? 0
            
            // item的x值
            var itemOffsetx: CGFloat = sectionInsets.left + (CGFloat(minColumn) * (itemLayoutSize.width + columnsSpacing))
            
            // item的y值
            var itemOffsety: CGFloat = 0
            
            // 计算每页可以显示几行
            var numberOfLines: NSInteger = 0
            
            if collectionView?.isPagingEnabled == true {
                
                // 布局高度
                let collectionHeight: CGFloat = (collectionView?.frame.size.height ?? 0) - sectionInsets.top - sectionInsets.bottom
                
                numberOfLines = NSInteger(round(((collectionHeight + lineSpacing) / (lineSpacing + itemLayoutSize.height))))
                if numberOfLines <= 0 {
                    numberOfLines = 1
                }
                
                // 总页数
                let pageNumber: NSInteger = indexPath.item / (numberOfLines * numberOfColumns)
                
                // 每页总的item高度
                let totalItemHeight: CGFloat = CGFloat(numberOfLines) * itemLayoutSize.height
                
                if (CGFloat(numberOfLines) * (itemLayoutSize.height + lineSpacing) != (collectionHeight + lineSpacing)) {
                    
                    lineSpacing = (CGFloat(numberOfLines - 1) > 0) ? ((collectionHeight - totalItemHeight) / CGFloat(numberOfLines - 1)) : (collectionHeight - totalItemHeight)
                }
                
                // 该页中item的序号
                let itemInPage: NSInteger = indexPath.item % (numberOfLines * numberOfColumns)
                
                // item的所在列
                let itemInColumns: NSInteger = itemInPage % numberOfColumns

                // item的所在行
                let itemInLines: NSInteger = itemInPage / numberOfColumns
                
                itemOffsetx = sectionInsets.left + ((itemLayoutSize.width + columnsSpacing)) * CGFloat(itemInColumns)
                
                itemOffsety = (sectionInsets.top + ((itemLayoutSize.height + lineSpacing) * CGFloat(itemInLines)) + CGFloat(pageNumber) * (collectionView?.frame.size.height ?? 0)) + lastContentHeight
                
            }else {
                
                itemOffsety = minColumnHeight + ((minColumnHeight != lastContentHeight) ? lineSpacing : 0) + ((indexPath.item < numberOfColumns) ? headerOffset : 0)
            }
            
            attributes.frame = CGRect(x: itemOffsetx, y: itemOffsety, width: itemLayoutSize.width, height: itemLayoutSize.height)
            
            if ((indexPath.item + 1) == collectionView?.numberOfItems(inSection: indexPath.section) && (collectionView?.isPagingEnabled == true)) {
                
                // 总页数
                var lastPageNumber: NSInteger = NSInteger(ceil(CGFloat(indexPath.item + 1) / CGFloat((numberOfLines * numberOfColumns))))
                if lastPageNumber <= 0 {
                    lastPageNumber = 1
                }

                minColumnHeight = (CGFloat(lastPageNumber) * (collectionView?.frame.size.height ?? 0) - sectionInsets.bottom) + lastContentHeight
            }
            
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
            
            let adjustLines: NSInteger = (collectionView?.numberOfItems(inSection: indexPath.section) ?? 0) < numberOfLines ? (collectionView?.numberOfItems(inSection: indexPath.section) ?? 0) : numberOfLines
            
            // 总的item高度
            let totalItemHeight: CGFloat = CGFloat(adjustLines) * itemLayoutSize.height
            
            // 行间距
            var lineSpacing: CGFloat = minimumLineSpacingForSectionAt(indexPath.section)
            if CGFloat(adjustLines) * (itemLayoutSize.height + lineSpacing) > (collectionHeight + lineSpacing) {
                lineSpacing = (CGFloat(adjustLines - 1) > 0) ? ((collectionHeight - totalItemHeight) / CGFloat(adjustLines - 1)) : (collectionHeight - totalItemHeight)
            }
            
            // 列间距
            var columnsSpacing: CGFloat = minimumInteritemSpacingForSectionAt(indexPath.section)
            
            // 计算每页可以显示几列
            var numberOfColumns: NSInteger = NSInteger(round(((collectionWidth + columnsSpacing) / (columnsSpacing + itemLayoutSize.width))))
            if numberOfColumns <= 0 {
                numberOfColumns = 1
            }
            
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
            
            // item的所在行
            var itemInLines: NSInteger = 0
            
            // 水平滚动时，分区的item排列方式是否需要调整为水平排列(系统默认为竖向排列)
            if horizontalScrollItemArrangementDirectionIn(indexPath.section) == true {
                
                if collectionView?.isPagingEnabled == false {
                    
                    // 总共有多少个item需要显示
                    let totalItem: NSInteger = collectionView?.numberOfItems(inSection: indexPath.section) ?? 0
                    
                    if totalItem > totalItemInPage {
                        numberOfColumns = NSInteger(ceil(CGFloat(totalItem) / CGFloat(numberOfLines)))
                    }
                }
                
                if (collectionView?.isPagingEnabled == true) || (numberOfColumns <= 1) {
                    
                    if (CGFloat(numberOfColumns) * (itemLayoutSize.width + columnsSpacing) != (collectionWidth + columnsSpacing)) {
                        columnsSpacing = (CGFloat(numberOfColumns - 1) > 0) ? ((collectionWidth - totalItemWidth) / CGFloat(numberOfColumns - 1)) : (collectionWidth - totalItemWidth)
                    }
                }
                
                // 该页中item的序号
                let itemInPage: NSInteger = indexPath.item % (numberOfLines * numberOfColumns)
                
                // item的所在列
                let itemInColumns: NSInteger = itemInPage % numberOfColumns
                
                itemInLines = itemInPage / numberOfColumns
                
                itemOffsetx = (((columnWidths[itemInLines] == 0) ? sectionInsets.left : 0) + columnWidths[itemInLines] + ((columnWidths[itemInLines] == 0) ? 0 : columnsSpacing) + ((collectionView?.isPagingEnabled ?? false) ? CGFloat(pageNumber) : 0.0) * (collectionView?.frame.size.width ?? 0))
                
                itemOffsety = sectionInsets.top + (itemLayoutSize.height + lineSpacing) * CGFloat(itemInLines)
                
            }else {
                
                if (collectionView?.isPagingEnabled == true) || (numberOfColumns <= 1) {
                    if (CGFloat(numberOfColumns) * (itemLayoutSize.width + columnsSpacing) != (collectionWidth + columnsSpacing)) {
                        columnsSpacing = (CGFloat(numberOfColumns - 1) > 0) ? ((collectionWidth - totalItemWidth) / CGFloat(numberOfColumns - 1)) : (collectionWidth - totalItemWidth)
                    }
                }
                
                if collectionView?.isPagingEnabled == true {
                    
                    itemOffsetx = (((indexPath.item % totalItemInPage) < numberOfLines) ? sectionInsets.left : 0) + minLineWidth + (((indexPath.item % totalItemInPage) < numberOfLines) ? 0 : columnsSpacing) + ((((indexPath.item % totalItemInPage) < numberOfLines) && (minLineWidth > 0)) ? sectionInsets.right : 0) - ((indexPath.section == 0) ? 0 : (((indexPath.item % totalItemInPage) < numberOfLines) && (indexPath.item < numberOfLines)) ? sectionInsets.right : 0)
                }else {
                    itemOffsetx = ((minLineWidth == 0) ? sectionInsets.left : 0) + minLineWidth + ((minLineWidth == 0) ? 0 : columnsSpacing)
                }
                
                itemOffsety = sectionInsets.top + (CGFloat(minLine) * (itemLayoutSize.height + lineSpacing))
            }
            
            attributes.frame = CGRect(x: itemOffsetx, y: itemOffsety, width: itemLayoutSize.width, height: itemLayoutSize.height)
            
            if columnWidths.isEmpty == false {
                if horizontalScrollItemArrangementDirectionIn(indexPath.section) == true {
                    columnWidths[itemInLines] = attributes.frame.maxX
                }else {
                    columnWidths[minLine] = attributes.frame.maxX
                }
            }
            
            if ((indexPath.item + 1) == collectionView?.numberOfItems(inSection: indexPath.section) && (collectionView?.isPagingEnabled == true)) {
                
                // 总页数
                var lastPageNumber: NSInteger = NSInteger(ceil(CGFloat(indexPath.item + 1) / CGFloat((numberOfLines * numberOfColumns))))
                if lastPageNumber <= 0 {
                    lastPageNumber = 1
                }

                minLineWidth = (CGFloat(lastPageNumber) * (collectionView?.frame.size.width ?? 0) - sectionInsets.right) + lastContentWidth
            }
            
            contentSize.width = (contentSize.width < minLineWidth) ? minLineWidth : contentSize.width
            
            contentSize.width = ((columnWidths.max() ?? 0.0) > contentSize.width) ? (columnWidths.max() ?? 0.0) : contentSize.width
            
            if (indexPath.item + 1) == collectionView?.numberOfItems(inSection: indexPath.section) {
                contentSize.width += sectionInsets.right
            }
        }
        return attributes
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
