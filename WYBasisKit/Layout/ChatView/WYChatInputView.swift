//
//  WYChatInputView.swift
//  WYBasisKit
//
//  Created by 官人 on 2023/3/30.
//  Copyright © 2023 官人. All rights reserved.
//

import UIKit

let canSaveLastInputTextKey: String = "canSaveLastInputTextKey"
let canSaveLastInputViewStyleKey: String = "canSaveLastInputViewStyleKey"

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

class WYChatInputView: UIImageView {
    
    let textVoiceContentView: UIButton = UIButton(type: .custom)
    let textView: WYChatInputTextView = WYChatInputTextView()
    let textPlaceholderView = UILabel()
    let textVoiceView: UIButton = UIButton(type: .custom)
    let emojiView: UIButton = UIButton(type: .custom)
    let moreView: UIButton = UIButton(type: .custom)
    
    weak var delegate: WYChatInputViewDelegate? = nil
    
    init() {
        super.init(frame: .zero)
        isUserInteractionEnabled = true
        backgroundColor = .clear
        image = inputBarBackgroundImage
        
        textVoiceContentView.setBackgroundImage(voiceViewBackgroundImage, for: .normal)
        textVoiceContentView.setBackgroundImage(textViewBackgroundImage, for: .selected)
        textVoiceContentView.setBackgroundImage(voiceViewBackgroundImageForHighlighted, for: .highlighted)
        textVoiceContentView.wy_nTitle = voicePlaceholder
        textVoiceContentView.wy_sTitle = ""
        textVoiceContentView.wy_hTitle = voicePlaceholder
        textVoiceContentView.wy_titleFont = voicePlaceholderFont
        textVoiceContentView.wy_title_nColor = voicePlaceholderColor
        textVoiceContentView.layer.cornerRadius = textViewCornerRadius
        textVoiceContentView.layer.borderWidth = textViewBorderWidth
        textVoiceContentView.layer.borderColor = textViewBorderColor.cgColor
        textVoiceContentView.layer.masksToBounds = true
        textVoiceContentView.addTarget(self, action: #selector(didClickRecordingButtonView(sender:)), for: .touchUpInside)
        addSubview(textVoiceContentView)
        textVoiceContentView.snp.makeConstraints { make in
            make.height.equalTo(inputViewHeight)
            make.left.equalToSuperview().offset(inputViewEdgeInsets.left)
            make.top.equalToSuperview().offset(inputViewEdgeInsets.top)
            make.right.equalToSuperview().offset(-inputViewEdgeInsets.right)
            make.bottom.equalToSuperview().offset(-inputViewEdgeInsets.bottom)
        }
        if canSaveLastInputViewStyle == true {
            textVoiceContentView.isSelected = !(UserDefaults.standard.value(forKey: canSaveLastInputViewStyleKey) as? Bool ?? false)
        }else {
            textVoiceContentView.isSelected = true
        }
        
        textView.backgroundColor = .clear
        textView.font = textFont
        textView.tintColor = inputViewCurvesColor
        textView.keyboardType = chatKeyboardType
        textView.returnKeyType = chatReturnKeyType
        textView.bounces = inputTextViewIsBounces
        textView.textContainerInset = inputTextEdgeInsets
        textView.textContainer.lineBreakMode = inputTextLineBreakMode
        textView.textContainer.maximumNumberOfLines = inputTextMaximumNumberOfLines
        textView.isScrollEnabled = inputTextViewIsScrollEnabled
        textView.delegate = self
        textVoiceContentView.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        if canSaveLastInputText == true {
            textView.attributedText = sharedAttributedText()
            if textView.attributedText.string.utf16.count > 0 {
                textView.becomeFirstResponder()
            }
        }
        
        if canSaveLastInputViewStyle == true {
            textView.isHidden = UserDefaults.standard.value(forKey: canSaveLastInputViewStyleKey) as? Bool ?? false
        }

        textPlaceholderView.text = textPlaceholder
        textPlaceholderView.textColor = textPlaceholderColor
        textPlaceholderView.font = textPlaceholderFont
        textPlaceholderView.textAlignment = .left
        textPlaceholderView.backgroundColor = .clear
        textPlaceholderView.adjustsFontSizeToFitWidth = true
        textPlaceholderView.isHidden = (textView.text.utf16.count > 0)
        textView.addSubview(textPlaceholderView)
        textPlaceholderView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(textPlaceholderOffset.x)
            make.top.equalToSuperview().offset(textPlaceholderOffset.y)
            make.right.lessThanOrEqualToSuperview().offset(-wy_screenWidth(5))
        }
        
        textVoiceView.wy_nImage = voiceButtonImage
        textVoiceView.wy_sImage = textButtomImage
        textVoiceView.wy_sTitle = voicePlaceholder
        textVoiceView.wy_title_sColor = voicePlaceholderColor
        textVoiceView.wy_titleFont = voicePlaceholderFont
        textVoiceView.isSelected = textView.isHidden
        textVoiceView.backgroundColor = .clear
        textVoiceView.addTarget(self, action: #selector(didClickTextVoiceView(sender:)), for: .touchUpInside)
        addSubview(textVoiceView)
        textVoiceView.snp.makeConstraints { make in
            make.size.equalTo(voiceTextButtonSize)
            make.right.equalTo(textVoiceContentView.snp.left).offset(-voiceTextButtonRightOffset)
            make.bottom.equalTo(textVoiceContentView).offset(-voiceTextButtonBottomOffset)
        }
        
        emojiView.setBackgroundImage(emojiButtomImage, for: .normal)
        emojiView.setBackgroundImage(textButtomImage, for: .selected)
        emojiView.addTarget(self, action: #selector(didClickEmojiView(sender:)), for: .touchUpInside)
        addSubview(emojiView)
        emojiView.snp.makeConstraints { make in
            make.size.equalTo(emojiTextButtonSize)
            make.left.equalTo(textVoiceContentView.snp.right).offset(emojiTextButtonLeftOffset)
            make.bottom.equalTo(textVoiceContentView).offset(-emojiTextButtonBottomOffset)
        }
        
        moreView.setBackgroundImage(moreButtomImage, for: .normal)
        moreView.setBackgroundImage(moreButtomImage, for: .highlighted)
        moreView.addTarget(self, action: #selector(didClickAddView(sender:)), for: .touchUpInside)
        addSubview(moreView)
        moreView.snp.makeConstraints { make in
            make.size.equalTo(moreButtonSize)
            make.left.equalTo(textVoiceContentView.snp.right).offset(moreButtonLeftOffset)
            make.bottom.equalTo(textVoiceContentView).offset(-moreButtonBottomOffset)
        }
        
        updateContentViewHeight()
    }
    
    @objc func didClickTextVoiceView(sender: UIButton) {
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
    
    @objc func didClickRecordingButtonView(sender: UIButton) {
        if sender.isSelected == false {
            wy_print("录音准备")
        }
    }
    
    @objc func didClickAddView(sender: UIButton) {
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
        delegate?.didClickMoreView?(!sender.isSelected)
        saveLastInputViewStyle()
    }
    
    @objc func didClickEmojiView(sender: UIButton) {
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
        delegate?.didClickEmojiTextView?(sender.isSelected)
        saveLastInputViewStyle()
    }
    
    func sharedAttributedText() -> NSAttributedString {
        let attributed: NSMutableAttributedString = NSMutableAttributedString(string: UserDefaults.standard.value(forKey: canSaveLastInputTextKey) as? String ?? "")
        attributed.wy_lineSpacing(lineSpacing: inputTextLineSpacing, alignment: .left)
        attributed.wy_fontsOfRanges(fontsOfRanges: [[textFont: attributed.string]])
        attributed.wy_colorsOfRanges(colorsOfRanges: [[textColor: attributed.string]])
        
        return attributed
    }
    
    func saveLastInputViewStyle() {
        UserDefaults.standard.setValue(textView.isHidden, forKey: canSaveLastInputViewStyleKey)
        UserDefaults.standard.synchronize()
    }
    
    func updateContentViewHeight() {
        let textHeight: CGFloat = textView.attributedText.wy_calculateHeight(controlWidth: wy_screenWidth - inputViewEdgeInsets.left - inputViewEdgeInsets.right - inputTextEdgeInsets.left - inputTextEdgeInsets.right - wy_screenWidth(10)) + inputTextEdgeInsets.top + inputTextEdgeInsets.bottom
        
        var contentHeight: CGFloat = [textHeight,textView.contentSize.height,inputViewHeight].max()!
        
        if (textVoiceView.isSelected == true) {
            contentHeight = inputViewHeight
        }
        
        UIView.animate(withDuration: 0.25) {[weak self] in
            guard let self = self else {return}
            self.textVoiceContentView.snp.updateConstraints { make in
                make.height.equalTo(contentHeight > inputTextViewMaxHeight ? inputTextViewMaxHeight : contentHeight)
            }
            self.textVoiceContentView.superview?.layoutIfNeeded()
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
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        emojiView.isSelected = false
        moreView.isSelected = false
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        if canInputEmoji == false {
            textView.text = textView.text.wy_replaceEmoji(emojiReplacement)
        }
        
        if textView.text.utf16.count > inputTextLength {
            let selectRange = textView.markedTextRange
            if let selectRange = selectRange {
                let position =  textView.position(from: (selectRange.start), offset: 0)
                if (position != nil) {
                    return
                }
            }
            let textContent = textView.text ?? ""
            let textNum = textContent.utf16.count
            if textNum > inputTextLength && inputTextLength > 0 {
                textView.text = textContent.wy_substring(from: 0, to: (inputTextLength - 1))
            }
        }
        
        updateContentViewHeight()
        
        textPlaceholderView.isHidden = !textView.text.isEmpty
        delegate?.textDidChanged?(wy_safe(textView.text))
        
        UserDefaults.standard.setValue(wy_safe(textView.text), forKey: canSaveLastInputTextKey)
        UserDefaults.standard.synchronize()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n" {
            if wy_safe(textView.text).wy_replace(appointSymbol: "\n", replacement: "").count > 0 {
                textView.resignFirstResponder()
                delegate?.didClickKeyboardEvent?(wy_safe(textView.text))
            }
            return false
        }
        return true
    }
}


class WYChatInputTextView: UITextView {
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        
        if (action == #selector(UIResponderStandardEditActions.cut(_:))) || (action == #selector(UIResponderStandardEditActions.copy(_:))) || (action == #selector(UIResponderStandardEditActions.paste(_:))) || (action == #selector(UIResponderStandardEditActions.select(_:))) ||
            (action == #selector(UIResponderStandardEditActions.selectAll(_:))) {
            return inputTextViewCanUserInteractionMenu
        }else {
            return false
        }
    }
}
