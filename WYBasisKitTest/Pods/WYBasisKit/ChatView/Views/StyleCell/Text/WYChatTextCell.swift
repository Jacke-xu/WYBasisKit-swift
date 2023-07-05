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
    
    /// 单聊时气泡图距离昵称控件的偏移量
    public var bubbleOffsetForSingle: (sendor: CGPoint, receive: CGPoint) = (sendor: CGPoint(x: wy_screenWidth(10), y: 0), receive: CGPoint(x: -wy_screenWidth(10), y: 0))
    
    /// 群聊时气泡图距离昵称控件的偏移量
    public var bubbleOffsetForGroup: (sendor: CGPoint, receive: CGPoint) = (sendor: CGPoint(x: wy_screenWidth(10), y: 0), receive: CGPoint(x: -wy_screenWidth(10), y: -wy_screenWidth(8)))
    
    /// 气泡图距离对侧头像控件的间距
    public var bubbleMaxOffset: CGFloat = wy_screenWidth(5)
    
    /// 左侧(接收方)气泡图
    public var receiveBubbleImage: UIImage = UIImage.wy_find("WYChatTextBubblesRight", inBundle: WYChatSourceBundle).withRenderingMode(.alwaysTemplate).resizableImage(withCapInsets: UIEdgeInsets(top: wy_screenWidth(35), left: wy_screenWidth(10), bottom: wy_screenWidth(10), right: wy_screenWidth(10)), resizingMode: .stretch)
    
    /// 右侧(发送方)气泡图
    public var sendorBubbleImage: UIImage = UIImage.wy_find("WYChatTextBubblesLeft", inBundle: WYChatSourceBundle).withRenderingMode(.alwaysTemplate).resizableImage(withCapInsets: UIEdgeInsets(top: wy_screenWidth(35), left: wy_screenWidth(10), bottom: wy_screenWidth(10), right: wy_screenWidth(10)), resizingMode: .stretch)
    
    /// 左侧(接收方)气泡背景色
    public var receiveBubbleColor: UIColor? = .white
    
    /// 右侧(发送方)气泡背景色
    public var sendorBubbleColor: UIColor? = .wy_rgb(169, 233, 121)
    
    /// 文本距离气泡内部的边界距离
    public var textEdgeInsets: (sendor: UIEdgeInsets, receive: UIEdgeInsets) = (
        
        sendor: UIEdgeInsets(top: wy_screenWidth(10), left: wy_screenWidth(10), bottom: wy_screenWidth(10), right: wy_screenWidth(16.5)),
        
        receive: UIEdgeInsets(top: wy_screenWidth(10), left: wy_screenWidth(16.5), bottom: wy_screenWidth(10), right: wy_screenWidth(10)))
    
    /// 字符行数限制(0为不限制行数)
    public var textMaximumNumberOfLines: NSInteger = 0
    
    /// 文本字体、字号
    public var textFont: UIFont = .systemFont(ofSize: wy_screenWidth(13))
    
    /// 文本字体颜色
    public var textColor: UIColor = .black
    
    /// 输入框文本行间距
    public var textLineSpacing: CGFloat = wy_screenWidth(5)
    
    public init() {}
}

public class WYChatTextCell: WYChatBasicCell {
    
    public lazy var bubblesView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        bubblesView
        contentView.addSubview(imageView)
        return imageView
    }()
    
    public lazy var textView: UITextView = {
        let textView: UITextView = UITextView()
        textView.isScrollEnabled = false
        textView.backgroundColor = .clear
        textView.bounces = false
        textView.isEditable = false
        textView.textContainer.maximumNumberOfLines = chatTextConfig.textMaximumNumberOfLines
        bubblesView.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        return textView
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
        
        bubblesView.tintColor = message.isSender(userID) ? config.sendorBubbleColor : config.receiveBubbleColor
        bubblesView.image = (message.isSender(userID) ? config.sendorBubbleImage : config.receiveBubbleImage)
        
        textView.attributedText = sharedEmojiAttributed(string: message.content.text ?? "")
        let numberOfRows: NSInteger = textView.attributedText.wy_numberOfRows(controlWidth: sharedTextMaxWidth())
        if message.isSender(userID) {
            if numberOfRows > 1 {
                textView.textContainerInset = chatTextConfig.textEdgeInsets.sendor
            }else {
                textView.textContainerInset = UIEdgeInsets(top: (config.basic.avatarSize.height - config.textFont.lineHeight) / 2, left: chatTextConfig.textEdgeInsets.sendor.left, bottom: (config.basic.avatarSize.height - config.textFont.lineHeight) / 2, right: chatTextConfig.textEdgeInsets.sendor.right)
            }
        }else {
            if numberOfRows > 1 {
                textView.textContainerInset = chatTextConfig.textEdgeInsets.receive
            }else {
                textView.textContainerInset = UIEdgeInsets(top: (config.basic.avatarSize.height - config.textFont.lineHeight) / 2, left: chatTextConfig.textEdgeInsets.receive.left, bottom: (config.basic.avatarSize.height - config.textFont.lineHeight) / 2, right: chatTextConfig.textEdgeInsets.receive.right)
            }
        }
        updateConstraints()
    }
    
    public override func updateConstraints() {
        super.updateConstraints()
        
        bubblesView.snp.updateConstraints { make in
            make.height.greaterThanOrEqualTo(avatarView)
            if message.isSender(userID) {
                
                make.left.greaterThanOrEqualToSuperview().offset((chatTextConfig.basic.avatarSize.width + fabs(chatTextConfig.basic.avatarOffset.receive.x) + chatTextConfig.bubbleMaxOffset))
                if message.group == nil {
                    make.right.equalTo(nicknameView).offset(chatTextConfig.bubbleOffsetForSingle.sendor.x)
                    make.top.equalTo(nicknameView.snp.bottom).offset(chatTextConfig.bubbleOffsetForSingle.sendor.y)
                    
                }else {
                    make.right.equalTo(nicknameView).offset(chatTextConfig.bubbleOffsetForGroup.sendor.x)
                    make.top.equalTo(nicknameView.snp.bottom).offset(chatTextConfig.bubbleOffsetForGroup.sendor.y)
                }
            }else {
                make.right.lessThanOrEqualToSuperview().offset(-(chatTextConfig.basic.avatarSize.width + fabs(chatTextConfig.basic.avatarOffset.sendor.x) + chatTextConfig.bubbleMaxOffset))
                if message.group == nil {
                    make.left.equalTo(nicknameView).offset(chatTextConfig.bubbleOffsetForSingle.receive.x)
                    make.top.equalTo(nicknameView.snp.bottom).offset(chatTextConfig.bubbleOffsetForSingle.receive.y)
                }else {
                    make.right.equalTo(nicknameView).offset(chatTextConfig.bubbleOffsetForGroup.receive.x)
                    make.top.equalTo(nicknameView.snp.bottom).offset(chatTextConfig.bubbleOffsetForGroup.receive.y)
                }
            }
            make.bottom.equalToSuperview()
        }
    }
    
    // 根据传入的表情字符串生成富文本，例如字符串 "哈哈[哈哈]" 会生成 "哈哈😄"
    public func sharedEmojiAttributed(string: String) -> NSAttributedString {
        let attributed: NSMutableAttributedString = NSMutableAttributedString.wy_convertEmojiAttributed(emojiString: string, textColor: chatTextConfig.textColor, textFont: chatTextConfig.textFont, emojiTable: emojiViewConfig.emojiSource, sourceBundle: emojiViewConfig.emojiBundle, pattern: inputBarConfig.emojiPattern)
        
        attributed.wy_lineSpacing(lineSpacing: chatTextConfig.textLineSpacing, alignment: .left)
        
        return attributed
    }
    
    // 获取textView的最大显示宽度
    func sharedTextMaxWidth() -> CGFloat {
        
        if message.isSender(userID) {

            let bubbleOffset: CGFloat = (message.group == nil) ? chatTextConfig.bubbleOffsetForSingle.sendor.x : chatTextConfig.bubbleOffsetForGroup.sendor.x
            return wy_width - fabs(chatTextConfig.basic.avatarOffset.sendor.x) - fabs(chatTextConfig.basic.avatarOffset.receive.x) - (chatTextConfig.basic.avatarSize.width * 2) - fabs(chatTextConfig.bubbleMaxOffset) - (fabs(chatTextConfig.basic.nameViewOffsetForSingle.sendor.x) + bubbleOffset) - chatTextConfig.textEdgeInsets.sendor.left - chatTextConfig.textEdgeInsets.sendor.right
            
        }else {
            
            let bubbleOffset: CGFloat = (message.group == nil) ? chatTextConfig.bubbleOffsetForSingle.receive.x : chatTextConfig.bubbleOffsetForGroup.receive.x
            return wy_width - fabs(chatTextConfig.basic.avatarOffset.receive.x) - fabs(chatTextConfig.basic.avatarOffset.sendor.x) - (chatTextConfig.basic.avatarSize.width * 2) - fabs(chatTextConfig.bubbleMaxOffset) - (fabs(chatTextConfig.basic.nameViewOffsetForSingle.receive.x) + bubbleOffset) - chatTextConfig.textEdgeInsets.receive.left - chatTextConfig.textEdgeInsets.receive.right
        }
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
