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
    
    /// 左侧(发送方)气泡图
    public var sendorBubbleImage: UIImage = UIImage.wy_find("WYChatTextBubbles", inBundle: WYChatSourceBundle).wy_flips(.upMirrored)
    
    /// 右侧(接收方)气泡图
    public var receiveBubbleImage: UIImage = UIImage.wy_find("WYChatTextBubbles", inBundle: WYChatSourceBundle)
    
    /// 左侧(发送方)气泡背景色
    public var sendorBubbleColor: UIColor = .wy_rgb(169, 233, 121)
    
    /// 右侧(接收方)气泡背景色
    public var receiveBubbleColor: UIColor = .white
    
    /// 文本距离气泡内部的边界距离
    public var textEdgeInsets: UIEdgeInsets = UIEdgeInsets(top: wy_screenWidth(15), left: wy_screenWidth(20), bottom: wy_screenWidth(15), right: wy_screenWidth(20))
    
    /// 文本字体、字号
    public var textFont: UIFont = .systemFont(ofSize: wy_screenWidth(13))
    
    /// 文本字体颜色
    public var textColor: UIColor = .black
    
    public init() {}
}

public class WYChatTextCell: WYChatBasicCell {
    
    public lazy var bubblesView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        contentView.addSubview(imageView)
        return imageView
    }()
    
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
