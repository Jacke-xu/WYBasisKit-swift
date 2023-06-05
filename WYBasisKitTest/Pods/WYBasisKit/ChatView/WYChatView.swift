//
//  WYChatView.swift
//  WYBasisKit
//
//  Created by 官人 on 2023/3/30.
//  Copyright © 2023 官人. All rights reserved.
//

import UIKit

@objc public protocol WYChatViewDelegate {
    
    /// 点击了 文本/语音按钮 切换按钮
    @objc optional func didClickTextVoiceView(_ isText: Bool)
    
    /// 点击了 表情/文本 切换按钮
    @objc optional func didClickEmojiTextView(_ isText: Bool)
    
    /// 点击了 更多 按钮
    @objc optional func didClickMoreView(_ isText: Bool)
    
    /// 输入框文本发生变化
    @objc optional func textDidChanged(_ text: String)
    
    /// 点击了 发送 按钮
    @objc optional func sendMessage(_ text: String)
    
    /// 将要显示表情预览控件(仅限WYEmojiPreviewStyle == other时才会回调)
    @objc optional func willShowPreviewView(_ imageView: UIImageView, _ imageName: String)
    
    /// 点击了More控件内某个item
    @objc optional func didClick(_ moreView: WYChatMoreView, _ itemIndex: NSInteger)
}

private enum WYChatTouchStyle {
    case done
    case more
    case emoji
}

public class WYChatView: UIView {
    
    public weak var delegate: WYChatViewDelegate? = nil
    
    public lazy var chatInput: WYChatInputView = {
        let inputView = WYChatInputView()
        inputView.delegate = self
        addSubview(inputView)
        inputView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
        }
        return inputView
    }()
    
    public lazy var tableView: UITableView = {

        let tableView = UITableView.wy_shared(style: .plain, separatorStyle: .singleLine, delegate: self, dataSource: self, superView: self)
        tableView.wy_swipeOrTapCollapseKeyboard()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        tableView.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.bottom.equalTo(chatInput.snp.top)
        }
        return tableView
    }()
    
    /// 表情控件
    public lazy var emojiView: WYChatEmojiView? = {
        guard inputBarConfig.emojiTextButtonSize != CGSize.zero else {
            return nil
        }
        let emojiView: WYChatEmojiView = WYChatEmojiView()
        emojiView.delegate = self
        emojiView.isHidden = true
        addSubview(emojiView)
        emojiView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(emojiViewConfig.contentHeight)
            make.bottom.equalToSuperview().offset(emojiViewConfig.contentHeight)
        }
        return emojiView
    }()
    
    /// More控件
    public lazy var moreView: WYChatMoreView? = {
        
        guard inputBarConfig.moreButtonSize != CGSize.zero else {
            return nil
        }
        
        let moreView: WYChatMoreView = WYChatMoreView()
        moreView.delegate = self
        moreView.isHidden = true
        addSubview(moreView)
        moreView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(moreViewConfig.contentHeight())
            make.bottom.equalToSuperview().offset(moreViewConfig.contentHeight())
        }
        
        return moreView
    }()
    
    /// 记录最近使用表情数据，用于实现延时更新最近使用表情
    public var recentlyEmojis: [String] = []
    
    /// TableView数据源
    public var dataSource: [String] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    /// 区分当前点击的是哪个控件
    private var touchStyle: WYChatTouchStyle = .done
    
    public init() {
        super.init(frame: .zero)
        self.tableView.backgroundColor = .white
        self.emojiView?.backgroundColor = .clear
        self.moreView?.backgroundColor = .clear
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDismiss), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        updateInputViewOffset(offsety: keyboardRect.size.height - wy_tabbarSafetyZone)
        updateEmojiViewConstraints(false)
        updateMoreViewConstraints(false)
    }
    
    @objc private func keyboardWillDismiss() {
        
        chatInput.layer.removeAllAnimations()
        var offsety: CGFloat = 0
        switch touchStyle {
        case .emoji:
            offsety = chatInput.emojiView.isSelected ? emojiViewConfig.contentHeight : 0
            break
        case .more:
            offsety = chatInput.moreView.isSelected ? moreViewConfig.contentHeight() : 0
            break
        default:
            offsety = 0
            break
        }
        updateInputViewOffset(offsety: offsety)
    }
    
    private func updateInputViewOffset(offsety: CGFloat) {
        UIView.animate(withDuration: 0.25) { [weak self] in
            if let self = self {
                self.chatInput.snp.updateConstraints({ make in
                    make.bottom.equalToSuperview().offset(-offsety)
                })
                self.chatInput.superview?.layoutIfNeeded()
            }
        }completion: { [weak self] _ in
            if let self = self {
                self.chatInput.updateTextViewOffset()
            }
        }
    }
    
    private func updateEmojiViewConstraints(_ isEmoji: Bool) {
        
        if (isEmoji == false) && (emojiView?.isHidden == true) {
            return
        }
        
        updateMoreViewConstraints(false)
        
        moreView?.isHidden = true
        emojiView?.isHidden = false
        
        if chatInput.textView.isFirstResponder == false {
            touchStyle = .emoji
            keyboardWillDismiss()
        }
        
        if inputBarConfig.emojiTextButtonSize != CGSize.zero {
            let emojiOffset: CGFloat = isEmoji ? 0 : emojiViewConfig.contentHeight
            UIView.animate(withDuration: 0.25) { [weak self] in
                self?.emojiView?.snp.updateConstraints { make in
                    make.bottom.equalToSuperview().offset(emojiOffset)
                }
                self?.emojiView?.superview?.layoutIfNeeded()
            }completion: {[weak self] _ in
                self?.emojiView?.isHidden = !isEmoji
            }
        }
    }
    
    private func updateMoreViewConstraints(_ isMore: Bool) {
        
        if (isMore == false) && (moreView?.isHidden == true) {
            return
        }
        
        updateEmojiViewConstraints(false)
        
        emojiView?.isHidden = true
        moreView?.isHidden = false

        if chatInput.textView.isFirstResponder == false {
            touchStyle = .more
            keyboardWillDismiss()
        }

        if inputBarConfig.moreButtonSize != CGSize.zero {
            let moreOffset: CGFloat = isMore ? 0 : moreViewConfig.contentHeight()
            UIView.animate(withDuration: 0.25) { [weak self] in
                self?.moreView?.snp.updateConstraints { make in
                    make.bottom.equalToSuperview().offset(moreOffset)
                }
                self?.emojiView?.superview?.layoutIfNeeded()
            }completion: {[weak self] _ in
                self?.moreView?.isHidden = !isMore
            }
        }
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        chatInput.emojiView.isSelected = false
        chatInput.moreView.isSelected = false
        updateEmojiViewConstraints(false)
        updateMoreViewConstraints(false)
        emojiView?.isHidden = true
        moreView?.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

extension WYChatView: UITableViewDelegate, UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        chatInput.textView.resignFirstResponder()
        scrollViewDidScroll(tableView)
    }
}

extension WYChatView: WYChatInputViewDelegate {
    
    public func didClickMoreView(_ isText: Bool) {
        delegate?.didClickMoreView?(isText)
        updateMoreViewConstraints(!isText)
    }
    
    public func didClickEmojiTextView(_ isText: Bool) {
        if isText {

        }else {
            updateEmojiFuncAreaViewState()
            if recentlyEmojis.isEmpty == false {
                emojiView?.updateRecentlyEmoji(chatInput.sharedEmojiAttributed(string: recentlyEmojis.joined()))
                recentlyEmojis.removeAll()
            }
        }
        updateEmojiViewConstraints(!isText)
        delegate?.didClickEmojiTextView?(isText)
    }
    
    public func didClickTextVoiceView(_ isText: Bool) {
        if isText {

        }else {
            updateEmojiViewConstraints(false)
            updateMoreViewConstraints(false)
            emojiView?.isHidden = true
            moreView?.isHidden = true
        }
        delegate?.didClickTextVoiceView?(isText)
    }
    
    public func textDidChanged(_ text: String) {
        chatInput.textView.attributedText = chatInput.sharedEmojiAttributed(string: text)
        updateEmojiFuncAreaViewState()
        delegate?.textDidChanged?(text)
    }
    
    public func didClickKeyboardEvent(_ text: String) {
        if emojiViewConfig.instantUpdatesRecently == true {
            emojiView?.updateRecentlyEmoji(chatInput.textView.attributedText)
        }else {
            recentlyEmojis.append(text)
        }
        chatInput.textView.text = ""
        updateEmojiFuncAreaViewState()
        chatInput.textViewDidChange(chatInput.textView)
        delegate?.sendMessage?(text)
    }
    
    public func updateEmojiFuncAreaViewState() {
        
        let userInteractionEnabled: Bool = (chatInput.textView.attributedText.string.utf16.count > 0)
        emojiView?.funcAreaView?.sendView.isUserInteractionEnabled = userInteractionEnabled
        emojiView?.funcAreaView?.deleteView.isUserInteractionEnabled = userInteractionEnabled
        emojiView?.funcAreaView?.sendView.isSelected = !userInteractionEnabled
        emojiView?.funcAreaView?.deleteView.isSelected = !userInteractionEnabled
    }
}

extension WYChatView: WYChatEmojiViewDelegate, WYChatMoreViewDelegate {
    
    public func didClick(_ emojiView: WYChatEmojiView, _ emoji: String) {
        
        let textContent = chatInput.textView.attributedText.string
        let textNum = textContent.utf16.count - (textContent.utf16.count - textContent.count) + 1
        if (textNum > inputBarConfig.inputTextLength) && (inputBarConfig.inputTextLength > 0) {
            return
        }

        let cursorPosition = chatInput.textView.offset(from: chatInput.textView.beginningOfDocument, to: chatInput.textView.selectedTextRange?.start ?? chatInput.textView.beginningOfDocument)
        
        chatInput.textView.insertText(emoji)
        chatInput.textViewDidChange(chatInput.textView)
        
        let start: UITextPosition = chatInput.textView.position(from: chatInput.textView.beginningOfDocument, offset: cursorPosition + (inputBarConfig.emojiPattern.isEmpty ? emoji.utf16.count : 1))!
        let end: UITextPosition = chatInput.textView.position(from: start, offset: 0)!

        chatInput.textView.selectedTextRange = chatInput.textView.textRange(from: start, to: end)
    }
    
    public func willShowPreviewView(_ imageName: String, _ imageView: UIImageView) {
        delegate?.willShowPreviewView?(imageView, imageName)
    }
    
    public func didClickEmojiDeleteView() {
        chatInput.textView.deleteBackward()
    }
    
    public func sendMessage() {
        let emojiText: String = NSMutableAttributedString(attributedString: chatInput.textView.attributedText).wy_convertEmojiAttributedString(textColor: inputBarConfig.textColor, textFont: inputBarConfig.textFont).string
        didClickKeyboardEvent(wy_safe(emojiText))
    }
    
    public func didClickMoreViewAt(_ itemIndex: NSInteger) {
        guard let moreView = moreView else { return }
        delegate?.didClick?(moreView, itemIndex)
    }
}
