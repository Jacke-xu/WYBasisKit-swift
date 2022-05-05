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
    
    /// 设置默认图片加载的Bundle名(例如：ImageSource.bundle 设置bundleName为 ImageSource 即可)
    public static var bundleName: String = ""
    
    /// Debug模式下是否打印日志
    public static var debugModeLog: Bool = true
}
