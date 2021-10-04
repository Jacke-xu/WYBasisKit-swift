//
//  WYNetworkManager.swift
//  WYBasisKit
//
//  Created by Jacke·xu on 2020/8/29.
//  Copyright © 2020 Jacke·xu. All rights reserved.
//

import Moya
import Alamofire
import HandyJSON
import Foundation

/// 网络请求任务类型
public enum WYTaskMethod {
    
    /// 数据任务
    case parameters
    /// Data数据任务(对应Postman的raw)
    case data
    /// 上传任务
    case upload
    /// 下载任务
    case download
}

/// 上传类型
public enum WYFileType {
    
    /// 上传图片
    case image
    /// 上传音频
    case audio
    /// 上传视频
    case video
    /// URL路径上传
    case urlPath
}

/// 网络连接模式与用户操作选项
public enum WYNetworkStatus {
    
    /// 未知网络，可能是不安全的连接
    case unknown
    /// 无网络连接
    case notReachable
    /// wifi网络
    case reachableWifi
    /// 蜂窝移动网络
    case reachableCellular
    
    /// 用户未选择
    case userNotSelectedConnect
    /// 用户设置取消连接
    case userCancelConnect
    /// 用户设置继续连接
    case userContinueConnect
}

public struct WYResponse: HandyJSON {
    
    public var msg: String? = ""
    public var code: String = ""
    public var data: Any? = nil
    
    public mutating func mapping(mapper: HelpingMapper) {
        mapper.specify(property: &msg, name: "reason")
        mapper.specify(property: &msg, name: "message")
        mapper.specify(property: &code, name: "ret")
    }
    
    public init() {}
}

public struct WYError {
    
    /// 错误码
    public var code: String = ""
    /// 详细错误描述
    public var describe: String = ""
}

public struct WYFileModel {
    
    /**
     *  上传的文件的上传后缀(选传项，例如，JPEG图像的MIME类型是image/jpeg，具体参考http://www.iana.org/assignments/media-types/.)
     *  可根据具体的上传文件类型自由设置，默认上传图片时设置为image/jpeg，上传音频时设置为audio/aac，上传视频时设置为video/mp4，上传url时设置为application/octet-stream
     */
    private var _mimeType: String = ""
    public var mimeType: String {
        
        set {
            _mimeType = newValue
        }
        mutating get {
            
            if _mimeType.isEmpty == true {
                
                switch fileType {
                case .image:
                    _mimeType = "image/jpeg"
                case .audio:
                    _mimeType =  "audio/aac"
                case .video:
                    _mimeType =  "video/mp4"
                case .urlPath:
                    _mimeType =  "application/octet-stream"
                }
            }
            return _mimeType
        }
    }
    
    /// 上传的文件的名字(选传项)
    public var fileName: String = ""
    
    /// 上传的文件的文件夹名字(选传项)
    public var folderName: String = "file"
    
    ///上传图片压缩比例(选传项，0~1.0区间，1.0代表无损，默认无损)
    private var _compressionQuality: CGFloat = 1.0
    public var compressionQuality: CGFloat {
        
        set {
            _compressionQuality = ((newValue > 1.0) || (newValue <= 0.0)) ? 1.0 : newValue
        }
        get {
            return _compressionQuality
        }
    }
    
    /// 上传文件的类型(选传项，默认image)
    public var fileType: WYFileType = .image
    
    /// 上传的图片
    public var image: UIImage? {
        
        willSet {
            
            if ((data == nil) && (newValue != nil)) {
                
                data = newValue!.jpegData(compressionQuality: compressionQuality)
            }else {
                fatalError("二进制文件 \(String(describing: data)) 与 图片 \(String(describing: image))只传入其中一项即可")
            }
        }
    }
    
    /// 上传的二进制文件
    public var data: Data?
    
    /// 上传的资源URL路径
    public var fileUrl: String = ""
}

public struct WYNetworkManager {
    
    /**
     *  发起一个网络请求
     *
     *  @param method       网络请求类型
     *
     *  @param path         网络请求url路径
     *
     *  @param data         data数据任务时对应的data，非data数据任务传nil即可
     *
     *  @param parameter    参数
     *
     *  @param config       请求配置
     *
     *  @param progress     进度回调
     *
     *  @param success      成功回调
     *
     *  @param failure      失败回调
     *
     */
    public static func request(method: HTTPMethod = .post, path: String = "", data: Data? = nil, parameter: [String : Any] = [:], config: WYNetworkConfig = .default, success:((_ response: Any?) -> Void)? = .none, failure:((_ error: WYError) -> Void)? = .none, progress:((_ progress: Double) -> Void)? = .none) {
        
        request(method: method, path: path, data: data, config: config, parameter: parameter, files: [], progress: progress, success: success, failure: failure)
    }

    /**
     *  发起一个上传请求
     *
     *  @param path         网络请求url路径
     *
     *  @param parameter    参数
     *
     *  @param files        要上传的文件
     *
     *  @param config       请求配置
     *
     *  @param progress     进度回调
     *
     *  @param success      成功回调
     *
     *  @param failure      失败回调
     *
     */
    public static func upload(path: String = "", parameter: [String : Any] = [:], files: [WYFileModel], config: WYNetworkConfig = .default, progress:((_ progress: Double) -> Void)? = .none, success:((_ response: Any?) -> Void)? = .none, failure:((_ error: WYError) -> Void)? = .none) {
        
        var taskConfig = config
        taskConfig.taskMethod = .upload

        request(method: .post, path: path, data: nil, config: taskConfig, parameter: parameter, files: files, progress: progress, success: success, failure: failure)
    }
    
    /**
     *  发起一个下载请求
     *
     *  @param path         网络请求url路径
     *
     *  @param parameter    参数
     *
     *  @param assetName    自定义要保存的资源文件的名字，不传则使用默认名
     *
     *  @param config       请求配置
     *
     *  @param progress     进度回调
     *
     *  @param success      成功回调
     *
     *  @param failure      失败回调
     *
     */
    public static func download(path: String = "", parameter: [String : Any] = [:], assetName: String = "", config: WYNetworkConfig = .default, progress:((_ progress: Double) -> Void)? = .none, success:((_ response: Any?) -> Void)? = .none, failure:((_ error: WYError) -> Void)? = .none) {
        
        var taskConfig = config
        taskConfig.taskMethod = .download

        request(method: .get, path: path, data: nil, config: taskConfig, parameter: parameter, files: [], assetName: assetName, progress: progress, success: success, failure: failure)
    }
    
    /**
     *  清除缓存
     *
     *  @param path         要清除的资源文件的路径
     *
     *  @param asset    为空表示清除传入 path 下所有资源文件，否则表示清除传入 path 下对应 asset 的指定资源
     *
     *  @param complte      完成后回调，error 为空表示成功，否则为失败
     *
     */
    public static func clearDiskCache(path: String = WYNetworkConfig.default.downloadSavePath.path, asset: String = "", complte:((_ error: String?) -> Void)? = .none) {

        guard let contents = try? FileManager.default.contentsOfDirectory(atPath: path) else {
            
            if complte != nil {
                complte!("\(path) 路径不存在或者该路径下没有需要删除的文件")
            }
            return
        }
        
        if asset.isEmpty {
            
            for obj: String in contents {
                
                let contentPath: String = URL(fileURLWithPath: path).appendingPathComponent(obj).path

                guard let _ = try? FileManager.default.removeItem(atPath: contentPath) else {
                    
                    if complte != nil {
                        complte!("移除 \(obj) 文件失败")
                    }
                    return
                }
                if complte != nil {
                    complte!(nil)
                }
            }
            
        }else {
            
            if contents.contains(asset) {
                
                let contentPath: String = URL(fileURLWithPath: path).appendingPathComponent(asset).path

                guard let _ = try? FileManager.default.removeItem(atPath: contentPath) else {
                
                    if complte != nil {
                        complte!("移除 \(asset) 文件失败")
                    }
                    return
                }
                if complte != nil {
                    complte!(nil)
                }
                return
                
            }else {
                if complte != nil {
                    complte!("没有找到 \(asset) 这个文件")
                }
                return
            }
        }
    }
    
    /// 取消所有网络请求
    public static func cancelAllRequest() {
        
        Moya.Session.default.session.getAllTasks { (tasks) in

            tasks.forEach { (task) in
                
                task.cancel()
            }
        }
    }
    
    /**
     *  取消指定url的请求
     *
     *  @param domain      域名
     *
     *  @param path        网络请求url路径
     *
     */
    public static func cancelRequest(domain: String = WYNetworkConfig.default.domain, path: String) {
        
        Moya.Session.default.session.getAllTasks { (tasks) in

            tasks.forEach { (task) in

                if (task.originalRequest?.url?.absoluteString == (domain + path)) {
                    task.cancel()
                }
            }
        }
    }
}

extension WYNetworkManager {
    
    private static var networkSecurityInfo = (WYNetworkStatus.userNotSelectedConnect, "")

    private static func request(method: HTTPMethod, path: String, data: Data?, config: WYNetworkConfig = .default, parameter: [String : Any], files: [WYFileModel], assetName: String = "", progress:((_ progress: Double) -> Void)?, success:((_ response: Any?) -> Void)?, failure:((_ error: WYError) -> Void)?) {

        checkNetworkStatus { (statusInfo) in

            if (statusInfo.0 == .userCancelConnect) {
                
                handlerFailure(error: WYError(code: WYNetworkConfig.networkServerFailCode, describe: statusInfo.1), failure: failure)

            }else {
                
                let request = WYRequest(method: method, path: path, data: data, parameter: parameter, files: files, assetName: assetName, config: config)
                
                let target = WYTarget(request: request)

                self.request(target: target, config: config, progress: progress, success: success, failure: failure)
            }
        }
    }

    private static func request(target: WYTarget, config: WYNetworkConfig, progress:((_ progress: Double) -> Void)? = .none, success:((_ response: Any?) -> Void)? = .none, failure:((_ error: WYError) -> Void)? = .none) {

        // 开启状态栏动画
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        WYTargetProvider.request(target, callbackQueue: config.callbackQueue) { (progressResponse) in

            if progress != nil {

                progress!(progressResponse.progress)
            }

        } completion: { (result) in

            switch result {

            case .success(let response):
                
                if config.taskMethod == .download {
                    
                    let format: String = ((response.response?.mimeType ?? "").components(separatedBy: "/").count > 1) ? ((response.response?.mimeType ?? "").components(separatedBy: "/").last ?? "") : ""
                    let saveName: String = (target.request.assetName.isEmpty ? (response.response?.suggestedFilename ?? "") : target.request.assetName) + "." + format

                    let saveUrl: URL = config.downloadSavePath.appendingPathComponent(saveName)
                    showDebugModeLog(target: target, response: response, saveUrl: saveUrl)
                    
                    handlerSuccess(response: ["directoryPath": saveUrl.absoluteString, "diskCache": config.downloadSavePath.path, "assetPath": saveUrl.path, "assetName": (target.request.assetName.isEmpty ? (response.response?.suggestedFilename ?? "") : target.request.assetName), "mimeType": format], success: success)
                    
                }else {
                    
                    let statusCode = response.statusCode

                    if statusCode != 200 {

                        showDebugModeLog(target: target, response: response)

                        handlerFailure(error: WYError(code: String(statusCode), describe: WYLocalizedString("状态码异常")), isStatusCodeError: true, failure: failure)

                    }else {
                        
                        if config.originObject {
                            
                            showDebugModeLog(target: target, response: response)
                            
                            handlerSuccess(response: response.data, success: success)
                            
                        }else {
                            
                            do {
                                //let responseData = try response.mapJSON()  也可以更改下返回值类型，直接把这个返回出去

                                let responseData = try WYResponse.deserialize(from: response.mapString())

                                if responseData?.code == WYNetworkConfig.serverRequestSuccessCode {

                                    showDebugModeLog(target: target, response: response)

                                    handlerSuccess(response: responseData?.data, success: success)

                                }else {

                                    showDebugModeLog(target: target, response: response)
                                    
                                    handlerFailure(error: WYError(code: responseData?.code ?? WYNetworkConfig.otherServerFailCode, describe: (responseData?.msg ?? WYLocalizedString("未知错误，接口信息返回为空"))), failure: failure)
                                }

                            } catch  {

                                showDebugModeLog(target: target, response: response)

                                handlerFailure(error: WYError(code: WYNetworkConfig.unpackServerFailCode, describe: error.localizedDescription), failure: failure)
                            }
                        }
                    }
                }
                break

            case .failure(let error):

                showDebugModeLog(target: target, response: Response(statusCode: error.errorCode, data: error.localizedDescription.data(using: .utf8) ?? Data()))
                
                handlerFailure(error: WYError(code: String(error.errorCode), describe: error.localizedDescription), failure: failure)

                break
            }
        }
    }

    private static func handlerSuccess(response: Any?, success:((_ response: Any?) -> Void)? = nil) {

        DispatchQueue.main.async {

            if (success != nil) {

                success!(response)
            }
            // 关闭状态栏动画
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }

    private static func handlerFailure(error: WYError, isStatusCodeError: Bool = false, function: String = #function, line: Int = #line, failure:((_ error: WYError) -> Void)? = nil) {

        DispatchQueue.main.async {

            if (failure != nil) {

                failure!(error)
            }
            // 关闭状态栏动画
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
            guard WYNetworkConfig.debugModeLog == true else { return }
            
            if isStatusCodeError {
                networkPrint("statusCode: \(error.code)\n statusError:  \(error)", function: function, line: line)
            }else {
                networkPrint("serverCode: \(error.code)\n serverError:  \(error)", function: function, line: line)
            }
        }
    }

    private static func showDebugModeLog(target: WYTarget, response: Response, saveUrl: URL? = nil, function: String = #function, line: Int = #line) {

        guard WYNetworkConfig.debugModeLog == true else { return }
        
        switch target.request.config.taskMethod {
        case .data:
            networkPrint("接口: \(target.baseURL)\(target.path)\n 请求头: \(target.headers ?? [:])\n dataString: \((target.request.data == nil ? "" : (String(data: target.request.data!, encoding: .utf8))) ?? "")\n 参数: \(target.request.parameter))\n 返回数据: \(String(describing: try? response.mapJSON()))", function: function, line: line)
            
        case .download:
            networkPrint("下载地址: \(target.baseURL)\(target.path)\n 请求头: \(target.headers ?? [:])\n 参数: \(target.request.parameter))\n 资源保存路径: \(saveUrl?.absoluteString ?? "")", function: function, line: line)
            
        default:
            networkPrint("接口: \(target.baseURL)\(target.path)\n 请求头: \(target.headers ?? [:])\n 参数: \(target.request.parameter))\n 返回数据: \(String(describing: try? response.mapJSON()))", function: function, line: line)
        }
    }

    private static func checkNetworkStatus(handler: ((_ status: (WYNetworkStatus, String)) -> Void)? = .none) {

        networkStatus(showStatusAlert: false, openSeting: true, statusHandler: { (status) in

            DispatchQueue.main.async {

                if ((status == .unknown) || (status == .notReachable)) {

                    if (networkSecurityInfo.0 == .userNotSelectedConnect) {

                        networkStatus(showStatusAlert: true, openSeting: true, actionHandler: { (actionStr, networkStatus) in

                            DispatchQueue.main.async {

                                if (actionStr == WYLocalizedString("继续连接")) {

                                    if (handler != nil) {

                                        handler!((.userContinueConnect, ""))
                                    }

                                }else if ((actionStr == WYLocalizedString("取消连接")) || (actionStr == WYLocalizedString("知道了"))) {

                                    if (handler != nil) {

                                        handler!((networkSecurityInfo.0, networkSecurityInfo.1))
                                    }

                                }else {

                                    if (handler != nil) {

                                        handler!((.userNotSelectedConnect, ""))
                                    }
                                }
                            }
                        })

                    }else {

                        if (handler != nil) {

                            handler!((networkSecurityInfo.0, networkSecurityInfo.1))
                        }
                    }

                }else {

                    networkStatus(showStatusAlert: false, openSeting: true, statusHandler: { (_) in

                        DispatchQueue.main.async {

                            if (handler != nil) {

                                handler!((.userNotSelectedConnect, ""))
                            }
                        }
                    })
                }
            }
        })
    }

    private static func networkStatus(showStatusAlert: Bool, openSeting: Bool, statusHandler:((_ status: WYNetworkStatus) -> Void)? = nil, actionHandler:((_ action: String, _ status: WYNetworkStatus) -> Void)? = nil) {

        let manager = NetworkReachabilityManager()
        manager!.startListening(onQueue: .main, onUpdatePerforming: { (status) in

            var message = WYLocalizedString("未知的网络，可能存在安全隐患，是否继续？")
            var networkStatus = WYNetworkStatus.unknown
            var actions = openSeting ? [WYLocalizedString("去设置"), WYLocalizedString(WYLocalizedString("继续连接")), WYLocalizedString("取消连接")] : [WYLocalizedString("继续连接"), WYLocalizedString("取消连接")]
            switch status {

            case .unknown:
                message = WYLocalizedString("未知的网络，可能存在安全隐患，是否继续？")
                networkStatus = .unknown
                actions = openSeting ? [WYLocalizedString("去设置"), WYLocalizedString("继续连接"), WYLocalizedString("取消连接")] : [WYLocalizedString("继续连接"), WYLocalizedString("取消连接")]
                break
            case .notReachable:
                message = WYLocalizedString("不可用的网络，请确认您的网络环境或网络连接权限已正确设置")
                networkStatus = .notReachable
                actions = openSeting ? [WYLocalizedString("去设置"), WYLocalizedString("知道了")] : [WYLocalizedString("知道了")]
                break
            case .reachable:
                if manager!.isReachableOnCellular {

                    message = WYLocalizedString("您正在使用蜂窝移动网络联网")
                    networkStatus = .reachableCellular
                    actions = openSeting ? [WYLocalizedString("去设置"), WYLocalizedString("知道了")] : [WYLocalizedString("知道了")]
                }else {

                    message = WYLocalizedString("您正在使用Wifi联网")
                    networkStatus = .reachableWifi
                    actions = openSeting ? [WYLocalizedString("去设置"), WYLocalizedString("知道了")] : [WYLocalizedString("知道了")]
                }
                break
            }

            if (statusHandler != nil) {

                statusHandler!(networkStatus)
            }

            showNetworkStatusAlert(showStatusAlert: showStatusAlert, status: networkStatus, message: message, actions: actions, actionHandler: actionHandler)
            manager?.stopListening()
        })
    }

    private static func showNetworkStatusAlert(showStatusAlert: Bool, status: WYNetworkStatus, message: String, actions: [String], actionHandler: ((_ action: String, _ status: WYNetworkStatus) -> Void)? = nil) {

        if (showStatusAlert == false) {

            networkSecurityInfo = (WYNetworkStatus.userNotSelectedConnect, "")
            return
        }

        UIAlertController.wy_show(message: message, actions: actions) { (actionStr, _) in

            DispatchQueue.main.async(execute: {

                if (actionHandler != nil) {

                    actionHandler!(actionStr, status)
                }

                if actionStr == WYLocalizedString("去设置") {

                    networkSecurityInfo = (WYNetworkStatus.userNotSelectedConnect, "")

                    let settingUrl = URL(string: UIApplication.openSettingsURLString)
                    if let url = settingUrl, UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(settingUrl!, options: [:], completionHandler: nil)
                    }
                }else if ((actionStr == WYLocalizedString("继续连接")) && (status == .unknown)) {

                    networkSecurityInfo = (WYNetworkStatus.userContinueConnect, "")

                }else if (((actionStr == WYLocalizedString("取消连接")) && (status == .unknown)) || ((actionStr == WYLocalizedString("知道了")) && (status == .notReachable))) {

                    let errorStr = (actionStr == WYLocalizedString("取消连接")) ? WYLocalizedString("已取消不安全网络连接") : WYLocalizedString("无网络连接，请检查您的网络设置")
                    networkSecurityInfo = (WYNetworkStatus.userCancelConnect, errorStr)

                    cancelAllRequest()
                    
                }else {

                    networkSecurityInfo = (WYNetworkStatus.userNotSelectedConnect, "")
                }
            })
        }
    }

    /// DEBUG打印日志
    public static func networkPrint(_ messages: Any..., file: String = #file, function: String = #function, line: Int = #line) {
        #if DEBUG
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        let time = timeFormatter.string(from: Date())
        let message = messages.compactMap { "\($0)" }.joined(separator: " ")
        print("\n【\((file as NSString).lastPathComponent) ——> \(function) ——> line:\(line) ——> time:\(time)】\n\n \(message)\n\n\n")
        #endif
    }
}
