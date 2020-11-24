//
//  UITableView.swift
//  WYBasisKit
//
//  Created by jacke·xu on 2020/8/29.
//  Copyright © 2020 jacke-xu. All rights reserved.
//

import MJRefresh

extension UITableView {
    
    func wy_headerEndRefreshing() {
        
        guard self.mj_header != nil else { return }
        
        self.mj_header?.endRefreshing()
    }

    func wy_footerEndRefreshing(responseSize: NSInteger = 0, pageSize: NSInteger = WYBasisKitConfig.wy_pageSize <= 0 ? wy_defaultPageSize : WYBasisKitConfig.wy_pageSize) {
        
        guard self.mj_footer != nil else { return }
        
        if responseSize < pageSize {
            
            self.mj_footer?.endRefreshingWithNoMoreData()
            
        }else {
            
            self.mj_footer?.endRefreshing()
        }
    }
}
