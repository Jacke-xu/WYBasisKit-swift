//
//  WYChatTextCell.swift
//  WYBasisKit
//
//  Created by Miraitowa on 2023/6/14.
//

import UIKit

/// 文本聊天配置选项
public struct WYTextChatConfig {

    /// basicCell配置选项
    public var basicChatConfig: WYBasicChatConfig = WYBasicChatConfig()
    
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

class WYChatTextCell: WYChatBasicCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    override func updateConstraints() {
        super.updateConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
