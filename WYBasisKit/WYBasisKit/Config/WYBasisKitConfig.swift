//
//  WYBasisKitConfig.swift
//  WYBasisKit
//
//  Created by jacke·xu on 2020/11/21.
//  Copyright © 2020 jacke-xu. All rights reserved.
//

import Foundation
import UIKit

let wy_defaultPageSize: NSInteger = 10
let wy_messageDuration: TimeInterval = 1.5
let timeoutIntervalForRequest: TimeInterval = 10

struct WYBasisKitConfig {
    
    /// 设置tableView或collectionView上拉加载更多时每次请求的数据量，默认10条
    static var wy_pageSize: NSInteger = wy_defaultPageSize
    
    /// 设置当前语言环境
    func wy_setCurrentLanguage(language: WYLanguage) {
        
        WYLocalizableManager.shared.setUserLanguage(language: language)
    }
}
