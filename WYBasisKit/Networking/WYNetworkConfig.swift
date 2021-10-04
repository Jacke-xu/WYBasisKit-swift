//
//  WYNetworkConfig.swift
//  WYBasisKit
//
//  Created by Jacke·xu on 2020/11/23.
//  Copyright © 2020 Jacke·xu. All rights reserved.
//

import Foundation
import Alamofire

/// 网络请求验证方式
public enum WYNetworkRequestStyle {
    
    /// HTTP和CAHTTPS(无需额外配置  CAHTTPS：向正规CA机构购买的HTTPS服务)
    case httpOrCAHttps
    /// HTTPS单向验证，客户端验证服务器(自建证书，需要将一个服务端的cer文件放进工程目录，并调用WYNetworkConfig.httpsConfig对应方法配置cer文件名)
    case httpsSingle
    /// HTTPS双向验证，客户端和服务端双向验证(自建证书，需要将一个服务端的cer文件与一个带密码的客户端p12文件放进工程目录，并调用WYNetworkConfig.httpsConfig对应方法配置cer、P12文件名与P12文件密码)
    case httpsBothway
}

/// HTTPS自建证书验证策略
public enum WYHttpsVerifyStrategy {
    
    /// 证书验证模式，客户端会将服务器返回的证书和本地保存的证书中的 所有内容 全部进行校验，如果正确，才继续执行
    case pinnedCertificates
    
    /// 公钥验证模式，客户端会将服务器返回的证书和本地保存的证书中的 公钥 部分 进行校验，如果正确，才继续执行
    case publicKeys
    
    /// 不进行任何验证,无条件信任证书(不建议使用此选项，如果确实要使用此选项的，最好自己实现验证策略)
    case directTrust
}

/// HTTPS自建证书相关配置
public struct WYHttpsConfig {
    
    /// 自定义单向认证验证策略
    public static var trustManager: ServerTrustManager? = nil
    public var trustManager: ServerTrustManager? = trustManager
    
    /// 自定义双向认证sessionDelegate
    public static var sessionDelegate: SessionDelegate? = nil
    public var sessionDelegate: SessionDelegate? = sessionDelegate
    
    /// 配置自建证书HTTPS请求时server.cer文件名
    public static var serverCer: String = ""
    public var serverCer: String = serverCer
    
    /// 配置自建证书HTTPS请求时client.p12文件名
    public static var clientP12: String = ""
    public var clientP12: String = clientP12
    
    /// 配置自建证书HTTPS请求时client.p12文件密码
    public static var clientP12Password: String = ""
    public var clientP12Password: String = clientP12Password
    
    /// 设置验证策略(安全等级)
    public static var verifyStrategy: WYHttpsVerifyStrategy = .pinnedCertificates
    public var verifyStrategy: WYHttpsVerifyStrategy = verifyStrategy
    
    /// 是否执行默认验证
    public static var defaultValidation: Bool = true
    public var defaultValidation: Bool = defaultValidation
    
    /// 是否验证域名
    public static var validateDomain: Bool = true
    public var validateDomain: Bool = validateDomain
    
    /// 确定是否必须评估此“服务器信任管理器”的所有主机
    public static var allHostsMustBeEvaluated: Bool = true
    public var allHostsMustBeEvaluated: Bool = allHostsMustBeEvaluated
    
    /// 获取一个默认config
    public static let `default`: WYHttpsConfig = WYHttpsConfig()
}

/// 网络请求相关配置
public struct WYNetworkConfig {
    
    /// 网络请求验证方式
    public static var requestStyle: WYNetworkRequestStyle = .httpOrCAHttps
    public var requestStyle: WYNetworkRequestStyle = requestStyle
    
    /// HTTPS自建证书相关
    public static var httpsConfig: WYHttpsConfig = .default
    public var httpsConfig: WYHttpsConfig = httpsConfig
    
    /// 网络请求任务类型
    public static var taskMethod: WYTaskMethod = .parameters
    public var taskMethod: WYTaskMethod = taskMethod
    
    /// 设置网络请求超时时间
    public static var timeoutInterval: TimeInterval = 15
    public var timeoutInterval: TimeInterval = timeoutInterval
    
    /// 配置接口域名
    public static var domain: String = ""
    public var domain: String = domain
    
    /// 配置默认请求头
    public static var header: [String : String]? = ["Content-Type": "application/x-www-form-urlencoded; charset=utf-8"]
    public var header: [String : String]? = header
    
    /// 设置url中需要过滤的特殊字符，当url包含有特殊字符时，内部自动将 域名 和 路径 拼接为新的url，避免特殊字符导致的404错误
    public static var specialCharacters: [String] = ["?"]
    public var specialCharacters: [String] = specialCharacters
    
    /// 返回数据是否需要最原始的data对象
    public static var originObject: Bool = false
    public var originObject: Bool = originObject
    
    /// 网络请求的缓存数据(缓存)路径
    public static var requestSavePath: URL = createDirectory(directory: .documentDirectory, subDirectory: "WYBasisKit/Request")
    public var requestSavePath: URL = requestSavePath

    /// 下载的文件、资源保存(缓存)路径
    public static var downloadSavePath: URL = createDirectory(directory: .documentDirectory, subDirectory: "WYBasisKit/Download")
    public var downloadSavePath: URL = downloadSavePath
    
    /// 下载是是否自动覆盖同名文件
    public static var removeSameNameFile: Bool = true
    public var removeSameNameFile: Bool = removeSameNameFile
    
    /// 网络请求时队列
    public static var callbackQueue: DispatchQueue? = .global()
    public var callbackQueue: DispatchQueue? = callbackQueue
    
    /// 配置服务端自定义的成功code
    public static var serverRequestSuccessCode: String = "200"
    public var serverRequestSuccessCode: String = serverRequestSuccessCode
    
    /// 配置其它失败code
    public static var otherServerFailCode: String = "10000"
    public var otherServerFailCode: String = otherServerFailCode
    
    /// 配置网络判断失败code
    public static var networkServerFailCode: String = "10002"
    public var networkServerFailCode: String = networkServerFailCode
    
    /// 配置解包失败code
    public static var unpackServerFailCode: String = "10001"
    public var unpackServerFailCode: String = unpackServerFailCode
    
    /// Debug模式下是否打印网络请求日志
    public static var debugModeLog: Bool = true
    public var debugModeLog: Bool = debugModeLog
    
    /// 获取一个默认config
    public static let `default`: WYNetworkConfig = WYNetworkConfig()
    
    /// 创建一个指定目录/文件夹
    public static func createDirectory(directory: FileManager.SearchPathDirectory, subDirectory: String) -> URL {
        
        let directoryURLs = FileManager.default.urls(for: directory,
                                                     in: .userDomainMask)
        
        let savePath = (directoryURLs.first ?? URL(fileURLWithPath: NSTemporaryDirectory())).appendingPathComponent(subDirectory)
        let isExists: Bool = FileManager.default.fileExists(atPath: savePath.path)
        
        if !isExists {
            
            guard let _ = try? FileManager.default.createDirectory(at: savePath, withIntermediateDirectories: true, attributes: nil) else {
            
                fatalError("创建 \(savePath) 路径失败")
            }
        }
        return savePath
    }
}
