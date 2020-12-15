//
//  WYBannerView.swift
//  WYBasisKit
//
//  Created by jacke·xu on 2020/12/14.
//  Copyright © 2020 jacke·xu. All rights reserved.
//

import UIKit
import Kingfisher

@objc public protocol WYBannerViewDelegate {
    
    /// 监控banner点击事件
    @objc optional func itemDidClick(_ bannerView: WYBannerView, _ bannerIndex: NSInteger)
    
    /// 监控banner的轮播事件
    @objc optional func itemDidScroll(_ bannerView: WYBannerView, _ bannerOffset: CGPoint)
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
    public func itemDidScroll(handler: @escaping ((_ bannerOffset: CGPoint) -> Void)) {
        
        scrollHandler = handler
    }
    
    /**
     *  设置分页控件位置，默认为底部往上30像素且居中
     *  只有一张图片时，pageControl隐藏
     */
    public var pageControlPosition: CGPoint = .zero
    
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
    
    /// 设置图片的切换模式, 默认轮播滚动
    public var switchModel: WYBannerSwitchMode = .scroll
    
    /// 图片显示模式
    public var imageContentMode: UIView.ContentMode = .scaleAspectFit
    
    /**
     *  每一页停留时间，默认为3s，最少1s
     *  当设置的值小于1s时，则为默认值
     */
    public var standingTime: TimeInterval = 3
    
    /**
     *  是否需要无限轮播，默认开启
     *  当设置false时，会关闭定时器
     */
    public var unlimitedCarousel: Bool {
    
        set {
            if ((_unlimitedCarousel == true) && (newValue == false) && (imageArray.count > 3)) {
                
                imageArray.removeFirst()
                imageArray.removeLast()
                
                describeArray.removeFirst()
                describeArray.removeLast()
                
                stopTimer()
            }
            _unlimitedCarousel = newValue
        }
        
        get {
            return _unlimitedCarousel
        }
    }
    
    /// 设置圆角位置，默认4角圆角
    public var rectCorner: UIRectCorner = .allCorners
    
    /// 设置圆角半径，默认0
    public var cornerRadius: CGFloat = 0.0
    
    /// banner图背景色
    public var bannerBackgroundColor: UIColor = .clear
    
    /// 描述文本控件frame, 默认底部居中
    public var describeViewFrame: CGRect = .zero
    
    /// 描述文本内容位置
    public var describeTextAlignment: NSTextAlignment = .center
    
    /// 描述文本颜色
    public var describeTextColor: UIColor = .black
    
    /// 描述文本背景色
    public var describeBackgroundColor: UIColor = .clear
    
    /// 描述文本字体
    public var describeTextFont: UIFont = .systemFont(ofSize: wy_screenWidthRatioValue(value: 12))
    
    /// 描述占位文本
    public var placeholderDescribe: String?
    
    /// 占位图
    public var placeholderImage: UIImage!
    
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
            self.unlimitedCarousel = (images.count > 1)
            
            if images.isEmpty == true {
                
                self.imageArray.append(self.placeholderImage as Any)
                
            }else {
                
                if images.count > 1 {
                    
                    self.imageArray.append(images.last as Any)
                    self.imageArray.append(contentsOf: images)
                    self.imageArray.append(images.first as Any)
                    
                }else {
                    
                    self.imageArray = images
                }
            }
            
            if describes.isEmpty == true {
                
                self.describeArray.append(self.placeholderDescribe ?? " ")
            }else {
                
                if describes.count > 1 {
                    
                    self.describeArray.append(describes.last ?? self.placeholderDescribe ?? " ")
                    self.describeArray.append(contentsOf: describes)
                    self.describeArray.append((describes.first ?? self.placeholderDescribe) ?? " ")
                }else {
                    
                    self.describeArray = describes
                }
            }
            
            self.collectionView.reloadData()
            self.pageControl.isHidden = (images.count <= 1)
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
        
        // 如果只有一张图片或设置不需要滚动，则直接返回，不开启定时器
        if ((imageArray.count <= 1) || (unlimitedCarousel == false)) { return }
        
        
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
     *  是否需要无限轮播，默认开启
     *  当设置false时，会关闭定时器
     */
    private var _unlimitedCarousel: Bool = true
    /**
     *  设置分页控件位置，默认为底部往上30像素且居中
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
    // 定时器
    private var timer: Timer?
    // 是否启用了定时器
    private var isTimer: Bool = true
    // 判断手动拖拽后是否需要启动定时器
    private var userTiming: Bool = false
    // block点击事件
    private var clickHandler: ((_ bannerIndex: NSInteger) -> Void)?
    // block轮播事件
    private var scrollHandler: ((_ bannerOffset: CGPoint) -> Void)?

    // 分页控件
    private lazy var pageControl: UIPageControl = {
        
        let pagecontrol = UIPageControl()
        pagecontrol.isUserInteractionEnabled = false
        pagecontrol.currentPage = currentIndex
        pagecontrol.numberOfPages = imageArray.count - 2
        addSubview(pagecontrol)
        pagecontrol.snp.makeConstraints { (make) in
            
            if pageControlPosition.equalTo(.zero) {
                
                make.centerX.equalToSuperview()
                make.bottom.equalToSuperview().offset(-wy_screenWidthRatioValue(value: 30))
                
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
    
    public init(placeholderImage: UIImage?) {
        super.init(frame: .zero)
        self.placeholderImage = placeholderImage
    }
    
    @objc private func nextPage() {
        
        if imageArray.count > 1 {
            
            if currentIndex == imageArray.count {
                
                currentIndex = 1
            }
            
            collectionView.scrollToItem(at: IndexPath(item: currentIndex, section: 0), at: .left, animated: true)
            
            currentIndex += 1
        }
    }
    
    @objc private func setUnlimitedCarousel() {
        
        let offsetx = collectionView.contentOffset.x
        
        let currentPage = offsetx / collectionView.frame.size.width
        
        if unlimitedCarousel == true {
            
            // 左滑
            if offsetx <= 0 {
                
                let indexPath = IndexPath(item: imageArray.count - 2, section: 0)
                collectionView.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.init(), animated: false)
            }
            
            // 右滑
            if (offsetx >= (collectionView.bounds.size.width * CGFloat((imageArray.count - 1)))) {
                
                let indexPath = IndexPath(item: 1, section: 0)
                collectionView.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.init(), animated: false)
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
    
    public override func layoutSubviews() {
        
        super.layoutSubviews()
        
        if ((imageArray.count > 1) && (unlimitedCarousel == true)) {
            
            collectionView.scrollToItem(at: IndexPath(item: 1, section: 0), at: UICollectionView.ScrollPosition.init(), animated: false)
            startTimer()
        }
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

        if imageArray[indexPath.item] is UIImage {
            
            cell.bannerView.image = imageArray[indexPath.item] as? UIImage
            
        }else {
            
            cell.bannerView.kf.setImage(with: URL(string: imageArray[indexPath.item] as? String ?? ""), placeholder: placeholderImage)
        }
        
        cell.bannerView.contentMode = imageContentMode
        cell.describeViewFrame = describeViewFrame
        cell.describeView.text = describeArray[indexPath.item]
        
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let index = (imageArray.count > 1 ) ? (indexPath.item - 1) : indexPath.item

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
        
        if scrollHandler != nil {
            
            scrollHandler!(scrollView.contentOffset)
        }
        
        // 设置无限轮播
        setUnlimitedCarousel()
    }
    
    // 判断是否重启定时器
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if ((userTiming == true) && (unlimitedCarousel == true)) {
            
            startTimer()
        }
    }
}

private class WYBannerCell: UICollectionViewCell {
    
    /// banner图背景色
    internal var bannerBackgroundColor: UIColor = .clear
    /// 设置圆角位置，默认4角圆角
    internal var rectCorner: UIRectCorner = .allCorners
    /// 设置圆角半径，默认0
    internal var cornerRadius: CGFloat = 0.0
    /// 描述文本位置, 默认底部居中
    internal var describePoint: CGPoint?
    /// 描述文本颜色
    internal var describeTextColor: UIColor = .black
    /// 描述文本背景色
    internal var describeBackgroundColor: UIColor = .clear
    /// 描述文本字体
    internal var describeTextFont: UIFont = .systemFont(ofSize: wy_screenWidthRatioValue(value: 12))
    /// 描述文本内容位置
    internal var describeTextAlignment: NSTextAlignment = .center
    /// 描述文本控件frame, 默认底部居中
    internal var describeViewFrame: CGRect = .zero
    
    internal lazy var bannerView: UIImageView = {
        
        contentView.backgroundColor = bannerBackgroundColor
    
        let bannerview = UIImageView()
        bannerview.backgroundColor = bannerBackgroundColor
        bannerview.wy_rectCorner(rectCorner).wy_cornerRadius(cornerRadius).wy_showVisual()
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
                
                make.left.right.bottom.equalToSuperview()
                
            }else {
                
                make.left.equalTo(describeViewFrame.origin.x)
                make.top.equalTo(describeViewFrame.origin.x)
                make.size.equalTo(describeViewFrame.size)
            }
        }
        
        return describeview
    }()
}
