//
//  WYChatConfig.swift
//  WYBasisKit
//
//  Created by 官人 on 2023/3/30.
//  Copyright © 2023 官人. All rights reserved.
//

import UIKit

/// 输入bar背景图
var inputBarBackgroundImage: UIImage = UIImage.wy_createImage(from: .orange)

/// 语音按钮图片
var voiceButtonImage: UIImage = UIImage(named: "voice")!

/// 文本按钮图片
var textButtomImage: UIImage = UIImage(named: "text")!

/// 表情按钮图片
var emojiButtomImage: UIImage = UIImage(named: "xiaolian")!

/// 加号按钮图片
var moreButtomImage: UIImage = UIImage(named: "jia")!

/// 文本框背景图
var textViewBackgroundImage: UIImage = UIImage.wy_createImage(from: .white)

/// 语音框背景图
var voiceViewBackgroundImage: UIImage = UIImage.wy_createImage(from: .white)

/// 语音框按压状态背景图
var voiceViewBackgroundImageForHighlighted: UIImage = UIImage.wy_createImage(from: .white)

/// 键盘类型
var chatKeyboardType: UIKeyboardType = .default

/// 键盘右下角按钮类型
var chatReturnKeyType: UIReturnKeyType = .send

/// 输入框占位文本
var textPlaceholder: String = "输入框占位文本"

/// 输入框占位文本色值
var textPlaceholderColor: UIColor = .lightGray

/// 输入框占位文本字体、字号
var textPlaceholderFont: UIFont = .systemFont(ofSize: wy_screenWidth(15))

/// 输入框占位文本距离输入框左侧和顶部的间距
var textPlaceholderOffset: CGPoint = CGPoint(x: wy_screenWidth(16), y: wy_screenWidth(12.5))

/// 输入框输入文本色值
var textColor: UIColor = .black

/// 输入框输入文本字体、字号
var textFont: UIFont = .systemFont(ofSize: wy_screenWidth(15))

/// 语音框占位文本
var voicePlaceholder: String = "语音框占位文本"

/// 语音框占位文本色值
var voicePlaceholderColor: UIColor = .black

/// 语音框占位文本字体、字号
var voicePlaceholderFont: UIFont = .systemFont(ofSize: wy_screenWidth(15))

/// 输入框、语音框的圆角半径
var textViewCornerRadius: CGFloat = wy_screenWidth(8)

/// 输入框、语音框的边框颜色
var textViewBorderColor: UIColor = .gray

/// 输入框、语音框的边框宽度
var textViewBorderWidth: CGFloat = 1

/// 输入框、语音框的高度
var inputViewHeight: CGFloat = wy_screenWidth(42)

/// 输入框文本行间距
var inputTextLineSpacing: CGFloat = 5

/// 输入框的最高高度
var inputTextViewMaxHeight: CGFloat = CGFLOAT_MAX

/// 输入框、语音框距离输入Bar的间距
var inputViewEdgeInsets: UIEdgeInsets = UIEdgeInsets(top: wy_screenWidth(12), left: wy_screenWidth(57), bottom: wy_screenWidth(12), right: wy_screenWidth(100))

/// 输入框内文本偏移量
var inputTextEdgeInsets: UIEdgeInsets = UIEdgeInsets(top: wy_screenWidth(13), left: wy_screenWidth(10), bottom: wy_screenWidth(5), right: wy_screenWidth(5))

/// 语音、文本切换按钮的size
var voiceTextButtonSize: CGSize = CGSize(width: wy_screenWidth(31), height: wy_screenWidth(31))

/// 语音、文本切换按钮距离 输入框、语音框 左侧的间距
var voiceTextButtonRightOffset: CGFloat = wy_screenWidth(13)

/// 语音、文本切换按钮距离 输入框、语音框 底部的间距
var voiceTextButtonBottomOffset: CGFloat = wy_screenWidth(5)

/// 表情、文本切换按钮的size
var emojiTextButtonSize: CGSize = CGSize(width: wy_screenWidth(31), height: wy_screenWidth(31))

/// 表情、文本切换按钮距离 输入框、语音框 右侧的间距
var emojiTextButtonLeftOffset: CGFloat = wy_screenWidth(13)

/// 表情、文本切换按钮距离 输入框、语音框 底部的间距
var emojiTextButtonBottomOffset: CGFloat = wy_screenWidth(5)

/// 加号按钮的size
var moreButtonSize: CGSize = CGSize(width: wy_screenWidth(31), height: wy_screenWidth(31))

/// 加号按钮距离 输入框、语音框 右侧的间距
var moreButtonLeftOffset: CGFloat = wy_screenWidth(57)

/// 加号按钮距离 输入框、语音框 底部的间距
var moreButtonBottomOffset: CGFloat = wy_screenWidth(5)

/// 是否允许输入表情
var canInputEmoji: Bool = true

/// 输入法自带的Emoji表情替换成什么字符(需要canInputEmoji为false才生效)
var emojiReplacement: String = ""

/// 输入字符长度限制
var inputTextLength: NSInteger = Int.max

/// 输入字符行数限制(0为不限制行数)
var inputTextMaximumNumberOfLines: NSInteger = 0

/// 输入字符的截断方式
var inputTextLineBreakMode: NSLineBreakMode = .byTruncatingTail

/// 字符输入控件是否允许滑动
var inputTextViewIsScrollEnabled: Bool = true

/// 字符输入控件是否允许弹跳效果
var inputTextViewIsBounces: Bool = true

/// 字符输入控件光标颜色
var inputViewCurvesColor: UIColor = .blue

/// 字符输入控件是否允许弹出用户交互菜单
var inputTextViewCanUserInteractionMenu: Bool = true

/// 是否需要保存上次退出时输入框中的文本
var canSaveLastInputText: Bool = true

/// 是否需要保存上次退出时输入框模式(语音输入还是文本输入)
var canSaveLastInputViewStyle: Bool = true

/// 自定义Emoji控件滚动方向
var emojiViewScrollDirection: UICollectionView.ScrollDirection = .vertical

/// 自定义更多控件滚动方向
var moreViewScrollDirection: UICollectionView.ScrollDirection = .horizontal

/// 自定义Emoji控件背景色
var emojiViewBackgroundColor: UIColor = .orange

/// 自定义更多控件背景色
var moreViewBackgroundColor: UIColor = .white

/// 自定义Emoji控件的高度
var emojiViewHeight: CGFloat = wy_screenWidth(350)

/// 自定义更多控件的高度
var moreViewHeight: CGFloat = wy_screenWidth(180)

/// 自定义Emoji数据源，示例：["[玫瑰]":"meigui(表情图片名)","[色]":"se(表情图片名)","[嘻嘻]":"xixi(表情图片名)"]
var emojiViewDataSource: [String: String] = ["": ""]

/// 自定义更多控件数据源，示例：["位置":"位置图片名", "拍摄": "拍摄图片名"]
var moreViewDataSource: [String: String] = ["": ""]

/// 自定义Emoji控件是否需要翻页模式
var emojiViewIsPagingEnabled: Bool = false

/// 自定义更多控件是否需要翻页模式
var moreViewIsPagingEnabled: Bool = true

/// 自定义Emoji控件实现需要显示最近使用的表情
var emojiViewShowRecently: Bool = true

/// 自定义Emoji控件最近使用表情Header文本(设置后会显示一个Header，仅emojiViewScrollDirection为vertical模式时生效)
var emojiViewRecentlyHeaderText: String = "最近使用"

/// 自定义Emoji控件所有表情Header文本(设置后会显示一个Header，仅emojiViewScrollDirection为vertical模式时生效)
var emojiViewTotalHeaderText: String = "所有表情"

/// 自定义Emoji控件Header文本字体、字号
var emojiViewHeaderTextFont: UIFont = .systemFont(ofSize: wy_screenWidth(15))

/// 自定义Emoji控件Header文本字体颜色
var emojiViewHeaderTextColor: UIColor = .black

/// 自定义Emoji控件HeaderView背景色
var emojiViewHeaderBackgroundColor: UIColor = .lightGray

/// 自定义Emoji控件TextView相对于HeaderView的上、下、左侧间距，右侧固定0
var emojiHeaderTextViewEdgeInsets: UIEdgeInsets = UIEdgeInsets(top: wy_screenWidth(8), left: wy_screenWidth(15), bottom: wy_screenWidth(8), right: 0)

/// 自定义Emoji控件单元格的Size
var emojiViewContentSize: CGSize = CGSize(width: wy_screenWidth(25), height: wy_screenWidth(25))

/// 自定义EmojiView表情控件size
var emojiImageViewSize: CGSize = CGSize(width: wy_screenWidth(20), height: wy_screenWidth(20))

/// 自定义EmojiView表情控件相对于单元格顶部的间距
var emojiImageViewTopOffset: CGFloat = ((emojiViewContentSize.height - emojiImageViewSize.height) / 2)

/// 自定义Emoji控件是否需要在右下角显示功能区(内含删除按钮和发送按钮，仅emojiViewScrollDirection为vertical模式时生效)
var emojiViewShowFuncArea: Bool = true

/// 自定义Emoji控件右下角功能区背景色
var emojiViewFuncAreaBackgroundColor: UIColor = .white

/// 自定义Emoji控件右下角功能区删除按钮背景图
var emojiViewDeleteImage: UIImage = UIImage()

/// 自定义Emoji控件右下角功能区发送按钮背景图
var emojiViewSendImage: UIImage = UIImage()

/// 自定义Emoji控件右下角功能区删除按钮文本
var emojiViewDeleteText: String = ""

/// 自定义Emoji控件右下角功能区发送按钮文本
var emojiViewSendText: String = "发送"

/// 自定义Emoji控件右下角功能区删除按钮字体、字号
var emojiViewDeleteTextFont: UIFont = UIFont.systemFont(ofSize: wy_screenWidth(13))

/// 自定义Emoji控件右下角功能区发送按钮字体、字号
var emojiViewSendTextFont: UIFont = UIFont.systemFont(ofSize: wy_screenWidth(13))

/// 自定义Emoji控件右下角功能区发送按钮距离Emoji控件右侧边框的间距
var emojiViewSendControRightOffset: CGFloat = wy_screenWidth(10)

/// 自定义Emoji控件右下角功能区Size
var emojiViewFuncControSize: CGSize = CGSize(width: wy_screenWidth(100), height: wy_screenWidth(80))

/// 自定义Emoji控件右下角删除按钮和发送按钮之间的间距
var emojiViewDeleteControRightOffset: CGFloat = wy_screenWidth(8)

/// 自定义Emoji控件右下角发送按钮Size
var emojiViewSendControSize: CGSize = CGSize(width: wy_screenWidth(40), height: wy_screenWidth(30))

/// 自定义Emoji控件右下角功能区删除按钮的size
var emojiViewDeleteControSize: CGSize = CGSize(width: wy_screenWidth(40), height: wy_screenWidth(30))

/// 自定义Emoji控件是否需要长按显示emoji详细信息
var emojiViewLongPressShow: Bool = true

/// 自定义Emoji控件长按组件的size
var emojiViewLongPressControSize: CGSize = CGSize(width: wy_screenWidth(60), height: wy_screenWidth(100))

/// 自定义Emoji控件长按组件的背景图
var emojiViewLongPressControImage: UIImage = UIImage()

/// 自定义Emoji控件长按组件内单个emoji的size
var emojiViewLongPressControEmojiSize: CGSize = CGSize(width: wy_screenWidth(40), height: wy_screenWidth(40))

/// 自定义Emoji控件长按组件内单个emoji顶部的偏移量
var emojiViewLongPressControEmojiTopOffset: CGFloat = wy_screenWidth(10)

/// 自定义Emoji控件长按组件内单个文本控件底部的偏移量
var emojiViewLongPressControTextBottomOffset: CGFloat = wy_screenWidth(5)
