//
//  WYNetworkConfig.swift
//  WYBasisKit
//
//  Created by Jacke·xu on 2020/11/23.
//  Copyright © 2020 Jacke·xu. All rights reserved.
//

import Foundation

/// 网络请求方式
public enum WYNetworkRequestWay {
    
    /// HTTP和CAHTTPS(无需额外配置  CAHTTPS：向正规CA机构购买的HTTPS服务)
    case httpOrCAHttps
    /// HTTPS单向验证(自建证书，需要将一个服务端的server.cer文件放进工程目录，并调用WYNetworkConfig对应方法配置cer文件路径)
    case httpsSingleVerify
    /// HTTPS双向验证(自建证书，需要将一个服务端的server.cer文件与一个带密码的客户端client.p12文件放进工程目录，并调用WYNetworkConfig对应方法配置cer、P12文件路径与P12文件密码)
    case httpsBothwayVerify
}

public struct WYNetworkConfig {
    
    /// 设置网络请求超时时间
    public static var timeoutIntervalForRequest: TimeInterval = 20
    
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
    public static var serverRequestSuccessCode: Int = 200
    
    /// 配置其它失败code
    public static var otherServerFailCode: Int = 10000
    
    /// 配置网络判断失败code
    public static var networkServerFailCode: Int = 10002
    
    /// 配置解包失败code
    public static var unpackServerFailCode: Int = 10001
    
    /// Debug模式下是否打印网络请求日志
    public static var debugModeLog: Bool = true
}
