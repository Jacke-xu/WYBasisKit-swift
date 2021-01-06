//
//  WYNetworkConfig.swift
//  WYBasisKit
//
//  Created by jacke·xu on 2020/11/23.
//  Copyright © 2020 jacke-xu. All rights reserved.
//

import Foundation

public let wy_timeoutIntervalForRequest: TimeInterval = 20
public let wy_serverRequestSuccessCode: Int = 200
public let wy_otherServerFailCode: Int = 10000
public let wy_unpackServerFailCode: Int = 10001
public let wy_networkServerFailCode: Int = 10002
public let wy_debugModeLog: Bool = true

public struct WYNetworkConfig {
    
    /// 设置网络请求超时时间
    public static var timeoutIntervalForRequest: TimeInterval = wy_timeoutIntervalForRequest
    
    /// 配置当前使用域名
    public static var currentDomainPath: String = ""
    
    /// 配置网络请求方式
    public static var requestWay: WYNetworkRequestWay = .httpOrCAHttps
    
    /// 配置HTTPS请求时server.cer文件路径
    public static var serverCerFilePath: String = ""
    
    /// 配置HTTPS请求时client.p12文件路径
    public static var clientP12FilePath: String = ""
    
    /// 配置HTTPS请求时client.p12文件密码
    public static var clientP12FilePassword: String = ""
    
    /// 配置默认请求头
    public static var requestHeaders: [String : String]? = ["Content-Type": "application/x-www-form-urlencoded; charset=utf-8"]
    
    /// 配置服务端自定义的成功code
    public static var serverRequestSuccessCode: Int = wy_serverRequestSuccessCode
    
    /// 配置其它失败code
    public static var otherServerFailCode: Int = wy_otherServerFailCode
    
    /// 配置网络判断失败code
    public static var networkServerFailCode: Int = wy_networkServerFailCode
    
    /// 配置解包失败code
    public static var unpackServerFailCode: Int = wy_unpackServerFailCode
    
    /// debug模式下是否打印网络请求日志
    public static var debugModeLog: Bool = wy_debugModeLog
}
