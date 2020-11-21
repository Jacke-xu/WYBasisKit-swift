//
//  WYAuthorize.swift
//  WYBasisKit
//
//  Created by jacke·xu on 2020/8/29.
//  Copyright © 2020 jacke-xu. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

/// 判断相机权限
func wy_authorizeCameraAccess(showAlert: Bool = true, handler:((_ authorized: Bool) -> Void)?) {
    
    let authStatus = AVCaptureDevice.authorizationStatus(for: .video)
    
    switch authStatus {
    case .notDetermined:
        /// 用户尚未授权(弹出授权提示)
        PHPhotoLibrary.requestAuthorization { (status) in

            if status == .authorized {
                /// 用户授权访问
                handler?(true)
            }else {

                /// App无权访问相机 用户已明确拒绝
                wy_showAuthorizeAlert(show: showAlert, message: WYLocalizedString("App没有访问相机的权限，现在去授权?"))
                handler?(false)
            }
        }

    case .authorized:
        /// 可以访问
        handler?(true)
    default:
        /// App无权访问相机 用户已明确拒绝
        wy_showAuthorizeAlert(show: showAlert, message: WYLocalizedString("App没有访问相机的权限，现在去授权?"))
        handler?(false)
    }
}

/// 判断相册权限
func wy_authorizeAlbumAccess(showAlert: Bool = true, handler:((_ authorized: Bool) -> Void)?) {
    
    let authStatus = PHPhotoLibrary.authorizationStatus()
    
    switch authStatus {
    case .notDetermined:
        /// 用户尚未授权(弹出授权提示)
        PHPhotoLibrary.requestAuthorization { (status) in

            if status == .authorized {
                /// 用户授权访问
                handler?(true)
            }else {

                /// App无权访问照片库 用户已明确拒绝
                wy_showAuthorizeAlert(show: showAlert, message: WYLocalizedString("App没有访问相册的权限，现在去授权?"))
                handler?(false)
            }
        }

    case .authorized:
        /// 可以访问
        handler?(true)
    default:
        /// App无权访问相册 用户已明确拒绝
        wy_showAuthorizeAlert(show: showAlert, message: WYLocalizedString("App没有访问相册的权限，现在去授权?"))
        handler?(false)
    }
}

/// 弹出授权弹窗
private func wy_showAuthorizeAlert(show: Bool, message: String) {

    if show {

        UIAlertController.wy_show(message: message, actions: [WYLocalizedString("取消"), WYLocalizedString("去授权")]) { (actionStr, _) in

            DispatchQueue.main.async {

                if actionStr == WYLocalizedString("去授权") {

                    let settingUrl = URL(string: UIApplication.openSettingsURLString)
                    if let url = settingUrl, UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(settingUrl!, options: [:], completionHandler: nil)
                    }
                }
            }
        }
    }
}
