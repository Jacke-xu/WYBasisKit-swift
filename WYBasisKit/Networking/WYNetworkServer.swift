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
    /// 任务类型
    var taskMethod: WYTaskMethod
    /// 要上传的文件
    var files: [WYFileModel] = []
    
    init(method: HTTPMethod, taskMethod: WYTaskMethod, domain: String, path: String, headers: [String : String]?, parameters: [String : Any], files: [WYFileModel] = []) {
        
        self.method = method
        self.taskMethod = taskMethod
        self.domain = domain
        self.path = path
        self.headers = headers
        self.parameters = parameters
        self.files = files
    }
}

struct WYTarget: TargetType {
    
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
        case .data:
            return .requestParameters(parameters: request.parameters, encoding: URLEncoding.default)
        case .upload:
            
            var multiparts: [Moya.MultipartFormData] = []
            for fileModel in request.files {
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
