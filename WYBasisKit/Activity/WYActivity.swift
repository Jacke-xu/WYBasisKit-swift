//
//  WYActivity.swift
//  WYBasisKit
//
//  Created by jacke·xu on 2021/8/29.
//  Copyright © 2021 Jacke·xu. All rights reserved.
//

import UIKit
import Foundation

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
    
    /// 设置滚动信息提示窗口的默认背景色
    public static var scrollInfoBackgroundColor: UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
    public var scrollInfoBackgroundColor: UIColor = scrollInfoBackgroundColor

    /// 设置信息提示窗口的默认背景色
    public static var infoBackgroundColor: UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
    public var infoBackgroundColor: UIColor = infoBackgroundColor

    /// 设置Loading提示窗口的默认背景色
    public static var loadingBackgroundColor: UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
    public var loadingBackgroundColor: UIColor = loadingBackgroundColor

    /// 设置滚动信息提示窗口的移动速度
    public static var movingSpeed: CGFloat = 1.2
    public var movingSpeed: CGFloat = movingSpeed

    /// 设置滚动信息提示窗口文本控件的默认颜色
    public static var scrollInfoTextColor: UIColor = .white
    public var scrollInfoTextColor: UIColor = scrollInfoTextColor

    /// 设置信息提示窗口文本控件的默认颜色
    public static var infoTextColor: UIColor = .white
    public var infoTextColor: UIColor = infoTextColor

    /// 设置Loading提示窗口文本控件的默认颜色
    public static var loadingTextColor: UIColor = .white
    public var loadingTextColor: UIColor = loadingTextColor

    /// 设置滚动信息提示窗口文本控件的默认字体、字号
    public static var scrollInfoTextFont: UIFont = .systemFont(ofSize: 15)
    public var scrollInfoTextFont: UIFont = scrollInfoTextFont

    /// 设置信息提示窗口文本控件的默认字体、字号
    public static var infoTextFont: UIFont = .systemFont(ofSize: 15)
    public var infoTextFont: UIFont = infoTextFont

    /// 设置Loading提示窗口文本控件的默认字体、字号
    public static var loadingTextFont: UIFont = .boldSystemFont(ofSize: 15)
    public var loadingTextFont: UIFont = loadingTextFont

    /// 设置Loading提示窗口动图
    public static var loadingImages: [UIImage] = defaultLoadingImages()
    public var loadingImages: [UIImage] = loadingImages

    /// 设置Loading提示窗口 WYActivityAnimation.gifImage 每一帧动画的间隔时间
    public static var gifImageDuration: TimeInterval = 0.4
    public var gifImageDuration: TimeInterval = gifImageDuration

    /// 设置Loading提示窗口 indicator 的颜色
    public static var indicatorColor: UIColor = .white
    public var indicatorColor: UIColor = indicatorColor

    /// 设置Loading提示窗口文本最多可显示几行
    public static var loadingNumberOfLines: NSInteger = 2
    public var loadingNumberOfLines: NSInteger = loadingNumberOfLines

    /// 设置Loading提示窗口动画控件的Size
    public static var animationSize: CGSize = CGSize(width: wy_screenWidth(60), height: wy_screenWidth(60))
    public var animationSize: CGSize = animationSize

    /// 滚动信息提示窗口默认配置
    public static let scroll: WYActivityConfig = WYActivityConfig(scrollInfoBackgroundColor: scrollInfoBackgroundColor, movingSpeed: movingSpeed, scrollInfoTextColor: scrollInfoTextColor, scrollInfoTextFont: scrollInfoTextFont)

    /// 信息提示窗口默认配置
    public static let info: WYActivityConfig = WYActivityConfig(infoBackgroundColor: infoBackgroundColor, infoTextColor: infoTextColor, infoTextFont: infoTextFont)

    /// Loading提示窗口默认配置
    public static let loading: WYActivityConfig = WYActivityConfig(loadingBackgroundColor: loadingBackgroundColor, loadingTextColor: loadingTextColor, loadingTextFont: loadingTextFont, loadingImages: loadingImages, gifImageDuration: gifImageDuration, indicatorColor: indicatorColor, loadingNumberOfLines: loadingNumberOfLines, animationSize: animationSize)

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
    public static func showScrollInfo(_ content: Any, in contentView: UIView? = nil, offset: CGFloat? = nil, config: WYActivityConfig = .scroll) {
        
        guard let windowView = sharedContentView(contentView) else {
            return
        }
        WYActivityScrollInfoView().showContent(content, in: windowView, offset: sharedContentViewOffset(offset: offset, window: windowView), config: config)
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
    public static func showInfo(_ content: Any, in contentView: UIView? = nil, position: WYActivityPosition = .middle, offset: CGFloat? = nil, config: WYActivityConfig = .info) {
        
        guard let windowView = sharedContentView(contentView) else {
            return
        }
        WYActivityInfoView().showContent(content, in: windowView, position: position, offset: sharedContentViewOffset(offset: offset, window: windowView), config: config)
    }
    
    /**
     *  显示一个Loading提示窗口
     *
     *  @param content            要显示的文本内容，支持 String 与 NSAttributedString
     *
     *  @param contentView        加载活动控件的父视图
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
    public static func showLoading(_ content: Any? = nil, in contentView: UIView, userInteraction: Bool = true, animation: WYActivityAnimation = .indicator, delay: TimeInterval = 0, config: WYActivityConfig = .loading) {
        
        WYActivityLoadingView.showContent(content, in: contentView, userInteraction: userInteraction, animation: animation, delay: delay, config: config)
    }
    
    /**
     *  移除Loading窗口
     */
    public static func dismissLoading(in contentView: UIView) {
        
        WYActivityLoadingView.dismissLoading(in: contentView)
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

    var movingSpeed: CGFloat = 0.0

    func showContent(_ content: Any, in contentView: UIView, offset: CGFloat, config: WYActivityConfig) {
        
        if contentView.wy_scrollInfoView != nil {
            contentView.wy_scrollInfoView?.stopScroll(initial: true)
        }

        let attributedText = WYActivity.sharedContentAttributed(content: content, textColor: config.scrollInfoTextColor, textFont: config.scrollInfoTextFont)

        let contentSize: CGSize = attributedText.wy_calculateSize(controlSize: CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))

        self.backgroundColor = config.scrollInfoBackgroundColor

        self.frame = CGRect(x: 0, y: offset, width: contentView.frame.size.width, height: contentSize.height + 10)
        contentView.addSubview(self)

        contentLabel.attributedText = attributedText

        contentLabel.frame = CGRect(x: frame.size.width, y: 0, width: contentSize.width, height: frame.size.height)

        movingSpeed = config.movingSpeed

        displayLink.isPaused = false
        
        contentView.wy_scrollInfoView = self
    }

    @objc func refreshScrollInfo() {
        contentLabel.frame.origin.x = contentLabel.frame.origin.x - movingSpeed
        if contentLabel.frame.size.width < self.frame.size.width {
            if contentLabel.frame.origin.x <= wy_screenWidth(5) {
                stopScroll()
            }
        }else {
            if (contentLabel.frame.origin.x + contentLabel.frame.size.width) <= (self.frame.size.width - wy_screenWidth(10)) {
                stopScroll()
                self.superview?.wy_scrollInfoView = nil
            }
        }
    }

    func stopScroll(initial: Bool = false) {

        displayLink.isPaused = true
        displayLink.invalidate()

        UIView.animate(withDuration: (initial ? 0 : 2)) {
            self.alpha = 0.0
        }completion: { _ in
            self.removeActivity()
            self.superview?.wy_scrollInfoView = nil
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
    
    lazy var swipeGesture: UISwipeGestureRecognizer = {
        
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
        swipe.numberOfTouchesRequired = 1
        addGestureRecognizer(swipe)
        return swipe
    }()
    
    var dismissOffset: CGFloat = 0

    func showContent(_ content: Any, in contentView: UIView, position: WYActivityPosition, offset: CGFloat, config: WYActivityConfig) {
        
        if contentView.wy_infoView != nil {
            contentView.wy_infoView?.removeActivity()
        }

        let attributedText = WYActivity.sharedContentAttributed(content: content, textColor: config.infoTextColor, textFont: config.infoTextFont)

        contentLabel.attributedText = attributedText

        self.backgroundColor = config.infoBackgroundColor
        self.wy_add(rectCorner: .allCorners, cornerRadius: wy_screenWidth(10))
        contentView.addSubview(self)

        layoutActivity(contentView: contentView, position: position, offset: offset, config: config)
        
        contentView.wy_infoView = self
    }

    func layoutActivity(contentView: UIView, position: WYActivityPosition, offset: CGFloat, config: WYActivityConfig) {

        let controlWidth: CGFloat = contentView.frame.size.width - [wy_screenWidth(40), wy_screenWidth(120), wy_screenWidth(120)][position.rawValue]

        contentLabel.frame = CGRect(x: wy_screenWidth(10), y: wy_screenWidth(10), width: controlWidth - wy_screenWidth(20), height: wy_screenWidth(10))
        contentLabel.sizeToFit()
        
        swipeGesture.direction = [.up, .left, .down][position.rawValue]
        if position == .middle {
            
            let swipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
            swipe.numberOfTouchesRequired = 1
            swipe.direction = .right
            addGestureRecognizer(swipe)
        }

        showAnimate(contentView: contentView, position: position, offset: offset, config: config)
    }

    func showAnimate(contentView: UIView, position: WYActivityPosition, offset: CGFloat, config: WYActivityConfig) {

        let controlWidth: CGFloat = contentView.frame.size.width - [wy_screenWidth(40), wy_screenWidth(120), wy_screenWidth(120)][position.rawValue]

        switch position {
        case .top:
            
            contentLabel.textAlignment = .left
            let controlHeight: CGFloat = contentLabel.frame.size.height + wy_screenWidth(20)
            
            dismissOffset = -controlHeight

            self.frame = CGRect(x: (contentView.frame.size.width - controlWidth) / 2, y: -controlHeight, width: controlWidth, height: controlHeight)

            UIView.animate(withDuration: 0.5) {

                self.frame = CGRect(x: (contentView.frame.size.width - controlWidth) / 2, y: offset + wy_screenWidth(10), width: controlWidth, height: controlHeight)

            } completion: { _ in

                self.activityTimer = Timer.scheduledTimer(withTimeInterval: self.sharedTimeInterval(config: config), repeats: false, block: { [weak self] _ in
                    self?.dismissActivity(direction: .up, isHandleSwipe: false)
                    self?.superview?.wy_infoView = nil
                })
            }
            break
        default:

            contentLabel.textAlignment = .center

            let contentSize = WYActivity.sharedLayoutSize(contentView: contentView, contentLabel: contentLabel, minimux: wy_screenWidth(80), maxWidth: (contentView.frame.size.width - wy_screenWidth(120)), defaultFont: config.infoTextFont)

            contentLabel.frame = CGRect(x: wy_screenWidth(10), y: wy_screenWidth(10), width: contentSize.width, height: contentSize.height)
            contentLabel.sizeToFit()

            let offsetx = (contentView.frame.size.width - contentLabel.frame.size.width - wy_screenWidth(20)) / 2
            var offsety = (contentView.frame.size.height - contentLabel.frame.size.height - wy_screenWidth(20)) / 2

            let tabbarOffset = wy_currentController()?.tabBarController?.tabBar.isHidden ?? true ? 0 : wy_tabBarHeight

            if position == .middle {
                offsety = (contentView.frame.size.height - contentLabel.frame.size.height - wy_screenWidth(20) - tabbarOffset) / 2
            }else {
                offsety = contentView.frame.size.height - contentLabel.frame.size.height - wy_screenWidth(80) - tabbarOffset
                
                dismissOffset = contentView.frame.size.height
            }
            self.frame = CGRect(x: offsetx, y: offsety, width: contentLabel.frame.size.width + wy_screenWidth(20), height: contentLabel.frame.size.height + wy_screenWidth(20))

            self.alpha = 0
            UIView.animate(withDuration: 0.5) {
                self.alpha = 1.0
            } completion: { _ in

                self.activityTimer = Timer.scheduledTimer(withTimeInterval: self.sharedTimeInterval(config: config), repeats: false, block: { [weak self] _ in
                    self?.dismissActivity(direction: .right, isHandleSwipe: false)
                    self?.superview?.wy_infoView = nil
                })
            }
            break
        }
    }
    
    @objc func handleSwipe(sender: UISwipeGestureRecognizer) {
        dismissActivity(direction: sender.direction, isHandleSwipe: true)
        superview?.wy_infoView = nil
    }

    func dismissActivity(direction: UISwipeGestureRecognizer.Direction, isHandleSwipe: Bool) {
        
        switch direction {
        case .up, .down:
            UIView.animate(withDuration: 0.5) {
                self.wy_top = self.dismissOffset
            } completion: { _ in
                self.removeActivity()
                self.superview?.wy_infoView = nil
            }
            break
        case .left:
            UIView.animate(withDuration: 0.5) {
                self.wy_right = self.superview?.frame.origin.x ?? 0
            } completion: { _ in
                self.removeActivity()
                self.superview?.wy_infoView = nil
            }
            break
        default:
            UIView.animate(withDuration: 0.5) {
                if isHandleSwipe {
                    self.wy_left = self.superview?.wy_right ?? 0
                }else {
                    self.alpha = 0.0
                }
            } completion: { _ in
                self.removeActivity()
                self.superview?.wy_infoView = nil
            }
            break
        }
    }

    func sharedTimeInterval(config: WYActivityConfig) -> TimeInterval {
        return 1.5 + Double((WYActivity.textNumberOfLines(contentLabel: contentLabel, defaultFont: config.infoTextFont) - 1) * 1)
    }

    func removeActivity() {

        activityTimer?.invalidate()
        activityTimer = nil

        var activity: UIView? = self
        activity?.removeFromSuperview()
        activity = nil
    }
}

private class WYActivityLoadingView: UIView {

    var interactionEnabled: Bool = true

    lazy var textlabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.lineBreakMode = .byTruncatingTail
        addSubview(label)
        return label
    }()

    lazy var imageView: UIImageView = {
        let imageview = UIImageView()
        imageview.contentMode = .scaleAspectFit
        addSubview(imageview)
        return imageview
    }()

    lazy var indicator: UIActivityIndicatorView = {

        let activity = UIActivityIndicatorView(style: .whiteLarge)
        addSubview(activity)
        return activity
    }()

    class func showContent(_ content: Any?, in contentView: UIView, userInteraction: Bool = true, animation: WYActivityAnimation, delay: TimeInterval, config: WYActivityConfig) {

        if contentView.wy_loadingView != nil {
            contentView.wy_loadingView?.removeActivity()
        }

        let loadingView = WYActivityLoadingView()
        loadingView.isHidden = true
        loadingView.backgroundColor = config.loadingBackgroundColor
        contentView.addSubview(loadingView)

        loadingView.interactionEnabled = contentView.isUserInteractionEnabled

        contentView.isUserInteractionEnabled = userInteraction

        loadingView.layoutActivity(content: content, contentView: contentView, animation: animation, delay: delay, config: config)

        loadingView.wy_add(rectCorner: .allCorners, cornerRadius: wy_screenWidth(10))

        contentView.wy_loadingView = loadingView
    }

    func layoutActivity(content: Any?, contentView: UIView, animation: WYActivityAnimation, delay: TimeInterval, config: WYActivityConfig) {

        switch animation {
        case .indicator:

            initialLayout(subContro: indicator, contentView: contentView, subControSize: config.animationSize)
            indicator.wy_left = indicator.wy_left + wy_screenWidth(2)
            indicator.wy_top = indicator.wy_top + wy_screenWidth(2)

            indicator.color = config.indicatorColor
            indicator.startAnimating()

            break
        case .gifImage:

            initialLayout(subContro: imageView, contentView: contentView, subControSize: config.animationSize)

            imageView.animationDuration = config.gifImageDuration
            imageView.animationImages = config.loadingImages
            imageView.startAnimating()

            break
        }

        if content != nil {

            let contentString: String? = (content is String) ? (content as? String) : ((content as? NSAttributedString)?.string)

            guard contentString?.count ?? 0 > 0 else {
                return
            }

            let attributedText = WYActivity.sharedContentAttributed(content: content!, textColor: config.loadingTextColor, textFont: config.loadingTextFont, alignment: .center)

            textlabel.numberOfLines = config.loadingNumberOfLines

            textlabel.attributedText = attributedText

            textlabel.sizeToFit()

            let textMinimux: CGFloat = frame.size.width
            var textMaximum: CGFloat = 0
            if config.loadingNumberOfLines > 0 {

                textMaximum = (frame.size.width * 1.5) + (CGFloat(config.loadingNumberOfLines) * textlabel.frame.size.height)
                if (textMaximum > (contentView.frame.size.width - wy_screenWidth(120))) {
                    textMaximum = (contentView.frame.size.width - wy_screenWidth(120))
                }

            }else {
                textMaximum = (contentView.frame.size.width - wy_screenWidth(120))
            }
            textlabel.wy_width = WYActivity.sharedLayoutSize(contentView: contentView, contentLabel: textlabel, minimux: textMinimux, maxWidth: textMaximum, defaultFont: config.loadingTextFont).width

            textlabel.sizeToFit()

            let controWidth = textlabel.frame.size.width < textMinimux ? textMinimux : textlabel.frame.size.width

            var controSize = CGSize(width: controWidth + wy_screenWidth(20), height: frame.size.height + textlabel.frame.size.height)

            if controSize.width < controSize.height {
                controSize.width = controSize.height
                textlabel.wy_width = controSize.width - (wy_screenWidth(10) * 2)
                textlabel.sizeToFit()
                controSize.height = frame.size.height + textlabel.frame.size.height
            }

            self.frame = CGRect(x: (contentView.frame.size.width - controSize.width) / 2, y: (contentView.frame.size.height - controSize.height - navViewHeight(contentView: contentView)) / 2, width: controSize.width, height: controSize.height)

            switch animation {
            case .indicator:

                finishLayout(subContro: indicator, contentView: contentView)
                indicator.wy_left = indicator.wy_left + wy_screenWidth(2)

                break
            case .gifImage:

                finishLayout(subContro: imageView, contentView: contentView)

                break
            }
        }
        perform(#selector(showAnimate), with: nil, afterDelay: delay)
    }

    @objc func showAnimate() {
        self.isHidden = false
        self.alpha = 0.0
        UIView.animate(withDuration: 0.5) {
            self.alpha = 1.0
        }
    }

    class func dismissLoading(in contentView: UIView) {

        guard let loadingView = contentView.wy_loadingView else {
            return
        }
        UIView.animate(withDuration: 0.5) {
            loadingView.alpha = 0.0;
        } completion: { _ in
            loadingView.removeActivity()
            contentView.wy_loadingView = nil
        }
    }

    private func initialLayout(subContro: UIView, contentView: UIView, subControSize: CGSize) {

        self.frame = CGRect(x: (contentView.frame.size.width - subControSize.width - 10) / 2, y: (contentView.frame.size.height - subControSize.height - navViewHeight(contentView: contentView) - 10) / 2, width: subControSize.width + 10, height: subControSize.height + 10)

        subContro.frame = CGRect(x: (frame.size.width - subControSize.width) / 2, y: (frame.size.height - subControSize.height) / 2, width: subControSize.width, height: subControSize.height)
    }

    private func finishLayout(subContro: UIView, contentView: UIView) {

        subContro.frame = CGRect(x: wy_screenWidth(10), y: wy_screenWidth(5), width: frame.size.width - (wy_screenWidth(10) * 2), height: subContro.frame.size.height)

        textlabel.frame = CGRect(x: (frame.size.width - textlabel.frame.size.width) / 2, y: subContro.wy_bottom - wy_screenWidth(5), width: textlabel.frame.size.width, height: textlabel.frame.size.height)
    }

    func navViewHeight(contentView: UIView) -> CGFloat {

        var navHeight: CGFloat = 0
        let controller: UIViewController? = contentView.wy_belongsViewController
        if (contentView == controller?.view) && (controller?.navigationController != nil) {
            navHeight = wy_navViewHeight
        }

        return navHeight
    }

    func removeActivity() {

        var activity: WYActivityLoadingView? = self
        activity?.superview?.isUserInteractionEnabled = interactionEnabled
        activity?.removeFromSuperview()
        activity = nil
    }
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
    static func sharedContentAttributed(content: Any, textColor: UIColor, textFont: UIFont, alignment: NSTextAlignment = .left) -> NSAttributedString {

        var attributed: NSMutableAttributedString? = nil
        if content is String {

            attributed = NSMutableAttributedString(string: content as? String ?? "")
            attributed?.wy_colorsOfRanges(colorsOfRanges: [[textColor: attributed?.string as Any]])
            attributed?.wy_fontsOfRanges(fontsOfRanges: [[textFont: attributed?.string as Any]])
            attributed?.wy_wordsSpacing(wordsSpacing: 1)
            attributed?.wy_lineSpacing(lineSpacing: wy_screenWidth(5), string: attributed?.string, alignment: alignment)
        }else {
            attributed = NSMutableAttributedString(attributedString: content as? NSAttributedString ?? NSAttributedString())
        }
        return attributed!
    }

    /// 计算文本控件最合适的宽度
    static func sharedLayoutSize(contentView: UIView, contentLabel: UILabel, minimux: CGFloat, maxWidth: CGFloat, defaultFont: UIFont) -> CGSize {

        let textHeight = contentLabel.frame.size.height
        let textWidth = contentLabel.frame.size.width

        var contentWidth = minimux;

        if textWidth > minimux {
            for line in 1..<(contentLabel.attributedText?.string.count ?? 0) {

                var maximum = minimux + (textHeight * CGFloat(line))

                if maximum > maxWidth {
                    maximum = maxWidth
                }

                let numberOfLines = textNumberOfLines(controlWidth: maximum, contentLabel: contentLabel, defaultFont: defaultFont)

                if maximum > maxWidth {
                    contentWidth = maxWidth
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

    /// 计算文本控件显示需要的行数
    static func textNumberOfLines(controlWidth: CGFloat = 0, contentLabel: UILabel, defaultFont: UIFont) -> NSInteger {

        let textfont: UIFont = contentLabel.attributedText?.attribute(NSAttributedString.Key.font, at: 0, effectiveRange: nil) as? UIFont ?? defaultFont

        let numberOfLines: NSInteger = contentLabel.attributedText?.string.wy_numberOfRows(font: textfont, controlWidth: (controlWidth > 0 ? controlWidth : contentLabel.frame.size.width), wordsSpacing: 1) ?? 1

        return numberOfLines
    }
}

private extension UIView {
    
    var wy_scrollInfoView: WYActivityScrollInfoView? {

        set(newValue) {

            objc_setAssociatedObject(self, WYAssociatedKeys.private_wy_scrollInfoView, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, WYAssociatedKeys.private_wy_scrollInfoView) as? WYActivityScrollInfoView
        }
    }
    
    var wy_infoView: WYActivityInfoView? {

        set(newValue) {

            objc_setAssociatedObject(self, WYAssociatedKeys.private_wy_infoView, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, WYAssociatedKeys.private_wy_infoView) as? WYActivityInfoView
        }
    }

    var wy_loadingView: WYActivityLoadingView? {

        set(newValue) {

            objc_setAssociatedObject(self, WYAssociatedKeys.private_wy_loadingView, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, WYAssociatedKeys.private_wy_loadingView) as? WYActivityLoadingView
        }
    }

    private struct WYAssociatedKeys {
        
        static let private_wy_scrollInfoView = UnsafeRawPointer(bitPattern: "private_wy_scrollInfoView".hashValue)!
        static let private_wy_infoView = UnsafeRawPointer(bitPattern: "private_wy_infoView".hashValue)!
        static let private_wy_loadingView = UnsafeRawPointer(bitPattern: "private_wy_loadingView".hashValue)!
    }
}
