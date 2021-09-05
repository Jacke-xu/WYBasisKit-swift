//
//  WYActivity.swift
//  WYBasisKit
//
//  Created by jacke·xu on 2021/8/29.
//  Copyright © 2021 Jacke·xu. All rights reserved.
//

import UIKit

/// 信息提示窗口的显示位置
public enum WYActivityPosition: NSInteger {
    
    /// 相对于父控件的顶部
    case top = 0
    
    /// 相对于父控件的中部
    case middle
    
    /// 相对于父控件的底部
    case bottom
}

/// Loading提示窗动画类型
public enum WYActivityAnimation {
    
    /// 默认，系统小菊花
    case indicator
    
    /// 图片帧
    case gifImage
}

public struct WYActivityConfig {
    
    /// 设置Activity提示窗口的默认背景色
    public static var backgroundColor: UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
    public var backgroundColor: UIColor = backgroundColor
    
    /// 设置Activity提示窗口文本控件的默认颜色
    public static var textColor: UIColor = .white
    public var textColor: UIColor = textColor
    
    /// 设置Activity提示窗口文本控件的默认字体、字号
    public static var textFont: UIFont = .systemFont(ofSize: 15)
    public var textFont: UIFont = textFont
    
    /// 设置Loading提示窗口动图
    public static var loadingImages: [UIImage] = defaultLoadingImages()
    public var loadingImages: [UIImage] = loadingImages
    
    /// 滚动信息提示窗口默认配置
    public static func scroll() -> WYActivityConfig {
        
        // 内部使用了这几项配置
        return WYActivityConfig(backgroundColor: backgroundColor, textColor: textColor, textFont: textFont)
    }
    
    /// 信息提示窗口默认配置
    public static func info() -> WYActivityConfig {
        
        // 内部使用了这几项配置
        return WYActivityConfig(backgroundColor: backgroundColor, textColor: textColor, textFont: textFont)
    }
    
    /// Loading提示窗口默认配置
    public static func loading() -> WYActivityConfig {
        
        // 内部使用了这几项配置
        return WYActivityConfig(backgroundColor: backgroundColor, textColor: textColor, textFont: textFont, loadingImages: loadingImages)
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
     *  @param offset             信息提示窗口相对于contentView的偏移量
     *
     *  @param config             信息提示窗口配置选项
     *
     */
    public static func showScrollInfo(_ content: Any?, in contentView: UIView? = nil, offset: CGFloat? = nil, config: WYActivityConfig = .scroll()) {
        
        guard content != nil else {
            return
        }
        guard let windowView = sharedContentView(contentView) else {
            return
        }
        WYActivityScrollInfoView().showContent(content!, in: windowView, offset: sharedContentViewOffset(offset: offset, window: windowView), config: config)
    }
    
    /**
     *  显示一个信息提示窗口
     *
     *  @param content            要显示的文本内容，支持 String 与 NSAttributedString
     *
     *  @param contentView        加载信息提示窗口的父视图，内部会按照 传入的View、控制器的View、keyWindow 的顺序去设置显示
     *
     *  @param position           信息提示窗口的显示位置，支持 top、middle、bottom
     *
     *  @param offset             信息提示窗口相对于contentView的偏移量(仅 position == top 时有效)
     *
     *  @param config             信息提示窗口配置选项
     */
    public static func showInfo(_ content: Any?, in contentView: UIView? = nil, position: WYActivityPosition = .middle, offset: CGFloat? = nil, config: WYActivityConfig = .info()) {
        
        guard content != nil else {
            return
        }
        guard let windowView = sharedContentView(contentView) else {
            return
        }
        WYActivityInfoView().showContent(content!, in: windowView, position: position, offset: sharedContentViewOffset(offset: offset, window: windowView), config: config)
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
    public static func showLoading(_ content: Any?, in contentView: UIView? = nil, userInteraction: Bool = true, animation: WYActivityAnimation = .indicator, delay: TimeInterval = 0, config: WYActivityConfig = .loading()) {
        
        guard let windowView = sharedContentView(contentView) else {
            return
        }
    }
    
    /**
     *  移除Loading窗口
     */
    public static func dismiss() {

    }
}

private class WYActivityScrollInfoView: UIView {
    
    lazy var displayLink: CADisplayLink = {
        
        let displayLink = CADisplayLink(target: self, selector: #selector(refreshScrollInfo))
        displayLink.add(to: .current, forMode: RunLoop.Mode.common)
        displayLink.isPaused = true

        return displayLink
    }()
    
    lazy var contentLabel: UILabel = {
        
        let label = UILabel()
        addSubview(label)
        return label
    }()
    
    func showContent(_ content: Any, in contentView: UIView, offset: CGFloat, config: WYActivityConfig) {
        
        let attributedText = WYActivity.sharedContentAttributed(config: config, content: content)
        
        let contentSize: CGSize = attributedText.wy_calculateSize(controlSize: CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
        
        self.backgroundColor = config.backgroundColor
        
        self.frame = CGRect(x: 0, y: offset, width: contentView.frame.size.width, height: contentSize.height + 10)
        contentView.addSubview(self)
        
        contentLabel.attributedText = attributedText
        
        contentLabel.frame = CGRect(x: frame.size.width, y: 0, width: contentSize.width, height: frame.size.height)
        
        displayLink.isPaused = false
    }
    
    @objc func refreshScrollInfo() {
        contentLabel.frame.origin.x = contentLabel.frame.origin.x - 1.5
        if contentLabel.frame.size.width < self.frame.size.width {
            if contentLabel.frame.origin.x <= wy_screenWidth(5) {
                stopScroll()
            }
        }else {
            if (contentLabel.frame.origin.x + contentLabel.frame.size.width) <= (self.frame.size.width - wy_screenWidth(10)) {
                stopScroll()
            }
        }
    }
    
    func stopScroll() {
        
        displayLink.isPaused = true
        displayLink.invalidate()
        
        UIView.animate(withDuration: 2) {
            self.alpha = 0.0
        }completion: { _ in
            self.removeActivity()
        }
    }
    
    func removeActivity() {
        var activity: UIView? = self
        activity?.removeFromSuperview()
        activity = nil
    }
}

private class WYActivityInfoView: UIView {
    
    var activityTimer: Timer? = nil
    
    lazy var contentLabel: UILabel = {
        
        let label = UILabel()
        label.numberOfLines = 0
        addSubview(label)
        return label
    }()
    
    func showContent(_ content: Any, in contentView: UIView, position: WYActivityPosition, offset: CGFloat, config: WYActivityConfig) {
        
        let attributedText = WYActivity.sharedContentAttributed(config: config, content: content)
        
        contentLabel.attributedText = attributedText
        
        self.backgroundColor = config.backgroundColor
        self.wy_add(rectCorner: .allCorners, cornerRadius: wy_screenWidth(10))
        contentView.addSubview(self)
        
        layoutActivity(contentView: contentView, position: position, offset: offset, config: config)
    }
    
    func layoutActivity(contentView: UIView, position: WYActivityPosition, offset: CGFloat, config: WYActivityConfig) {
        
        let controlWidth: CGFloat = contentView.frame.size.width - [wy_screenWidth(40), wy_screenWidth(120), wy_screenWidth(120)][position.rawValue]
        
        contentLabel.frame = CGRect(x: wy_screenWidth(10), y: wy_screenWidth(10), width: controlWidth - wy_screenWidth(20), height: wy_screenWidth(10))
        contentLabel.sizeToFit()
        
        showAnimate(contentView: contentView, position: position, offset: offset, config: config)
    }
    
    func showAnimate(contentView: UIView, position: WYActivityPosition, offset: CGFloat, config: WYActivityConfig) {
        
        let controlWidth: CGFloat = contentView.frame.size.width - [wy_screenWidth(40), wy_screenWidth(120), wy_screenWidth(120)][position.rawValue]
        
        switch position {
        case .top:
            contentLabel.textAlignment = .left
            let controlHeight: CGFloat = contentLabel.frame.size.height + wy_screenWidth(20)
            
            self.frame = CGRect(x: (contentView.frame.size.width - controlWidth) / 2, y: -controlHeight, width: controlWidth, height: controlHeight)
            
            UIView.animate(withDuration: 0.5) {
                
                self.frame = CGRect(x: (contentView.frame.size.width - controlWidth) / 2, y: offset + wy_screenWidth(10), width: controlWidth, height: controlHeight)
                
            } completion: { _ in
                
                self.activityTimer = Timer.scheduledTimer(withTimeInterval: self.sharedTimeInterval(config: config), repeats: false, block: { [weak self] _ in
                    self?.dismissActivity(config: config, position: position, offset: -controlHeight)
                })
            }
            break
        default:
            contentLabel.textAlignment = .center
            let contentSize = sharedLayoutSize(contentView: contentView, config: config)
            contentLabel.frame = CGRect(x: wy_screenWidth(10), y: wy_screenWidth(10), width: contentSize.width, height: contentSize.height)
            contentLabel.sizeToFit()
            
            let offsetx = (contentView.frame.size.width - contentLabel.frame.size.width - wy_screenWidth(20)) / 2
            var offsety = (contentView.frame.size.height - contentLabel.frame.size.height - wy_screenWidth(20)) / 2
            
            let tabbarOffset = wy_currentController()?.tabBarController?.tabBar.isHidden ?? true ? 0 : wy_tabBarHeight
            
            if position == .middle {
                offsety = (contentView.frame.size.height - contentLabel.frame.size.height - wy_screenWidth(20) - tabbarOffset) / 2
            }else {
                offsety = contentView.frame.size.height - contentLabel.frame.size.height - wy_screenWidth(80) - tabbarOffset
            }
            self.frame = CGRect(x: offsetx, y: offsety, width: contentLabel.frame.size.width + wy_screenWidth(20), height: contentLabel.frame.size.height + wy_screenWidth(20))
            
            self.alpha = 0
            UIView.animate(withDuration: 0.5) {
                self.alpha = 1.0
            } completion: { _ in

                self.activityTimer = Timer.scheduledTimer(withTimeInterval: self.sharedTimeInterval(config: config), repeats: false, block: { [weak self] _ in
                    self?.dismissActivity(config: config, position: position)
                })
            }
            break
        }
    }
    
    func dismissActivity(config: WYActivityConfig, position: WYActivityPosition, offset: CGFloat = 0) {
        
        switch position {
        case .top:
            UIView.animate(withDuration: 0.5) {
                self.frame = CGRect(x: self.frame.origin.x, y: offset, width: self.frame.size.width, height: self.frame.size.height)
            } completion: { _ in
                self.removeActivity()
            }
            break
        default:
            UIView.animate(withDuration: 0.5) {
                self.alpha = 0.0;
            } completion: { _ in
                self.removeActivity()
            }
            break
        }
    }
    
    func sharedTimeInterval(config: WYActivityConfig) -> TimeInterval {
        return 1.5 + Double((textNumberOfLines(config: config) - 1) * 1)
    }
    
    func removeActivity() {
        
        activityTimer?.invalidate()
        activityTimer = nil
        
        var activity: UIView? = self
        activity?.removeFromSuperview()
        activity = nil
    }
    
    func sharedLayoutSize(contentView: UIView, config: WYActivityConfig) -> CGSize {
        
        let textHeight = contentLabel.frame.size.height
        let textWidth = contentLabel.frame.size.width
        let minimux = wy_screenWidth(80)
        
        var contentWidth = minimux;
        
        if textWidth > minimux {
            for line in 1..<(contentLabel.attributedText?.string.count ?? 0) {
                
                var maximum = minimux + (textHeight * CGFloat(line))
                
                if (maximum > (contentView.frame.size.width - wy_screenWidth(120))) {
                    maximum = contentView.frame.size.width - wy_screenWidth(120)
                }
                
                let numberOfLines = textNumberOfLines(config: config, controlWidth: maximum)
                
                if (maximum > (contentView.frame.size.width - wy_screenWidth(120))) {
                    contentWidth = contentView.frame.size.width - wy_screenWidth(120)
                    break
                }else {
                    if numberOfLines <= (line + 1) {
                        contentWidth = maximum
                        break
                    }
                }
            }
        }
        let contentHeight: CGFloat = contentLabel.attributedText?.wy_calculateHeight(controlWidth: contentWidth) ?? textHeight
        
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    func textNumberOfLines(config: WYActivityConfig, controlWidth: CGFloat = 0) -> NSInteger {
        
        let textfont: UIFont = contentLabel.attributedText?.attribute(NSAttributedString.Key.font, at: 0, effectiveRange: nil) as? UIFont ?? config.textFont

        let numberOfLines: NSInteger = contentLabel.attributedText?.string.wy_numberOfRows(font: textfont, controlWidth: (controlWidth > 0 ? controlWidth : contentLabel.frame.size.width), wordsSpacing: 1) ?? 1
        
        return numberOfLines
    }
}

private class WYActivityLoadingView: UIView {
    
    
}

private extension WYActivity {
    
    /// 获取加载信息提示窗口的父视图
    static func sharedContentView(_ window: UIView? = nil) -> UIView? {
        
        guard let contentView = window else {
            return wy_currentController()?.view ?? nil
        }
        return contentView
    }
    
    /// 获取加载信息提示窗口的父视图的默认偏移量
    static func sharedContentViewOffset(offset: CGFloat?, window: UIView?) -> CGFloat {
        guard offset == nil else {
            return offset ?? 0
        }
        guard let controller: UIViewController = wy_currentController() else {
            return offset ?? 0
        }
        if (window == controller.view) && (controller.navigationController != nil) {
            return wy_navViewHeight
        }else {
            return wy_statusBarHeight
        }
    }
    
    /// 根据传入的 content 和 config 动态生成一个富文本
    static func sharedContentAttributed(config: WYActivityConfig, content: Any) -> NSAttributedString {
        
        var attributed: NSMutableAttributedString? = nil
        if content is String {
            
            attributed = NSMutableAttributedString(string: content as? String ?? "")
            attributed?.wy_colorsOfRanges(colorsOfRanges: [[config.textColor: attributed?.string as Any]])
            attributed?.wy_fontsOfRanges(fontsOfRanges: [[config.textFont: attributed?.string as Any]])
            attributed?.wy_wordsSpacing(wordsSpacing: 1)
            attributed?.wy_lineSpacing(lineSpacing: wy_screenWidth(5), string: attributed?.string)
        }else {
            attributed = NSMutableAttributedString(attributedString: content as? NSAttributedString ?? NSAttributedString())
        }
        return attributed!
    }
}
