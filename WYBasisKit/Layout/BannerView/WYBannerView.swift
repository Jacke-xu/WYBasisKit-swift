//
//  WYBannerView.swift
//  WYBasisKit
//
//  Created by Jacke·xu on 2021/4/13.
//  Copyright © 2021 Jacke·xu. All rights reserved.
//

import UIKit

/// 图片切换效果
public enum WYBannerSwitchMode {
    
    /// 滚动切换
    case scroll
    
    /// 淡入淡出
    case fade
}

/// 分页控件显示位置
public enum WYPageControlPosition {
    
    /// 左下角
    case bottomLeft
    /// 右下角
    case bottomRight
    /// 底部居中
    case bottomCenter
    /// 隐藏
    case hide
}

@objc public protocol WYBannerViewDelegate {
    
    /// 监控banner点击事件
    @objc optional func didClick(_ bannerView: WYBannerView, _ index: NSInteger)
    
    /// 监控banner的轮播事件
    @objc optional func didScroll(_ bannerView: WYBannerView, _ offset: CGPoint, _ index: NSInteger)
}

public class WYBannerView: UIView {
    
    /// 点击或滚动事件代理(也可以通过传入block监听)
    public weak var delegate: WYBannerViewDelegate?
    
    /// 设置Banner切换模式，默认为scroll
    public var switchMode: WYBannerSwitchMode = .scroll
    
    /// 图片显示模式
    public var imageContentMode: UIView.ContentMode = .scaleAspectFit
    
    /// banner控件背景色
    public var bannerBackgroundColor: UIColor = .clear
    
    /// 描述控件占位文本
    public var placeholderDescribe: String = ""
    
    /// 占位图
    public var placeholderImage: UIImage = WYBannerView.sharedPlaceholderImage()
    
    /**
     *  设置分页控件位置，默认为bottomCenter
     *  只有一张图片时，pageControl隐藏
     */
    public var pageControlPosition: WYPageControlPosition = .bottomCenter
    
    /**
     *  设置分页控件距离滚动控件底部间距，默认wy_screenWidth(5)
     *  只有一张图片时，pageControl隐藏
     */
    public var margin_bottom_pageControl: CGFloat = wy_screenWidth(5)
    
    /**
     *  每一页停留时间，默认为3s，最少1s
     *  当设置的值小于1s时，则为默认值
     */
    public var timeInterval: TimeInterval = 3 {
        
        didSet {
            
            guard timeInterval != oldValue else {
                return
            }
            
            if timeInterval < 1 {
                
                timeInterval = 1
            }
        }
    }
    
    /**
     *  是否需要自动轮播，默认开启
     *  当设置false时，会关闭定时器
     *  当设置true时，unlimitedCarousel会强制设置为True
     */
    public var autoCarousel: Bool = true {
        
        didSet {
            
            if oldValue != autoCarousel {
                
                if autoCarousel == true {
                    unlimitedCarousel = true
                }
                updateContentSize()
            }
        }
    }
    
    /**
     *  是否需要无限轮播，默认开启
     *  当设置false时，会强制设置autoCarousel为false
     */
    public var unlimitedCarousel: Bool = true {
        
        didSet {
            
            if oldValue != unlimitedCarousel {
                
                if unlimitedCarousel == false {
                    autoCarousel = false
                }
                updateContentSize()
            }
        }
    }
    
    /**
     *  文本描述控件高度
     */
    public var describeLabelHeight: CGFloat = wy_screenWidth(20)
    
    /**
     *  文本描述控件和滚动控件的垂直间距
     */
    public var margin_vertical_describe: CGFloat = wy_screenWidth(5)
    
    /**
     *  文本描述控件距离滚动控件的左间距
     */
    public var margin_horizontal_describe: CGFloat = wy_screenWidth(10)
    
    /**
     *  设置要显示的图片数组和描述文本数组
     *
     *  @param images 轮播的图片数组，只能是UIImage或者网络url(String类型)
     *
     *  @param describes 描述图片的字符串数组，应与图片顺序对应，为空时描述控件自动隐藏
     *
     */
    public func show(_ images: [Any] = [], _ describes: [String] = []) {
        
        DispatchQueue.main.async {
            
            self.superview?.layoutIfNeeded()
            
            self.imageArray.removeAll()
            self.describeArray.removeAll()
            
            self.describeLabel.isHidden = ((describes.isEmpty && self.placeholderDescribe.isEmpty) || (images.isEmpty)) ? true : false
            
            if images.isEmpty {
                self.imageArray.append(self.placeholderImage)
                self.describeArray.append(self.placeholderDescribe)
            }else {
            
                for objectIndex in 0..<images.count {
                    if images[objectIndex] is UIImage {
                        self.imageArray.append(images[objectIndex] as? UIImage ?? self.placeholderImage)
                    }
                    if images[objectIndex] is String {
                        // 如果是网络图片，则先添加占位图片，下载完成后替换
                        self.imageArray.append(self.placeholderImage)
                        self.downloadImage(imageIndex:objectIndex)
                    }
                    
                    self.describeArray.append((objectIndex < self.describeArray.count) ? describes[objectIndex] : self.placeholderDescribe)
                }
            }
            self.reload()
        }
    }
    
    /// 图片描述控件，默认在底部
    public lazy var describeLabel: UILabel = {
        
        let label = UILabel()
        label.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        label.textColor = .white
        label.font = .systemFont(ofSize: wy_fontSize(15))
        label.textAlignment = .center
        addSubview(label)
        
        return label
    }()
    
    /**
     *  设置分页控件指示器的图片
     *  两个图片必须同时设置，否则设置无效
     *  不设置则为系统默认
     *
     *  @param defaultImage    其他页码的图片
     *  @param currentImage    当前页码的图片
     */
    public func pageControlUpdate(defaultImage: UIImage, currentImage: UIImage) {
        pageControl.setValue(currentImage, forKey: "_currentPageImage")
        pageControl.setValue(defaultImage, forKey: "_pageImage")
    }
    
    /**
     *  设置分页控件指示器的颜色
     *  不设置则为系统默认
     *
     *  @param defaultColor    其他页码的颜色
     *  @param currentColor    当前页码的颜色
     */
    public func pageControlUpdate(defaultColor: UIColor, currentColor: UIColor) {
        pageControl.pageIndicatorTintColor = defaultColor
        pageControl.currentPageIndicatorTintColor = currentColor
    }
    
    /**
     *  开启定时器
     *  默认已开启，调用该方法会重新开启
     */
    public func startTimer() {
        
        // 如果只有一张图片，或者自动轮播、无限轮播是关闭状态，则直接返回，不开启定时器
//        guard (imageArray.count > 1) && (autoCarousel == true) && (unlimitedCarousel == true) else {
//            return
//        }
//
//        // 如果定时器已开启，先停止再重新开启
//        if timer != nil {
//            stopTimer()
//        }
//
//        timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true, block:{ [weak self] (timer: Timer) -> Void in
//            self?.switchImage()
//        })
//        // 把定时器加入到RunLoop里面，保证持续运行，不被表视图滑动事件这些打断
//        RunLoop.current.add(timer!, forMode: .common)
//
//        useTimer = true
//        autoCarousel = true
//        unlimitedCarousel = true
    }
    
    /**
     *  停止定时器
     *  停止后，如果手动滚动图片，定时器会检查滚动前的定时器状态，判断是否需要重启定时器
     */
    public func stopTimer() {
        
        timer?.invalidate()
        timer = nil
        useTimer = false
        
        autoCarousel = false
    }
    
    /**
     * 监控banner点击事件(也可以通过实现代理监听)
     *
     * @param handler 点击事件的block
     */
    public func didClick(handler: @escaping ((_ index: NSInteger) -> Void)) {
         clickHandler = handler
    }
    
    /**
     * 监控banner的轮播事件(也可以通过实现代理监听)
     *
     * @param handler 轮播事件的block
     */
    public func didScroll(handler: @escaping ((_ offset: CGPoint, _ index: NSInteger) -> Void)) {
        scrollHandler = handler
    }
    
    // block点击事件
    private var clickHandler: ((_ index: NSInteger) -> Void)?
    // block轮播事件
    private var scrollHandler: ((_ offset: CGPoint, _ index: NSInteger) -> Void)?
    // 获取本地占位图
    private class func sharedPlaceholderImage() -> UIImage {
        
        let bundlePath = Bundle(for: WYBannerView.self).resourcePath! + "/WYBannerView.bundle"
        let bannerBundle = Bundle(path: bundlePath)
        let placeholder = UIImage(named: "placeholder_"+WYLocalizableManager.shared.currentLanguage().rawValue, in: bannerBundle, compatibleWith: nil)
        return placeholder ?? UIImage()
    }
    
    // 滚动控件
    private lazy var scrollView: UIScrollView = {
        
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: wy_width, height: wy_height))
        scrollView.isPagingEnabled = true
        scrollView.bounces = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delegate = self
        
        // 添加手势，监听图片的点击事件
        scrollView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didClickImage)))
        
        otherImageView.contentMode = imageContentMode
        otherImageView.wy_size = CGSize(width: wy_width, height: wy_height)
        scrollView.addSubview(otherImageView)
        
        currentImageView.contentMode = imageContentMode
        currentImageView.wy_size = CGSize(width: wy_width, height: wy_height)
        scrollView.addSubview(currentImageView)
        
        useTimer = true
        
        otherImageView.backgroundColor = .orange
        currentImageView.backgroundColor = .purple
        
        addSubview(scrollView)
        
        return scrollView
    }()
    
    // 分页控件
    private lazy var pageControl: UIPageControl = {
        
        let pageControl = UIPageControl()
        pageControl.isUserInteractionEnabled = false
        addSubview(pageControl)
        
        switch pageControlPosition {
        case .bottomLeft:
            break
        case .bottomCenter:
            
            break
        case .bottomRight:
            
            break
        case .hide:
            break
        }
        
        return pageControl
    }()
    
    // 当前正在显示的imageView
    private let currentImageView = UIImageView()
    
    // 轮播显示的imageView
    private let otherImageView = UIImageView()
    
    // 当前显示图片的索引
    private var currentIndex: NSInteger = 0
    
    // 定时器
    private var timer: Timer?
    
    // 判断手动拖拽后是否需要启动定时器
    private var useTimer: Bool = false
    
    /// 轮播的图片数组
    private var imageArray: [UIImage] = []
    /// 描述文本数组
    private var describeArray: [String] = []
    
    @objc private func didClickImage() {
        
    }
    
    private func switchImage(first: Bool = false) {
        
        let nextIndex: NSInteger = first ? currentIndex : ((currentIndex == (imageArray.count - 1)) ? 0 : (currentIndex + 1))
        
        wy_print("currentIndex = \(currentIndex), nextIndex = \(nextIndex)")
        
        if first {
            
            if imageArray.count > 1 {
                
                currentImageView.wy_origin = CGPoint(x: (unlimitedCarousel == true) ? wy_width : 0, y: 0)
                otherImageView.wy_origin = CGPoint(x: (unlimitedCarousel == true) ? wy_width : 0, y: 0)
                scrollView.contentOffset = currentImageView.wy_origin
                
            }else {
                currentImageView.wy_origin = CGPoint.zero
                otherImageView.wy_origin = CGPoint.zero
            }
            currentImageView.image = imageArray[currentIndex]

            describeLabel.text = describeArray[currentIndex]
            
            return
        }
        
        switch switchMode {
        case .scroll:
            // 滚动切换模式直接修改偏移量就行
            otherImageView.wy_origin = CGPoint(x: wy_width * ((unlimitedCarousel == true) ? 2 : 1), y: 0)
            scrollView.setContentOffset(otherImageView.wy_origin, animated: true)
            break
        case .fade:
            // 淡入淡出模式，不需要修改scrollview偏移量，改变两张图片的透明度即可
            otherImageView.image = imageArray[nextIndex]
            UIView.animate(withDuration: 1.2) {
                self.currentImageView.alpha = 0.0
                self.otherImageView.alpha = 1.0
                self.pageControl.currentPage = nextIndex
            } completion: { _ in
                self.switchDisplay()
            }
            break
        }
    }
    
    private func switchDisplay() {
        
        guard currentImageView.image == otherImageView.image else {
            return
        }
        
        switch switchMode {
        case .fade:
            currentImageView.alpha = 1.0
            otherImageView.alpha = 0.0
            break
        default :
            break
        }
        
        // 切换到下一张图片
        currentImageView.image = otherImageView.image
        
        currentIndex = (currentIndex == (imageArray.count - 1)) ? 0 : (currentIndex + 1)
        scrollView.contentOffset = CGPoint(x: wy_width, y: 0)

        pageControl.currentPage = currentIndex
        
        describeLabel.text = describeArray[currentIndex]
    }
    
    // 当图片滚动过半时就修改当前页码
    private func updatePageControlCurrentPage(_ offset: CGFloat) {
        
        if ((offset - (wy_width * CGFloat(pageControl.currentPage + 1))) > (wy_width * 0.5) && (unlimitedCarousel == true) && (currentIndex != (pageControl.numberOfPages - 1))) {
            pageControl.currentPage = (pageControl.currentPage + 1) > (pageControl.numberOfPages - 1) ? 0 : (pageControl.currentPage + 1)
        }else if (((wy_width * CGFloat(pageControl.currentPage - 1)) - offset)  > (wy_width * 0.5)) && (unlimitedCarousel == true) && (currentIndex != 0) {
            
            pageControl.currentPage = (pageControl.currentPage - 1) < 0 ? (pageControl.numberOfPages - 1) : (pageControl.currentPage - 1)
        }else {
            pageControl.currentPage = currentIndex
        }
    }
    
    private func updateContentSize() {

        // 需要的contentSize
        let needContentSize = (autoCarousel == true || unlimitedCarousel == true) ? CGSize(width: wy_width * 3, height: wy_height) : CGSize(width: wy_width * CGFloat(imageArray.count > 3 ? 3 : imageArray.count), height: wy_height)
        
        // 排除相等的情况
        guard scrollView.contentSize.equalTo(needContentSize) == false else {
            return
        }
        
        // 更新需要的contentSize
        scrollView.contentSize = needContentSize
    }
    
    private func reload() {
        
        if currentIndex > (imageArray.count - 1) {
            currentIndex = 0
        }
        autoCarousel = ((imageArray.count > 1) && (autoCarousel == true)) ? true : false

        unlimitedCarousel = ((imageArray.count > 1) && (unlimitedCarousel == true)) ? true : false
        
        updateContentSize()

        if autoCarousel == true && unlimitedCarousel == true && imageArray.count > 1 {
            startTimer()
        }else {
            stopTimer()
        }
        switchImage(first: currentIndex == 0)
        pageControl.numberOfPages = imageArray.count
    }
    
    private func downloadImage(imageIndex: Int) {
        
    }
    
    private func clearDiskCache() {
        
    }
    
    deinit {
        wy_print("WYBannerView 准备释放")
        stopTimer()
        wy_print("WYBannerView 已经释放")
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

extension WYBannerView: UIScrollViewDelegate {
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        guard scrollView.contentSize.equalTo(.zero) == false else {
            return
        }
        
        let offset = scrollView.contentOffset.x

        //滚动过程中改变pageControl的当前页码
        updatePageControlCurrentPage(offset)
        
        if (offset - (wy_width * CGFloat(pageControl.currentPage + 1))) > (wy_width * 0.5) {
            
            wy_print("offset = \(offset), + 1")
            
            otherImageView.image = imageArray[(currentIndex + 1) > (imageArray.count - 1) ? 0 : (currentIndex + 1)]
            
            switch switchMode {
            case .fade:
                currentImageView.alpha = offset / wy_width - 1
                otherImageView.alpha = 2 - offset / wy_width
                break
            default:
                otherImageView.wy_origin = CGPoint(x: currentImageView.wy_right, y: 0)
                break
            }
            switchDisplay()
        }
        
        if ((wy_width * CGFloat(pageControl.currentPage - 1)) - offset)  > (wy_width * 0.5) {
            
            wy_print("offset = \(offset), - 1")
            
            otherImageView.image = imageArray[currentIndex > 0 ? (currentIndex - 1) : (imageArray.count - 1)]
            
            switch switchMode {
            case .fade:
                currentImageView.alpha = 3 - offset / wy_width
                otherImageView.alpha = offset / wy_width - 2
                break
            default:
                otherImageView.wy_origin = CGPoint.zero
                break
            }
            switchDisplay()
        }
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        if useTimer {
            stopTimer()
            useTimer = true
        }else {
            stopTimer()
        }
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        // 滚动结束后让currentImageView无缝显示otherImageView的图片
        switchDisplay()
        
        if useTimer {
           startTimer()
        }else {
            stopTimer()
        }
    }
}
