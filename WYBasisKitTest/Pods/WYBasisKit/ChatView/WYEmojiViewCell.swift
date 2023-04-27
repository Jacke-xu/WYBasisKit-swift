//
//  WYEmojiViewCell.swift
//  WYBasisKit
//
//  Created by Miraitowa on 2023/4/13.
//  Copyright © 2023 Jacke·xu. All rights reserved.
//

import UIKit

@objc public protocol WYEmojiViewCellDelegate {
    
    /// 长按了表情预览控件(仅限WYEmojiPreviewStyle == other时才会回调)
    @objc optional func willShowPreviewView(_ imageName: String, _ imageView: UIImageView)
}

public class WYEmojiViewCell: UICollectionViewCell {
    
    weak var delegate: WYEmojiViewCellDelegate? = nil
    
    private let emojiView: UIImageView = UIImageView()
    private var emojiString: String = ""
    public var emoji: String {
        
        set {
            emojiString = newValue
            emojiView.image = UIImage.wy_find(newValue)
        }
        
        get {
            return emojiString
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .clear
        contentView.addSubview(emojiView)
        emojiView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let longPress: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(didLongPress(sender:)))
        longPress.minimumPressDuration = 0.5
        addGestureRecognizer(longPress)
    }
    
    @objc private func didLongPress(sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            
            WYEmojiPreviewView.show(emoji: emoji, according: emojiView) { [weak self] imageName, imageView in
                DispatchQueue.main.async {
                    self?.delegate?.willShowPreviewView?(imageName, imageView)
                }
            }
        }
        
        if (sender.state == .cancelled) || (sender.state == .ended) {
            WYEmojiPreviewView.dismiss()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
