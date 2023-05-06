//
//  WYHorizontalFlowLayout.swift
//  WYBasisKit
//
//  Created by Miraitowa on 2023/4/28.
//

import UIKit

public class WYHorizontalFlowLayout: UICollectionViewFlowLayout {
    
    /// 行个数
    private var row: NSInteger = 0
    /// 列个数
    private var column: NSInteger = 0
    /// item 数组
    private lazy var allAttrs = [UICollectionViewLayoutAttributes]()
    
    /// 设置分页大小
    override public var collectionViewContentSize: CGSize {
        return CGSize(width: viewSize.width * CGFloat(ceil(Double(allAttrs.count) / Double(row * column))),
                      height: viewSize.height)
    }
    /// CollectionView Size
    private var viewSize: CGSize {
        return collectionView?.frame.size ?? .zero
    }

    // 唯一初始化方法
    public init(row: NSInteger, column: NSInteger) {
        super.init()
        self.row = row
        self.column = column
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: - 布局 Items
    override public func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView else { return }

        itemSize = CGSize(width: collectionView.frame.width / CGFloat(column),
                          height: collectionView.frame.height / CGFloat(row))
 
        (0..<collectionView.numberOfItems(inSection: 0)).forEach { (i) in
            let curpage = CGFloat(i / (column * row)) * collectionView.frame.width
            let itemX = itemSize.width * CGFloat(i % column) + curpage
            var itemY = itemSize.height * CGFloat(i / column % row)
            if i % (row * column) < column {
                itemY += 3
            }else {
                itemY -= 3
            }
            let attrs = layoutAttributesForItem(at: IndexPath(item: i, section: 0))!
            attrs.frame = CGRect(x: itemX, y: itemY, width: itemSize.width, height: itemSize.height)
            allAttrs.append(attrs)
        }
    }

    override public func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return allAttrs.filter { rect.contains($0.frame) }
    }
}
