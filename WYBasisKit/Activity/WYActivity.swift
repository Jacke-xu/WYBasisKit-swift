//
//  WYActivity.swift
//  WYBasisKit
//
//  Created by jacke·xu on 2021/8/29.
//  Copyright © 2021 Jacke·xu. All rights reserved.
//

import UIKit

/// 信息提示窗口的显示位置
public enum WYActivityPosition {
    
    /// 相对于父控件的顶部
    case top
    
    /// 相对于父控件的中部
    case middle
    
    /// 相对于父控件的底部
    case bottom
}

/// 信息提示窗口的状态
public enum WYActivityInfoState {
    
    /// 默认，无图标
    case `default`
    
    /// 成功
    case success
    
    /// 警告
    case warning
    
    /// 失败/错误
    case error
}

/// Loading提示窗动画类型
public enum WYActivityAnimation {
    
    /// 默认，系统小菊花
    case indicator
    
    /// 图片帧
    case gifImage
}

public struct WYActivityConfig {
    
    /// 设置Activity提示窗口驻留时间
    public static var activityDuration: TimeInterval = 1.5
    public var activityDuration: TimeInterval = activityDuration
    
    /// 设置Activity提示窗口最大显示行数
    public static var activityMaxRow: NSInteger = 4
    public var activityMaxRow: NSInteger = activityMaxRow
    
    /// 设置Activity提示窗口的默认背景色
    public static var backgroundColor: UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
    public var backgroundColor: UIColor = backgroundColor
    
    /// 设置Activity提示窗口文本控件的默认颜色
    public static var textColor: UIColor = .white
    public var textColor: UIColor = textColor
    
    /// 设置Activity提示窗口文本控件的默认字体、字号
    public static var testFont: UIFont = .systemFont(ofSize: 15)
    public var testFont: UIFont = testFont
    
    /// 设置Activity提示窗口 成功 状态图标
    public static var successImage: UIImage = UIImage.wy_named("success", inBundle: "WYActivity", subdirectory: "ActivityState")
    public var successImage: UIImage = successImage
    
    /// 设置Activity提示窗口 警告 状态图标
    public static var warningImage: UIImage = UIImage.wy_named("warning", inBundle: "WYActivity", subdirectory: "ActivityState")
    public var warningImage: UIImage = warningImage
    
    /// 设置Activity提示窗口 失败/错误 状态图标
    public static var errorImage: UIImage = UIImage.wy_named("error", inBundle: "WYActivity", subdirectory: "ActivityState")
    public var errorImage: UIImage = errorImage
    
    /// 设置Loading提示窗口动图
    public static var loadingImages: [UIImage] = defaultLoadingImages()
    public var loadingImages: [UIImage] = loadingImages
    
    /// 滚动信息提示窗口默认配置
    public static func scroll() -> WYActivityConfig {
        
        // 内部只使用了这几项配置
        return WYActivityConfig(backgroundColor: backgroundColor, textColor: textColor, testFont: testFont, successImage: successImage, warningImage: warningImage, errorImage: errorImage)
    }
    
    /// 信息提示窗口默认配置
    public static func info() -> WYActivityConfig {
        
        // 内部使用到了所有配置选项
        return WYActivityConfig()
    }
    
    /// Loading提示窗口默认配置
    public static func loading() -> WYActivityConfig {
        
        // 内部只使用了这几项配置
        return WYActivityConfig(activityMaxRow: 2, backgroundColor: backgroundColor, textColor: textColor, testFont: testFont, loadingImages: loadingImages)
    }
    
    /// 获取Loading提示窗口默认动图
    private static func defaultLoadingImages() -> [UIImage] {
        
        var defaultImages: [UIImage] = []
        for index in 0..<5 {
            defaultImages.append(UIImage.wy_named("loading" + "\(index + 1)", inBundle: "WYActivity", subdirectory: "LoadingState"))
        }
        
        return defaultImages
    }
}

public struct WYActivity {
    
    /**
     *  显示一个滚动信息提示窗口
     *
     *  @param content            要显示的文本内容，支持 String 与 NSAttributedString
     *
     *  @param contentView        加载活动控件的父视图，内部会按照 传入的View、控制器的View、keyWindow 的顺序去设置显示
     *
     *  @param state              信息提示窗口的状态
     *
     *  @param config             信息提示窗口配置选项
     *
     */
    public static func showScrollInfo<T>(_ content: T, in contentView: UIView? = nil, state: WYActivityInfoState = .default, config: WYActivityConfig = WYActivityConfig.scroll()) {
        
    }
    
    /**
     *  显示一个信息提示窗口
     *
     *  @param content            要显示的文本内容，支持 String 与 NSAttributedString
     *
     *  @param contentView        加载信息提示窗口的父视图，内部会按照 传入的View、控制器的View、keyWindow 的顺序去设置显示
     *
     *  @param state              信息提示窗口的状态
     *
     *  @param position           信息提示窗口的显示位置，支持 top、middle、bottom
     *
     *  @param switchAlert        信息行数超过 numberOfLines 后，是否自动切换成 UIAlertController 来显示
     *
     *  @param config             信息提示窗口配置选项
     */
    public static func showInfo<T>(_ content: T, in contentView: UIView? = nil, state: WYActivityInfoState = .default, position: WYActivityPosition = .middle, switchAlert: Bool = true, config: WYActivityConfig = WYActivityConfig.info()) {
        
    }
    
    /**
     *  显示一个Loading提示窗口
     *
     *  @param content            要显示的文本内容，支持 String 与 NSAttributedString
     *
     *  @param contentView        加载活动控件的父视图，内部会按照 传入的View、控制器的View、keyWindow 的顺序去设置显示
     *
     *  @param userInteraction    窗口显示期间是否允许用户对界面进行交互，默认允许
     *
     *  @param animation          动画类型，默认系统小菊花
     *
     *  @param delay              是否需要延时显示，设置后会延时 delay 后再显示Loading窗口
     *
     *  @param config             信息提示窗口配置选项
     *
     */
    public static func showLoading<T>(_ content: T, in contentView: UIView? = nil, userInteraction: Bool = true, animation: WYActivityAnimation = .indicator, delay: TimeInterval = 0, config: WYActivityConfig = WYActivityConfig.loading()) {
    }
    
    /**
     *  移除Loading窗口
     */
    public static func dismiss() {

    }
    
    /// 获取加载信息提示窗口的父视图
    private static func sharedContentView(_ window: UIView? = nil) -> UIView? {
        
        guard let contentView = window else {
            
            return wy_currentController()?.view ?? nil
        }
        return contentView
    }
}

private class WYActivityScrollInfoView: UIView {
    
    
}

private class WYActivityInfoView: UIView {
    
    
}

private class WYActivityLoadingView: UIView {
    
    
}
