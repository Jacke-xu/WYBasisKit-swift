//
//  WYTestChatController.swift
//  WYBasisKit
//
//  Created by Miraitowa on 2023/3/30.
//  Copyright © 2023 Jacke·xu. All rights reserved.
//

import UIKit

class WYTestChatController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        
        let resourcePath = (((Bundle(for: WYTestChatController.self).path(forResource: "Emoji", ofType: "plist")) ?? (Bundle.main.path(forResource: "Emoji", ofType: "plist"))) ?? "")
        
        inputBarConfig.textButtomImage = UIImage(named: "toggle_keyboard")!
        inputBarConfig.voiceButtonImage = UIImage(named: "voice")!
        inputBarConfig.emojiButtomImage = UIImage(named: "toggle_emoji")!
        inputBarConfig.moreButtomImage = UIImage(named: "jia")!
        inputBarConfig.emojiPattern = "\\[.{1,3}\\]"
        
        emojiViewConfig.emojiSource = try! NSArray(contentsOf: URL(string: "file://".appending(resourcePath))!, error: ()) as! [String]
        
        emojiViewConfig.funcAreaConfig.deleteViewImageWithUnenable = UIImage.wy_find("chatDeleteUnenable")
        emojiViewConfig.funcAreaConfig.deleteViewImageWithEnable = UIImage.wy_find("chatDeleteEnable")
        emojiViewConfig.funcAreaConfig.deleteViewImageWithHighly = UIImage.wy_find("chatDeleteEnable")
        
        emojiViewConfig.funcAreaConfig.deleteViewText = ""
        
        emojiViewConfig.previewConfig.backgroundImage = UIImage.wy_find("emoji-preview-bg")
        
//        emojiViewConfig.totalHeaderText = ""
//        emojiViewConfig.recentlyHeaderText = ""
//        emojiViewConfig.showRecently = false
        
        moreViewConfig.moreSource = [["照片": "zhaopian"], ["拍摄": "paishe"], ["位置": "weizhi"], ["语音输入": "yuyinshuru"], ["收藏": "shoucang"], ["个人名片": "gerenmingpian"], ["文件": "wenjianjia"], ["音乐": "yinle"]]
        
        let chatView = WYChatView()
        chatView.dataSource = emojiViewConfig.emojiSource
        chatView.delegate = self
        view.addSubview(chatView)
        chatView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(wy_navViewHeight)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-wy_tabbarSafetyZone)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension WYTestChatController: WYChatViewDelegate {
    
    /// 点击了 文本/语音按钮 切换按钮
    func didClickTextVoiceView(_ isText: Bool) {
        if isText {
            wy_print("显示键盘")
        }else {
            wy_print("显示语音")
        }
    }
    
    /// 点击了 表情/文本 切换按钮
    func didClickEmojiTextView(_ isText: Bool) {
        if isText {
            wy_print("显示键盘")
        }else {
            wy_print("显示表情")
        }
    }
    
    /// 点击了 更多 按钮
    func didClickMoreView(_ isText: Bool) {
        if isText {
            wy_print("显示键盘")
        }else {
            wy_print("显示更多")
        }
    }
    
    /// 输入框文本发生变化
    func textDidChanged(_ text: String) {
        wy_print("输入的文本：\(text)")
    }
    
    /// 点击了 发送 按钮
    func sendMessage(_ text: String) {
        wy_print("发送文本消息：\(text)")
    }
    
    /// 将要显示表情预览控件(仅限WYEmojiPreviewStyle == other时才会回调)
    func willShowPreviewView(_ imageView: UIImageView, _ imageName: String) {
        wy_print("imageView = \(imageView), imageName = \(imageName)")
    }
    
    /// 点击了More控件内某个item
    func didClick(_ moreView: WYChatMoreView, _ itemIndex: NSInteger) {
        wy_print("点击More控件 \(moreView) 内第 \(itemIndex) 个item")
    }
}
