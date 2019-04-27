//
//  NetworkAPI.swift
//  WYBasisKit
//
//  Created by jacke-xu on 2019/4/9.
//  Copyright © 2019 jacke-xu. All rights reserved.
//

import Foundation

///所有的网络请求的地址
struct NetworkAPI {
    
    ///基础API地址
    static let API_base = "https://test........."
    
    ///获取s短信验证码
    static let API_sms = API_base + "service=Sms.SmsSendCode"
}

