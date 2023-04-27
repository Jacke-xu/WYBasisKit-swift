//
//  WYChatInputView.swift
//  WYBasisKit
//
//  Created by 官人 on 2023/3/30.
//  Copyright © 2023 官人. All rights reserved.
//

import UIKit

private let canSaveLastInputTextKey: String = "canSaveLastInputTextKey"
private let canSaveLastInputViewStyleKey: String = "canSaveLastInputViewStyleKey"

@objc public protocol WYChatInputViewDelegate {
    
    /// 点击了 文本/语音按钮 切换按钮
    @objc optional func didClickTextVoiceView(_ isText: Bool)
    
    /// 点击了 表情/文本 切换按钮
    @objc optional func didClickEmojiTextView(_ isEmoji: Bool)
    
    /// 点击了 更多 按钮
    @objc optional func didClickMoreView(_ isText: Bool)
    
    /// 输入框文本发生变化
    @objc optional func textDidChanged(_ text: String)
    
    /// 点击了键盘右下角按钮(例如发送)
    @objc optional func didClickKeyboardEvent(_ text: String)
}

public class WYChatInputView: UIImageView {
    
    public let textVoiceContentView: UIButton = UIButton(type: .custom)
    public let textView: WYChatInputTextView = WYChatInputTextView()
    public let textPlaceholderView = UILabel()
    public let textVoiceView: UIButton = UIButton(type: .custom)
    public let emojiView: UIButton = UIButton(type: .custom)
    public let moreView: UIButton = UIButton(type: .custom)
    
    public weak var delegate: WYChatInputViewDelegate? = nil
    
    public init() {
        super.init(frame: .zero)
        isUserInteractionEnabled = true
        backgroundColor = .clear
        image = inputBarConfig.backgroundImage
        
        textVoiceContentView.setBackgroundImage(inputBarConfig.voiceViewBackgroundImage, for: .normal)
        textVoiceContentView.setBackgroundImage(inputBarConfig.textViewBackgroundImage, for: .selected)
        textVoiceContentView.setBackgroundImage(inputBarConfig.voiceViewBackgroundImageForHighlighted, for: .highlighted)
        textVoiceContentView.wy_nTitle = inputBarConfig.voicePlaceholder
        textVoiceContentView.wy_sTitle = inputBarConfig.voicePlaceholder
        textVoiceContentView.wy_hTitle = inputBarConfig.voicePlaceholder
        textVoiceContentView.wy_titleFont = inputBarConfig.voicePlaceholderFont
        textVoiceContentView.wy_title_nColor = inputBarConfig.voicePlaceholderColor
        textVoiceContentView.wy_title_sColor = .clear
        textVoiceContentView.layer.cornerRadius = inputBarConfig.textViewCornerRadius
        textVoiceContentView.layer.borderWidth = inputBarConfig.textViewBorderWidth
        textVoiceContentView.layer.borderColor = inputBarConfig.textViewBorderColor.cgColor
        textVoiceContentView.layer.masksToBounds = true
        textVoiceContentView.addTarget(self, action: #selector(didClickRecordingButtonView(sender:)), for: .touchUpInside)
        addSubview(textVoiceContentView)
        textVoiceContentView.snp.makeConstraints { make in
            make.height.equalTo(inputBarConfig.inputViewHeight)
            make.left.equalToSuperview().offset(inputBarConfig.inputViewEdgeInsets.left)
            make.top.equalToSuperview().offset(inputBarConfig.inputViewEdgeInsets.top)
            make.right.equalToSuperview().offset(-inputBarConfig.inputViewEdgeInsets.right)
            make.bottom.equalToSuperview().offset(-inputBarConfig.inputViewEdgeInsets.bottom)
        }
        if inputBarConfig.canSaveLastInputViewStyle == true {
            textVoiceContentView.isSelected = !(UserDefaults.standard.value(forKey: canSaveLastInputViewStyleKey) as? Bool ?? false)
        }else {
            textVoiceContentView.isSelected = true
        }
        
        textView.backgroundColor = .clear
        textView.font = inputBarConfig.textFont
        textView.tintColor = inputBarConfig.inputViewCurvesColor
        textView.keyboardType = inputBarConfig.chatKeyboardType
        textView.returnKeyType = inputBarConfig.chatReturnKeyType
        textView.bounces = inputBarConfig.textViewIsBounces
        textView.textContainerInset = inputBarConfig.inputTextEdgeInsets
        textView.textContainer.lineBreakMode = inputBarConfig.textLineBreakMode
        textView.textContainer.maximumNumberOfLines = inputBarConfig.inputTextMaximumNumberOfLines
        textView.isScrollEnabled = inputBarConfig.textViewIsScrollEnabled
        textView.delegate = self
        textVoiceContentView.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        if inputBarConfig.canSaveLastInputText == true {
            textView.attributedText = sharedEmojiAttributed(string: UserDefaults.standard.value(forKey: canSaveLastInputTextKey) as? String ?? "")
            if textView.attributedText.string.utf16.count > 0 {
                textView.becomeFirstResponder()
            }
        }
        
        if inputBarConfig.canSaveLastInputViewStyle == true {
            textView.isHidden = UserDefaults.standard.value(forKey: canSaveLastInputViewStyleKey) as? Bool ?? false
        }

        textPlaceholderView.text = inputBarConfig.textPlaceholder
        textPlaceholderView.textColor = inputBarConfig.textPlaceholderColor
        textPlaceholderView.font = inputBarConfig.textPlaceholderFont
        textPlaceholderView.textAlignment = .left
        textPlaceholderView.backgroundColor = .clear
        textPlaceholderView.adjustsFontSizeToFitWidth = true
        textPlaceholderView.isHidden = (textView.attributedText.string.utf16.count > 0)
        textView.addSubview(textPlaceholderView)
        textPlaceholderView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(inputBarConfig.textPlaceholderOffset.x)
            make.top.equalToSuperview().offset(inputBarConfig.textPlaceholderOffset.y)
            make.right.lessThanOrEqualToSuperview().offset(-wy_screenWidth(5))
        }
        
        textVoiceView.wy_nImage = inputBarConfig.voiceButtonImage
        textVoiceView.wy_sImage = inputBarConfig.textButtomImage
        textVoiceView.wy_sTitle = inputBarConfig.voicePlaceholder
        textVoiceView.wy_title_sColor = inputBarConfig.voicePlaceholderColor
        textVoiceView.wy_titleFont = inputBarConfig.voicePlaceholderFont
        textVoiceView.isSelected = textView.isHidden
        textVoiceView.backgroundColor = .clear
        textVoiceView.addTarget(self, action: #selector(didClickTextVoiceView(sender:)), for: .touchUpInside)
        addSubview(textVoiceView)
        textVoiceView.snp.makeConstraints { make in
            make.size.equalTo(inputBarConfig.voiceTextButtonSize)
            make.right.equalTo(textVoiceContentView.snp.left).offset(-inputBarConfig.voiceTextButtonRightOffset)
            make.bottom.equalTo(textVoiceContentView).offset(-inputBarConfig.voiceTextButtonBottomOffset)
        }
        
        emojiView.setBackgroundImage(inputBarConfig.emojiButtomImage, for: .normal)
        emojiView.setBackgroundImage(inputBarConfig.textButtomImage, for: .selected)
        emojiView.addTarget(self, action: #selector(didClickEmojiView(sender:)), for: .touchUpInside)
        addSubview(emojiView)
        emojiView.snp.makeConstraints { make in
            make.size.equalTo(inputBarConfig.emojiTextButtonSize)
            make.left.equalTo(textVoiceContentView.snp.right).offset(inputBarConfig.emojiTextButtonLeftOffset)
            make.bottom.equalTo(textVoiceContentView).offset(-inputBarConfig.emojiTextButtonBottomOffset)
        }
        
        moreView.setBackgroundImage(inputBarConfig.moreButtomImage, for: .normal)
        moreView.setBackgroundImage(inputBarConfig.moreButtomImage, for: .highlighted)
        moreView.addTarget(self, action: #selector(didClickAddView(sender:)), for: .touchUpInside)
        addSubview(moreView)
        moreView.snp.makeConstraints { make in
            make.size.equalTo(inputBarConfig.moreButtonSize)
            make.left.equalTo(textVoiceContentView.snp.right).offset(inputBarConfig.moreButtonLeftOffset)
            make.bottom.equalTo(textVoiceContentView).offset(-inputBarConfig.moreButtonBottomOffset)
        }
        
        updateContentViewHeight()
    }
    
    @objc private func didClickTextVoiceView(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        textVoiceContentView.isSelected = !sender.isSelected
        textView.isHidden = !textVoiceContentView.isSelected
        emojiView.isSelected = false
        moreView.isSelected = false
        
        if sender.isSelected {
            textView.resignFirstResponder()
        }else {
            textView.becomeFirstResponder()
        }
        
        updateContentViewHeight()
        
        delegate?.didClickTextVoiceView?(!sender.isSelected)
        saveLastInputViewStyle()
    }
    
    @objc private func didClickRecordingButtonView(sender: UIButton) {
        if sender.isSelected == false {
            wy_print("录音准备")
        }
    }
    
    @objc private func didClickAddView(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        textVoiceContentView.isSelected = true
        textView.isHidden = false
        textVoiceView.isSelected = false
        emojiView.isSelected = false
        
        if sender.isSelected {
            textView.resignFirstResponder()
        }else {
            textView.becomeFirstResponder()
        }
        
        updateContentViewHeight()
        
        delegate?.didClickMoreView?(!sender.isSelected)
        saveLastInputViewStyle()
    }
    
    @objc private func didClickEmojiView(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        textVoiceContentView.isSelected = true
        textView.isHidden = false
        textVoiceView.isSelected = false
        moreView.isSelected = false
        
        if sender.isSelected {
            textView.resignFirstResponder()
        }else {
            textView.becomeFirstResponder()
        }
        
        updateContentViewHeight()
        
        delegate?.didClickEmojiTextView?(sender.isSelected)
        saveLastInputViewStyle()
    }
    
    public func sharedEmojiAttributed(string: String) -> NSAttributedString {
        let attributed: NSMutableAttributedString = NSMutableAttributedString.wy_convertEmojiAttributed(emojiString: string, textColor: inputBarConfig.textColor, textFont: inputBarConfig.textFont, emojiTable: emojiViewConfig.emojiSource, pattern: inputBarConfig.emojiPattern)
        attributed.wy_lineSpacing(lineSpacing: inputBarConfig.textLineSpacing, alignment: .left)
        
        return attributed
    }
    
    public func sharedEmojiAttributedText(attributed: NSAttributedString) -> NSAttributedString {
        let attributed: NSMutableAttributedString = NSMutableAttributedString(attributedString: attributed).wy_convertEmojiAttributedString(textColor: inputBarConfig.textColor, textFont: inputBarConfig.textFont)
        attributed.wy_lineSpacing(lineSpacing: inputBarConfig.textLineSpacing, alignment: .left)
        return attributed
    }
    
    private func saveLastInputViewStyle() {
        UserDefaults.standard.setValue(textView.isHidden, forKey: canSaveLastInputViewStyleKey)
        UserDefaults.standard.synchronize()
    }
    
    private func updateContentViewHeight() {
        let textHeight: CGFloat = textView.attributedText.wy_calculateHeight(controlWidth: wy_screenWidth - inputBarConfig.inputViewEdgeInsets.left - inputBarConfig.inputViewEdgeInsets.right - inputBarConfig.inputTextEdgeInsets.left - inputBarConfig.inputTextEdgeInsets.right - wy_screenWidth(10)) + inputBarConfig.inputTextEdgeInsets.top + inputBarConfig.inputTextEdgeInsets.bottom
        
        var contentHeight: CGFloat = [textHeight,textView.contentSize.height,inputBarConfig.inputViewHeight].max()!
        
        if (textVoiceView.isSelected == true) {
            contentHeight = inputBarConfig.inputViewHeight
        }
        
        UIView.animate(withDuration: 0.25) {[weak self] in
            guard let self = self else {return}
            self.textVoiceContentView.snp.updateConstraints { make in
                make.height.equalTo(contentHeight > inputBarConfig.textViewMaxHeight ? inputBarConfig.textViewMaxHeight : contentHeight)
            }
            self.textVoiceContentView.superview?.layoutIfNeeded()
        }completion: {[weak self] _ in
            guard let self = self else {return}
            self.updateTextViewOffset()
        }
    }
    
    func updateTextViewOffset() {
        if textView.attributedText.string.utf16.count > 0 {
            if textView.attributedText.wy_numberOfRows(controlWidth: textView.wy_width) <= 1 {
                textView.contentOffset = CGPoint(x: 0, y: 0)
            }else {
                textView.contentOffset = CGPoint(x: 0, y: textView.contentSize.height - textView.wy_height)
            }
        }
    }
    
    private func checkTextCount() {
        
        if textView.attributedText.string.utf16.count > inputBarConfig.inputTextLength {
            let selectRange = textView.markedTextRange
            if let selectRange = selectRange {
                let position =  textView.position(from: (selectRange.start), offset: 0)
                if (position != nil) {
                    return
                }
            }
            let textContent = textView.attributedText.string
            let textNum = textContent.utf16.count - (textContent.utf16.count - textContent.count)
            if (textNum > inputBarConfig.inputTextLength) && (inputBarConfig.inputTextLength > 0) {
                textView.attributedText = textView.attributedText.attributedSubstring(from: NSMakeRange(0, (inputBarConfig.inputTextLength)))
            }
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

extension WYChatInputView: UITextViewDelegate {
    
    public func textView(_ textView: UITextView, shouldInteractWith textAttachment: NSTextAttachment, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {

        if textView.isFirstResponder == false {
            textView.becomeFirstResponder()
        }
        let start: UITextPosition = textView.position(from: textView.beginningOfDocument, offset: characterRange.location)!
        let end: UITextPosition = textView.position(from: start, offset: 0)!
        textView.selectedTextRange = textView.textRange(from: start, to: end)
        return true
    }
    
    public func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        emojiView.isSelected = false
        moreView.isSelected = false
        return true
    }
    
    public func textViewDidChange(_ textView: UITextView) {
        
        let cursorPosition = textView.offset(from: textView.beginningOfDocument, to: textView.selectedTextRange?.start ?? textView.beginningOfDocument)
        
        var emojiText: String = NSMutableAttributedString(attributedString: textView.attributedText).wy_convertEmojiAttributedString(textColor: inputBarConfig.textColor, textFont: inputBarConfig.textFont).string
  
        if inputBarConfig.canInputEmoji == false {
            emojiText = emojiText.wy_replaceEmoji(inputBarConfig.emojiReplacement)
            textView.text = emojiText
        }
        
        textView.attributedText = sharedEmojiAttributed(string: emojiText)
        
        checkTextCount()
        
        emojiText = NSMutableAttributedString(attributedString: textView.attributedText).wy_convertEmojiAttributedString(textColor: inputBarConfig.textColor, textFont: inputBarConfig.textFont).string
        
        textPlaceholderView.isHidden = !emojiText.isEmpty
        delegate?.textDidChanged?(wy_safe(emojiText))
        
        updateContentViewHeight()
        
        if cursorPosition < textView.attributedText.string.utf16.count {
            let start: UITextPosition = textView.position(from: textView.beginningOfDocument, offset: cursorPosition)!
            let end: UITextPosition = textView.position(from: start, offset: 0)!
            textView.selectedTextRange = textView.textRange(from: start, to: end)
        }
        
        UserDefaults.standard.setValue(wy_safe(emojiText), forKey: canSaveLastInputTextKey)
        UserDefaults.standard.synchronize()
        
        updateTextViewOffset()
    }
    
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n" {
            
            let emojiText: String = NSMutableAttributedString(attributedString: textView.attributedText).wy_convertEmojiAttributedString(textColor: inputBarConfig.textColor, textFont: inputBarConfig.textFont).string
            
            if wy_safe(emojiText).wy_replace(appointSymbol: "\n", replacement: "").count > 0 {
                delegate?.didClickKeyboardEvent?(wy_safe(emojiText))
            }
            return false
        }
        
        let textContent = textView.attributedText.string + text
        let textNum = textContent.utf16.count - (textContent.utf16.count - textContent.count)
        
        if textView.attributedText.string.utf16.count > inputBarConfig.inputTextLength {
            let selectRange = textView.markedTextRange
            if let selectRange = selectRange {
                let position =  textView.position(from: (selectRange.start), offset: 0)
                if (position != nil) {
                    return true
                }
            }
        }
        checkTextCount()
        
        if (textNum > inputBarConfig.inputTextLength) && (inputBarConfig.inputTextLength > 0) {
            return false
        }
        
        return true
    }
}


public class WYChatInputTextView: UITextView {
    
    override public  func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        
        if (action == #selector(UIResponderStandardEditActions.cut(_:))) || (action == #selector(UIResponderStandardEditActions.copy(_:))) || (action == #selector(UIResponderStandardEditActions.paste(_:))) || (action == #selector(UIResponderStandardEditActions.select(_:))) ||
            (action == #selector(UIResponderStandardEditActions.selectAll(_:))) {
            return inputBarConfig.textViewCanUserInteractionMenu
        }else {
            return false
        }
    }
    
    // 重定义光标
    override public  func caretRect(for position: UITextPosition) -> CGRect {
        var originalRect = super.caretRect(for: position)
        // 设置光标高度
        originalRect.size.height = inputBarConfig.textFont.lineHeight + 2
        return originalRect
    }
}

public struct WYInputBarConfig {
    
    /// inputBar背景图
    public var backgroundImage: UIImage = UIImage.wy_createImage(from: .wy_hex("#ECECEC"))
    
    /// 是否需要保存上次退出时输入框中的文本
    public var canSaveLastInputText: Bool = true

    /// 是否需要保存上次退出时输入框模式(语音输入还是文本输入)
    public var canSaveLastInputViewStyle: Bool = true
    
    /// 是否允许输入Emoji表情
    public var canInputEmoji: Bool = true

    /// 输入法自带的Emoji表情替换成什么字符(需要canInputEmoji为false才生效)
    public var emojiReplacement: String = ""
    
    /// 自定义表情转换时的正则匹配规则
    public var emojiPattern: String = ""
    
    /// 文本切换按钮图片
    public var textButtomImage: UIImage = UIImage.wy_createImage(from: .wy_random)
    
    /// 语音切换按钮图片
    public var voiceButtonImage: UIImage = UIImage.wy_createImage(from: .wy_random)
    
    /// 表情切换按钮图片
    public var emojiButtomImage: UIImage = UIImage.wy_createImage(from: .wy_random)
    
    /// 更多切换按钮图片
    public var moreButtomImage: UIImage = UIImage.wy_createImage(from: .wy_random)
    
    /// 文本输入框背景图
    public var textViewBackgroundImage: UIImage = UIImage.wy_createImage(from: .white)
    
    /// 语音输入框背景图
    public var voiceViewBackgroundImage: UIImage = UIImage.wy_createImage(from: .white)
    
    /// 语音输入框按压状态背景图
    public var voiceViewBackgroundImageForHighlighted: UIImage = UIImage.wy_createImage(from: .white)
    
    /// 语音输入框占位文本
    public var voicePlaceholder: String = "语音框占位文本"

    /// 语音输入框占位文本色值
    public var voicePlaceholderColor: UIColor = .black

    /// 语音框输入占位文本字体、字号
    public var voicePlaceholderFont: UIFont = .systemFont(ofSize: wy_screenWidth(15))
    
    /// 键盘类型
    public var chatKeyboardType: UIKeyboardType = .default
    
    /// 键盘右下角按钮类型
    public var chatReturnKeyType: UIReturnKeyType = .send
    
    /// 输入框占位文本
    public var textPlaceholder: String = "输入框占位文本"
    
    /// 输入框占位文本色值
    public var textPlaceholderColor: UIColor = .lightGray

    /// 输入框占位文本字体、字号
    public var textPlaceholderFont: UIFont = .systemFont(ofSize: wy_screenWidth(15))

    /// 输入框占位文本距离输入框左侧和顶部的间距
    public var textPlaceholderOffset: CGPoint = CGPoint(x: wy_screenWidth(16), y: wy_screenWidth(12.5))
    
    /// 输入框内文本偏移量
    public var inputTextEdgeInsets: UIEdgeInsets = UIEdgeInsets(top: wy_screenWidth(13), left: wy_screenWidth(10), bottom: wy_screenWidth(5), right: wy_screenWidth(5))
    
    /// 输入字符长度限制
    public var inputTextLength: NSInteger = Int.max

    /// 输入字符行数限制(0为不限制行数)
    public var inputTextMaximumNumberOfLines: NSInteger = 0

    /// 输入字符的截断方式
    public var textLineBreakMode: NSLineBreakMode = .byTruncatingTail

    /// 字符输入控件是否允许滑动
    public var textViewIsScrollEnabled: Bool = true

    /// 字符输入控件是否允许弹跳效果
    public var textViewIsBounces: Bool = true

    /// 字符输入控件光标颜色
    public var inputViewCurvesColor: UIColor = .blue

    /// 字符输入控件是否允许弹出用户交互菜单
    public var textViewCanUserInteractionMenu: Bool = true
    
    /// 输入框输入文本色值
    public var textColor: UIColor = .black

    /// 输入框输入文本字体、字号
    public var textFont: UIFont = .systemFont(ofSize: wy_screenWidth(15))
    
    /// 输入框文本行间距
    public var textLineSpacing: CGFloat = 5

    /// 输入框的最高高度
    public var textViewMaxHeight: CGFloat = CGFLOAT_MAX
    
    /// 输入框、语音框的圆角半径
    public var textViewCornerRadius: CGFloat = wy_screenWidth(8)

    /// 输入框、语音框的边框颜色
    public var textViewBorderColor: UIColor = .gray

    /// 输入框、语音框的边框宽度
    public var textViewBorderWidth: CGFloat = 1

    /// 输入框、语音框的高度
    public var inputViewHeight: CGFloat = wy_screenWidth(42)

    /// 输入框、语音框距离InputBar的间距
    public var inputViewEdgeInsets: UIEdgeInsets = UIEdgeInsets(top: wy_screenWidth(12), left: wy_screenWidth(57), bottom: wy_screenWidth(12), right: wy_screenWidth(100))
    
    /// 语音、文本切换按钮的size
    public var voiceTextButtonSize: CGSize = CGSize(width: wy_screenWidth(31), height: wy_screenWidth(31))
    
    /// 表情、文本切换按钮的size
    public var emojiTextButtonSize: CGSize = CGSize(width: wy_screenWidth(31), height: wy_screenWidth(31))
    
    /// 更多按钮的size
    public var moreButtonSize: CGSize = CGSize(width: wy_screenWidth(31), height: wy_screenWidth(31))

    /// 语音、文本切换按钮距离 输入框、语音框 左侧的间距
    public var voiceTextButtonRightOffset: CGFloat = wy_screenWidth(13)

    /// 语音、文本切换按钮距离 输入框、语音框 底部的间距
    public var voiceTextButtonBottomOffset: CGFloat = wy_screenWidth(5)

    /// 表情、文本切换按钮距离 输入框、语音框 右侧的间距
    public var emojiTextButtonLeftOffset: CGFloat = wy_screenWidth(13)

    /// 表情、文本切换按钮距离 输入框、语音框 底部的间距
    public var emojiTextButtonBottomOffset: CGFloat = wy_screenWidth(5)
    
    /// 更多按钮距离 输入框、语音框 右侧的间距
    public var moreButtonLeftOffset: CGFloat = wy_screenWidth(57)

    /// 更多按钮距离 输入框、语音框 底部的间距
    public var moreButtonBottomOffset: CGFloat = wy_screenWidth(5)
    
    public init() {}
}
