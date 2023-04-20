//
//  WYEmojiViewCell.swift
//  WYBasisKit
//
//  Created by 官人 on 2023/4/13.
//  Copyright © 2023 Jacke·xu. All rights reserved.
//

import UIKit

public class WYEmojiViewCell: UICollectionViewCell {
    
    public let emojiView: UIImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .clear
        contentView.addSubview(emojiView)
        emojiView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
