//
//  WYScrollText.swift
//  WYBasisKit
//
//  Created by jacke·xu on 2020/11/1.
//  Copyright © 2020 jacke-xu. All rights reserved.
//

import SnapKit

@objc protocol WYScrollTextDelegate {
    
    @objc optional func didClickText(index: NSInteger)
}

class WYScrollText: UIView {
    
    weak var delegate: WYScrollTextDelegate?
    
    /// 占位文本
    var placeholder: String = WYLocalizedString("暂无消息")
    /// 文本颜色
    var textColor: UIColor = .black
    /// 文本字体
    var textFont: UIFont = .systemFont(ofSize: 12)
    /// 轮播间隔，默认3s  为保证轮播流畅，该值要求最小为2
    var interval: TimeInterval = 3
    
    private var _textArray: [String]!
    var textArray: [String]! {
        
        set {
            
            _textArray = NSMutableArray(array: newValue) as? [String]
            if _textArray.isEmpty == true {

                _textArray.append(placeholder.wy_emptyStr())
            }
            
            _textArray.append(_textArray.first ?? "")
            
            self.collectionView.reloadData()
            
            self.startTimer()
        }
        
        get {
            return _textArray
        }
    }
    
    private lazy var collectionView: UICollectionView = {
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = 0 // 行间距
        flowLayout.minimumInteritemSpacing = 0 // 列间距
//        flowLayout.itemSize = CGSize(width: self.bounds.size.width, height: self.bounds.size.height) // item大小
//        flowLayout.headerReferenceSize = .zero // 组头大小
//        flowLayout.footerReferenceSize = .zero // 组尾大小
        
        let collectionview = UICollectionView(frame: self.bounds, collectionViewLayout: flowLayout)
        collectionview.showsVerticalScrollIndicator = false
        collectionview.showsHorizontalScrollIndicator = false
        collectionview.delegate = self
        collectionview.dataSource = self
        collectionview.backgroundColor = .white
        collectionview.register(SctolTextCell.self, forCellWithReuseIdentifier: "SctolTextCell")
        collectionview.isScrollEnabled = false
        self.addSubview(collectionview)
        collectionview.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        return collectionview
    }()
    
    /// 当前文本下标
    private var textIndex: NSInteger = 0
    
    /// 定时器
    private var timer: Timer?
    
    /// 开启定时器
    private func startTimer() {
        
        if timer == nil {
            
            self.timer = Timer.scheduledTimer(timeInterval: (interval < 2) ? 2 : interval, target: self, selector: #selector(scroll), userInfo: nil, repeats: true)
        }
    }
    
    @objc private func scroll() {
        
        textIndex += 1
        
        collectionView.scrollToItem(at: IndexPath(item: textIndex, section: 0), at: .top, animated: true)
        
        if textIndex >= (textArray.count-1) {
            
            textIndex = 0
            self.perform(#selector(scrollToFirstText), with: nil, afterDelay: 1)
        }
    }
    
    @objc private func scrollToFirstText() {
        
        collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredVertically, animated: false)
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

extension WYScrollText: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.bounds.self.width, height: collectionView.bounds.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return textArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: SctolTextCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SctolTextCell", for: indexPath) as! SctolTextCell

        cell.textView.font = self.textFont
        cell.textView.textColor = self.textColor
        cell.textView.text = textArray[indexPath.item]
        

        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if delegate != nil {
            
            delegate?.didClickText?(index: (textIndex == textArray.count-1) ? 0 : textIndex)
        }
    }
}

class SctolTextCell: UICollectionViewCell {
    
    lazy var textView: UILabel = {
    
        let label = UILabel()
        label.textAlignment = .left
        label.backgroundColor = .white
        self.contentView.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        return label
    }() 
}
