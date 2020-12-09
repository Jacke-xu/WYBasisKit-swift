//
//  WYBasisKitConfig.swift
//  WYBasisKit
//
//  Created by jacke·xu on 2020/11/21.
//  Copyright © 2020 jacke-xu. All rights reserved.
//

import UIKit

public let wy_defaultPageSize: NSInteger = 10
public let wy_messageDuration: TimeInterval = 1.5
public let wy_currentScreenWidthRatioBase: CGFloat = 375.0
public let wy_currentScreenHeightRatioBase: CGFloat = 812.0

public class WYBasisKitConfig {
    
    /// 设置tableView或collectionView上拉加载更多时每次请求的数据量
    public static var wy_pageSize: NSInteger = wy_defaultPageSize
    
    /// 设置当前语言环境
    public class func wy_switchLanguage(language: WYLanguage, reload: Bool = true, handler:(() -> Void)? = nil) {
        
        WYLocalizableManager.shared.switchLanguage(language: language, reload: reload, handler: handler)
    }
    
    /// 设置屏幕宽度比基数
    public static var wy_screenWidthRatioBase: CGFloat = wy_currentScreenWidthRatioBase
    
    /// 设置屏幕高度比基数
    public static var wy_screenHeightRatioBase: CGFloat = wy_currentScreenHeightRatioBase
}
