//
//  UICollectionView.swift
//  WYBasisKit
//
//  Created by jacke·xu on 2021/8/28.
//  Copyright © 2021 Jacke·xu. All rights reserved.
//

import UIKit

/// UICollectionView注册类型
public enum WYCollectionViewRegisterType {
    
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
     *  @param sectionInset: 分区 上、左、下、右 的间距(该设置仅适用于一个分区的情况，多个分区请调用相关代理进行针对性设置)
     *  @param minimumLineSpacing: item 上下间距
     *  @param minimumInteritemSpacing: item 左右间距
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
                         delegate: UICollectionViewDelegate,
                         dataSource: UICollectionViewDataSource,
                         backgroundColor: UIColor = .white,
                         superView: UIView? = nil) -> UICollectionView {
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = scrollDirection
        flowLayout.sectionInset = sectionInset
        flowLayout.minimumLineSpacing = minimumLineSpacing
        flowLayout.minimumInteritemSpacing = minimumInteritemSpacing
        
        let collectionview = UICollectionView(frame: frame, collectionViewLayout: flowLayout)
        collectionview.delegate = delegate
        collectionview.dataSource = dataSource
        collectionview.backgroundColor = backgroundColor
        superView?.addSubview(collectionview)
        
        return collectionview
    }
    
    /// 注册UICollectionView的Cell或Header/FooterView
    func wy_register(_ className: String, _ type: WYCollectionViewRegisterType) {
        
        guard className.isEmpty == false else {
            fatalError("调用注册方法前必须创建与 \(className) 对应的类文件")
        }
        
        let registerClass = (className == "UICollectionViewCell") ? className : (wy_projectName + "." + className)
        
        switch type {
        case .cell:
            guard let cellClass = NSClassFromString(registerClass) as? UICollectionViewCell.Type else {
                wy_print("注册 \(className) 失败")
                return
            }
            register(cellClass.self, forCellWithReuseIdentifier: className)
            break
            
        case .headerView:
            guard let headerViewClass = NSClassFromString(registerClass) as? UICollectionReusableView.Type else {
                wy_print("注册 \(className) 失败")
                return
            }
            register(headerViewClass.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: className)
            break
            
        case .footerView:
            guard let footerViewClass = NSClassFromString(registerClass) as? UICollectionReusableView.Type else {
                wy_print("注册 \(className) 失败")
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
