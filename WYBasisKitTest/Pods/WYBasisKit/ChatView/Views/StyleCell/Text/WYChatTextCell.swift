//
//  WYChatTextCell.swift
//  WYBasisKit
//
//  Created by 官人 on 2023/6/14.
//

import UIKit

/// 文本聊天配置选项
public struct WYTextChatConfig {
    
    /// basicCell配置选项
    public var basic: WYBasicChatConfig = WYBasicChatConfig()
    
    /// 文本字体、字号
    public var textFont: UIFont = .systemFont(ofSize: wy_screenWidth(13))
    
    /// 文本字体颜色
    public var textColor: UIColor = .black
    
    /// 文本过长时截断方式
    public var textBreakMode: NSLineBreakMode = .byTruncatingTail
    
    /// 文本对齐方式
    public var textAlignment: NSTextAlignment = .left
    
    public init() {}
}

public class WYChatTextCell: WYChatBasicCell {
    
    public override var message: WYChatMessageModel {
        didSet {
            updateContent(config: chatTextConfig)
        }
    }
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
    }
    
    /// 数据(页面)刷新
    public func updateContent(config: WYTextChatConfig) {
        super.updateContent(config: config.basic)
        updateConstraints()
    }
    
    public override func updateConstraints() {
        super.updateConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
