//
//  UIDevice.swift
//  WYBasisKit
//
//  Created by Jacke·xu on 2020/8/29.
//  Copyright © 2020 Jacke·xu. All rights reserved.
//

import UIKit
import Photos
import CoreMotion
import AVFoundation
import CoreTelephony
import LocalAuthentication
import Contacts

/// 生物识别模式
public enum WYBiometricMode {
    
    /// 未知或者不支持
    case none
    
    /// 指纹识别
    case touchID
    
    /// 面部识别
    case faceID
}

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
    
    /// 是否是齐刘海手机
    var wy_isFullScreen: Bool {
        if #available(iOS 15.0, *) {
            let window = UIApplication.shared.connectedScenes.map({ $0 as? UIWindowScene }).compactMap({ $0 }).first?.windows.first
            return (window?.safeAreaInsets ?? UIEdgeInsets.zero).bottom != 0
        } else {
            return (UIApplication.shared.windows.first?.safeAreaInsets)?.bottom != 0
        }
    }
    
    /// 是否是传入的分辨率
    func wy_resolutionRatio(horizontal: CGFloat, vertical: CGFloat) -> Bool {
        return (UIScreen.instancesRespond(to: #selector(getter: UIScreen.main.currentMode)) ? CGSize(width: horizontal, height: vertical).equalTo((UIScreen.main.currentMode?.size)!) && !wy_iPadSeries : false)
    }
    
    /// 是否是竖屏模式
    var wy_verticalScreen: Bool {
        
        var orientation: UIInterfaceOrientation = .portrait
        if #available(iOS 13.0, *) {
            let window = UIApplication.shared.connectedScenes.map({ $0 as? UIWindowScene }).compactMap({ $0 }).first?.windows.first
            orientation = (window?.windowScene?.interfaceOrientation) ?? .portrait
        }else {
            orientation = UIApplication.shared.statusBarOrientation
        }
        
        if (orientation == UIInterfaceOrientation.portrait) ||
            (orientation == UIInterfaceOrientation.portraitUpsideDown) {
            return true
        } else {
            return false
        }
    }
    
    /// 是否是横屏模式
    var wy_horizontalScreen: Bool {
        
        var orientation: UIInterfaceOrientation = .portrait
        if #available(iOS 13.0, *) {
            let window = UIApplication.shared.connectedScenes.map({ $0 as? UIWindowScene }).compactMap({ $0 }).first?.windows.first
            orientation = (window?.windowScene?.interfaceOrientation) ?? .portrait
        }else {
            orientation = UIApplication.shared.statusBarOrientation
        }
        
        if (orientation == UIInterfaceOrientation.landscapeLeft) ||
            (orientation == UIInterfaceOrientation.landscapeRight) {
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
                wy_rotateScreenTo(.portrait)
                break
            case .landscapeLeft:
                stopMotionManager()
                wy_currentInterfaceOrientation = .landscapeLeft
                wy_rotateScreenTo(.landscapeLeft)
                break
            case .landscapeRight:
                stopMotionManager()
                wy_currentInterfaceOrientation = .landscapeRight
                wy_rotateScreenTo(.landscapeRight)
                break
            case .portraitUpsideDown:
                stopMotionManager()
                wy_currentInterfaceOrientation = .portraitUpsideDown
                wy_rotateScreenTo(.portraitUpsideDown)
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
    
    /// 获取当前设备屏幕方向(只会出现 portrait、landscapeLeft、landscapeRight、portraitUpsideDown 四种情况)
    private(set) var wy_currentInterfaceOrientation: UIInterfaceOrientationMask {
        set(newValue) {
            
            objc_setAssociatedObject(self, WYAssociatedKeys.privateCurrentInterfaceOrientation, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        get {
            return objc_getAssociatedObject(self, WYAssociatedKeys.privateCurrentInterfaceOrientation) as? UIInterfaceOrientationMask ?? .portrait
        }
    }
    
    /// 判断相机权限
    func wy_authorizeCameraAccess(showAlert: Bool = true, handler:((_ authorized: Bool) -> Void)?) {
        
        let authStatus = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch authStatus {
        case .notDetermined:
            /// 用户尚未授权(弹出授权提示)
            PHPhotoLibrary.requestAuthorization {[weak self] (status) in
                DispatchQueue.main.async {
                    if status == .authorized {
                        /// 用户授权访问
                        handler?(true)
                    }else {
                        /// App无权访问相机 用户已明确拒绝
                        self?.wy_showAuthorizeAlert(show: showAlert, message: WYLocalizedString("App没有访问相机的权限，现在去授权?"))
                        handler?(false)
                    }
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
    func wy_authorizeAlbumAccess(showAlert: Bool = true, handler:((_ authorized: Bool, _ limited: Bool) -> Void)?) {
        
        if #available(iOS 14, *) {
            let requiredAccessLevel: PHAccessLevel = .readWrite
            PHPhotoLibrary.requestAuthorization(for: requiredAccessLevel) { [weak self] (authStatus) in
                DispatchQueue.main.async {
                    self?.wy_checkAlbumAccess(showAlert: showAlert, authStatus: authStatus, handler: handler)
                }
            }
            
        }else {
            wy_checkAlbumAccess(showAlert: showAlert, authStatus: PHPhotoLibrary.authorizationStatus(), handler: handler)
        }
    }
    
    /// 判断通讯录权限并获取通讯录
    func wy_authorizeAddressBookAccess(showAlert: Bool = true, keysToFetch: [String] = [CNContactFamilyNameKey, CNContactGivenNameKey, CNContactOrganizationNameKey, CNContactPhoneNumbersKey, CNContactNicknameKey], handler:((_ authorized: Bool, _ userInfo: [CNContact]?) -> Void)?) {
        
        let authStatus = CNContactStore.authorizationStatus(for: .contacts)
        let contactStore = CNContactStore()
        switch authStatus {
        case .notDetermined:
            contactStore.requestAccess(for: .contacts) { [weak self] granted, error in
                DispatchQueue.main.async {
                    if granted {
                        self?.wy_openContact(contactStore: contactStore, keysToFetch: keysToFetch, handler: handler)
                    }else {
                        /// App无权访问通讯录 用户已明确拒绝
                        self?.wy_showAuthorizeAlert(show: showAlert, message: WYLocalizedString("App没有访问通讯录的权限，现在去授权?"))
                        handler?(false, nil)
                    }
                 }
            }
        case .authorized:
            /// 可以访问
            wy_openContact(contactStore: contactStore, keysToFetch: keysToFetch, handler: handler)
        default:
            /// App无权访问通讯录 用户已明确拒绝
            wy_showAuthorizeAlert(show: showAlert, message: WYLocalizedString("App没有访问通讯录的权限，现在去授权?"))
            handler?(false, nil)
        }
    }
    
    /// 判断麦克风权限
    func wy_authorizeMicrophoneAccess(showAlert: Bool = true, handler:((_ authorized: Bool) -> Void)?) {
        
        let authStatus = AVCaptureDevice.authorizationStatus(for: .audio)
        
        switch authStatus {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .audio) {[weak self] authorized in
                DispatchQueue.main.async {
                    if authorized {
                        /// 用户授权访问
                        handler?(true)
                    }else {
                        /// App无权访问麦克风 用户已明确拒绝
                        self?.wy_showAuthorizeAlert(show: showAlert, message: WYLocalizedString("App没有访问麦克风的权限，现在去授权?"))
                        handler?(false)
                    }
                }
            }
            
        case .authorized:
            /// 可以访问
            handler?(true)
        default:
            /// App无权访问麦克风 用户已明确拒绝
            wy_showAuthorizeAlert(show: showAlert, message: WYLocalizedString("App没有访问麦克风的权限，现在去授权?"))
            handler?(false)
        }
    }
    
    /// 获取设备支持的生物识别类型
    func wy_checkBiometric() -> WYBiometricMode {
        
        var biometric = WYBiometricMode.none
        
        // 该参数必须在canEvaluatePolicy方法后才有值
        let authContent = LAContext()
        var error: NSError?
        if authContent.canEvaluatePolicy(
            .deviceOwnerAuthenticationWithBiometrics,
            error: &error) {
            // iPhoneX出厂最低系统版本号：iOS11.0.0
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
    
    /// 生物识别认证
    func wy_verifyBiometrics(localizedFallbackTitle: String = "", localizedReason: String, handler:((_ isBackupHandler: Bool ,_ isSuccess: Bool, _ error: String) -> Void)?) {
        
        let authContent = LAContext()
        
        // 如果为空不展示输入密码的按钮
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
                            handler!(false, true, "")
                        }
                    }
                    
                }else {
                    
                    guard let laError = error as? LAError else {
                        
                        // 生物识别不可用
                        DispatchQueue.main.async {
                            
                            handler!(false, false, WYLocalizedString("生物识别不可用"))
                        }
                        return
                    }
                    
                    switch laError.code {
                    case .authenticationFailed:
                        
                        DispatchQueue.main.async {
                            
                            self.wy_unlockLocalAuth { (_success) in
                                
                                DispatchQueue.main.async {
                                    
                                    if _success == true {
                                        
                                        handler!(false, true, "")
                                    }else {
                                        
                                        // 生物识别已被锁定，锁屏并成功解锁iPhone后可重新打开本页面开启
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
                            
                            handler!(false, false, WYLocalizedString("系统中断了本次识别"))
                        }
                    case .passcodeNotSet:
                        
                        // 用户未设置解锁密码
                        DispatchQueue.main.async {
                            
                            handler!(false, false, WYLocalizedString("开启生物识别前请设置解锁密码"))
                        }
                    case .touchIDNotAvailable:
                        
                        // 生物识别不可用
                        DispatchQueue.main.async {
                            
                            handler!(false, false, WYLocalizedString("生物识别不可用"))
                        }
                    case .touchIDNotEnrolled:
                        
                        // 未设置生物识别
                        DispatchQueue.main.async {
                            
                            handler!(false, false, WYLocalizedString("请在设备设置中开启/设置生物识别功能"))
                        }
                    case .touchIDLockout:
                        
                        // 生物识别已被锁定，锁屏并成功解锁iPhone后可重新打开本页面开启
                        DispatchQueue.main.async {
                            
                            handler!(false, false, WYLocalizedString("生物识别已被锁定，锁屏并成功解锁设备后重新打开本页面即可重新开启"))
                        }
                    default:break
                    }
                }
            }
            
        }else {
            
            // 生物识别已被锁定，锁屏并成功解锁iPhone后可重新打开本页面开启
            DispatchQueue.main.async {
                
                handler!(false, false, WYLocalizedString("生物识别已被锁定，锁屏并成功解锁设备后重新打开本页面即可重新开启"))
            }
        }
    }
    
    /// 解锁生物识别
    func wy_unlockLocalAuth(handler:((_ isSuccess: Bool) -> Void)?) {
        
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
}

private extension UIDevice {
    
    // 获取通讯录
    func wy_openContact(contactStore: CNContactStore, keysToFetch: [String], handler:((_ authorized: Bool, _ userInfo: [CNContact]?) -> Void)?) {
        
        contactStore.requestAccess(for: .contacts) {(granted, error) in
            if (granted) && (error == nil) {
                
                let request = CNContactFetchRequest(keysToFetch: keysToFetch as [CNKeyDescriptor])
                do {
                    var contacts: [CNContact] = []
                    // 需要传入一个CNContactFetchRequest
                    try contactStore.enumerateContacts(with: request, usingBlock: {(contact : CNContact, stop : UnsafeMutablePointer) -> Void in
                        contacts.append(contact)
                    })
                    handler?(true, contacts)
                } catch {
                    handler?(true, nil)
                }
            } else {
                handler?(true, nil)
            }
        }
    }
    
    // 检查相册权限
    func wy_checkAlbumAccess(showAlert: Bool, authStatus: PHAuthorizationStatus, handler:((_ authorized: Bool, _ limited: Bool) -> Void)?) {
        
        switch authStatus {
        case .notDetermined:
            /// 用户尚未授权(弹出授权提示)
            PHPhotoLibrary.requestAuthorization {[weak self] (status) in
                
                if status == .authorized {
                    /// 用户授权访问
                    handler?(true, false)
                }else {
                    
                    /// App无权访问照片库 用户已明确拒绝
                    self?.wy_showAuthorizeAlert(show: showAlert, message: WYLocalizedString("App没有访问相册的权限，现在去授权?"))
                    handler?(false, false)
                }
            }
            
        case .authorized:
            /// 可以访问
            handler?(true, false)
        case .limited:
            /// 部分可访问
            handler?(true, true)
        default:
            /// App无权访问相册 用户已明确拒绝
            wy_showAuthorizeAlert(show: showAlert, message: WYLocalizedString("App没有访问相册的权限，现在去授权?"))
            handler?(false, false)
        }
    }
    
    // 弹出授权弹窗
    func wy_showAuthorizeAlert(show: Bool, message: String) {
        
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
    
    // 旋转屏幕到指定方向
    private func wy_rotateScreenTo(_ orientation: UIInterfaceOrientation) {
        if #available(iOS 16.0, *) {
            
            let window = UIApplication.shared.connectedScenes.map({ $0 as? UIWindowScene }).compactMap({ $0 }).first?.windows.first
            
            if let windowScene: UIWindowScene = window?.windowScene {
                windowScene.requestGeometryUpdate(UIWindowScene.GeometryPreferences.iOS(interfaceOrientations: wy_currentInterfaceOrientation))
                UIViewController.wy_currentController()?.setNeedsUpdateOfSupportedInterfaceOrientations()
                windowScene.requestGeometryUpdate(UIWindowScene.GeometryPreferences.iOS(interfaceOrientations: wy_currentInterfaceOrientation)) { error in
                    wy_print("旋转屏幕方向出错啦： \(error.localizedDescription)")
                }
            }else {
                wy_print("旋转屏幕方向出错啦")
            }
        }else {
            UIDevice.current.setValue(orientation.rawValue, forKey: "orientation")
            UIViewController.attemptRotationToDeviceOrientation()
        }
    }
    
    func rotateScreenOrientationDynamically(_ orientation: UIInterfaceOrientationMask) {
        
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
                            UIDevice.current.wy_rotateScreenTo(.portraitUpsideDown)
                            
                        } else {
                            
                            self?.wy_currentInterfaceOrientation = .portrait
                            UIDevice.current.wy_rotateScreenTo(.portrait)
                        }
                        
                    }else {
                        
                        if x >= 0 {
                            
                            self?.wy_currentInterfaceOrientation = .landscapeLeft
                            UIDevice.current.wy_rotateScreenTo(.landscapeLeft)
                            
                        } else{
                            
                            self?.wy_currentInterfaceOrientation = .landscapeRight
                            UIDevice.current.wy_rotateScreenTo(.landscapeRight)
                        }
                    }
                }
            }
        }else {
            wy_print("当前设备不支持加速传感器")
        }
    }
    
    func stopMotionManager() {
        
        guard motionManager != nil else {
            return
        }
        
        if motionManager!.isAccelerometerActive {
            motionManager?.stopAccelerometerUpdates()
        }
        motionManager = nil
    }
    
    var motionManager: CMMotionManager? {
        
        set(newValue) {
            
            objc_setAssociatedObject(self, WYAssociatedKeys.privateMotionManager, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, WYAssociatedKeys.privateMotionManager) as? CMMotionManager
        }
    }
    
    struct WYAssociatedKeys {
        
        static let privateMotionManager = UnsafeRawPointer(bitPattern: "privateMotionManager".hashValue)!
        
        static let privateInterfaceOrientation = UnsafeRawPointer(bitPattern: "privateInterfaceOrientation".hashValue)!
        
        static let privateCurrentInterfaceOrientation = UnsafeRawPointer(bitPattern: "privateCurrentInterfaceOrientation".hashValue)!
    }
}
