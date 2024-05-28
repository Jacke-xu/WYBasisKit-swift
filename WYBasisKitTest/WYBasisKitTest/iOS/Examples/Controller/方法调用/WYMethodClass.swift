//
//  WYMethodClass.swift
//  WYBasisKitTest
//
//  Created by 官人 on 2024/5/13.
//  Copyright © 2024 官人. All rights reserved.
//

import UIKit

/// 申明协议
protocol WYMethodSuperProtocol {
    func callMethodClassEventHandle(_ responseData: String)
}

/// 添加协议扩展，提供默认实现达到可选实现效果
extension WYMethodSuperProtocol {
    func callMethodClassEventHandle(_ responseData: String) {
        wy_print("如果外部没有实现这个协议就会走到这里来,responseData = \(responseData)")
    }
}

struct WYMethodClass: WYMethodSuperProtocol {
    
    func testNoParameterMethod() {
        wy_print("testNoParameterMethod() called")
    }
    
    func testParameterMethod(parameter1: String, parameter2: Int) {
        wy_print("testParameterMethod(parameter1: String, parameter2: Int)  called")
    }
    
    func testParameterMethodWithReturnValue(parameter: String) -> String {
        wy_print("testParameterMethodWithReturnValue(parameter: String) called")
        return "通过 return 方式获取的返回值"
    }
    
    func testParameterMethodWithProtocol(parameter: String) {
        wy_print("testParameterMethodWithProtocol(parameter: String) called")
        callMethodClassEventHandle("通过协议方式获取的返回值")
    }
}
