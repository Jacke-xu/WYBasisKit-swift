//
//  WYRefresh.swift
//  WYBasisKit
//
//  Created by jacke·xu on 2021/8/28.
//  Copyright © 2021 Jacke·xu. All rights reserved.
//

import Foundation
import MJRefresh

public extension MJRefreshConfig {
    
    /// 本地化语言切换
    class func switchLanguage(_ language: WYLanguage = WYLocalizableManager.currentLanguage()) {
        MJRefreshConfig.default.languageCode = language.rawValue
    }
}

public extension UITableView {
    
    /// 结束mj_header刷新状态
    func wy_headerEndRefreshing() {
        
        guard self.mj_header != nil else { return }
        
        self.mj_header?.endRefreshing()
    }

    /// 结束mj_footer刷新状态
    func wy_footerEndRefreshing(responseSize: NSInteger = 0, pageSize: NSInteger = WYBasisKitConfig.pageSize) {
        
        guard self.mj_footer != nil else { return }
        
        if responseSize < pageSize {
            
            self.mj_footer?.endRefreshingWithNoMoreData()
            
        }else {
            self.mj_footer?.endRefreshing()
        }
    }
}

public extension UICollectionView {
    
    /// 结束mj_header刷新状态
    func wy_headerEndRefreshing() {
        
        guard self.mj_header != nil else { return }
        
        self.mj_header?.endRefreshing()
    }

    /// 结束mj_footer刷新状态
    func wy_footerEndRefreshing(responseSize: NSInteger = 0, pageSize: NSInteger = WYBasisKitConfig.pageSize) {
        
        guard self.mj_footer != nil else { return }
        
        if responseSize < pageSize {
            
            self.mj_footer?.endRefreshingWithNoMoreData()
            
        }else {
            self.mj_footer?.endRefreshing()
        }
    }
}
