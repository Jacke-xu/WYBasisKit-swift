//
//  WYNetworkAPI.swift
//  WYBasisKit
//
//  Created by jacke·xu on 2020/8/29.
//  Copyright © 2020 jacke·xu. All rights reserved.
//

import Foundation

///所有的网络请求的地址
struct WYNetworkAPI {
    
    ///基础API地址
    static let API_base = "https://test........."
    
    ///获取短信验证码
    static let API_sms = API_base + "service=Sms.SmsSendCode"
}
