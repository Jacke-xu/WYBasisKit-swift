//
//  WYNetworkManager.swift
//  WYBasisKit
//
//  Created by jacke·xu on 2020/8/29.
//  Copyright © 2020 jacke·xu. All rights reserved.
//

import Moya
import Alamofire
import HandyJSON

enum WYServerCode: Int {
    
    /// 成功
    case success = 200
    /// 报错
    case error = 201
    /// 余额不足
    case notMoney = 203
    /// 未登录
    case notLogin = 204
}

enum WYFileType {
    
    /// 上传图片
    case image
    /// 上传音频
    case audio
    /// 上传视频
    case video
    /// URL路径上传
    case urlPath
}

class WYResponse: HandyJSON {
    
    var msg: String? = ""
    var code: Int = 200
    var data: Any?
    
    required init() {}
}

class WYResponseInfo: HandyJSON {
    
    required init() {}
}

class WYFileModel: HandyJSON {
    
    /**
     *  上传的文件的上传后缀(选传项，例如，JPEG图像的MIME类型是image/jpeg，具体参考http://www.iana.org/assignments/media-types/.)
     *  可根据具体的上传文件类型自由设置，默认上传图片时设置为image/jpeg，上传音频时设置为audio/aac，上传视频时设置为video/mp4，上传url时设置为application/octet-stream
     */
    private var _mimeType: String = ""
    var mimeType: String {
        
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
    var fileName: String = ""
    
    /// 上传的文件的文件夹名字(选传项)
    var folderName: String = "file"
    
    ///上传图片压缩比例(选传项，0~1.0区间，1.0代表无损，默认无损)
    private var _compressionQuality: CGFloat = 1.0
    var compressionQuality: CGFloat {
        
        set {
            _compressionQuality = ((newValue > 1.0) || (newValue <= 0.0)) ? 1.0 : newValue
        }
        get {
            return _compressionQuality
        }
    }
    
    /// 上传文件的类型(选传项，默认image)
    var fileType: WYFileType = .image
    
    /// 上传的图片
    var image: UIImage? {
        
        willSet {
            
            if ((data == nil) && (newValue != nil)) {
                
                data = newValue!.jpegData(compressionQuality: compressionQuality)
            }
        }
    }
    
    /// 上传的二进制文件
    var data: Data?
    
    /// 上传的资源URL路径
    var fileUrl: String = ""
    
    required init() {}
}

class WYNetworkManager {
    
    enum WYNetworkStatus {
        
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
    
    static let shared = WYNetworkManager()
    
    private var networkSecurityInfo = (WYNetworkStatus.userNotSelectedConnect, "")
    
    func post(domain: String = "", path: String = "", headers: [String : String]? = ["Content-Type":"application/x-www-form-urlencoded; charset=utf-8"], parameters: [String : Any] = [:], originJson: Bool = false, callbackQueue: DispatchQueue = .main, success:((_ response: Any?) -> Void)? = nil, failure:((_ error: String, _ serverCode: WYServerCode) -> Void)? = nil) {
        
        request(method: .post, taskMethod: .data, domain: domain, path: path, headers: headers, parameters: parameters, files: [], originJson: originJson, callbackQueue: callbackQueue, progress: nil, success: success, failure: failure)
    }
    
    func get(domain: String = "", path: String = "", headers: [String : String]? = ["Content-Type":"application/x-www-form-urlencoded; charset=utf-8"], parameters: [String : Any] = [:], originJson: Bool = false, callbackQueue: DispatchQueue = .main, success:((_ response: Any?) -> Void)? = nil, failure:((_ error: String, _ serverCode: WYServerCode) -> Void)? = nil) {
        
        request(method: .get, taskMethod: .data, domain: domain, path: path, headers: headers, parameters: parameters, files: [], originJson: originJson, callbackQueue: callbackQueue, progress: nil, success: success, failure: failure)
    }
    
    func upload(domain: String = "", path: String = "", headers: [String : String]? = ["Content-Type":"application/x-www-form-urlencoded; charset=utf-8"], parameters: [String : Any] = [:], files: [WYFileModel], originJson: Bool = false, callbackQueue: DispatchQueue = .main, progress:((_ progress: Double) -> Void)?, success:((_ response: Any?) -> Void)?, failure:((_ error: String, _ serverCode: WYServerCode) -> Void)?) {
        
        request(method: .post, taskMethod: .upload, domain: domain, path: path, headers: headers, parameters: parameters, files: files, originJson: originJson, callbackQueue: callbackQueue, progress: progress, success: success, failure: failure)
    }
    
    private func request(method: HTTPMethod, taskMethod: WYTaskMethod, domain: String, path: String, headers: [String : String]?, parameters: [String : Any], files: [WYFileModel], originJson: Bool, callbackQueue: DispatchQueue, progress:((_ progress: Double) -> Void)?, success:((_ response: Any?) -> Void)?, failure:((_ error: String, _ serverCode: WYServerCode) -> Void)?) {
        
        self.checkNetworkStatus {[weak self] (statusInfo) in
            
            if (statusInfo.0 == .userCancelConnect) {
                
                self?.handlerFailure(error: statusInfo.1.wy_emptyStr(), failure: failure)
                
            }else {
                
                let request = WYRequest(method: method, taskMethod: taskMethod, domain: domain, path: path, headers: headers, parameters: parameters, files: files)
                let target = WYTarget(request: request)
                
                self?.request(target: target, originJson: originJson, callbackQueue: callbackQueue, progress: progress, success: success, failure: failure)
            }
        }
    }
    
    private func request(target: WYTarget, originJson: Bool, callbackQueue: DispatchQueue = .main, progress:((_ progress: Double) -> Void)? = nil, success:((_ response: Any?) -> Void)? = nil, failure:((_ error: String, _ serverCode: WYServerCode) -> Void)? = nil) {
        
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
                
                if statusCode != 200 {
                    
                    self?.handlerFailure(error: WYLocalizedString("数据请求失败，状态码")+"：\(statusCode)", failure: failure)
                    
                }else {
                    
                    do {
                        
                        //let responseData = try response.mapJSON()  也可以更改下返回值类型，直接把这个返回出去
                        
                        //wy_print("接口：\(target.baseURL)\(target.path)\n 请求头：\(target.headers ?? [:])\n 参数：\(target.request.parameters))\n 返回数据：\(try response.mapJSON())")
                        
                        let responseData = try WYResponse.deserialize(from: response.mapString())
                        
                        if responseData?.code == 200 {
                            
                            self?.handlerSuccess(response: (originJson == true) ? try response.mapJSON() : responseData?.data, success: success)
                            
                        }else {
                            
                            self?.handlerFailure(error: responseData?.msg ?? "", serverCode: WYServerCode(rawValue: responseData!.code)!, failure: failure)
                        }
                        
                    } catch  {
                        
                        self?.handlerFailure(error: error.localizedDescription.wy_emptyStr(), failure: failure)
                    }
                }
                break
                
            case .failure(let error):
                
                self?.handlerFailure(error: error.localizedDescription.wy_emptyStr(), failure: failure)
                
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
    
    private func handlerFailure(error: String, serverCode: WYServerCode = .error, failure:((_ error: String, _ serverCode: WYServerCode) -> Void)? = nil) {
        
        DispatchQueue.main.async {
        
            if (failure != nil) {
                
                failure!(error.wy_emptyStr(), serverCode)
            }
            // 关闭状态栏动画
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
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
    
    func networkStatus(showStatusAlert: Bool, openSeting: Bool, statusHandler:((_ status: WYNetworkStatus) -> Void)? = nil, actionHandler:((_ action: String, _ status: WYNetworkStatus) -> Void)? = nil) {
        
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
}
