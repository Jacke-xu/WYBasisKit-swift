//
//  UITableView.swift
//  WYBasisKit
//
//  Created by jacke·xu on 2020/8/29.
//  Copyright © 2020 jacke-xu. All rights reserved.
//

import UIKit
import MJRefresh

public extension UITableView {
    
    /* UITableView.Style 区别
     
     * plain模式：
                1、如果实现了viewForHeaderInSection、viewForFooterInSection方法之一或两个都实现了，则与之对应的header或者footer在滑动的时候会有悬浮效果
     
                2、如果实现了viewForHeaderInSection、viewForFooterInSection方法之一或两个都实现了，则header或footer的高度会显示为传入的高度，相反，则不会显示header或footer，与之对应的高度也会自动置零
     
                3、该模式下实现对应代理方法后可以在右侧显示分区索引，参考手机通讯录界面可理解
     
                4、有header或footer的时候，header或footer会有个默认的背景色
     
     * grouped模式：
                1、该模式下header、footer不会有悬浮效果
     
                2、该模式下header、footer会有默认高度，如果不需要显示高度，可以设置为0.01
     
                3、默认背景色为透明
     */
    
    /// 创建一个UITableView
    class func wy_shared(frame: CGRect = .zero,
                         style: UITableView.Style = .plain,
                         headerHeight: CGFloat = UITableView.automaticDimension,
                         footerHeight: CGFloat = UITableView.automaticDimension,
                         rowHeight: CGFloat = UITableView.automaticDimension,
                         separatorStyle: UITableViewCell.SeparatorStyle = .none,
                         delegate: UITableViewDelegate,
                         dataSource: UITableViewDataSource,
                         backgroundColor: UIColor = .white,
                         superView: UIView? = nil) -> UITableView {
        
        let tableview = UITableView(frame: frame, style: style)
        tableview.delegate = delegate
        tableview.dataSource = dataSource
        tableview.separatorStyle = separatorStyle
        tableview.backgroundColor = backgroundColor
        tableview.estimatedSectionHeaderHeight = headerHeight
        tableview.sectionHeaderHeight = headerHeight
        tableview.estimatedSectionFooterHeight = footerHeight
        tableview.sectionFooterHeight = footerHeight
        tableview.estimatedRowHeight = rowHeight
        tableview.rowHeight = rowHeight
        tableview.tableHeaderView = UIView()
        tableview.tableFooterView = UIView()
        superView?.addSubview(tableview)
        
        return tableview
    }
    
    /// 是否允许其它手势识别，默认false，在tableView嵌套的类似需求下可设置为true
    var wy_openOtherGestureRecognizer: Bool {
        
        set(newValue) {
            
            objc_setAssociatedObject(self, WYAssociatedKeys.wy_openOtherGestureRecognizer, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
        get {
            return objc_getAssociatedObject(self, WYAssociatedKeys.wy_openOtherGestureRecognizer) as? Bool ?? false
        }
    }
    
    /// 结束mj_header刷新状态
    func wy_headerEndRefreshing() {
        
        guard self.mj_header != nil else { return }
        
        self.mj_header?.endRefreshing()
    }

    /// 结束mj_footer刷新状态
    func wy_footerEndRefreshing(responseSize: NSInteger = 0, pageSize: NSInteger = WYBasisKitConfig.wy_pageSize <= 0 ? wy_defaultPageSize : WYBasisKitConfig.wy_pageSize) {
        
        guard self.mj_footer != nil else { return }
        
        if responseSize < pageSize {
            
            self.mj_footer?.endRefreshingWithNoMoreData()
            
        }else {
            
            self.mj_footer?.endRefreshing()
        }
    }
    
    /// 注册UITableView的Cell或HeaderFooterView
    func wy_register(_ className: String, _ type: WYTableViewRegisterType) {
        
        guard className.isEmpty == false else {

            fatalError("调用注册方法前必须创建与className对应的类文件")
        }
        
        let registerClass = (className == "UITableViewCell") ? className : (wy_projectName + "." + className)
        
        switch type {
        case .cell:
            guard let cellClass = NSClassFromString(registerClass) as? UITableViewCell.Type else {
                
                wy_print("注册 \(className) 失败")
                return
            }
            register(cellClass.self, forCellReuseIdentifier: className)
            break

        case .headerFooterView:
            guard let headerFooterViewClass = NSClassFromString(registerClass) as? UITableViewHeaderFooterView.Type else {
                
                wy_print("注册 \(className) 失败")
                return
            }
            register(headerFooterViewClass.self, forHeaderFooterViewReuseIdentifier: className)
            break
        }
    }
    
    /// 设置plain模式下headerView不悬停(需在scrollViewDidScroll方法中调用)
    func wy_scrollWithoutPasting(scrollView: UIScrollView, headerHeight: CGFloat) {

        if (scrollView == self) {
            
            if (scrollView.contentOffset.y <= headerHeight && scrollView.contentOffset.y >= 0) {
                
                scrollView.contentInset = UIEdgeInsets(top: -scrollView.contentOffset.y, left: 0, bottom: 0, right: 0)
                
            } else if (scrollView.contentOffset.y >= headerHeight) {
                
                scrollView.contentInset = UIEdgeInsets(top: -headerHeight, left: 0, bottom: 0, right: 0)
            }
        }
    }
    
    private struct WYAssociatedKeys {
        
        static let wy_openOtherGestureRecognizer = UnsafeRawPointer.init(bitPattern: "wy_openOtherGestureRecognizer".hashValue)!
    }
}

extension UITableView: UIGestureRecognizerDelegate {
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return wy_openOtherGestureRecognizer
    }
}
