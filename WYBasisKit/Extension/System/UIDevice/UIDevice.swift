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
import CoreTelephony

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
    
    ///获取CPU核心数
    var wy_numberOfCpuCores: Int {
        var ncpu: UInt = UInt(0)
        var len: size_t = MemoryLayout.size(ofValue: ncpu)
        sysctlbyname("hw.ncpu", &ncpu, &len, nil, 0)
        return Int(ncpu)
    }
    
    ///获取cpu类型
    var wy_cpuType: String {
        
        let HOST_BASIC_INFO_COUNT = MemoryLayout<host_basic_info>.stride/MemoryLayout<integer_t>.stride
        var size = mach_msg_type_number_t(HOST_BASIC_INFO_COUNT)
        var hostInfo = host_basic_info()
        let result = withUnsafeMutablePointer(to: &hostInfo) {
            $0.withMemoryRebound(to: integer_t.self, capacity:Int(size)){
                host_info(mach_host_self(), Int32(HOST_BASIC_INFO), $0, &size)
            }
        }
        print(result, hostInfo)
        switch hostInfo.cpu_type {
        case CPU_TYPE_ARM:
            return "ARM"
        case CPU_TYPE_ARM64:
            return "ARM64"
        case CPU_TYPE_ARM64_32:
            return"ARM64_32"
        case CPU_TYPE_X86:
            return "X86"
        case CPU_TYPE_X86_64:
            return"X86_64"
        case CPU_TYPE_ANY:
            return"ANY"
        case CPU_TYPE_VAX:
            return"VAX"
        case CPU_TYPE_MC680x0:
            return"MC680x0"
        case CPU_TYPE_I386:
            return"I386"
        case CPU_TYPE_MC98000:
            return"MC98000"
        case CPU_TYPE_HPPA:
            return"HPPA"
        case CPU_TYPE_MC88000:
            return"MC88000"
        case CPU_TYPE_SPARC:
            return"SPARC"
        case CPU_TYPE_I860:
            return"I860"
        case CPU_TYPE_POWERPC:
            return"POWERPC"
        case CPU_TYPE_POWERPC64:
            return"POWERPC64"
        default:
            return ""
        }
    }
    
    /// uuid 注意其实uuid并不是唯一不变的
    var wy_uuid: String {
        return identifierForVendor?.uuidString ?? ""
    }
    
    /// 获取手机卡对应的运营商
    var wy_supplier: String  {
        
        let info = CTTelephonyNetworkInfo()
        var supplier:String = ""
        if #available(iOS 12.0, *) {
            if let carriers = info.serviceSubscriberCellularProviders {
                if carriers.keys.count == 0 {
                    return WYLocalizedString("无手机卡")
                } else { //获取运营商信息
                    var firstSupplier = ""
                    var secondSupplier = ""
                    for (index, carrier) in carriers.values.enumerated() {
                        //查看运营商信息 通过CTCarrier类
                        if index == 0 {
                            firstSupplier = carrier.carrierName ?? ""
                        } else {
                            secondSupplier = carrier.carrierName ?? ""
                        }
                    }
                    supplier = (firstSupplier.isEmpty ? "" : firstSupplier) + (secondSupplier.isEmpty ? "" : ("," + secondSupplier))
                    
                    return supplier.isEmpty ? WYLocalizedString("无手机卡") : supplier
                }
            } else{
                return WYLocalizedString("无手机卡")
            }
        } else {
            if let carrier = info.subscriberCellularProvider {
                return carrier.carrierName ?? WYLocalizedString("无手机卡")
            } else{
                return WYLocalizedString("无手机卡")
            }
        }
    }
    
    /// 获取运营商IP地址
    var wy_carrierIP: String {
        
        var addresses = [String]()
        var ifaddr : UnsafeMutablePointer<ifaddrs>? = nil
        if getifaddrs(&ifaddr) == 0 {
            var ptr = ifaddr
            while (ptr != nil) {
                let flags = Int32(ptr!.pointee.ifa_flags)
                var addr = ptr!.pointee.ifa_addr.pointee
                if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
                    if addr.sa_family == UInt8(AF_INET) || addr.sa_family == UInt8(AF_INET6) {
                        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                        if (getnameinfo(&addr, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count),nil, socklen_t(0), NI_NUMERICHOST) == 0) {
                            if let address = String(validatingUTF8:hostname) {
                                addresses.append(address)
                            }
                        }
                    }
                }
                ptr = ptr!.pointee.ifa_next
            }
            freeifaddrs(ifaddr)
        }
        return addresses.first ?? "0.0.0.0"
    }
    
    /// 获取WIFIIP地址
    var wy_wifiIP: String {
        
        var address: String?
        var ifaddr: UnsafeMutablePointer<ifaddrs>? = nil
        guard getifaddrs(&ifaddr) == 0 else {
            return "0.0.0.0"
        }
        guard let firstAddr = ifaddr else {
            return "0.0.0.0"
        }
        
        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let interface = ifptr.pointee
            // Check for IPV4 or IPV6 interface
            let addrFamily = interface.ifa_addr.pointee.sa_family
            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                // Check interface name
                let name = String(cString: interface.ifa_name)
                if name == "en0" {
                    // Convert interface address to a human readable string
                    var addr = interface.ifa_addr.pointee
                    var hostName = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(&addr,socklen_t(interface.ifa_addr.pointee.sa_len), &hostName, socklen_t(hostName.count), nil, socklen_t(0), NI_NUMERICHOST)
                    address = String(cString: hostName)
                }
            }
        }
        
        freeifaddrs(ifaddr)
        return address ?? "0.0.0.0"
    }
    
    /// 当前电池健康度
    var wy_batteryLevel: CGFloat {
        return 100.0 + CGFloat(self.batteryLevel)
    }
    
    /// 磁盘总大小
    var wy_totalDiskSize: String {
        
        guard let systemAttributes = try? FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory() as String),
              let totalDiskSpaceInBytes = (systemAttributes[FileAttributeKey.systemSize] as? NSNumber)?.int64Value else { return "0" }
        
        return ByteCountFormatter.string(fromByteCount: totalDiskSpaceInBytes, countStyle: ByteCountFormatter.CountStyle.decimal)
    }
    
    /// 磁盘可用大小
    var wy_availableDiskSize: String {
        
        var freeDiskSpaceInBytes: Int64 = 0
        if #available(iOS 11.0, *) {
            if let space = try? URL(fileURLWithPath: NSHomeDirectory() as String).resourceValues(forKeys: [URLResourceKey.volumeAvailableCapacityForImportantUsageKey]).volumeAvailableCapacityForImportantUsage {
                freeDiskSpaceInBytes = space
            }
        } else {
            if let systemAttributes = try? FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory() as String),
               let freeSpace = (systemAttributes[FileAttributeKey.systemFreeSize] as? NSNumber)?.int64Value {
                freeDiskSpaceInBytes = freeSpace
            }
        }
        return ByteCountFormatter.string(fromByteCount: freeDiskSpaceInBytes, countStyle: ByteCountFormatter.CountStyle.decimal)
    }
    
    /// 磁盘已使用大小
    var wy_usedDiskSize: String {
        
        guard let systemAttributes = try? FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory() as String),
              let totalDiskSpaceInBytes = (systemAttributes[FileAttributeKey.systemSize] as? NSNumber)?.int64Value else { return "0" }
        
        var freeDiskSpaceInBytes: Int64 = 0
        if #available(iOS 11.0, *) {
            if let space = try? URL(fileURLWithPath: NSHomeDirectory() as String).resourceValues(forKeys: [URLResourceKey.volumeAvailableCapacityForImportantUsageKey]).volumeAvailableCapacityForImportantUsage {
                freeDiskSpaceInBytes = space
            }
        } else {
            if let systemAttributes = try? FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory() as String),
               let freeSpace = (systemAttributes[FileAttributeKey.systemFreeSize] as? NSNumber)?.int64Value {
                freeDiskSpaceInBytes = freeSpace
            }
        }
        
        return ByteCountFormatter.string(fromByteCount: totalDiskSpaceInBytes - freeDiskSpaceInBytes, countStyle: ByteCountFormatter.CountStyle.decimal)
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
            
            switch newValue {
            case .portrait:
                stopMotionManager()
                wy_currentInterfaceOrientation = .portrait
                UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
                UIViewController.attemptRotationToDeviceOrientation()
                break
            case .landscapeLeft:
                stopMotionManager()
                wy_currentInterfaceOrientation = .landscapeLeft
                UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue, forKey: "orientation")
                UIViewController.attemptRotationToDeviceOrientation()
                break
            case .landscapeRight:
                stopMotionManager()
                wy_currentInterfaceOrientation = .landscapeRight
                UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
                UIViewController.attemptRotationToDeviceOrientation()
                break
            case .portraitUpsideDown:
                stopMotionManager()
                wy_currentInterfaceOrientation = .portraitUpsideDown
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
    
    /// 获取当前屏幕方向(只会出现 portrait、landscapeLeft、landscapeRight、portraitUpsideDown 四种情况)
    private(set) var wy_currentInterfaceOrientation: UIInterfaceOrientationMask {
        set(newValue) {
            
            objc_setAssociatedObject(self, WYAssociatedKeys.privateCurrentInterfaceOrientation, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        get {
            return objc_getAssociatedObject(self, WYAssociatedKeys.privateCurrentInterfaceOrientation) as? UIInterfaceOrientationMask ?? .portrait
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
                            
                            self?.wy_currentInterfaceOrientation = .portraitUpsideDown
                            
                            UIDevice.current.setValue(UIInterfaceOrientation.portraitUpsideDown.rawValue, forKey: "orientation")
                            UIViewController.attemptRotationToDeviceOrientation()
                            
                        } else {
                            
                            self?.wy_currentInterfaceOrientation = .portrait
                            
                            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
                            UIViewController.attemptRotationToDeviceOrientation()
                        }
                        
                    }else {
                        
                        if x >= 0 {
                            
                            self?.wy_currentInterfaceOrientation = .landscapeLeft
                            
                            UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue, forKey: "orientation")
                            UIViewController.attemptRotationToDeviceOrientation()
                            
                        } else{
                            
                            self?.wy_currentInterfaceOrientation = .landscapeRight
                            
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
    
    private struct WYAssociatedKeys {
        
        static let privateMotionManager = UnsafeRawPointer(bitPattern: "privateMotionManager".hashValue)!
        
        static let privateInterfaceOrientation = UnsafeRawPointer(bitPattern: "privateInterfaceOrientation".hashValue)!
        
        static let privateCurrentInterfaceOrientation = UnsafeRawPointer(bitPattern: "privateCurrentInterfaceOrientation".hashValue)!
    }
}
