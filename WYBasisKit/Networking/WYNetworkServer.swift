//
//  WYNetworkServer.swift
//  WYBasisKit
//
//  Created by Jacke·xu on 2020/8/29.
//  Copyright © 2020 Jacke·xu. All rights reserved.
//

import Moya
import Alamofire

struct WYRequest {
    
    /// 请求方式
    var method: HTTPMethod
    /// 接口域名
    var domain: String
    /// 接口路径
    var path: String
    /// 请求头
    var headers: [String : String]?
    /// 参数
    var parameters: [String: Any]
    /// 自定义data
    var data: Data?
    /// 任务类型
    var taskMethod: WYTaskMethod
    /// 要上传的文件
    var files: [WYFileModel] = []
    
    init(method: HTTPMethod, taskMethod: WYTaskMethod, domain: String, path: String, headers: [String : String]?, data: Data?, parameters: [String : Any], files: [WYFileModel] = []) {
        
        self.method = method
        self.taskMethod = taskMethod
        self.domain = domain
        self.path = path
        self.headers = headers
        self.data = data
        self.parameters = parameters
        self.files = files
    }
}

let requestProvider = { (endpoint: Endpoint, done: @escaping MoyaProvider<WYProvider>.RequestResultClosure) in
    
    do {
        var request: URLRequest = try endpoint.urlRequest()
        /// 设置请求超时时间
        request.timeoutInterval = WYNetworkConfig.timeoutIntervalForRequest
        done(.success(request))
    } catch  {
        return
    }
}

let WYTargetProvider = MoyaProvider<WYProvider>(requestClosure: requestProvider)

struct WYProvider: TargetType {
    
    init(request: WYRequest) {
        self.request = request
    }
    
    var request: WYRequest
    
    var baseURL: URL {
        return URL(string: request.domain)!
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
        
        switch request.taskMethod {
        case .parameters:
            return .requestParameters(parameters: request.parameters, encoding: URLEncoding.default)
        case .data:
            return .requestCompositeData(bodyData: request.data!, urlParameters: request.parameters)
        case .upload:
            var multiparts: [Moya.MultipartFormData] = []
            for var fileModel in request.files {
                switch fileModel.fileType {
                case .urlPath:
                    if let multipart = try? MultipartFormData(provider: .data(Data(contentsOf: URL(fileURLWithPath: fileModel.fileUrl))), name: fileModel.folderName, fileName: fileModel.fileName, mimeType: fileModel.mimeType) {
                        multiparts.append(multipart)
                    }
                default:
                    let multipart = MultipartFormData(provider: .data(fileModel.data!), name: fileModel.folderName, fileName: fileModel.fileName, mimeType: fileModel.mimeType)
                    multiparts.append(multipart)
                }
            }
            return .uploadCompositeMultipart(multiparts, urlParameters: request.parameters)
        }
    }
    
    var headers: [String : String]? {
        return request.headers
    }
}
