//
//  WYBiometric.swift
//  WYBasisKit
//
//  Created by jacke·xu on 2020/8/29.
//  Copyright © 2020 jacke-xu. All rights reserved.
//

import Foundation
import LocalAuthentication

public enum WYBiometricType {
    case none
    case touchID
    case faceID
}

/// 获取设备支持的生物识别类型
public func wy_checkBiometric() -> WYBiometricType {

    var biometric = WYBiometricType.none

    //该参数必须在canEvaluatePolicy方法后才有值
    let authContent = LAContext()
    var error: NSError?
    if authContent.canEvaluatePolicy(
    .deviceOwnerAuthenticationWithBiometrics,
    error: &error) {
        //iPhoneX出厂最低系统版本号：iOS11.0.0
        if #available(iOS 11.0, *) {
            if authContent.biometryType == .faceID {
                biometric = .faceID
            }else if authContent.biometryType == .touchID {
                biometric = .touchID
            }else {
                biometric = .none
            }
        } else {
            guard let laError = error as? LAError else {
                
                biometric = .none
                return biometric
            }
            if laError.code != .touchIDNotAvailable {
                biometric = .touchID
            }
        }
    }

    return biometric
}

/// 验证生物识别
public func wy_verifyBiometrics(localizedFallbackTitle: String = "", localizedReason: String, handler:((_ isBackupHandler: Bool ,_ isSuccess: Bool, _ error: String) -> Void)?) {

        let authContent = LAContext()

        //如果为空不展示输入密码的按钮
        authContent.localizedFallbackTitle = localizedFallbackTitle

        var error: NSError?
        /*
          LAPolicy有2个参数：
          用TouchID/FaceID验证，如果连续出错则需要锁屏验证手机密码，
          但是很多app都是用这个参数，等需要输入密码解锁touchId&faceId再弃用该参数。
          优点：用户在单次使用后就可以取消验证。
          1，deviceOwnerAuthenticationWithBiometrics

          用TouchID/FaceID或密码验证, 默认是错误两次或锁定后, 弹出输入密码界面
          等错误次数过多验证被锁时启用该参数
          2，deviceOwnerAuthentication

        */
        if authContent.canEvaluatePolicy (.deviceOwnerAuthenticationWithBiometrics, error: &error) {

            authContent.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: localizedReason) { (success, error) in

                if success {

                    // evaluatedPolicyDomainState 只有生物验证成功才会有值
                    if let _ = authContent.evaluatedPolicyDomainState {

                        // 如果不放在主线程回调可能会有5-6s的延迟
                        DispatchQueue.main.async {
                            handler!(false, true, "")
                        }

                    }else {

                        DispatchQueue.main.async {
                            // 设备密码输入正确
                            //wy_print("设备密码输入正确")
                            handler!(false, true, "")
                        }
                    }

                }else {

                    guard let laError = error as? LAError else {

                        // 生物识别不可用
                        DispatchQueue.main.async {
                            
                            //wy_print("生物识别不可用")
                            handler!(false, false, WYLocalizedString("生物识别不可用"))
                        }
                        return
                    }

                    switch laError.code {
                    case .authenticationFailed:
                        
                        DispatchQueue.main.async {
                            
                            wy_unlockLocalAuth { (_success) in

                                DispatchQueue.main.async {

                                    if _success == true {

                                        handler!(false, true, "")
                                    }else {

                                        // 生物识别已被锁定，锁屏并成功解锁iPhone后可重新打开本页面开启
                                        //wy_print("生物识别已被锁定，锁屏并成功解锁iPhone后可重新打开本页面开启")
                                        handler!(false, false, WYLocalizedString("生物识别已被锁定，锁屏并成功解锁设备后重新打开本页面即可重新开启"))
                                    }
                                }
                            }
                        }
                    case .userCancel:
                        DispatchQueue.main.async {
                            
                            // 用户点击取消按钮
                            handler!(false, false, "")
                        }
                    case .userFallback:
                        DispatchQueue.main.async {
                            // 用户点击了输入密码按钮，在这里处理点击事件"
                            handler!(true, false, "")
                        }
                    case .systemCancel:
                        
                        // 系统取消
                        DispatchQueue.main.async {
                            
                            //wy_print("系统取消")
                            handler!(false, false, WYLocalizedString("系统中断了本次识别"))
                        }
                    case .passcodeNotSet:
                        
                        // 用户未设置解锁密码
                        DispatchQueue.main.async {
                            
                            //wy_print("用户未设置解锁密码")
                            handler!(false, false, WYLocalizedString("生物识别前请设置解锁密码"))
                        }
                    case .touchIDNotAvailable:
                        
                        // 生物识别不可用
                        DispatchQueue.main.async {
                            
                            //wy_print("生物识别不可用")
                            handler!(false, false, WYLocalizedString("生物识别不可用"))
                        }
                    case .touchIDNotEnrolled:
                        
                        // 未设置生物识别
                        DispatchQueue.main.async {
                            
                            //wy_print("未设置生物识别")
                            handler!(false, false, WYLocalizedString("请在设备设置中开启/设置生物识别功能"))
                        }
                    case .touchIDLockout:
                        
                        // 生物识别已被锁定，锁屏并成功解锁iPhone后可重新打开本页面开启
                        DispatchQueue.main.async {
                            
                            //wy_print("生物识别已被锁定，锁屏并成功解锁iPhone后可重新打开本页面开启")
                            handler!(false, false, WYLocalizedString("生物识别已被锁定，锁屏并成功解锁设备后重新打开本页面即可重新开启"))
                        }
                    default:break
                    }
                }
            }

        }else {

            // 生物识别已被锁定，锁屏并成功解锁iPhone后可重新打开本页面开启
            DispatchQueue.main.async {
                
                //wy_print("生物识别已被锁定，锁屏并成功解锁iPhone后可重新打开本页面开启")
                handler!(false, false, WYLocalizedString("生物识别已被锁定，锁屏并成功解锁设备后重新打开本页面即可重新开启"))
            }
        }
}

/// 解锁生物识别
public func wy_unlockLocalAuth(handler:((_ isSuccess: Bool) -> Void)?) {

    let passwordContent = LAContext()
    var error: NSError?
    if passwordContent.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error){
        
        // 输入密码开启生物识别
        passwordContent.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: WYLocalizedString("请输入密码验证生物识别")) { (success, err) in
            if success {
                handler!(true)
            }else{
                handler!(false)
            }
        }

}else {}}
