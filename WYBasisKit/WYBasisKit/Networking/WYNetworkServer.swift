//
//  WYNetworkServer.swift
//  WYBasisKit
//
//  Created by jacke·xu on 2020/8/29.
//  Copyright © 2020 jacke·xu. All rights reserved.
//

import Moya
import Alamofire

struct WYRequest {
    
    var method: HTTPMethod
    var baseURL: String
    var path: String
    var headers: [String : String]?
    var parameters: [String: Any]
    
    init(method: HTTPMethod = .post, baseURL: String = "", path: String = "", headers: [String : String]? = ["Content-Type":"application/x-www-form-urlencoded; charset=utf-8"], parameters: [String : Any]?) {
        
        self.method = method
        self.baseURL = baseURL
        self.path = path
        self.headers = headers
        self.parameters = parameters ?? [:]
    }
}

struct WYTarget: TargetType {
    
    init(request: WYRequest) {
        
        /// 设置超时时间
        Moya.Session.default.session.configuration.timeoutIntervalForRequest = 10
        self.request = request
    }
    
    var request: WYRequest
    
    var baseURL: URL {
        
        return URL(string: request.baseURL)!
    }
    
    var path: String {
        
        return request.path
    }
    
    var method: Moya.Method {
        
        return request.method
    }
    
    var sampleData: Data {
        
        return "".data(using: .utf8)!
    }
    
    var task: Task {
        
        return .requestParameters(parameters: request.parameters, encoding: URLEncoding.default)
    }
    
    var headers: [String : String]? {
        
        return request.headers
    }
}
