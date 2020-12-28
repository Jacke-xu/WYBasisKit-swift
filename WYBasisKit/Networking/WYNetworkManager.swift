//
//  WYNetworkManager.swift
//  WYBasisKit
//
//  Created by jacke·xu on 2020/8/29.
//  Copyright © 2020 jacke·xu. All rights reserved.
//

/* 常见的HTTP状态码(HTTP Status Code)
 
 2开头 （请求成功）表示成功处理了请求的状态代码。
 200   （成功）  服务器已成功处理了请求。 通常，这表示服务器提供了请求的网页。
 201   （已创建）  请求成功并且服务器创建了新的资源。
 202   （已接受）  服务器已接受请求，但尚未处理。
 203   （非授权信息）  服务器已成功处理了请求，但返回的信息可能来自另一来源。
 204   （无内容）  服务器成功处理了请求，但没有返回任何内容。
 205   （重置内容） 服务器成功处理了请求，但没有返回任何内容。
 206   （部分内容）  服务器成功处理了部分 GET 请求。
 
 3开头 （请求被重定向）表示要完成请求，需要进一步操作。 通常，这些状态代码用来重定向。
 300   （多种选择）  针对请求，服务器可执行多种操作。 服务器可根据请求者 (user agent) 选择一项操作，或提供操作列表供请求者选择。
 301   （永久移动）  请求的网页已永久移动到新位置。 服务器返回此响应（对 GET 或 HEAD 请求的响应）时，会自动将请求者转到新位置。
 302   （临时移动）  服务器目前从不同位置的网页响应请求，但请求者应继续使用原有位置来进行以后的请求。
 303   （查看其他位置） 请求者应当对不同的位置使用单独的 GET 请求来检索响应时，服务器返回此代码。
 304   （未修改） 自从上次请求后，请求的网页未修改过。 服务器返回此响应时，不会返回网页内容。
 305   （使用代理） 请求者只能使用代理访问请求的网页。 如果服务器返回此响应，还表示请求者应使用代理。
 307   （临时重定向）  服务器目前从不同位置的网页响应请求，但请求者应继续使用原有位置来进行以后的请求。
 
 4开头 （请求错误）这些状态代码表示请求可能出错，妨碍了服务器的处理。
 400   （错误请求） 服务器不理解请求的语法。
 401   （未授权） 请求要求身份验证。 对于需要登录的网页，服务器可能返回此响应。
 403   （禁止） 服务器拒绝请求。
 404   （未找到） 服务器找不到请求的网页。
 405   （方法禁用） 禁用请求中指定的方法。
 406   （不接受） 无法使用请求的内容特性响应请求的网页。
 407   （需要代理授权） 此状态代码与 401（未授权）类似，但指定请求者应当授权使用代理。
 408   （请求超时）  服务器等候请求时发生超时。
 409   （冲突）  服务器在完成请求时发生冲突。 服务器必须在响应中包含有关冲突的信息。
 410   （已删除）  如果请求的资源已永久删除，服务器就会返回此响应。
 411   （需要有效长度） 服务器不接受不含有效内容长度标头字段的请求。
 412   （未满足前提条件） 服务器未满足请求者在请求中设置的其中一个前提条件。
 413   （请求实体过大） 服务器无法处理请求，因为请求实体过大，超出服务器的处理能力。
 414   （请求的 URI 过长） 请求的 URI（通常为网址）过长，服务器无法处理。
 415   （不支持的媒体类型） 请求的格式不受请求页面的支持。
 416   （请求范围不符合要求） 如果页面无法提供请求的范围，则服务器会返回此状态代码。
 417   （未满足期望值） 服务器未满足"期望"请求标头字段的要求。
 
 5开头（服务器错误）这些状态代码表示服务器在尝试处理请求时发生内部错误。 这些错误可能是服务器本身的错误，而不是请求出错。
 500   （服务器内部错误）  服务器遇到错误，无法完成请求。
 501   （尚未实施） 服务器不具备完成请求的功能。 例如，服务器无法识别请求方法时可能会返回此代码。
 502   （错误网关） 服务器作为网关或代理，从上游服务器收到无效响应。
 503   （服务不可用） 服务器目前无法使用（由于超载或停机维护）。 通常，这只是暂时状态。
 504   （网关超时）  服务器作为网关或代理，但是没有及时从上游服务器收到请求。
 505   （HTTP 版本不受支持） 服务器不支持请求中所用的 HTTP 协议版本。
 */

import Moya
import Alamofire
import HandyJSON

public class WYResponse: HandyJSON {
    
    public var message: String? = ""
    public var msg: String? = ""
    public var code: Int = WYNetworkConfig.serverRequestSuccessCode
    public var data: Any?
    
    required public init() {}
}

public class WYFileModel: HandyJSON {
    
    /**
     *  上传的文件的上传后缀(选传项，例如，JPEG图像的MIME类型是image/jpeg，具体参考http://www.iana.org/assignments/media-types/.)
     *  可根据具体的上传文件类型自由设置，默认上传图片时设置为image/jpeg，上传音频时设置为audio/aac，上传视频时设置为video/mp4，上传url时设置为application/octet-stream
     */
    private var _mimeType: String = ""
    public var mimeType: String {
        
        set {
            _mimeType = newValue
        }
        get {
            
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
            }
        }
    }
    
    /// 上传的二进制文件
    public var data: Data?
    
    /// 上传的资源URL路径
    public var fileUrl: String = ""
    
    required public init() {}
}

public class WYNetworkManager {
    
    public static let shared = WYNetworkManager()
    
    private var networkSecurityInfo = (WYNetworkStatus.userNotSelectedConnect, "")
    
    public func post(taskMethod: WYTaskMethod = .parameters, domain: String = WYNetworkConfig.currentDomainPath, path: String = "", headers: [String : String]? = WYNetworkConfig.requestHeaders, data: Data? = nil, parameters: [String : Any] = [:], originJson: Bool = false, callbackQueue: DispatchQueue = .main, success:((_ response: Any?) -> Void)? = nil, failure:((_ error: String, _ serverCode: Int) -> Void)? = nil) {
        
        request(method: .post, taskMethod: taskMethod, domain: domain, path: path, headers: headers, data: data, parameters: parameters, files: [], originJson: originJson, callbackQueue: callbackQueue, progress: nil, success: success, failure: failure)
    }
    
    public func get(taskMethod: WYTaskMethod = .parameters, domain: String = WYNetworkConfig.currentDomainPath, path: String = "", headers: [String : String]? = WYNetworkConfig.requestHeaders, data: Data? = nil, parameters: [String : Any] = [:], originJson: Bool = false, callbackQueue: DispatchQueue = .main, success:((_ response: Any?) -> Void)? = nil, failure:((_ error: String, _ serverCode: Int) -> Void)? = nil) {
        
        request(method: .get, taskMethod: taskMethod, domain: domain, path: path, headers: headers, data: data, parameters: parameters, files: [], originJson: originJson, callbackQueue: callbackQueue, progress: nil, success: success, failure: failure)
    }
    
    public func upload(domain: String = WYNetworkConfig.currentDomainPath, path: String = "", headers: [String : String]? = WYNetworkConfig.requestHeaders, parameters: [String : Any] = [:], files: [WYFileModel], originJson: Bool = false, callbackQueue: DispatchQueue = .main, progress:((_ progress: Double) -> Void)?, success:((_ response: Any?) -> Void)?, failure:((_ error: String, _ serverCode: Int) -> Void)?) {
        
        request(method: .post, taskMethod: .upload, domain: domain, path: path, headers: headers, data: nil, parameters: parameters, files: files, originJson: originJson, callbackQueue: callbackQueue, progress: progress, success: success, failure: failure)
    }
    
    private func request(method: HTTPMethod, taskMethod: WYTaskMethod, domain: String, path: String, headers: [String : String]?, data: Data?, parameters: [String : Any], files: [WYFileModel], originJson: Bool, callbackQueue: DispatchQueue, progress:((_ progress: Double) -> Void)?, success:((_ response: Any?) -> Void)?, failure:((_ error: String, _ serverCode: Int) -> Void)?) {
        
        self.checkNetworkStatus {[weak self] (statusInfo) in
            
            if (statusInfo.0 == .userCancelConnect) {
                
                self?.handlerFailure(error: statusInfo.1, serverCode: WYNetworkConfig.networkServerFailCode, failure: failure)
                
            }else {
                
                let request = WYRequest(method: method, taskMethod: taskMethod, domain: domain, path: path, headers: headers, data: data, parameters: parameters, files: files)
                let target = WYTarget(request: request)
                
                self?.request(target: target, originJson: originJson, callbackQueue: callbackQueue, progress: progress, success: success, failure: failure)
            }
        }
    }
    
    private func request(target: WYTarget, originJson: Bool, callbackQueue: DispatchQueue = .main, progress:((_ progress: Double) -> Void)? = nil, success:((_ response: Any?) -> Void)? = nil, failure:((_ error: String, _ serverCode: Int) -> Void)? = nil) {
        
        /// 设置超时时间
        Moya.Session.default.session.configuration.timeoutIntervalForRequest = WYNetworkConfig.timeoutIntervalForRequest
        
        // 开启状态栏动画
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        MoyaProvider<WYTarget>().request(target, callbackQueue: callbackQueue) { (progressResponse) in
            
            if progress != nil {
                
                progress!(progressResponse.progress)
            }
            
        } completion: {[weak self] (result) in
            
            switch result {
                
            case .success(let response):
                
                let statusCode = response.statusCode
                
                if statusCode != wy_serverRequestSuccessCode {
                    
                    self?.showDebugModeLog(target: target, response: response, function: #function, line: #line)

                    self?.handlerFailure(error: WYLocalizedString("数据请求失败"), serverCode: statusCode, failure: failure)
                    
                }else {
                    
                    do {
                        
                        //let responseData = try response.mapJSON()  也可以更改下返回值类型，直接把这个返回出去

                        let responseData = try WYResponse.deserialize(from: response.mapString())
                        
                        if responseData?.code == WYNetworkConfig.serverRequestSuccessCode {
                            
                            self?.showDebugModeLog(target: target, response: response, function: #function, line: #line)
                            
                            self?.handlerSuccess(response: (originJson == true) ? try response.mapJSON() : responseData?.data, success: success)
                            
                        }else {
                            
                            self?.showDebugModeLog(target: target, response: response, function: #function, line: #line)
                            
                            self?.handlerFailure(error: (responseData?.msg ?? responseData?.message) ?? WYLocalizedString("未知错误，接口message返回为空"), serverCode: responseData?.code ?? WYNetworkConfig.otherServerFailCode, failure: failure)
                        }
                        
                    } catch  {
                        
                        self?.showDebugModeLog(target: target, response: response, function: #function, line: #line)

                        self?.handlerFailure(error: error.localizedDescription, serverCode: WYNetworkConfig.unpackServerFailCode, failure: failure)
                    }
                }
                break
                
            case .failure(let error):

                self?.showDebugModeLog(target: target, response: Response(statusCode: error.errorCode, data: error.localizedDescription.data(using: .utf8) ?? Data()), function: #function, line: #line)
               
                self?.handlerFailure(error: error.localizedDescription, serverCode: error.errorCode, failure: failure)
                
                break
            }
        }
    }
    
    private func handlerSuccess(response: Any?, success:((_ response: Any?) -> Void)? = nil) {
        
        DispatchQueue.main.async {
        
            if (success != nil) {
                
                success!(response)
            }
            // 关闭状态栏动画
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
    
    private func handlerFailure(error: String, serverCode: Int, failure:((_ error: String, _ serverCode: Int) -> Void)? = nil) {
        
        DispatchQueue.main.async {
        
            if (failure != nil) {
                
                failure!(error, serverCode)
            }
            // 关闭状态栏动画
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
    
    private func showDebugModeLog(target: WYTarget, response: Response, function: String, line: Int) {
        
        guard WYNetworkConfig.debugModeLog == true else { return }
        
        wy_networkPrint("接口：\(target.baseURL)\(target.path)\n 请求头：\(target.headers ?? [:])\ndata:\(target.request.data?.mapJSON() ?? "")\n 参数：\(target.request.parameters))\n 返回数据：\(String(describing: try? response.mapJSON()))", function: function, line: line)
    }
    
    private func checkNetworkStatus(handler: ((_ status: (WYNetworkStatus, String)) -> Void)? = nil) {
        
        self.networkStatus(showStatusAlert: false, openSeting: true, statusHandler: {[weak self] (status) in
            
            DispatchQueue.main.async {
                
                if ((status == .unknown) || (status == .notReachable)) {
                    
                    if (self?.networkSecurityInfo.0 == .userNotSelectedConnect) {
                        
                        self?.networkStatus(showStatusAlert: true, openSeting: true, actionHandler: { (actionStr, networkStatus) in
                            
                            DispatchQueue.main.async {
                                
                                if (actionStr == WYLocalizedString("继续连接")) {
                                    
                                    if (handler != nil) {
                                        
                                        handler!((.userContinueConnect, ""))
                                    }
                                    
                                }else if ((actionStr == WYLocalizedString("取消连接")) || (actionStr == WYLocalizedString("知道了"))) {
                                    
                                    if (handler != nil) {
                                        
                                        handler!((self!.networkSecurityInfo.0, self!.networkSecurityInfo.1))
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
                            
                            handler!((self!.networkSecurityInfo.0, self!.networkSecurityInfo.1))
                        }
                    }
                    
                }else {
                    
                    self?.networkStatus(showStatusAlert: false, openSeting: true, statusHandler: { (_) in
                        
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
    
    public func networkStatus(showStatusAlert: Bool, openSeting: Bool, statusHandler:((_ status: WYNetworkStatus) -> Void)? = nil, actionHandler:((_ action: String, _ status: WYNetworkStatus) -> Void)? = nil) {
        
        let manager = NetworkReachabilityManager()
        manager!.startListening(onQueue: .main, onUpdatePerforming: {[weak self] (status) in
            
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
            
            self?.showNetworkStatusAlert(showStatusAlert: showStatusAlert, status: networkStatus, message: message, actions: actions, actionHandler: actionHandler)
            manager?.stopListening()
        })
    }
    
    private func showNetworkStatusAlert(showStatusAlert: Bool, status: WYNetworkStatus, message: String, actions: [String], actionHandler: ((_ action: String, _ status: WYNetworkStatus) -> Void)? = nil) {
        
        if (showStatusAlert == false) {
            
            self.networkSecurityInfo = (WYNetworkStatus.userNotSelectedConnect, "")
            return
        }
        
        UIAlertController.wy_show(message: message, actions: actions) { (actionStr, _) in
            
            DispatchQueue.main.async(execute: {
                
                if (actionHandler != nil) {
                    
                    actionHandler!(actionStr, status)
                }

                if actionStr == WYLocalizedString("去设置") {
                    
                    self.networkSecurityInfo = (WYNetworkStatus.userNotSelectedConnect, "")
                    
                    let settingUrl = URL(string: UIApplication.openSettingsURLString)
                    if let url = settingUrl, UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(settingUrl!, options: [:], completionHandler: nil)
                    }
                }else if ((actionStr == WYLocalizedString("继续连接")) && (status == .unknown)) {
                    
                    self.networkSecurityInfo = (WYNetworkStatus.userContinueConnect, "")
                    
                }else if (((actionStr == WYLocalizedString("取消连接")) && (status == .unknown)) || ((actionStr == WYLocalizedString("知道了")) && (status == .notReachable))) {
                    
                    let errorStr = (actionStr == WYLocalizedString("取消连接")) ? WYLocalizedString("已取消不安全网络连接") : WYLocalizedString("无网络连接，请检查您的网络设置")
                    self.networkSecurityInfo = (WYNetworkStatus.userCancelConnect, errorStr)
                
                    Moya.Session.default.session.getAllTasks { (tasks) in
                        
                        tasks.forEach { (task) in
                            
                            task.cancel()
                        }
                        
                        /*
                         
                         取消指定url的请求
                        
                         if (task.originalRequest?.url?.absoluteString == "http://www.apple.com") {
                             
                             task.cancel()
                         }
                         
                        */
                    }
                }else {
                    
                    self.networkSecurityInfo = (WYNetworkStatus.userNotSelectedConnect, "")
                }
            })
        }
    }
    
    /// DEBUG打印日志
    public func wy_networkPrint(_ messages: Any..., file: String = #file, function: String, line: Int) {
        #if DEBUG
        let message = messages.compactMap { "\($0)" }.joined(separator: " ")
        print("\n【\((file as NSString).lastPathComponent) ——> \(function) ——> line:\(line)】\n\n \(message)\n\n\n")
        #endif
    }
}
