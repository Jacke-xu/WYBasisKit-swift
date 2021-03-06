//
//  UIApplication.swift
//  WYBasisKit
//
//  Created by Jacke·xu on 2020/12/3.
//  Copyright © 2020 Jacke·xu. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
extension UIApplication: UIApplicationDelegate {
    
    /// 切换为深色或浅色模式
    public func wy_switchAppDisplayBrightness(style: UIUserInterfaceStyle) {
        delegate!.window!?.rootViewController?.overrideUserInterfaceStyle = style
    }
    
    /// 全局关闭暗夜模式
    public func wy_closeDarkModel() {
        delegate!.window!?.overrideUserInterfaceStyle = UIUserInterfaceStyle.light
    }
}
