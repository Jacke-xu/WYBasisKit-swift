//
//  WYChatView.swift
//  WYBasisKit
//
//  Created by 官人 on 2023/3/30.
//  Copyright © 2023 官人. All rights reserved.
//

import UIKit

/// 返回一个Bool值来判定各控件的点击或手势事件是否需要内部处理(默认返回True)
@objc public protocol WYChatViewEventsHandler {
    
    /// 是否需要内部处理 键盘将要弹出 时的事件
    @objc optional func canManagerKeyboardWillShowEvents(_ notification: Notification) -> Bool
    
    /// 是否需要内部处理 键盘将要消失 时的事件
    @objc optional func canManagerKeyboardWillDismissEvents() -> Bool
    
    /// 是否需要内部处理 tableView的滚动事件
    @objc optional func canManagerScrollViewDidScrollEvents(_ scrollView: UIScrollView) -> Bool
    
    /// 是否需要内部处理chatInput控件内 文本/语音 按钮的点击事件
    @objc optional func canManagerTextVoiceViewEvents(_ textVoiceView: UIButton) -> Bool
    
    /// 是否需要内部处理chatInput控件内 语音(录音) 按钮的长按事件
    @objc optional func canManagerRecordingViewLongPressEvents(_ recordingView: UIButton, _ gestureRecognizer: UILongPressGestureRecognizer) -> Bool
    
    /// 是否需要内部处理chatInput控件内 文本/表情 切换按钮的点击事件
    @objc optional func canManagerTextEmojiViewEvents(_ textEmojiView: UIButton) -> Bool
    
    /// 是否需要内部处理chatInput控件内 更多 按钮的点击事件
    @objc optional func canManagerMoreViewEvents(_ moreView: UIButton) -> Bool
    
    /// 是否需要内部处理chatInput控件内 键盘发送按钮 的点击事件
    @objc optional func canManagerKeyboardSendEvents(_ text: String) -> Bool
    
    /// 是否需要内部处理Emoji控件内 cell 的点击事件
    @objc optional func canManagerEmojiViewClickEvents(_ emojiView: WYChatEmojiView, _ indexPath: IndexPath) -> Bool
    
    /// 是否需要内部处理 表情预览控件(仅限WYEmojiPreviewStyle == other时才会回调) 的长按事件
    @objc optional func canManagerEmojiLongPressEvents(_ gestureRecognizer: UILongPressGestureRecognizer, emoji: String, imageView: UIImageView) -> Bool
    
    /// 是否需要内部处理Emoji控件内 删除按钮 的点击事件
    @objc optional func canManagerEmojiDeleteViewClickEvents(_ deleteView: UIButton) -> Bool
    
    /// 是否需要内部处理Emoji控件内 发送按钮 的点击事件
    @objc optional func canManagerEmojiSendViewClickEvents(_ sendView: UIButton) -> Bool
    
    /// 是否需要内部处理More控件内 cell 的点击事件
    @objc optional func canManagerMoreViewClickEvents(_ moreView: WYChatMoreView, _ itemIndex: NSInteger) -> Bool
}

@objc public protocol WYChatViewDelegate {
    
    /// 键盘将要弹出
    @objc optional func keyboardWillShow(_ notification: Notification)
    
    /// 键盘将要消失
    @objc optional func keyboardWillDismiss()
    
    /// tableView的滚动事件
    @objc optional func scrollViewDidScroll(_ scrollView: UIScrollView)
    
    /// 点击了 文本/语音 切换按钮
    @objc optional func didClickTextVoiceView(_ isText: Bool)
    
    /// 长按了 语音 按钮
    @objc optional func didLongPressRecordingView(_ state: UIGestureRecognizer.State)
    
    /// 点击了 表情/文本 切换按钮
    @objc optional func didClickEmojiTextView(_ isText: Bool)
    
    /// 点击了 更多 按钮
    @objc optional func didClickMoreView(_ isText: Bool)
    
    /// 输入框文本发生变化
    @objc optional func textDidChanged(_ text: String)
    
    /// 点击了键盘上的 发送 按钮
    @objc optional func keyboardSendMessage(_ text: String)
    
    /// 点击了emoji控件内某个item
    @objc optional func didClickEmojiView(_ emojiView: WYChatEmojiView, _ indexPath: IndexPath)
    
    /// 点击了emoji控件内功能区删除按钮
    @objc optional func didClickEmojiDeleteView(_ deleteView: UIButton)
    
    /// 点击了emoji控件内功能区发送按钮
    @objc optional func didClickEmojiSendView(_ sendView: UIButton)
    
    /// 长按了表情预览控件(仅限WYEmojiPreviewStyle == other时才会回调)
    @objc optional func emojiItemLongPress(_ gestureRecognizer: UILongPressGestureRecognizer, emoji: String, imageView: UIImageView)
    
    /// 点击了More控件内某个item
    @objc optional func didClickMoreView(_ moreView: WYChatMoreView, _ itemIndex: NSInteger)
}

public enum WYChatTouchStyle {
    case done
    case more
    case emoji
}

public class WYChatView: UIView {
    
    public weak var eventsHandler: WYChatViewEventsHandler? = nil
    public weak var delegate: WYChatViewDelegate? = nil
    
    public lazy var chatInput: WYChatInputView = {
        let inputView = WYChatInputView()
        inputView.eventsHandler = self
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
        emojiView.eventsHandler = self
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
        moreView.eventsHandler = self
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
    public var touchStyle: WYChatTouchStyle = .done
    
    public init() {
        super.init(frame: .zero)
        self.tableView.backgroundColor = .white
        self.emojiView?.backgroundColor = .clear
        self.moreView?.backgroundColor = .clear
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDismiss), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc public func keyboardWillShowWith(_ notification: Notification, silence: Bool) {
        if silence == false {
            guard (eventsHandler?.canManagerKeyboardWillShowEvents?(notification) ?? true) else {
                return
            }
        }
        
        let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        updateInputViewOffset(offsety: keyboardRect.size.height - wy_tabbarSafetyZone)
        updateEmojiViewConstraints(false)
        updateMoreViewConstraints(false)
    }
    
    @objc public func keyboardWillShow(notification: Notification) {
        keyboardWillShowWith(notification, silence: false)
    }
    
    @objc public func keyboardWillDismissWith(_ silence: Bool) {
        if silence == false {
            guard (eventsHandler?.canManagerKeyboardWillDismissEvents?() ?? true) else {
                return
            }
        }
        
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
    
    @objc public func keyboardWillDismiss() {
        keyboardWillDismissWith(false)
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
            keyboardWillDismissWith(true)
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
            keyboardWillDismissWith(true)
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
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView, silence: Bool) {
        
        if silence == false {
            guard (eventsHandler?.canManagerScrollViewDidScrollEvents?(scrollView) ?? true) else {
                return
            }
        }
        chatInput.emojiView.isSelected = false
        chatInput.moreView.isSelected = false
        updateEmojiViewConstraints(false)
        updateMoreViewConstraints(false)
        emojiView?.isHidden = true
        moreView?.isHidden = true
        if silence == false {
            delegate?.scrollViewDidScroll?(scrollView)
        }
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollViewDidScroll(scrollView, silence: false)
    }
    
    public func updateEmojiFuncAreaViewState() {
        
        let userInteractionEnabled: Bool = (chatInput.textView.attributedText.string.utf16.count > 0)
        emojiView?.funcAreaView?.sendView.isUserInteractionEnabled = userInteractionEnabled
        emojiView?.funcAreaView?.deleteView.isUserInteractionEnabled = userInteractionEnabled
        emojiView?.funcAreaView?.sendView.isSelected = !userInteractionEnabled
        emojiView?.funcAreaView?.deleteView.isSelected = !userInteractionEnabled
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
        scrollViewDidScroll(tableView, silence: true)
    }
}

extension WYChatView: WYChatInputViewDelegate, WYChatInputViewEventsHandler {
    
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
    
    public func didLongPressRecordingView(_ state: UIGestureRecognizer.State) {
        delegate?.didLongPressRecordingView?(state)
    }
    
    public func textDidChanged(_ text: String) {
        chatInput.textView.attributedText = chatInput.sharedEmojiAttributed(string: text)
        updateEmojiFuncAreaViewState()
        delegate?.textDidChanged?(text)
    }
    
    public func didClickKeyboardEvent(_ text: String, silence: Bool) {
        
        if silence == false {
            guard (eventsHandler?.canManagerKeyboardSendEvents?(text) ?? true) else {
                return
            }
        }
        if emojiViewConfig.instantUpdatesRecently == true {
            emojiView?.updateRecentlyEmoji(chatInput.textView.attributedText)
        }else {
            recentlyEmojis.append(text)
        }
        chatInput.textView.text = ""
        updateEmojiFuncAreaViewState()
        chatInput.textViewDidChange(chatInput.textView, silence: true)
        delegate?.keyboardSendMessage?(text)
    }
    
    public func didClickKeyboardEvent(_ text: String) {
        didClickKeyboardEvent(text, silence: false)
    }
    
    public func canManagerTextVoiceViewEvents(_ textVoiceView: UIButton) -> Bool {
        return eventsHandler?.canManagerTextVoiceViewEvents?(textVoiceView) ?? true
    }
    
    public func canManagerRecordingViewLongPressEvents(_ recordingView: UIButton, _ gestureRecognizer: UILongPressGestureRecognizer) -> Bool {
        return eventsHandler?.canManagerRecordingViewLongPressEvents?(recordingView, gestureRecognizer) ?? true
    }
    
    public func canManagerTextEmojiViewEvents(_ textEmojiView: UIButton) -> Bool {
        return eventsHandler?.canManagerTextEmojiViewEvents?(textEmojiView) ?? true
    }
    
    public func canManagerMoreViewEvents(_ moreView: UIButton) -> Bool {
        return eventsHandler?.canManagerMoreViewEvents?(moreView) ?? true
    }
}

extension WYChatView: WYChatEmojiViewDelegate, WYChatEmojiViewEventsHandler {
    
    public func didClick(_ emojiView: WYChatEmojiView, _ indexPath: IndexPath) {
        
        let emoji: String = emojiView.dataSource[indexPath.section][indexPath.item]
        
        let textContent = chatInput.textView.attributedText.string
        let textNum = textContent.utf16.count - (textContent.utf16.count - textContent.count) + 1
        if (textNum > inputBarConfig.inputTextLength) && (inputBarConfig.inputTextLength > 0) {
            return
        }

        let cursorPosition = chatInput.textView.offset(from: chatInput.textView.beginningOfDocument, to: chatInput.textView.selectedTextRange?.start ?? chatInput.textView.beginningOfDocument)
        
        chatInput.textView.insertText(emoji)
        // 这里 silence 传True，目的是解决delegate回调两次的问题(insertText 和 textViewDidChange 都会导致回调)
        chatInput.textViewDidChange(chatInput.textView, silence: true)
        
        let start: UITextPosition = chatInput.textView.position(from: chatInput.textView.beginningOfDocument, offset: cursorPosition + (inputBarConfig.emojiPattern.isEmpty ? emoji.utf16.count : 1))!
        let end: UITextPosition = chatInput.textView.position(from: start, offset: 0)!

        chatInput.textView.selectedTextRange = chatInput.textView.textRange(from: start, to: end)
        
        delegate?.didClickEmojiView?(emojiView, indexPath)
    }
    
    public func emojiItemLongPress(_ gestureRecognizer: UILongPressGestureRecognizer, emoji: String, imageView: UIImageView) {
        delegate?.emojiItemLongPress?(gestureRecognizer, emoji: emoji, imageView: imageView)
    }
    
    public func didClickEmojiSendView(_ sendView: UIButton) {
        let emojiText: String = NSMutableAttributedString(attributedString: chatInput.textView.attributedText).wy_convertEmojiAttributedString(textColor: inputBarConfig.textColor, textFont: inputBarConfig.textFont).string
        didClickKeyboardEvent(wy_safe(emojiText), silence: true)
        delegate?.didClickEmojiSendView?(sendView)
    }
    
    public func didClickEmojiDeleteView(_ deleteView: UIButton) {
        chatInput.textView.deleteBackward()
        delegate?.didClickEmojiDeleteView?(deleteView)
    }
    
    public func canManagerEmojiViewClickEvents(_ emojiView: WYChatEmojiView, _ indexPath: IndexPath) -> Bool {
        return eventsHandler?.canManagerEmojiViewClickEvents?(emojiView, indexPath) ?? true
    }
    
    public func canManagerEmojiLongPressEvents(_ gestureRecognizer: UILongPressGestureRecognizer, emoji: String, imageView: UIImageView) -> Bool {
        return eventsHandler?.canManagerEmojiLongPressEvents?(gestureRecognizer, emoji: emoji, imageView: imageView) ?? true
    }
    
    public func canManagerEmojiDeleteViewClickEvents(_ deleteView: UIButton) -> Bool {
        return eventsHandler?.canManagerEmojiDeleteViewClickEvents?(deleteView) ?? true
    }
    
    public func canManagerEmojiSendViewClickEvents(_ sendView: UIButton) -> Bool {
        return eventsHandler?.canManagerEmojiSendViewClickEvents?(sendView) ?? true
    }
}

extension WYChatView: WYChatMoreViewDelegate, WYMoreViewEventsHandler {
    
    public func didClickMoreViewAt(_ itemIndex: NSInteger) {
        guard let moreView = moreView else { return }
        delegate?.didClickMoreView?(moreView, itemIndex)
    }
    
    public func canManagerMoreViewClickEvents(_ moreView: WYChatMoreView, _ itemIndex: NSInteger) -> Bool {
        return eventsHandler?.canManagerMoreViewClickEvents?(moreView, itemIndex) ?? true
    }
}
