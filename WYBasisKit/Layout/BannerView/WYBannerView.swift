//
//  WYBannerView.swift
//  WYBasisKit
//
//  Created by Jacke·xu on 2021/4/13.
//  Copyright © 2021 Jacke·xu. All rights reserved.
//
import UIKit
import Kingfisher
import SnapKit

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
    @objc optional func itemDidClick(_ bannerView: WYBannerView, _ bannerIndex: NSInteger)
    
    /// 监控banner的轮播事件
    @objc optional func itemDidScroll(_ bannerView: WYBannerView, _ bannerOffset: CGPoint, _ bannerIndex: NSInteger)
}

public class WYBannerView: UIView {
    
    /// 点击或滚动事件代理(也可以通过传入block监听)
    public weak var delegate: WYBannerViewDelegate?
    
    /**
     * 监控banner点击事件(也可以通过实现代理监听)
     *
     * @param handler 点击事件的block
     */
    public func itemDidClick(handler: @escaping ((_ bannerIndex: NSInteger) -> Void)) {
         clickHandler = handler
    }
    
    /**
     * 监控banner的轮播事件(也可以通过实现代理监听)
     *
     * @param handler 轮播事件的block
     */
    public func itemDidScroll(handler: @escaping ((_ bannerOffset: CGPoint, _ bannerIndex: NSInteger) -> Void)) {
        
        scrollHandler = handler
    }
    
    /**
     *  设置分页控件位置，默认为底部往上5像素且居中
     *  只有一张图片时，pageControl隐藏
     *  第一次reload前设置有效
     */
    public var pageControlPosition: CGPoint = CGPoint(x: (wy_screenWidth / 2), y: -wy_screenWidth(5))
    
    /**
     *  设置分页控件指示器的图片
     *  两个图片必须同时设置，否则设置无效
     *  不设置则为系统默认
     *
     *  @param defaultImage    其他页码的图片
     *  @param currentImage    当前页码的图片
     */
    public func pageControlUpdate(defaultImage: UIImage, currentImage: UIImage) {
        
        pageControlSize = defaultImage.size
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
    
    /// 设置图片的切换模式
    public var switchModel: WYBannerSwitchMode = .scroll
    
    /// 图片显示模式(第一次reload前设置有效)
    public var imageContentMode: UIView.ContentMode = .scaleAspectFit
    
    /**
     *  每一页停留时间，默认为3s，最少1s
     *  当设置的值小于1s时，则为默认值
     */
    public var standingTime: TimeInterval = 3
    
    /**
     *  是否需要自动轮播，默认开启
     *  当设置false时，会关闭定时器
     *  当设置true时，unlimitedCarousel会强制设置为True
     */
    public var automaticCarousel: Bool {

        set {
            if ((_automaticCarousel == true) && (newValue == false) && (imageArray.count > 3) && (pageControl.numberOfPages < imageArray.count)) {

                imageArray.removeFirst()
                imageArray.removeLast()

                describeArray.removeFirst()
                describeArray.removeLast()
                
                stopTimer()
                collectionView.reloadData()
            }
            _automaticCarousel = newValue
            if newValue == false {
                stopTimer()
            }else {
                unlimitedCarousel = newValue
                reload(images: imageArray, describes: describeArray)
            }
        }
        get {
            return _automaticCarousel
        }
    }

    /**
     *  是否需要无限轮播，默认开启
     *  当设置false时，会强制设置automaticCarousel为false
     */
    public var unlimitedCarousel: Bool {
    
        set {
            if ((_unlimitedCarousel == true) && (newValue == false) && (imageArray.count > 3) && (pageControl.numberOfPages < imageArray.count)) {

                imageArray.removeFirst()
                imageArray.removeLast()

                describeArray.removeFirst()
                describeArray.removeLast()
                
                stopTimer()
                collectionView.reloadData()
            }
            _unlimitedCarousel = newValue
            if newValue == false {
                stopTimer()
                automaticCarousel = newValue
            }else {
                reload(images: imageArray, describes: describeArray)
            }
        }
        get {
            return _unlimitedCarousel
        }
    }
    
    /// banner图背景色(第一次reload前设置有效)
    public var bannerBackgroundColor: UIColor = .clear
    
    /// 描述文本控件frame, 默认底部居中(第一次reload前设置有效)
    public var describeViewFrame: CGRect = .zero
    
    /// 描述文本内容位置(第一次reload前设置有效)
    public var describeTextAlignment: NSTextAlignment = .center
    
    /// 描述文本颜色(第一次reload前设置有效)
    public var describeTextColor: UIColor = .black
    
    /// 描述文本背景色(第一次reload前设置有效)
    public var describeBackgroundColor: UIColor = .clear
    
    /// 描述文本字体(第一次reload前设置有效)
    public var describeTextFont: UIFont = .systemFont(ofSize: wy_fontSize(12))
    
    /// 描述占位文本(第一次reload前设置有效)
    public var placeholderDescribe: String?
    
    /// 占位图
    public var placeholderImage: UIImage = WYBannerView.getPlaceholderImage()
    
    /**
     *  刷新/显示轮播图
     *
     *  @param images    轮播图片数组(可以是UIImage，也可以是图片网络路径)，如果不传的话会去调用imageArray后刷新
     */
    public func reload(images: [Any] = [], describes: [String] = []) {
        
        DispatchQueue.main.async {
            
            self.superview?.layoutIfNeeded()
            
            self.imageArray.removeAll()
            self.describeArray.removeAll()
            
            if images.isEmpty == true {
                self.imageArray.append(self.placeholderImage as Any)
            }else {
                if ((images.count > 1) && (self.unlimitedCarousel == true)) {
                    self.imageArray.append(images.last as Any)
                    self.imageArray.append(contentsOf: images)
                    self.imageArray.append(images.first as Any)
                    self.pageControl.numberOfPages = self.imageArray.count - 2
                }else {
                    self.imageArray = images
                    self.pageControl.numberOfPages = images.count
                }
            }
            if describes.isEmpty == true {
                self.describeArray.append(self.placeholderDescribe ?? " ")
            }else {
                if ((describes.count > 1) && (self.unlimitedCarousel == true)) {
                    self.describeArray.append(describes.last ?? self.placeholderDescribe ?? " ")
                    self.describeArray.append(contentsOf: describes)
                    self.describeArray.append((describes.first ?? self.placeholderDescribe) ?? " ")
                }else {
                    self.describeArray = describes
                }
            }
            
            if (self.pageControl.numberOfPages != self.imageArray.count) {
                
                self.collectionView.reloadData()
                self.collectionView.performBatchUpdates {
                    
                    self.showSwitchAnimation(indexPath: IndexPath(item: self.currentIndex, section: 0), animation: false)
                    
                    self.pageControl.isHidden = false
                    self.pageControl.currentPage = (self.currentIndex - 1)
                    if (self.automaticCarousel == true) {
                        if self.timer == nil {
                            self.startTimer()
                        }
                    }else {
                        self.stopTimer()
                    }
                }

            }else {
                self.stopTimer()
                self.collectionView.reloadData()
                self.pageControl.isHidden = (images.count <= 1)
                if images.count > 1 {
                    if self.pageControl.numberOfPages <= 0 {
                        self.pageControl.currentPage = 0
                    }else {
                        self.pageControl.currentPage = (self.currentIndex > (images.count - 1)) ? 0 : self.currentIndex
                    }
                }
            }
            self.collectionView.bounces = (self.pageControl.numberOfPages != self.imageArray.count)
            self.bringSubviewToFront(self.pageControl)
        }
    }
    
    /**
     *  开启定时器
     *  默认开启，调用该方法会重新开启
     */
    public func startTimer() {
        
        // 如果定时器已开启，先停止再根据条件重新开启
        if (timer != nil) {
            stopTimer()
        }
        // 判断是否需要开启定时器
        if ((imageArray.count <= 1) || (unlimitedCarousel == false) || (automaticCarousel == false) || (pageControl.numberOfPages == imageArray.count)) { return }
        
        timer = Timer.scheduledTimer(timeInterval: (standingTime < 1) ? 3 : standingTime, target: self, selector: #selector(nextPage), userInfo: nil, repeats: true)
        
        userTiming = true
    }

    /**
     *  停止定时器
     *  滚动视图将不再自动轮播
     */
    public func stopTimer() {
        
        timer?.invalidate()
        timer = nil
    }
    
    /**
     *  是否需要自动轮播，默认开启
     */
    private var _automaticCarousel: Bool = true
    /**
     *  是否需要无限轮播，默认开启
     */
    private var _unlimitedCarousel: Bool = true
    /**
     *  设置分页控件位置，默认为底部往上5像素且居中
     *  只有一张图片时，pageControl隐藏
     */
    private var _pageControlPosition: CGPoint = .zero
    /// 轮播图片数组(可以是UIImage或图片网络路径，也可以是本地图片的图片名)
    private var imageArray: [Any] = []
    /// 描述文本数组
    private var describeArray: [String] = []
    // 当前显示图片的索引
    private var currentIndex: NSInteger = 1
    // pageControl图片大小
    private var pageControlSize: CGSize?
    // 定时器startTimer
    private var timer: Timer?
    // 判断手动拖拽后是否需要启动定时器
    private var userTiming: Bool = false
    // block点击事件
    private var clickHandler: ((_ bannerIndex: NSInteger) -> Void)?
    // block轮播事件
    private var scrollHandler: ((_ bannerOffset: CGPoint, _ bannerIndex: NSInteger) -> Void)?

    // 分页控件
    private lazy var pageControl: UIPageControl = {
        
        let pagecontrol = UIPageControl()
        pagecontrol.isUserInteractionEnabled = false
        addSubview(pagecontrol)
        pagecontrol.snp.makeConstraints { (make) in
            
            if pageControlPosition.equalTo(CGPoint(x: (wy_screenWidth / 2), y: -wy_screenWidth(5))) {
                make.centerX.equalToSuperview()
                make.bottom.equalToSuperview().offset(pageControlPosition.y)
            }else {
                make.left.equalTo(pageControlPosition.x)
                make.top.equalTo(pageControlPosition.y)
            }
            make.width.lessThanOrEqualToSuperview()
        }
        return pagecontrol
    }()
    
    // 使用UICollectionView实现轮播
    private lazy var collectionView: UICollectionView = {

        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0
        flowLayout.itemSize = CGSize(width: bounds.size.width, height: bounds.size.height)
        
        let collectionview = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionview.showsVerticalScrollIndicator = false
        collectionview.showsHorizontalScrollIndicator = false
        collectionview.alwaysBounceHorizontal = true
        collectionview.isPagingEnabled = true
        collectionview.delegate = self
        collectionview.dataSource = self
        collectionview.backgroundColor = bannerBackgroundColor
        collectionview.register(WYBannerCell.self, forCellWithReuseIdentifier: "WYBannerCell")
        addSubview(collectionview)
        collectionview.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        return collectionview
    }()
    
    public init() {
        super.init(frame: .zero)
    }
    
    private class func getPlaceholderImage() -> UIImage {
        
        let bundlePath = Bundle(for: WYBannerView.self).resourcePath! + "/WYBannerView.bundle"
        let bannerBundle = Bundle(path: bundlePath)
        let placeholder = UIImage(named: "placeholder_"+WYLocalizableManager.currentLanguage().rawValue, in: bannerBundle, compatibleWith: nil)
        return placeholder ?? UIImage(named: "placeholder_"+WYLanguage.chinese.rawValue, in: bannerBundle, compatibleWith: nil)!
    }
    
    @objc private func nextPage() {
        
        guard self.superview != nil else {
            stopTimer()
            return
        }
        currentIndex += 1
        if currentIndex == 1 {
            currentIndex = (imageArray.count - 1)
        }
        if currentIndex >= imageArray.count {
            currentIndex = 2
        }
        if currentIndex < imageArray.count {
            showSwitchAnimation(indexPath: IndexPath(item: currentIndex, section: 0), animation: true)
            if currentIndex == (imageArray.count - 1) {
                self.perform(#selector(changeCurrentIndex), with: nil, afterDelay: 1)
            }
        }
    }
    
    @objc private func changeCurrentIndex() {
        currentIndex = 1
    }
    
    @objc private func setUnlimitedCarousel() {
        
        let offsetx = collectionView.contentOffset.x
        let currentPage = offsetx / collectionView.frame.size.width
        if pageControl.numberOfPages != imageArray.count {
            // 左滑
            if offsetx <= 0 {
                let indexPath = IndexPath(item: imageArray.count - 2, section: 0)
                showSwitchAnimation(indexPath: indexPath, animation: false)
            }
            // 右滑
            if (offsetx >= (collectionView.bounds.size.width * CGFloat((imageArray.count - 1)))) {
                let indexPath = IndexPath(item: 1, section: 0)
                showSwitchAnimation(indexPath: indexPath, animation: false)
            }
            if currentPage == 0 {
                pageControl.currentPage = (pageControl.numberOfPages - 1)
            }else if (currentPage == CGFloat((imageArray.count - 1))) {
                pageControl.currentPage = 0
            }else {
                pageControl.currentPage = Int((currentPage - 1))
            }
        }else {
            collectionView.alwaysBounceHorizontal = false
            pageControl.currentPage = Int(currentPage)
        }
        currentIndex = NSInteger(currentPage)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

extension WYBannerView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return imageArray.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: WYBannerCell = collectionView.dequeueReusableCell(withReuseIdentifier: "WYBannerCell", for: indexPath) as! WYBannerCell
        
        cell.bannerBackgroundColor = bannerBackgroundColor
        cell.describeTextColor = describeTextColor
        cell.describeBackgroundColor = describeBackgroundColor
        cell.describeTextFont = describeTextFont
        cell.describeTextAlignment = describeTextAlignment
        cell.describeViewFrame = describeViewFrame
        cell.placeholderImage = placeholderImage
        cell.imageContentMode = imageContentMode

        cell.reload(image: imageArray[indexPath.item], describe: (indexPath.item < describeArray.count) ? describeArray[indexPath.item] : (placeholderDescribe ?? ""))
        
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard !((imageArray.count == 1) && (imageArray.first is UIImage) && ((imageArray.first as! UIImage) == placeholderImage)) else {
            return
        }
        
        let index = (imageArray.count == pageControl.numberOfPages) ? indexPath.item : ((imageArray.count > 1 ) ? (indexPath.item - 1) : indexPath.item)

        delegate?.itemDidClick?(self, index)
        
        if clickHandler != nil {
            
            clickHandler!(index)
        }
    }
    
    // 开始拖动时停止定时器
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        stopTimer()
    }
    
    // 实现无限轮播
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // 支持无限轮播
        setUnlimitedCarousel()
        
        guard !((imageArray.count == 1) && (imageArray.first is UIImage) && ((imageArray.first as! UIImage) == placeholderImage)) else {
            return
        }

        let contentOffset = CGPoint(x: scrollView.contentOffset.x - ((pageControl.numberOfPages != imageArray.count) ? collectionView.frame.size.width : 0.0), y: 0)

        // 判断只有滚动到准确下标后才返回代理或block
        if (contentOffset.x.truncatingRemainder(dividingBy: collectionView.frame.size.width) == 0) {
            if ((imageArray.count != pageControl.numberOfPages) && ((currentIndex == (imageArray.count - 1) || (currentIndex == 0)))) {
                return
            }
            let bannerIndex = NSInteger(contentOffset.x / collectionView.frame.size.width)
            if scrollHandler != nil {
                scrollHandler!(contentOffset, bannerIndex)
            }
            delegate?.itemDidScroll?(self, contentOffset, bannerIndex)
        }
    }
    
    // 根据不同的显示模式提供切换动画
    func showSwitchAnimation(indexPath: IndexPath, animation: Bool) {
        
        switch switchModel {
        case .scroll:
            collectionView.scrollToItem(at: indexPath, at: ((animation == false) ? .init() : .left), animated: animation)
            break
        case .fade:
            if (indexPath.row == (imageArray.count == pageControl.numberOfPages ? 0 : 1)) {
                self.collectionView.performBatchUpdates {
                    self.collectionView.scrollToItem(at: indexPath, at: .init(), animated: false)
                } completion: { ( finish) in
                    let currentCell = self.collectionView.visibleCells.first
                    currentCell?.contentView.alpha = 1.0
                }
                return
            }
            let currentCell = collectionView.visibleCells.first
            currentCell?.contentView.alpha = 1.0
            UIView.animate(withDuration: 1) {
                currentCell?.contentView.alpha = 0.0
            }completion: { (finish) in
                currentCell?.contentView.alpha = 1.0
                self.collectionView.performBatchUpdates {
                    self.collectionView.scrollToItem(at: indexPath, at: .init(), animated: false)
                } completion: { ( finish) in
                    let nextCell = self.collectionView.visibleCells.first
                    nextCell?.contentView.alpha = 0.0
                    UIView.animate(withDuration: 1) {
                        nextCell?.contentView.alpha = 1.0
                    }
                }
            }
            break
        }
    }
    
    // 判断是否重启定时器
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {

        if ((userTiming == true) && (unlimitedCarousel == true) && (automaticCarousel == true) && (pageControl.numberOfPages != imageArray.count)) {
            startTimer()
        }
    }
}

private class WYBannerCell: UICollectionViewCell {
    
    internal var bannerBackgroundColor: UIColor!
    internal var describeTextColor: UIColor!
    internal var describeBackgroundColor: UIColor!
    internal var describeTextFont: UIFont!
    internal var describeTextAlignment: NSTextAlignment!
    internal var describeViewFrame: CGRect!
    internal var placeholderImage: UIImage!
    internal var imageContentMode: UIView.ContentMode!

    internal lazy var bannerView: UIImageView = {
        
        contentView.backgroundColor = bannerBackgroundColor
    
        let bannerview = UIImageView()
        bannerview.backgroundColor = bannerBackgroundColor
        bannerview.contentMode = imageContentMode
        contentView.addSubview(bannerview)
        bannerview.snp.makeConstraints { (make) in
            
            make.edges.equalToSuperview()
        }
        return bannerview
    }()
    
    internal lazy var describeView: UILabel = {
    
        let describeview = UILabel()
        describeview.font = describeTextFont
        describeview.backgroundColor = describeBackgroundColor
        describeview.textColor = describeTextColor
        describeview.textAlignment = describeTextAlignment
        contentView.addSubview(describeview)
        describeview.snp.makeConstraints { (make) in
            if describeViewFrame.equalTo(.zero) {
                make.width.centerX.bottom.equalToSuperview()
            }else {
                make.left.equalTo(describeViewFrame.origin.x)
                make.top.equalTo(describeViewFrame.origin.y)
                make.size.equalTo(describeViewFrame.size)
            }
        }
        return describeview
    }()
    
    func reload(image: Any, describe: String) {
        
        if image is UIImage {
            bannerView.image = image as? UIImage
        }else {
            bannerView.kf.setImage(with: URL(string: image as? String ?? ""), placeholder: placeholderImage)
        }
        describeView.text = describe
    }
}
