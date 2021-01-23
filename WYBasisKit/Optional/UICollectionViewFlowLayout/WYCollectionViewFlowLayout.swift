//
//  WYCollectionAlignmentFlowLayout.swift
//  WYBasisKit
//
//  Created by jacke·xu on 2021/1/14.
//  Copyright © 2021 jacke·xu. All rights reserved.
//

import UIKit

/// UICollectionFlowLayoutAlignment
enum WYFlowLayoutAlignment {
    
    /// 左对齐
    case left
    
    /// 居中对齐
    case center
    
    /// 右对齐
    case right
}

class WYCollectionAlignmentFlowLayout: UICollectionViewFlowLayout {

    /// cell对齐方式
    var wy_layoutAlignment: WYFlowLayoutAlignment = .center
    
    /// 在居中对齐的时候需要知道这行所有cell的宽度总和
    private(set) var wy_cellTotalWidth: CGFloat = 0.0
    
    convenience init(_ layoutAlignment: WYFlowLayoutAlignment){
        self.init()
        wy_layoutAlignment = layoutAlignment
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        let layoutAttributes_super : [UICollectionViewLayoutAttributes] = super.layoutAttributesForElements(in: rect) ?? [UICollectionViewLayoutAttributes]()
        let layoutAttributes:[UICollectionViewLayoutAttributes] = NSArray(array: layoutAttributes_super, copyItems:true)as! [UICollectionViewLayoutAttributes]
        var layoutAttributes_t : [UICollectionViewLayoutAttributes] = [UICollectionViewLayoutAttributes]()
        for index in 0..<layoutAttributes.count {
            
            let currentAttr = layoutAttributes[index]
            let previousAttr = index == 0 ? nil : layoutAttributes[index-1]
            let nextAttr = index + 1 == layoutAttributes.count ?
                nil : layoutAttributes[index+1]
            
            layoutAttributes_t.append(currentAttr)
            wy_cellTotalWidth += currentAttr.frame.size.width
            
            let previousY :CGFloat = previousAttr == nil ? 0 : previousAttr!.frame.maxY
            let currentY :CGFloat = currentAttr.frame.maxY
            let nextY:CGFloat = nextAttr == nil ? 0 : nextAttr!.frame.maxY
            
            if currentY != previousY && currentY != nextY {
                if ((currentAttr.representedElementKind == UICollectionView.elementKindSectionHeader) || (currentAttr.representedElementKind == UICollectionView.elementKindSectionFooter)) {
                    layoutAttributes_t.removeAll()
                    wy_cellTotalWidth = 0.0
                }else{
                    updateCellAttributes(layoutAttributes: layoutAttributes_t)
                    layoutAttributes_t.removeAll()
                    wy_cellTotalWidth = 0.0
                }
            }else if currentY != nextY {
                updateCellAttributes(layoutAttributes: layoutAttributes_t)
                layoutAttributes_t.removeAll()
                wy_cellTotalWidth = 0.0
            }
        }
        return layoutAttributes
    }
    
    // 调整属于同一行的cell的位置frame
    private func updateCellAttributes(layoutAttributes: [UICollectionViewLayoutAttributes]) {
        var nowWidth : CGFloat = 0.0
        switch wy_layoutAlignment {
        case .right:
            nowWidth = (collectionView?.frame.size.width ?? 0) - sectionInset.right
            for var index in 0 ..< layoutAttributes.count {
                index = layoutAttributes.count - 1 - index
                let attributes = layoutAttributes[index]
                var nowFrame = attributes.frame
                nowFrame.origin.x = nowWidth - nowFrame.size.width
                attributes.frame = nowFrame
                nowWidth = nowWidth - nowFrame.size.width - minimumInteritemSpacing
            }
            break
        default:
            nowWidth = (wy_layoutAlignment == .left) ? (sectionInset.left) : (((collectionView?.frame.size.width ?? 0) - wy_cellTotalWidth - (CGFloat(layoutAttributes.count - 1) * minimumInteritemSpacing)) / 2)
            for attributes in layoutAttributes {
                var nowFrame = attributes.frame
                nowFrame.origin.x = nowWidth
                attributes.frame = nowFrame
                nowWidth += nowFrame.size.width + minimumInteritemSpacing
            }
            break
        }
    }
}
