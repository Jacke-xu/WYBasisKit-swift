//
//  WYAlignmentFlowLayout.swift
//  WYBasisKit
//
//  Created by 官人 on 2021/1/14.
//  Copyright © 2021 官人. All rights reserved.
//

import UIKit

/// 瀑布流对齐方式
public enum WYFlowLayoutAlignment {
    
    /// 左对齐
    case left
    
    /// 居中对齐
    case center
    
    /// 右对齐
    case right
}

@objc public protocol WYAlignmentFlowLayoutDelegate {
    
    /** cell换行事件 */
    @objc optional func alignmentFlowLayout(_ flowLayout: WYAlignmentFlowLayout, numberOfLines: Int)
}

public class WYAlignmentFlowLayout: UICollectionViewFlowLayout {
    
    /// cell对齐方式
    public var wy_layoutAlignment: WYFlowLayoutAlignment = .center
    
    /** delegate */
    public weak var delegate: WYAlignmentFlowLayoutDelegate?
    
    /// 最大能显示的宽度，默认屏幕宽度
    public var flowLayoutMaxWidth: CGFloat = UIScreen.main.bounds.size.width
    
    /// 换行显示，即当控件所需宽度超过 flowLayoutMaxWidth 时，最多能显示几行, 默认只显示一行, 传入0时表示无限换行
    public var flowLayoutNumberOfLines: NSInteger = 1;
    
    /// 每换一行新增的高度， 默认0
    public var flowLayoutWrapHeight: CGFloat = 0
    
    /// 在居中对齐的时候需要知道这行所有cell的宽度总和
    private var wy_cellTotalWidth: CGFloat = 0.0
    
    /// 记录换行新增的高度
    private var wy_cellAddHeight: CGFloat = 0.0
    
    public convenience init(_ layoutAlignment: WYFlowLayoutAlignment, delegate: WYAlignmentFlowLayoutDelegate? = nil){
        self.init()
        wy_layoutAlignment = layoutAlignment
        self.delegate = delegate
    }
    
    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        let layoutAttributes_super : [UICollectionViewLayoutAttributes] = super.layoutAttributesForElements(in: rect) ?? [UICollectionViewLayoutAttributes]()
        let layoutAttributes:[UICollectionViewLayoutAttributes] = NSArray(array: layoutAttributes_super, copyItems:true)as! [UICollectionViewLayoutAttributes]
        var layoutAttributes_t : [UICollectionViewLayoutAttributes] = [UICollectionViewLayoutAttributes]()
        var numberOfLines: Int = 0
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
                // 如果当前cell是单独一行
                if ((currentAttr.representedElementKind == UICollectionView.elementKindSectionHeader) || (currentAttr.representedElementKind == UICollectionView.elementKindSectionFooter)) {
                    layoutAttributes_t.removeAll()
                    wy_cellTotalWidth = 0.0
                }else{
                    updateCellAttributes(layoutAttributes: layoutAttributes_t)
                    layoutAttributes_t.removeAll()
                    wy_cellTotalWidth = 0.0
                }
            }else if currentY != nextY {
                // 如果下一个cell在本行，这开始调整frame位置
                updateCellAttributes(layoutAttributes: layoutAttributes_t)
                layoutAttributes_t.removeAll()
                wy_cellTotalWidth = 0.0
                numberOfLines += 1
                delegate?.alignmentFlowLayout?(self, numberOfLines: numberOfLines)
            }
            
            // 从新计算下一个cell的原点
            var nextlayoutAttributesFrame: CGRect = nextAttr?.frame ?? .zero
            nextlayoutAttributesFrame.origin.y = nextlayoutAttributesFrame.origin.y + wy_cellAddHeight
            nextAttr?.frame = nextlayoutAttributesFrame;
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
                attributes.frame = calculateWrapHeight(attributes: &nowFrame)
                nowWidth = nowWidth - nowFrame.size.width - minimumInteritemSpacing
            }
            break
        default:
            nowWidth = (wy_layoutAlignment == .left) ? (sectionInset.left) : (((collectionView?.frame.size.width ?? 0) - wy_cellTotalWidth - (CGFloat(layoutAttributes.count - 1) * minimumInteritemSpacing)) / 2)
            for attributes in layoutAttributes {
                var nowFrame = attributes.frame
                nowFrame.origin.x = nowWidth
                attributes.frame = calculateWrapHeight(attributes: &nowFrame)
                nowWidth += nowFrame.size.width + minimumInteritemSpacing
            }
            break
        }
    }
    
    /// 调整换行显示时的高度
    private func calculateWrapHeight(attributes: inout CGRect) -> CGRect {
        
        if attributes.size.width > flowLayoutMaxWidth {
            if flowLayoutNumberOfLines != 1 {
                
                let maxNumberOfLines: NSInteger = NSInteger(ceil(Double(attributes.size.width) / Double(flowLayoutMaxWidth)))
                
                let numberOfLines: NSInteger = (flowLayoutNumberOfLines == 0) ? maxNumberOfLines : ((maxNumberOfLines > flowLayoutNumberOfLines) ? flowLayoutNumberOfLines : maxNumberOfLines)
                
                let addHeight: CGFloat = (flowLayoutWrapHeight * CGFloat(numberOfLines - 1))
                
                attributes.size.height = attributes.size.height + addHeight
                
                wy_cellAddHeight = wy_cellAddHeight + addHeight
            }
            attributes.size.width = flowLayoutMaxWidth
        }
        return attributes
    }
}
