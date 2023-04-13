//
//  WYChatView.swift
//  WYBasisKit
//
//  Created by 官人 on 2023/3/30.
//  Copyright © 2023 官人. All rights reserved.
//

import UIKit

class WYChatView: UIView {
    
    lazy var chatInput: WYChatInputView = {
        let inputView = WYChatInputView()
        inputView.delegate = self
        addSubview(inputView)
        inputView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-wy_tabbarSafetyZone)
        }
        return inputView
    }()
    
    lazy var tableView: UITableView = {

        let tableView = UITableView.wy_shared(style: .plain, separatorStyle: .singleLine, delegate: self, dataSource: self, superView: self)
        tableView.wy_swipeOrTapCollapseKeyboard()
        tableView.wy_register(["UITableViewCell",
                               "UITableViewCell",
                               "UITableViewCell"], [
                                .cell,
                                .cell,
                                .cell])
        tableView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(wy_navViewHeight)
            make.bottom.equalTo(chatInput.snp.top)
        }
        return tableView
    }()
    
    lazy var emojiView: WYEmojiView = {
        let emojiView: WYEmojiView = WYEmojiView()
        addSubview(emojiView)
        emojiView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(emojiViewHeight)
            make.bottom.equalToSuperview().offset(emojiViewHeight)
        }
        return emojiView
    }()
    
    init() {
        super.init(frame: .zero)
        self.tableView.backgroundColor = .purple
        if emojiTextButtonSize != CGSize.zero {
            self.emojiView.backgroundColor = .clear
        }
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDismiss), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        updateInputViewOffset(offsety: keyboardRect.size.height)
        updateEmojiViewConstraints(false)
    }
    
    @objc func keyboardWillDismiss() {
        
        let offsety: CGFloat = chatInput.emojiView.isSelected ? (wy_tabbarSafetyZone + emojiViewHeight) : wy_tabbarSafetyZone
        updateInputViewOffset(offsety: offsety)
    }
    
    func updateInputViewOffset(offsety: CGFloat) {
        UIView.animate(withDuration: 0.25) { [weak self] in
            if let self = self {
                self.chatInput.snp.updateConstraints({ make in
                    make.bottom.equalToSuperview().offset(-offsety)
                })
                self.chatInput.superview?.layoutIfNeeded()
            }
        }
    }
    
    func updateEmojiViewConstraints(_ isEmoji: Bool) {
        
        if chatInput.textView.isFirstResponder == false {
            keyboardWillDismiss()
        }
        
        if emojiTextButtonSize != CGSize.zero {
            let emojiOffset: CGFloat = isEmoji ? -wy_tabbarSafetyZone : emojiViewHeight
            UIView.animate(withDuration: 0.25) { [weak self] in
                self?.emojiView.snp.updateConstraints { make in
                    make.bottom.equalToSuperview().offset(emojiOffset)
                }
                self?.emojiView.superview?.layoutIfNeeded()
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        chatInput.emojiView.isSelected = false
        updateEmojiViewConstraints(false)
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        chatInput.textView.resignFirstResponder()
        scrollViewDidScroll(tableView)
    }
}

extension WYChatView: WYChatInputViewDelegate {
    
    func didClickMoreView(_ isText: Bool) {
        if isText {
            wy_print("显示键盘")
        }else {
            wy_print("显示更多")
        }
    }
    
    func didClickEmojiTextView(_ isEmoji: Bool) {
        if isEmoji {
            wy_print("显示表情")
        }else {
            wy_print("显示键盘")
        }
        updateEmojiViewConstraints(isEmoji)
    }
    
    func didClickTextVoiceView(_ isText: Bool) {
        if isText {
            wy_print("显示键盘")
        }else {
            wy_print("显示语音")
            updateEmojiViewConstraints(false)
        }
    }
    
    func textDidChanged(_ text: String) {
        wy_print("输入的文本：\(text)")
    }
    
    func didClickKeyboardEvent(_ text: String) {
        wy_print("点击了键盘右下角按钮，最终文本内容是：\(text)")
    }
}
