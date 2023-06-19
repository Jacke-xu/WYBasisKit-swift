//
//  WYChatModel.swift
//  WYBasisKit
//
//  Created by Miraitowa on 2023/6/16.
//

import Foundation
import CoreLocation

/// 允许语音断点播放的间隔时间(单位秒)
public var voiceBreakpointIntervalTime: TimeInterval = 60

/// 消息撤回时长间隔时间(单位秒)
public var messageWithdrawalInterval: TimeInterval = 120

/// 聊天消息类型
public enum WYChatMessageStyle {
    /// 未知
    case none
    /// 文本
    case text
    /// 语音
    case voice
    /// 照片
    case photo
    /// 音乐
    case music
    /// 视频
    case video
    /// 红包
    case luckyMoney
    /// 转账
    case transfer
    /// 位置
    case location
    /// 拍一拍
    case takePat
    /// 消息撤回
    case withdrawn
    /// 音视频通话
    case call
    /// 网页、小程序
    case webpage
    /// 文件
    case file
    /// 名片
    case businessCard
    /// 聊天记录(合集)
    case chatRecords
}

/// 红包、转账收款状态
public enum WYChatFundsState {
    
    /// 待收款
    case unreceived
    
    /// 已收款
    case received
    
    /// 超时退回
    case timeout
    
    /// 用户退回
    case `return`
}

/// 通话类型
public enum WYChatCallStyle {
    
    /// 一对一语音
    case oneToOneVoice
    
    /// 一对一视屏
    case oneToOneVideo
    
    /// 多人语音
    case multipleVoices
    
    /// 多人视频
    case multipleVideos
}

/// 消息发送状态
public enum WYChatMessageSendState {
    /// 未发送
    case notSent
    /// 发送中
    case sending
    /// 发送成功
    case success
    /// 发送失败
    case failed
}

/// 图片、视频等资源文件相关信息
public struct WYChatAssetsModel {
    
    /// id
    public var id: String = ""
    
    /// 名字
    public var name: String = ""
    
    /// 网络下载地址
    public var downloadPath: String = ""
    
    /// 本地文件路径
    public var localPath: String = ""
    
    public init(id: String = "", name: String = "", downloadPath: String = "", localPath: String = "") {
        self.id = id
        self.name = name
        self.downloadPath = downloadPath
        self.localPath = localPath
    }
}

/// 语音消息Model
public struct WYChatVoiceModel {
    
    /// 语音时长
    public var duration: TimeInterval = 0
    
    /// 是否被播放过
    public var played: Bool = false
    
    /// 是否被暂停播放(决定是否可以断点续播)
    public var pause: Bool {
        get {
            return (pauseWithTimestamp + voiceBreakpointIntervalTime) > NSDate().timeIntervalSince1970
        }
    }
    
    /// 被暂停播放时的时间戳
    public var pauseWithTimestamp: TimeInterval = 0
    
    /// 当前已播放时长
    public var currentPlayDuration: TimeInterval = 0
    
    /// 语音转换后的文本
    public var voiceToText: String = ""
    
    /// wav格式本地路径
    public var wavPath: String = ""
    
    /// mp3格式本地路径
    public var mp3Path: String = ""
    
    /// amr格式本地路径
    public var amrPath: String = ""
    
    /// caf格式本地路径
    public var cafPath: String = ""
    
    /// aac格式本地路
    public var aacPath: String = ""
    
    public init(duration: TimeInterval = 0, played: Bool = false, pauseWithTimestamp: TimeInterval = 0, currentPlayDuration: TimeInterval = 0, voiceToText: String = "", wavPath: String = "", mp3Path: String = "", amrPath: String = "", cafPath: String = "", aacPath: String = "") {
        self.duration = duration
        self.played = played
        self.pauseWithTimestamp = pauseWithTimestamp
        self.currentPlayDuration = currentPlayDuration
        self.voiceToText = voiceToText
        self.wavPath = wavPath
        self.mp3Path = mp3Path
        self.amrPath = amrPath
        self.cafPath = cafPath
        self.aacPath = aacPath
    }
}

/// 照片消息Model
public struct WYChatPhotoModel {
    
    /// 原图
    public var original: WYChatAssetsModel = WYChatAssetsModel()
    
    /// 缩略图
    public var thumbnail: WYChatAssetsModel = WYChatAssetsModel()
    
    public init(original: WYChatAssetsModel = WYChatAssetsModel(), thumbnail: WYChatAssetsModel = WYChatAssetsModel()) {
        self.original = original
        self.thumbnail = thumbnail
    }
}

/// 音乐消息Model
public struct WYChatMusicModel {
    
    /// id
    public var id: String = ""
    
    /// 音乐名
    public var name: String = ""
    
    /// 作曲家
    public var composer: String = ""
    
    /// 演唱者
    public var singer: String = ""
    
    /// 音乐时长
    public var duration: TimeInterval = 0
    
    /// 当前已播放时长
    public var playedDuration: TimeInterval = 0
    
    /// 播放地址
    public var playPath: String = ""
    
    /// 封面
    public var cover: WYChatAssetsModel = WYChatAssetsModel()
    
    /// 封面缩略图
    public var thumbnailCover: WYChatAssetsModel = WYChatAssetsModel()
    
    public init(id: String = "", name: String = "", composer: String = "", singer: String = "", duration: TimeInterval = 0, playedDuration: TimeInterval = 0, playPath: String = "", thumbnailCover: WYChatAssetsModel = WYChatAssetsModel()) {
        self.id = id
        self.name = name
        self.composer = composer
        self.singer = singer
        self.duration = duration
        self.playedDuration = playedDuration
        self.playPath = playPath
        self.thumbnailCover = thumbnailCover
    }
}

/// 视频消息Model
public struct WYChatVideoModel {
    
    /// id
    public var id: String = ""
    
    /// 封面
    public var cover: WYChatAssetsModel = WYChatAssetsModel()
    
    /// 封面缩略图
    public var thumbnailCover: WYChatAssetsModel = WYChatAssetsModel()
    
    /// 视频
    public var video: WYChatAssetsModel = WYChatAssetsModel()
    
    /// 视频时长
    public var duration: TimeInterval = 0
    
    /// 当前播放时长
    public var playedDuration: TimeInterval = 0
    
    public init(id: String = "", cover: WYChatAssetsModel = WYChatAssetsModel(), thumbnailCover: WYChatAssetsModel = WYChatAssetsModel(), video: WYChatAssetsModel = WYChatAssetsModel(), duration: TimeInterval = 0, playedDuration: TimeInterval = 0) {
        self.id = id
        self.cover = cover
        self.thumbnailCover = thumbnailCover
        self.video = video
        self.duration = duration
        self.playedDuration = playedDuration
    }
}

/// 红包消息Model
public struct WYChatLuckyMoneyModel {
    
    /// id
    public var id: String = ""
    
    /// 大封面
    public var fullCover: WYChatAssetsModel = WYChatAssetsModel()
    
    /// 小封面
    public var smailCover: WYChatAssetsModel = WYChatAssetsModel()
    
    /// 封面视频
    public var coverVideo: WYChatAssetsModel = WYChatAssetsModel()
    
    /// 金额
    public var amounts: String = ""
    
    /// 红包个数(1为个人红包，否则为多人红包)
    public var numberOfLuckyMoney: NSInteger = 1
    
    /// 已抢红包个数
    public var numberOfRobbed: NSInteger = 0
    
    /// 红包已抢金额
    public var amountsStolen: Double = 0
    
    /// 收款状态
    public var state: WYChatFundsState = .unreceived
    
    /// 备注
    public var remarks: String = ""
    
    /// 说明(xx红包)
    public var notes: String = ""
    
    public init(id: String = "", fullCover: WYChatAssetsModel = WYChatAssetsModel(), smailCover: WYChatAssetsModel = WYChatAssetsModel(), coverVideo: WYChatAssetsModel = WYChatAssetsModel(), amounts: String = "", numberOfLuckyMoney: NSInteger = 0, numberOfRobbed: NSInteger = 0, amountsStolen: Double = 0, state: WYChatFundsState = .unreceived, remarks: String = "", notes: String = "") {
        self.id = id
        self.fullCover = fullCover
        self.smailCover = smailCover
        self.coverVideo = coverVideo
        self.amounts = amounts
        self.numberOfLuckyMoney = numberOfLuckyMoney
        self.numberOfRobbed = numberOfRobbed
        self.amountsStolen = amountsStolen
        self.state = state
        self.remarks = remarks
        self.notes = notes
    }
}

/// 定位消息Model
public struct WYChatLocationModel {
    
    /// 定位封面
    public var cover: WYChatAssetsModel = WYChatAssetsModel()
    
    /// 定位标题
    public var title: String = ""
    
    /// 定位详细地址
    public var address: String = ""
    
    /// 定位经纬度
    public var location: CLLocationCoordinate2D = CLLocationCoordinate2D()
    
    public init(cover: WYChatAssetsModel = WYChatAssetsModel(), title: String = "", address: String = "", location: CLLocationCoordinate2D = CLLocationCoordinate2D()) {
        self.cover = cover
        self.title = title
        self.address = address
        self.location = location
    }
}

/// 拍一拍model
public struct WYChatTakePatModel {
    
    /// 拍人者
    public var striking: WYChatUaerModel = WYChatUaerModel()
    
    /// 被拍者
    public var beaten: WYChatUaerModel = WYChatUaerModel()
    
    /// 被拍者拍一拍设置
    public var notes: String = ""
    
    public init(striking: WYChatUaerModel = WYChatUaerModel(), beaten: WYChatUaerModel = WYChatUaerModel(), notes: String = "") {
        self.striking = striking
        self.beaten = beaten
        self.notes = notes
    }
}

/// 消息撤回model
public struct WYChatWithdrawnModel {
    
    /// 发送时间
    public var sendTime: String = ""
    
    /// 可撤回时长间隔
    public var withdrawalInterval: TimeInterval = messageWithdrawalInterval
    
    /// 撤回时间
    public var withdrawnTime: String = ""
    
    /// 消息内容
    public var content: Data = Data()
    
    /// 消息类型
    public var messageStyle: WYChatMessageStyle = .none
    
    public init(sendTime: String = "", withdrawalInterval: TimeInterval = messageWithdrawalInterval, withdrawnTime: String = "", messageStyle: WYChatMessageStyle = .none) {
        self.sendTime = sendTime
        self.withdrawalInterval = withdrawalInterval
        self.withdrawnTime = withdrawnTime
        self.messageStyle = messageStyle
    }
}

/// 音视频通话model
public struct WYChatCallModel {
    
    /// 通话时长
    public var durationOfCall: TimeInterval = 0
    
    /// 通话类型
    public var callStyle: WYChatCallStyle = .oneToOneVoice
    
    /// 通话发起者信息
    public var promoter: WYChatUaerModel = WYChatUaerModel()
    
    /// 通话成员信息(一对一通话时只有一个成员)
    public var members: [WYChatUaerModel] = []
    
    public init(durationOfCall: TimeInterval = 0, callStyle: WYChatCallStyle = .oneToOneVoice, promoter: WYChatUaerModel = WYChatUaerModel(), members: [WYChatUaerModel] = []) {
        self.durationOfCall = durationOfCall
        self.callStyle = callStyle
        self.promoter = promoter
        self.members = members
    }
}

/// 网页、小程序model
public struct WYChatWebpageModel {
    
    /// id
    public var id: String = ""
    
    /// 封面
    public var cover: WYChatAssetsModel = WYChatAssetsModel()
    
    /// 标题
    public var title: String = ""
    
    /// 描述
    public var description: String = ""
    
    /// 头像
    public var avatar: WYChatAssetsModel = WYChatAssetsModel()
    
    /// 名称
    public var name: String = ""
    
    /// 内容链接
    public var path: String = ""
    
    public init(id: String = "", cover: WYChatAssetsModel = WYChatAssetsModel(), title: String = "", description: String = "", avatar: WYChatAssetsModel = WYChatAssetsModel(), name: String = "", path: String = "") {
        self.id = id
        self.cover = cover
        self.title = title
        self.description = description
        self.avatar = avatar
        self.name = name
        self.path = path
    }
}

/// 文件model
public struct WYChatFileModel {
    
    /// id
    public var id: String = ""
    
    /// 标题
    public var title: String = ""
    
    /// icon
    public var icon: WYChatAssetsModel = WYChatAssetsModel()
    
    /// 大小(占用内存，如xxkb,xxmb)
    public var size: String = ""
    
    /// 名称
    public var name: String = ""
    
    /// 头像
    public var avatar: WYChatAssetsModel = WYChatAssetsModel()
    
    public init(id: String = "", title: String = "", icon: WYChatAssetsModel = WYChatAssetsModel(), size: String = "", name: String = "", avatar: WYChatAssetsModel = WYChatAssetsModel()) {
        self.id = id
        self.title = title
        self.icon = icon
        self.size = size
        self.name = name
        self.avatar = avatar
    }
}

/// 名片model
public struct WYChatBusinessCardModel {
    
    /// id
    public var id: String = ""
    
    /// 用户信息
    public var userInfo: WYChatUaerModel = WYChatUaerModel()
    
    /// 描述
    public var description: String = ""
    
    public init(id: String = "", userInfo: WYChatUaerModel = WYChatUaerModel(), description: String = "") {
        self.id = id
        self.userInfo = userInfo
        self.description = description
    }
}

/// 聊天记录(合集)model
public struct WYChatRecordsModel {
    
    /// 标题(xxx的聊天记录)
    public var title: String = ""
    
    /// 消息合集
    public var messages: [WYChatMessageModel] = []
    
    /// 描述
    public var description: String = ""
    
    public init(title: String, messages: [WYChatMessageModel] = [], description: String) {
        self.title = title
        self.messages = messages
        self.description = description
    }
}

/// 消息体
public struct WYChatMeesageContentModel {
    
    /// 文本
    var text: String? = nil
    
    /// 语音
    var voice: WYChatVoiceModel? = nil
    
    /// 照片
    var photo: WYChatPhotoModel? = nil
    
    /// 音乐
    var music: WYChatMusicModel? = nil
    
    /// 视频
    var video: WYChatVideoModel? = nil
    
    /// 红包
    var luckyMoney: WYChatLuckyMoneyModel? = nil
    
    /// 转账
    var transfer: WYChatLuckyMoneyModel? = nil
    
    /// 位置
    var location: WYChatLocationModel? = nil
    
    /// 拍一拍
    var takePat: WYChatTakePatModel? = nil
    
    /// 消息撤回
    var withdrawn: WYChatWithdrawnModel? = nil
    
    /// 音视频通话
    var call: WYChatCallModel? = nil
    
    /// 网页、小程序
    var webpage: WYChatWebpageModel? = nil
    
    /// 文件
    var file: WYChatFileModel? = nil
    
    /// 名片
    var businessCard: WYChatBusinessCardModel? = nil
    
    /// 聊天记录(合集)
    var chatRecords: WYChatRecordsModel? = nil
    
    public init(text: String? = nil, voice: WYChatVoiceModel? = nil, photo: WYChatPhotoModel? = nil, music: WYChatMusicModel? = nil, video: WYChatVideoModel? = nil, luckyMoney: WYChatLuckyMoneyModel? = nil, transfer: WYChatLuckyMoneyModel? = nil, location: WYChatLocationModel? = nil, takePat: WYChatTakePatModel? = nil, withdrawn: WYChatWithdrawnModel? = nil, call: WYChatCallModel? = nil, webpage: WYChatWebpageModel? = nil, file: WYChatFileModel? = nil, businessCard: WYChatBusinessCardModel? = nil, chatRecords: WYChatRecordsModel? = nil) {
        self.text = text
        self.voice = voice
        self.photo = photo
        self.music = music
        self.video = video
        self.luckyMoney = luckyMoney
        self.transfer = transfer
        self.location = location
        self.takePat = takePat
        self.withdrawn = withdrawn
        self.call = call
        self.webpage = webpage
        self.file = file
        self.businessCard = businessCard
        self.chatRecords = chatRecords
    }
}

/// 聊天用户model
public struct WYChatUaerModel {
    
    /// 用户id
    public var id: String = ""
    
    /// 用户名
    public var name: String = ""
    
    /// 用户昵称
    public var nickname: String = ""
    
    /// 用户备注
    public var remarks: String = ""
    
    /// 用户签名
    public var signature: String = ""
    
    /// 用户所在地区
    public var area: String = ""
    
    /// 加入的群
    public var groups: [WYChatGroupModel] = []
    
    /// 用户二维码
    public var qrCode: WYChatAssetsModel = WYChatAssetsModel()
    
    /// 用户头像
    public var avatar: WYChatAssetsModel = WYChatAssetsModel()
    
    /// 用户头像缩略图
    public var thumbnailAvatar: WYChatAssetsModel = WYChatAssetsModel()
    
    /// 更多信息
    public var moreInfo: Data? = nil
    
    public init(id: String = "", name: String = "", nickname: String = "", remarks: String = "", signature: String = "", area: String = "", groups: [WYChatGroupModel] = [], qrCode: WYChatAssetsModel = WYChatAssetsModel(), avatar: WYChatAssetsModel = WYChatAssetsModel(), thumbnailAvatar: WYChatAssetsModel = WYChatAssetsModel(), moreInfo: Data? = nil) {
        self.id = id
        self.name = name
        self.nickname = nickname
        self.remarks = remarks
        self.signature = signature
        self.area = area
        self.groups = groups
        self.qrCode = qrCode
        self.avatar = avatar
        self.thumbnailAvatar = thumbnailAvatar
        self.moreInfo = moreInfo
    }
}

/// 群聊Model
public struct WYChatGroupModel {
    
    /// 群ID
    public var id: String = ""
    
    /// 用户在群内的昵称
    public var nickname: String = ""
    
    /// 群主信息
    public var ownerInfo: WYChatUaerModel = WYChatUaerModel()
    
    /// 群名称
    public var name: String = ""
    
    /// 群头像
    public var avatar: WYChatAssetsModel = WYChatAssetsModel()
    
    /// 群头像缩略图
    public var thumbnailAvatar: WYChatAssetsModel = WYChatAssetsModel()
    
    /// 群公告
    public var publicity: String = ""
    
    /// 用户给群设置的备注
    public var remarks: String = ""
    
    /// 群二维码
    public var qrCode: WYChatAssetsModel = WYChatAssetsModel()
    
    /// 群管理信息
    public var managers: [WYChatUaerModel] = []
    
    /// 群成员信息
    public var members: [WYChatUaerModel] = []
    
    public init(id: String = "", nickname: String = "", ownerInfo: WYChatUaerModel = WYChatUaerModel(), name: String = "", avatar: WYChatAssetsModel = WYChatAssetsModel(), thumbnailAvatar: WYChatAssetsModel = WYChatAssetsModel(), publicity: String = "", remarks: String = "", qrCode: WYChatAssetsModel = WYChatAssetsModel(), managers: [WYChatUaerModel] = [], members: [WYChatUaerModel] = []) {
        self.id = id
        self.nickname = nickname
        self.ownerInfo = ownerInfo
        self.name = name
        self.avatar = avatar
        self.thumbnailAvatar = thumbnailAvatar
        self.publicity = publicity
        self.remarks = remarks
        self.qrCode = qrCode
        self.managers = managers
        self.members = members
    }
}

public struct WYChatMessageModel {
    
    /**
     *  消息已读人数
     *  单聊时  0未读，1已读
     *  群聊时  若已读人数等于群人数则表示全部已读，否则为群内已读人数
     */
    public var readers: String = ""

    /// 已读回执发送状态
    public var readBackState: WYChatMessageSendState = .notSent

    /// 消息发送状态
    public var sendState: WYChatMessageSendState = .notSent

    /// 消息ID
    public var id: String = ""

    /// 消息发送时间
    public var timestamp: String = ""

    /// 消息发送者信息
    public var sendorInfo: WYChatUaerModel = WYChatUaerModel()

    /// 消息所属群信息(若为空为单聊，否则为群聊)
    public var groupInfo: WYChatGroupModel? = nil

    /// 消息内容
    public var content: WYChatMeesageContentModel = WYChatMeesageContentModel()
    
    /// 引用消息
    var reference: WYChatMeesageContentModel? = nil

    /// 聊天消息类型
    public var messageStyle: WYChatMessageStyle {

        let index: NSInteger = [nil, content.text, content.voice, content.photo, content.music, content.video, content.luckyMoney, content.transfer, content.location, content.takePat, content.withdrawn, content.call, content.webpage, content.file, content.businessCard, content.chatRecords].firstIndex(where: { $0 != nil }) ?? 0
        return messageStyles[index]
    }

    /// 引用消息类型
    public var referenceStyle: WYChatMessageStyle {
        let index: NSInteger = [nil, reference?.text, reference?.voice, reference?.photo, reference?.music, reference?.video, reference?.luckyMoney, reference?.transfer, reference?.location, reference?.takePat, reference?.withdrawn, reference?.call, reference?.webpage, reference?.file, reference?.businessCard, reference?.chatRecords].firstIndex(where: { $0 != nil }) ?? 0
        return messageStyles[index]
    }

    /**
     *  查看某人是否是该条消息的发送者
     *  userID 某人的ID
     */
    public func isSender(_ userID: String) ->Bool {
        return (sendorInfo.id == userID)
    }
}

private let messageStyles: [WYChatMessageStyle] = [.none, .text, .video, .photo, .music, .video, .luckyMoney, .transfer, .location, .takePat, .withdrawn, .call, .webpage, .file, .businessCard, .chatRecords]
