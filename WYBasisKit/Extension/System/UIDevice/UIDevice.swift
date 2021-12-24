//
//  UIDevice.swift
//  WYBasisKit
//
//  Created by Jacke·xu on 2020/8/29.
//  Copyright © 2020 Jacke·xu. All rights reserved.
//

/**
 * 可编译通过的小数点写法 ⒈ ⒉ ⒊ ⒋ ⒌ ⒍ ⒎ ⒏ ⒐ ⒑ ⒒ ⒓ ⒔ ⒕ ⒖ ⒗
 * 参考文库 http://www,xueui,cn/design/142395,html
 */

/**
 * 设备型号identifier
 * 参考文库 https://www,theiphonewiki,com/wiki/Models
 */


import UIKit
import CoreMotion

public extension UIDevice {
    
    /// 设备型号
    var wy_deviceName: String {
        return name
    }
    
    /// 系统名称
    var wy_systemName: String {
        return systemName
    }
    
    /// 系统版本号
    var wy_systemVersion: String {
        return systemVersion
    }
    
    /// 是否是iPhone系列
    var wy_iPhoneSeries: Bool {
        return userInterfaceIdiom == .phone
    }
    
    /// 是否是iPad系列
    var wy_iPadSeries: Bool {
        return userInterfaceIdiom == .pad
    }
    
    /// 是否是模拟器
    var wy_simulatorSeries: Bool {
#if targetEnvironment(simulator)
        return true
#else
        return false
#endif
    }
    
    /// uuid 注意其实uuid并不是唯一不变的
    var wy_uuid: String {
        return identifierForVendor?.uuidString ?? ""
    }
    
    /// 是否使用3x图片
    var wy_use3xAsset: Bool {
        return UIScreen.main.currentMode!.size.width / UIScreen.main.bounds.size.width >= 3 ? true : false
    }
    
    /// 是否是齐刘海手机
    var wy_isBangsScreen: Bool {
        
        guard #available(iOS 11.0, *) else {
            return false
        }
        return UIApplication.shared.windows.first?.safeAreaInsets != UIEdgeInsets.zero
    }
    
    /// 是否是传入的分辨率
    func wy_resolutionRatio(horizontal: CGFloat, vertical: CGFloat) -> Bool {
        return (UIScreen.instancesRespond(to: #selector(getter: UIScreen.main.currentMode)) ? CGSize(width: horizontal, height: vertical).equalTo((UIScreen.main.currentMode?.size)!) && !wy_iPadSeries : false)
    }
    
    /// 是否是竖屏模式
    var wy_verticalScreen: Bool {
        let orientation = UIApplication.shared.statusBarOrientation
        if orientation == UIInterfaceOrientation.portrait || orientation == UIInterfaceOrientation.portraitUpsideDown {
            return true
        } else {
            return false
        }
    }
    
    /// 是否是横屏模式
    var wy_horizontalScreen: Bool {
        let orientation = UIApplication.shared.statusBarOrientation
        if orientation == UIInterfaceOrientation.landscapeLeft || orientation == UIInterfaceOrientation.landscapeRight {
            return true
        } else {
            return false
        }
    }
    
    /// 旋转屏幕，设置界面方向，支持重力感应切换(默认竖屏)
    var wy_interfaceOrientation: UIInterfaceOrientationMask {
        
        set(newValue) {
            
            objc_setAssociatedObject(self, WYAssociatedKeys.privateInterfaceOrientation, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
            releaseMotionManager(newValue)
            
            switch newValue {
            case .portrait:
                UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
                UIViewController.attemptRotationToDeviceOrientation()
                break
            case .landscapeLeft:
                UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue, forKey: "orientation")
                UIViewController.attemptRotationToDeviceOrientation()
                break
            case .landscapeRight:
                UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
                UIViewController.attemptRotationToDeviceOrientation()
                break
            case .portraitUpsideDown:
                UIDevice.current.setValue(UIInterfaceOrientation.portraitUpsideDown.rawValue, forKey: "orientation")
                UIViewController.attemptRotationToDeviceOrientation()
                break
            default:
                rotateScreenOrientationDynamically(newValue)
                break
            }
        }
        get {
            return objc_getAssociatedObject(self, WYAssociatedKeys.privateInterfaceOrientation) as? UIInterfaceOrientationMask ?? .portrait
        }
    }
}

extension UIDevice {
    
    private func rotateScreenOrientationDynamically(_ orientation: UIInterfaceOrientationMask) {
        
        if motionManager == nil {
            motionManager = CMMotionManager()
            motionManager?.accelerometerUpdateInterval = 0.75
        }
        if motionManager!.isAccelerometerAvailable {
            
            motionManager!.startAccelerometerUpdates(to: OperationQueue.current!) { [weak self] (accelerometerData, error) in
                if error != nil {
                    self?.stopMotionManager()
                    wy_print("启用加速传感器出错：\(wy_safe(error?.localizedDescription))")
                }else {
                    
                    let x: Double = accelerometerData!.acceleration.x
                    let y: Double = accelerometerData!.acceleration.y
                    
                    if (fabs(y) >= fabs(x)) {
                        
                        if orientation == .landscape {
                            return
                        }
                        
                        if y >= 0 {
                            if orientation == .allButUpsideDown {
                                return
                            }
                            
                            UIDevice.current.setValue(UIInterfaceOrientation.portraitUpsideDown.rawValue, forKey: "orientation")
                            UIViewController.attemptRotationToDeviceOrientation()
                            
                        } else {

                            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
                            UIViewController.attemptRotationToDeviceOrientation()
                        }
                        
                    }else {
                        
                        if x >= 0 {
                            
                            UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue, forKey: "orientation")
                            UIViewController.attemptRotationToDeviceOrientation()
                            
                        } else{
                            
                            UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
                            UIViewController.attemptRotationToDeviceOrientation()
                        }
                    }
                }
            }
        }else {
            wy_print("当前设备不支持加速传感器")
        }
    }
    
    private func releaseMotionManager(_ newInterfaceOrientation: UIInterfaceOrientationMask) {
        
        if (motionManager != nil) && (newInterfaceOrientation != lastInterfaceOrientation) {
            lastInterfaceOrientation = newInterfaceOrientation
            stopMotionManager()
        }
    }
    
    private func stopMotionManager() {
        
        guard motionManager != nil else {
            return
        }
        
        if motionManager!.isAccelerometerActive {
            motionManager?.stopAccelerometerUpdates()
        }
        motionManager = nil
    }
    
    private var motionManager: CMMotionManager? {
        
        set(newValue) {
            
            objc_setAssociatedObject(self, WYAssociatedKeys.privateMotionManager, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, WYAssociatedKeys.privateMotionManager) as? CMMotionManager
        }
    }
    
    private var lastInterfaceOrientation: UIInterfaceOrientationMask {
        
        set(newValue) {
            
            objc_setAssociatedObject(self, WYAssociatedKeys.privateLastInterfaceOrientation, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, WYAssociatedKeys.privateLastInterfaceOrientation) as? UIInterfaceOrientationMask ?? .portrait
        }
    }
    
    private struct WYAssociatedKeys {
        
        static let privateMotionManager = UnsafeRawPointer(bitPattern: "privateMotionManager".hashValue)!
        
        static let privateInterfaceOrientation = UnsafeRawPointer(bitPattern: "privateInterfaceOrientation".hashValue)!
        
        static let privateLastInterfaceOrientation = UnsafeRawPointer(bitPattern: "privateLastInterfaceOrientation".hashValue)!
    }
}
