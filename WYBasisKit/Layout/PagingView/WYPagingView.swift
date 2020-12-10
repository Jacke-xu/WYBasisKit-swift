//
//  WYPagingView.swift
//  WYBasisKit
//
//  Created by jacke·xu on 2020/12/7.
//  Copyright © 2020 jacke-xu. All rights reserved.
//

import UIKit
import SnapKit

@objc public protocol WYPagingViewDelegate {
    
    @objc optional func itemDidScroll(_ pagingIndex: NSInteger)
}

public class WYPagingView: UIView {
    
    /// 点击或滚动事件代理(也可以通过传入block监听)
    public weak var delegate: WYPagingViewDelegate?
    
    /// 分页栏宽度 默认对应每页标题文本宽度(若传入则整体使用传入宽度)
    public var bar_Width: CGFloat = 0

    /// 分页栏的高度 默认45
    public var bar_Height: CGFloat = wy_screenWidthRatioValue(value: 45)
    
    /// 图片和文字显示模式
    public var buttonPosition: WYButtonPosition = .imageTop_titleBottom

    /// 分页栏左起始点距离(第一个标题栏距离屏幕边界的距离) 默认0
    public var bar_originlLeftOffset: CGFloat = 0

    /// 分页栏右起始点距离(最后一个标题栏距离屏幕边界的距离) 默认0
    public var bar_originlRightOffset: CGFloat = 0
    
    /// 显示整体宽度小于一屏，且设置了bar_Width != 0，是否需要居中显示，默认 居中 (居中后，将会动态调整bar_originlLeftOffset和bar_originlRightOffset的距离)
    public var bar_adjustOffset: Bool = true

    /// 左右分页栏之间的间距
    public var bar_dividingOffset: CGFloat = wy_screenWidthRatioValue(value: 20)

    /// 内部按钮图片和文字的上下或左右间距 默认5
    public var barButton_dividingOffset: CGFloat = wy_screenWidthRatioValue(value: 5)
    
    /// 分页控制器底部背景色 默认白色
    public var bar_pagingContro_content_color: UIColor = .white
    
    /// 分页控制器背景色 默认白色
    public var bar_pagingContro_bg_color: UIColor = .white
    
    /// 分页栏默认背景色 默认白色
    public var bar_bg_defaultColor: UIColor = .white

    /// 分页栏item默认背景色 默认白色
    public var bar_item_bg_defaultColor: UIColor = .white

    /// 分页栏item选中背景色 默认白色
    public var bar_item_bg_selectedColor: UIColor = .white

    /// 分页栏标题默认颜色 默认<#7B809E>
    public var bar_title_defaultColor: UIColor = .wy_hexColor(hexColor: "#7B809E")

    /// 分页栏标题选中颜色 默认<#2D3952>
    public var bar_title_selectedColor: UIColor = .wy_hexColor(hexColor: "#2D3952")

    /// 分页栏底部分隔带背景色 默认<#F2F2F2>
    public var bar_dividingStripColor: UIColor = .wy_hexColor(hexColor: "#F2F2F2")

    /// 滑动线条背景色 默认<#2D3952>
    public var bar_scrollLineColor: UIColor = .wy_hexColor(hexColor: "#2D3952")

    /// 滑动线条宽度 默认25像素
    public var bar_scrollLineWidth: CGFloat = wy_screenWidthRatioValue(value: 25)

    /// 滑动线条距离分页栏底部的距离 默认5像素
    public var bar_scrollLineBottomOffset: CGFloat = wy_screenWidthRatioValue(value: 5)

    /// 分隔带高度 默认2像素
    public var bar_dividingStripHeight: CGFloat = wy_screenWidthRatioValue(value: 2)

    /// 滑动线条高度 默认2像素
    public var bar_scrollLineHeight: CGFloat = wy_screenWidthRatioValue(value: 2)

    /// 分页栏标题默认字号 默认14号；
    public var bar_title_defaultFont: UIFont = .systemFont(ofSize: wy_screenWidthRatioValue(value: 14))

    /// 分页栏标题选中字号 默认粗体17号；
    public var bar_title_selectedFont: UIFont = .boldSystemFont(ofSize: wy_screenWidthRatioValue(value: 17))

    /// 初始选中第几项  默认第一项
    public var bar_selectedIndex: NSInteger = 0
    
    /// 传入的控制器数组
    public private(set) var controllers: [UIViewController] = []
    
    /// 传入的标题数组
    public private(set) var titles: [String] = []
    
    /// 传入的未选中的图片数组
    public private(set) var defaultImages: [UIImage] = []
    
    /// 传入的选中的图片数组
    public private(set) var selectedImages: [UIImage] = []
    
    /// 传入的父控制器
    public private(set) var superController: UIViewController!
    
    /**
     *调用后开始布局
     *
     * @param controllerAry 控制器数组
     * @param titleAry 标题数组
     * @param defaultImageAry 未选中状态图片数组(可不传)
     * @param selectedImageAry 选中状态图片数组(可不传)
     * @param superViewController 父控制器
     */
    public func layout(controllerAry: [UIViewController], titleAry: [String], defaultImageAry: [UIImage] = [], selectedImageAry: [UIImage] = [], superViewController: UIViewController) {
        
        controllers = controllerAry
        titles = titleAry
        defaultImages = defaultImageAry
        selectedImages = selectedImageAry
        superController = superViewController
        
        layoutMethod()
    }
    
    /**
     * 点击或滚动事件(也可以通过实现代理监听)
     *
     * @param handler 点击或滚动事件的block
     */
    public func itemDidScroll(handler: @escaping ((_ pagingIndex: NSInteger) -> Void)) {
        
        actionHandler = handler
    }
    
    private var currentButtonItem: UIButton!
    
    private var actionHandler: ((_ index: NSInteger) -> Void)?
    
    public init() {
        super.init(frame: .zero)
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

extension WYPagingView: UIScrollViewDelegate {
       
    /// 监听滚动事件判断当前拖动到哪一个了
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if((scrollView == controllerScrollView) && (controllerScrollView.contentOffset.x >= 0)) {

            let index: CGFloat = scrollView.contentOffset.x / self.frame.size.width
            
            let channeItem: UIButton =  barScrollView.viewWithTag(buttonItemTagBegin + Int(index)) as! UIButton
            //重新赋值标签属性
            updateButtonItemProperty(currentItem: channeItem)
        }
    }
}

extension WYPagingView {
    
    @objc func buttonItemClick(sender: UIButton) {
        
        if(sender.tag != currentButtonItem.tag) {
            
            controllerScrollView.contentOffset = CGPoint(x: CGFloat(self.frame.size.width) * CGFloat((sender.tag - buttonItemTagBegin)), y: 0)
        }
        bar_selectedIndex = sender.tag - buttonItemTagBegin
        
        /// 重新赋值标签属性
        updateButtonItemProperty(currentItem: sender)
    }
    
    func scrollMethod() {
        
        barScrollLine.superview?.layoutIfNeeded()
        
        /// 计算应该滚动多少
        var needScrollOffsetX: CGFloat = currentButtonItem.center.x - barScrollView.bounds.size.width * 0.5
        
        /// 最大允许滚动的距离
        let maxAllowScrollOffsetX: CGFloat = barScrollView.contentSize.width - barScrollView.bounds.size.width
        
        if (needScrollOffsetX < 0) { needScrollOffsetX = 0 }
        
        if (needScrollOffsetX > maxAllowScrollOffsetX) { needScrollOffsetX = maxAllowScrollOffsetX }
        
        if (barScrollView.contentSize.width > self.frame.size.width) {
            
            barScrollView.setContentOffset(CGPoint(x: needScrollOffsetX, y: 0), animated: true)
        }
        
        UIView.animate(withDuration: 0.2) {

            self.barScrollLine.snp.updateConstraints { (make) in

                make.left.equalToSuperview().offset(self.currentButtonItem.center.x-self.barScrollLine.frame.size.width * 0.5)
            }
            self.barScrollLine.superview?.layoutIfNeeded()
        }
        
        if actionHandler != nil {
            
            actionHandler!(currentButtonItem.tag-buttonItemTagBegin)
        }
        
        delegate?.itemDidScroll?(currentButtonItem.tag-buttonItemTagBegin)
    }
    
    func updateButtonItemProperty(currentItem: UIButton) {
        
        if(currentItem.tag != currentButtonItem.tag) {
            
            currentButtonItem.isSelected = false
            
            currentButtonItem.backgroundColor = bar_item_bg_defaultColor
            currentButtonItem.setTitleColor(bar_title_defaultColor, for: .normal)
            currentButtonItem.titleLabel!.font = bar_title_defaultFont
            updateButtonContentMode(sender: currentButtonItem)
            
            /// 将当前选中的item赋值
            currentItem.isSelected = true
            currentButtonItem = currentItem
            
            currentButtonItem.backgroundColor = bar_item_bg_selectedColor
            currentButtonItem.setTitleColor(bar_title_selectedColor, for: .selected)
            currentButtonItem.titleLabel!.font = bar_title_selectedFont
            updateButtonContentMode(sender: currentButtonItem)
            
            /// 调用最终的方法
            scrollMethod()
        }
    }
    
    func updateButtonContentMode(sender: UIButton) {
        
        if((defaultImages.count == titles.count) && (selectedImages.count == titles.count)) {
            
            sender.wy_layouEdgeInsets(position: buttonPosition, spacing: barButton_dividingOffset)
        }
    }
}

extension WYPagingView {
    
    private func layoutMethod() {
        
        layoutIfNeeded()
        
        if ((bar_adjustOffset == true) && (bar_Width > 0) && (bar_Width * CGFloat(titles.count) <= wy_screenWidth)) {
            
            bar_originlLeftOffset = (self.frame.size.width - (bar_Width * CGFloat(titles.count)) - bar_dividingOffset) / 2
            
            bar_originlRightOffset = bar_originlLeftOffset
        }
        
        var lastView: UIView? = nil
        for index in 0..<titles.count {
            
            let buttonItem = UIButton(type: .custom)
            buttonItem.contentHorizontalAlignment = .center
            buttonItem.backgroundColor = (index == bar_selectedIndex) ? bar_item_bg_selectedColor : bar_item_bg_defaultColor
            buttonItem.setTitleColor(bar_title_defaultColor, for: .normal)
            buttonItem.setTitleColor(bar_title_selectedColor, for: .selected)
            buttonItem.titleLabel?.font = (index == bar_selectedIndex) ? bar_title_selectedFont : bar_title_defaultFont
            buttonItem.setTitle(titles[index], for: .normal)
            buttonItem.tag = buttonItemTagBegin+index
            buttonItem.addTarget(self, action: #selector(buttonItemClick(sender:)), for: .touchUpInside)
            if(index == bar_selectedIndex) {
                
                buttonItem.isSelected = true
                currentButtonItem = buttonItem
            }
            barScrollView.insertSubview(buttonItem, at: 0)
            buttonItem.snp.makeConstraints { (make) in
                
                make.top.equalToSuperview()
                make.bottom.equalToSuperview().offset(-bar_dividingStripHeight)

                if lastView == nil {
                    make.left.equalToSuperview().offset(bar_originlLeftOffset)
                }else {
                    make.left.equalTo(lastView!.snp.right).offset(bar_dividingOffset)
                }
                if bar_Width > 0 {
                    make.width.equalTo(bar_Width)
                }
                if(index == (titles.count-1)) {

                    make.right.equalToSuperview().offset(-bar_originlRightOffset)
                }
            }
            if ((defaultImages.count == titles.count) && (selectedImages.count == titles.count)) {

                buttonItem.setImage(defaultImages[index], for: .normal)
                buttonItem.setImage(selectedImages[index], for: .selected)
                buttonItem.imageView?.contentMode = .center
                updateButtonContentMode(sender: buttonItem)
            }
            
            lastView = buttonItem
            
            /// 设置scrollView的ContentSize让其滚动
            if(index == (titles.count-1)) {

                controllerScrollView.superview?.layoutIfNeeded()
                controllerScrollView.contentOffset = CGPoint(x: self.frame.size.width * CGFloat(bar_selectedIndex), y: 0)

                /// 底部分隔带
                let dividingView = UIView()
                dividingView.backgroundColor = bar_dividingStripColor
                addSubview(dividingView)
                dividingView.snp.makeConstraints { (make) in

                    make.left.right.equalToSuperview()
                    make.height.equalTo(bar_dividingStripHeight)
                    make.top.equalTo(buttonItem.snp.bottom)
                    make.bottom.equalTo(barScrollView)
                }
                scrollMethod()
            }
        }
    }
    
    var controllerScrollView: UIScrollView {
        
        var scrollView: UIScrollView? = objc_getAssociatedObject(self, WYAssociatedKeys.controllerScrollView) as? UIScrollView
        
        if scrollView == nil {
            
            scrollView = UIScrollView()
            scrollView!.delegate = self
            scrollView!.isPagingEnabled = true
            scrollView!.isScrollEnabled = true
            scrollView!.showsHorizontalScrollIndicator = false
            scrollView!.showsVerticalScrollIndicator = false
            scrollView!.backgroundColor = bar_pagingContro_content_color
            addSubview(scrollView!)
            scrollView!.snp.makeConstraints { (make) in
                
                make.top.equalTo(barScrollView.snp.bottom)
                make.left.bottom.width.equalToSuperview()
            }
            
            var lastView: UIView? = nil
            for index in 0..<controllers.count {
                
                superController.addChild(controllers[index])
                
                let controllerView = controllers[index].view
                controllerView?.backgroundColor = bar_pagingContro_bg_color
                scrollView!.addSubview(controllerView!)
                controllerView!.snp.makeConstraints({ (make) in

                    make.top.bottom.equalToSuperview()
                    make.height.equalTo(self).offset(-bar_Height)
                    make.width.equalTo(self)
                    if lastView == nil {
                        make.left.equalToSuperview()
                    }else {
                        make.left.equalTo(lastView!.snp.right)
                    }
                    if (index == (controllers.count - 1)) {

                        make.right.equalToSuperview()
                    }
                })
                lastView = controllerView!
            }
            
            objc_setAssociatedObject(self, WYAssociatedKeys.controllerScrollView, scrollView, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        return scrollView!
    }
    
    var barScrollView: UIScrollView {
        
        var barScroll: UIScrollView? = objc_getAssociatedObject(self, WYAssociatedKeys.barScrollView) as? UIScrollView
        
        if barScroll == nil {
            
            barScroll = UIScrollView()
            barScroll!.showsHorizontalScrollIndicator = false
            barScroll!.backgroundColor = bar_bg_defaultColor
            addSubview(barScroll!)
            barScroll!.snp.makeConstraints { (make) in

                make.top.left.width.equalToSuperview()
                make.height.equalTo(bar_Height)
            }
            
            objc_setAssociatedObject(self, WYAssociatedKeys.barScrollView, barScroll, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        return barScroll!
    }
    
    var barScrollLine: UIView {
        
        var scrollLine: UIView? = objc_getAssociatedObject(self, WYAssociatedKeys.barScrollLine) as? UIView
        
        if scrollLine == nil {
            
            scrollLine = UIView()
            scrollLine!.backgroundColor = (titles.count > 1) ? bar_scrollLineColor : .clear
            barScrollView.addSubview(scrollLine!)
            
            scrollLine!.snp.makeConstraints { (make) in
                
                make.bottom.equalToSuperview().offset(-bar_scrollLineBottomOffset)
                make.left.equalToSuperview()
                make.size.equalTo(CGSize(width: bar_scrollLineWidth, height: bar_scrollLineHeight))
            }
            scrollLine?.wy_add(cornerRadius: bar_scrollLineHeight / 2)
            
            objc_setAssociatedObject(self, WYAssociatedKeys.barScrollLine, scrollLine!, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        return scrollLine!
    }
    
    var buttonItemTagBegin: NSInteger {
        
        return 1000
    }
    
    private struct WYAssociatedKeys {
        
        static let barScrollView = UnsafeRawPointer.init(bitPattern: "barScrollView".hashValue)!
        
        static let controllerScrollView = UnsafeRawPointer.init(bitPattern: "controllerScrollView".hashValue)!
        
        static let barScrollLine = UnsafeRawPointer.init(bitPattern: "barScrollLine".hashValue)!
    }
}
