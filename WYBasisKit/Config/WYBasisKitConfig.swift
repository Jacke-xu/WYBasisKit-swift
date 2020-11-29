//
//  WYBasisKitConfig.swift
//  WYBasisKit
//
//  Created by jacke·xu on 2020/11/21.
//  Copyright © 2020 jacke-xu. All rights reserved.
//

import Foundation
import UIKit

public let wy_defaultPageSize: NSInteger = 10
public let wy_messageDuration: TimeInterval = 1.5
public let wy_timeoutIntervalForRequest: TimeInterval = 10

public class WYBasisKitConfig {
    
    /// 设置tableView或collectionView上拉加载更多时每次请求的数据量，默认10条
    public static var wy_pageSize: NSInteger = wy_defaultPageSize
    
    /// 设置当前语言环境
    public class func wy_setCurrentLanguage(language: WYLanguage) {
        
        WYLocalizableManager.shared.setUserLanguage(language: language)
    }
}
