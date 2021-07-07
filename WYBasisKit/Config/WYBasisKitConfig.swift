//
//  WYBasisKitConfig.swift
//  WYBasisKit
//
//  Created by jacke·xu on 2020/11/21.
//  Copyright © 2020 jacke-xu. All rights reserved.
//

import UIKit

public struct WYBasisKitConfig {
    
    /// 设置屏幕宽度比基数
    public static var screenWidthRatioBase: CGFloat = 375.0
    
    /// 设置屏幕高度比基数
    public static var screenHeightRatioBase: CGFloat = 812.0
    
    /// 设置字号适配的最大比率数
    public static var maxFontRatio: CGFloat = 1.0
    
    /// 设置AlertView提示控件驻留时间
    public static var messageDuration: TimeInterval = 1.5
    
    /// 设置tableView或collectionView上拉加载更多时每次请求的数据量
    public static var pageSize: NSInteger = 10
}
