//
//  WYNetworkConfig.swift
//  WYBasisKit
//
//  Created by jacke·xu on 2020/11/23.
//  Copyright © 2020 jacke-xu. All rights reserved.
//

import Foundation

public struct WYNetworkConfig {
    
    /// 设置网络请求超时事件，默认10秒
    public static var timeoutIntervalForRequest: TimeInterval = wy_timeoutIntervalForRequest
    
    /// 配置当前使用域名
    public static var currentDomainPath: String = ""
    
    /// 配置默认请求头
    public static var requestHeaders: [String : String]? = ["Content-Type": "application/x-www-form-urlencoded; charset=utf-8"]
}
