//
//  WYEnums.swift
//  WYBasisKit
//
//  Created by jacke·xu on 2020/12/9.
//  Copyright © 2020 jacke·xu. All rights reserved.
//

import Foundation

/// viewController显示模式
public enum WYDisplaMode {
    
    /// push模式
    case push
    
    /// present模式
    case present
}

/// 国际化语言版本
public enum WYLanguage: String {
    
    /// 中文
    case chinese = "zh-Hans"
    
    /// 英文
    case english = "en"
}

/// 渐变方向
public enum WYGradientDirection: UInt {
    
    /// 从上到小
    case topToBottom = 0
    /// 从左到右
    case leftToRight = 1
    /// 左上到右下
    case leftToLowRight = 2
    /// 右上到左下
    case rightToLowlLeft = 3
}

/// UIButton图片控件和文本控件显示位置
public enum WYButtonPosition {
    
    /** 图片在左，文字在右，默认 */
    case imageLeft_titleRight
    /** 图片在右，文字在左 */
    case imageRight_titleLeft
    /** 图片在上，文字在下 */
    case imageTop_titleBottom
    /** 图片在下，文字在上 */
    case imageBottom_titleTop
}

/// 时间格式化模式
public enum WYTimeFormat {
    
    /// 时:分
    case hourMinutes
    /// 年-月-日
    case yearMonthDay
    /// 时:分:秒
    case hourMinutesSecond
    /// 月-日 时:分
    case monthDayAndHourMinutes
    /// 年-月-日 时:分
    case yearMonthDayAndhourMinutes
    /// 年-月-日 时:分:秒
    case yearMonthDayAndhourMinutesSecond
}

/// 生物识别模式
public enum WYBiometricType {
    
    /// 未知或者不支持
    case none
    
    /// 指纹识别
    case touchID
    
    /// 面部识别
    case faceID
}

/// 网络请求类型
public enum WYTaskMethod {
    
    /// 数据任务
    case data
    /// 上传任务
    case upload
}

/// 上传类型
public enum WYFileType {
    
    /// 上传图片
    case image
    /// 上传音频
    case audio
    /// 上传视频
    case video
    /// URL路径上传
    case urlPath
}

/// 网络连接模式与用户操作选项
public enum WYNetworkStatus {
    
    /// 未知网络，可能是不安全的连接
    case unknown
    /// 无网络连接
    case notReachable
    /// wifi网络
    case reachableWifi
    /// 蜂窝移动网络
    case reachableCellular
    
    /// 用户未选择
    case userNotSelectedConnect
    /// 用户设置取消连接
    case userCancelConnect
    /// 用户设置继续连接
    case userContinueConnect
}
