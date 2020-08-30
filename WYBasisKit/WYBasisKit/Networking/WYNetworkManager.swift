//
//  WYNetworkManager.swift
//  WYBasisKit
//
//  Created by jacke·xu on 2020/8/29.
//  Copyright © 2020 jacke·xu. All rights reserved.
//

import Moya
import Alamofire

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
    
    func post(baseURL: String = "", path: String = "", headers: [String : String]? = ["Content-Type":"application/x-www-form-urlencoded; charset=utf-8"], parameters: [String : Any]?, success:((_ response: Any?) -> Void)?, failure:((_ error: String) -> Void)?) {
        
        self.request(method: .post, baseURL: baseURL, path: path, headers: headers, parameters: parameters, success: success, failure: failure)
    }
    
    func get(baseURL: String = "", path: String = "", headers: [String : String]? = ["Content-Type":"application/x-www-form-urlencoded; charset=utf-8"], parameters: [String : Any]?, success:((_ response: Any?) -> Void)?, failure:((_ error: String) -> Void)?) {
        
        self.request(method: .get, baseURL: baseURL, path: path, headers: headers, parameters: parameters, success: success, failure: failure)
    }
    
    func request(method: HTTPMethod, baseURL: String = "", path: String = "", headers: [String : String]? = ["Content-Type":"application/x-www-form-urlencoded; charset=utf-8"], parameters: [String : Any]?, success:((_ response: Any?) -> Void)?, failure:((_ error: String) -> Void)?) {
        
        self.checkNetworkStatus {[weak self] (statusInfo) in
            
            if (statusInfo.0 == .userCancelConnect) {
                
                self?.handlerFailure(error: statusInfo.1.wy_emptyStr(), failure: failure)
                
            }else {
                
                let request = WYRequest(method: method, baseURL: baseURL, path: path, headers: headers, parameters: parameters)
                let target = WYTarget(request: request)
                
                self?.request(target: target, success: success, failure: failure)
            }
        }
    }
    
    private func request(target: WYTarget, success:((_ response: Any?) -> Void)?, failure:((_ error: String) -> Void)?) {
        
        // 开启状态栏动画
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        MoyaProvider<WYTarget>().request(target, callbackQueue: .main) {[weak self] (result) in
            
            switch result {
                
            case .success(let response):
                
                let statusCode = response.statusCode
                
                if statusCode != 200 {

                    self?.handlerFailure(error: "数据请求失败，状态码：\(statusCode)", failure: failure)
                    
                }else {
                    
                    do {
                        
                        let responseData = try response.mapJSON()
                        self?.handlerSuccess(response: responseData, success: success)
                        
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
    
    private func handlerSuccess(response: Any, success:((_ response: Any?) -> Void)?) {
        
        if (success != nil) {
            
            success!(response)
        }
        // 关闭状态栏动画
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    private func handlerFailure(error: String, failure:((_ error: String) -> Void)?) {
        
        if (failure != nil) {
            
            failure!(error.wy_emptyStr())
        }
        // 关闭状态栏动画
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    private func checkNetworkStatus(handler: ((_ status: (WYNetworkStatus, String)) -> Void)?) {
        
        self.networkStatus(showStatusAlert: false, openSeting: true, statusHandler: {[weak self] (status) in
            
            DispatchQueue.main.async {
                
                if ((status == .unknown) || (status == .notReachable)) {
                    
                    if (self?.networkSecurityInfo.0 == .userNotSelectedConnect) {
                        
                        self?.networkStatus(showStatusAlert: true, openSeting: true, actionHandler: { (actionStr, networkStatus) in
                            
                            DispatchQueue.main.async {
                                
                                if (actionStr == "继续连接") {
                                    
                                    if (handler != nil) {
                                        
                                        handler!((.userContinueConnect, ""))
                                    }
                                    
                                }else if ((actionStr == "取消连接") || (actionStr == "知道了")) {
                                    
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
            
            var message = "未知的网络，可能存在安全隐患，是否继续？"
            var networkStatus = WYNetworkStatus.unknown
            var actions = openSeting ? ["去设置", "继续连接", "取消连接"] : ["继续连接", "取消连接"]
            switch status {

            case .unknown:
                message = "未知的网络，可能存在安全隐患，是否继续？"
                networkStatus = .unknown
                actions = openSeting ? ["去设置", "继续连接", "取消连接"] : ["继续连接", "取消连接"]
                break
            case .notReachable:
                message = "不可用的网络，请确认您的网络环境或网络连接权限已正确设置"
                networkStatus = .notReachable
                actions = openSeting ? ["去设置", "知道了"] : ["知道了"]
                break
            case .reachable:
                if manager!.isReachableOnCellular {

                    message = "您正在使用蜂窝移动网络联网"
                    networkStatus = .reachableCellular
                    actions = openSeting ? ["去设置", "知道了"] : ["知道了"]
                }else {

                    message = "您正在使用Wifi联网"
                    networkStatus = .reachableWifi
                    actions = openSeting ? ["去设置", "知道了"] : ["知道了"]
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

                if actionStr == "去设置" {
                    
                    self.networkSecurityInfo = (WYNetworkStatus.userNotSelectedConnect, "")
                    
                    let settingUrl = URL(string: UIApplication.openSettingsURLString)
                    if let url = settingUrl, UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(settingUrl!, options: [:], completionHandler: nil)
                    }
                }else if ((actionStr == "继续连接") && (status == .unknown)) {
                    
                    self.networkSecurityInfo = (WYNetworkStatus.userContinueConnect, "")
                    
                }else if (((actionStr == "取消连接") && (status == .unknown)) || ((actionStr == "知道了") && (status == .notReachable))) {
                    
                    let errorStr = (actionStr == "取消连接") ? "已取消不安全网络连接" : "无网络连接，请检查您的网络设置"
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
