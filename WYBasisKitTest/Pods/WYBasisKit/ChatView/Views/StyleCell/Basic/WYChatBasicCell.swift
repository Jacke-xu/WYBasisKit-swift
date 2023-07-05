//
//  WYChatBasicCell.swift
//  WYBasisKit
//
//  Created by 官人 on 2023/6/14.
//

import UIKit
import Kingfisher

/// 通用聊天配置选项
public struct WYBasicChatConfig {
    
    /// 默认头像(placeholder)
    public var defaultAvatar: UIImage = UIImage.wy_createImage(from: .wy_random)

    /// 头像contentMode
    public var avatarContentMode: UIView.ContentMode = .scaleAspectFit
    
    /// 头像距离cell的偏移量
    public var avatarOffset: (sendor: CGPoint, receive: CGPoint) = (
        
        sendor: CGPoint(x: -wy_screenWidth(15), y: wy_screenWidth(35)),
        
        receive: CGPoint(x: wy_screenWidth(15), y: wy_screenWidth(35)))

    /// 头像size
    public var avatarSize: CGSize = CGSize(width: wy_screenWidth(50), height: wy_screenWidth(50))

    /// 头像圆角半径
    public var avatarCornerRadius: CGFloat = wy_screenWidth(5)
    
    /// 单聊时是否显示昵称
    public var showNicknameForSingle: (sendor: Bool, receive: Bool) = (sendor: false, receive: false)
    
    /// 群聊时是否显示昵称
    public var showNicknameForGroup: (sendor: Bool, receive: Bool) = (sendor: false, receive: true)
    
    /// 单聊时昵称距离头像控件的偏移量
    public var nameViewOffsetForSingle: (sendor: CGPoint, receive: CGPoint) = (
        
        sendor: CGPoint(x: -wy_screenWidth(20), y: -(UIFont.systemFont(ofSize: wy_screenWidth(13))).lineHeight),
        
        receive: CGPoint(x: wy_screenWidth(20), y: -(UIFont.systemFont(ofSize: wy_screenWidth(13))).lineHeight))
    
    /// 群聊时昵称距离头像控件的偏移量
    public var nameViewOffsetForGroup: (sendor: CGPoint, receive: CGPoint) = (
        
        sendor: CGPoint(x: -wy_screenWidth(20), y: -(UIFont.systemFont(ofSize: wy_screenWidth(13))).lineHeight),
        
        receive: CGPoint(x: wy_screenWidth(20), y: -wy_screenWidth(5)))

    /// 昵称字体、字号
    public var nicknameFont: UIFont = .systemFont(ofSize: wy_screenWidth(13))

    /// 昵称字体颜色
    public var nicknameColor: UIColor = .black
    
    /// 时间距离cell的偏移量(x为0时表示居中对齐)
    public var timeViewOffset: CGPoint = .zero

    /// 时间字体、字号
    public var timeFont: UIFont = .systemFont(ofSize: wy_screenWidth(13))

    /// 时间字体颜色
    public var timeColor: UIColor = .black
    
    /// 时间是否显示 上午/下午 标识
    public var showAmPmSymbol: Bool = false
    
    public init() {}
}

public class WYChatBasicCell: UITableViewCell {
    
    /// 当前登录用户的用户ID
    public var userID: String = ""
    
    /// 消息model
    public var message: WYChatMessageModel = WYChatMessageModel()
    
    /// 布局配置
    private var config: WYBasicChatConfig = WYBasicChatConfig()
    
    /// 头像控件
    public lazy var avatarView: UIImageView = {
        let avatarView: UIImageView = UIImageView()
        contentView.addSubview(avatarView)
        return avatarView
    }()
    
    /// 昵称控件
    public lazy var nicknameView: UILabel = {
        let nicknameView: UILabel = UILabel()
        contentView.addSubview(nicknameView)
        return nicknameView
    }()
    
    /// 时间控件
    public lazy var timeView: UILabel = {
        let timeView: UILabel = UILabel()
        contentView.addSubview(timeView)
        return timeView
    }()
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
    }
    
    /// 数据(页面)刷新
    public func updateContent(config: WYBasicChatConfig) {
        
        self.config = config
        
        avatarView.wy_clearVisual()
        avatarView.contentMode = config.avatarContentMode
        loadImage(avatarView)
        
        nicknameView.font = config.nicknameFont
        nicknameView.text = message.sendor.name
        if message.group == nil {
            if message.isSender(userID) {
                nicknameView.textColor = config.showNicknameForSingle.sendor ? config.nicknameColor : .clear
            }else {
                nicknameView.textColor = config.showNicknameForSingle.receive ? config.nicknameColor : .clear
            }
            
        }else {
            if message.isSender(userID) {
                nicknameView.textColor = config.showNicknameForGroup.sendor ? config.nicknameColor : .clear
            }else {
                nicknameView.textColor = config.showNicknameForGroup.receive ? config.nicknameColor : .clear
            }
        }
        
        timeView.text = message.timeFormat ?? sharedTimeText(message.timestamp, message.clientTimestamp ?? String.wy_sharedDeviceTimestamp(), message.lastMessageTimestamp)
        timeView.font = config.timeFont
        timeView.textColor = config.timeColor
        
        updateConstraints()
        
        avatarView.wy_cornerRadius(config.avatarCornerRadius).wy_showVisual()
    }
    
    public override func updateConstraints() {
        super.updateConstraints()
        
        avatarView.snp.updateConstraints { make in
            if message.isSender(userID) {
                make.top.equalToSuperview().offset(config.avatarOffset.sendor.y)
                make.right.equalToSuperview().offset(config.avatarOffset.sendor.x)
            }else {
                make.top.equalToSuperview().offset(config.avatarOffset.receive.y)
                make.left.equalToSuperview().offset(config.avatarOffset.receive.x)
            }
            make.size.equalTo(config.avatarSize)
        }
        
        nicknameView.snp.updateConstraints { make in
            if message.isSender(userID) {
                if message.group == nil {
                    make.right.equalTo(avatarView.snp.left).offset(config.nameViewOffsetForSingle.sendor.x)
                    make.top.equalTo(avatarView).offset(config.nameViewOffsetForSingle.sendor.y)
                }else {
                    make.right.equalTo(avatarView.snp.left).offset(config.nameViewOffsetForGroup.sendor.x)
                    make.top.equalTo(avatarView).offset(config.nameViewOffsetForSingle.sendor.y)
                }
            }else {
                if message.group == nil {
                    make.left.equalTo(avatarView.snp.right).offset(config.nameViewOffsetForSingle.receive.x)
                    make.top.equalTo(avatarView).offset(config.nameViewOffsetForSingle.receive.y)
                }else {
                    make.left.equalTo(avatarView.snp.right).offset(config.nameViewOffsetForGroup.receive.x)
                    make.top.equalTo(avatarView).offset(config.nameViewOffsetForGroup.receive.y)
                }
            }
        }
        
        timeView.snp.updateConstraints { make in
            if config.timeViewOffset.x == 0 {
                make.centerX.equalToSuperview()
            }else {
                if message.isSender(userID) {
                    make.right.equalToSuperview().offset(-config.timeViewOffset.x)
                }else {
                    make.left.equalToSuperview().offset(config.timeViewOffset.x)
                }
            }
            make.top.equalToSuperview().offset(config.timeViewOffset.y)
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

public extension WYChatBasicCell {
    
    public func loadImage(_ imageView: UIImageView) {
         
        let imageCache = try! ImageCache(name: message.sendor.name, cacheDirectoryURL: createDirectory(directory: .cachesDirectory, subDirectory: "WYBasisKit/WYChatView/\(message.sendor.name)"))
        
        let urlString: String = message.sendor.avatar.downloadPath
        
        avatarView.kf.setImage(with: URL(string: urlString), placeholder: config.defaultAvatar, options: [.targetCache(imageCache)]) { [weak self] result in
            
            guard let self = self else { return }
            
            switch result {
            case .success(let source):
                imageView.image = source.image
                message.sendor.avatar.localPath = imageCache.cachePath(forKey: urlString)
                message.sendor.avatar.id = urlString.wy_md5
                message.sendor.avatar.name = urlString.wy_md5
                break
            case .failure(let error):
                wy_print("\(error)")
                break
            }
        }
    }
    
    /// 创建一个指定目录/文件夹
    public func createDirectory(directory: FileManager.SearchPathDirectory, subDirectory: String) -> URL {
        
        let directoryURLs = FileManager.default.urls(for: directory,
                                                        in: .userDomainMask)
        
        let savePath = (directoryURLs.first ?? URL(fileURLWithPath: NSTemporaryDirectory())).appendingPathComponent(subDirectory)
        let isExists: Bool = FileManager.default.fileExists(atPath: savePath.path)
        
        if !isExists {
            guard let _ = try? FileManager.default.createDirectory(at: savePath, withIntermediateDirectories: true, attributes: nil) else {
                fatalError("创建 \(savePath) 路径失败")
            }
        }
        return savePath
    }
    
    /**
     *  依据message.timestamp显示格式化后的消息发送时间
     *  默认聊天消息时间显示说明
          1、当天的消息，以每5分钟为一个跨度显示时间，具体格式为：HH:mm，如 12:12
          2、昨天的消息，显示格式为：昨天 HH:mm，如 昨天 12:12
          3、消息超过2天、小于1周，显示星期+收发消息的时间，具体格式为：星期几 HH:mm，如    星期日 12:12
          4、消息大于1周且是今年的消息，显示格式为：MMdd HH:mm，如 12月12日 12:12
          5、消息时间不是今年的消息，显示格式为：yyyyMMdd HH:mm，如 2022年12月12日 12:12
     */
    public func sharedTimeText(_ messageTimestamp: String, _ clientTimestamp: String = String.wy_sharedDeviceTimestamp(), _ lastMessageTimestamp: String, _ locale: Locale = Locale(identifier: "zh_CN")) -> String {
        
        let showTime: Bool = ((NumberFormatter().number(from: messageTimestamp)?.doubleValue ?? 0) - (NumberFormatter().number(from: lastMessageTimestamp)?.doubleValue ?? 0) >= 300)
        
        guard showTime == true else {
            return ""
        }

        let timeDistance: WYTimeDistance = String.wy_timeIntervalCycle(messageTimestamp, clientTimestamp)
        
        switch timeDistance {
        case .today:
            return messageTimestamp.wy_timestampConvertDate(.HM, config.showAmPmSymbol)
            
        case .yesterday:
            return (WYLocalized("WYLocalizable_51", table: WYBasisKitConfig.kitLocalizableTable) + " " + messageTimestamp.wy_timestampConvertDate(.HM, config.showAmPmSymbol))
            
        case .yesterdayBefore, .withinWeek:
            
            let whatDay: [String] = [
                messageTimestamp.wy_timestampConvertDate(.YMDHM, config.showAmPmSymbol),
                WYLocalized("WYLocalizable_53", table: WYBasisKitConfig.kitLocalizableTable),
                WYLocalized("WYLocalizable_54", table: WYBasisKitConfig.kitLocalizableTable),
                WYLocalized("WYLocalizable_55", table: WYBasisKitConfig.kitLocalizableTable),
                WYLocalized("WYLocalizable_56", table: WYBasisKitConfig.kitLocalizableTable),
                WYLocalized("WYLocalizable_57", table: WYBasisKitConfig.kitLocalizableTable),
                WYLocalized("WYLocalizable_58", table: WYBasisKitConfig.kitLocalizableTable),
                WYLocalized("WYLocalizable_59", table: WYBasisKitConfig.kitLocalizableTable)]
            
            return whatDay[messageTimestamp.wy_whatDay.rawValue] + (messageTimestamp.wy_whatDay == .unknown ? "" : (" " + messageTimestamp.wy_timestampConvertDate(.HM, config.showAmPmSymbol)))
            
        case .withinSameMonth, .withinSameYear:
            
            let mm: String = WYLocalized("WYLocalizable_61", table: WYBasisKitConfig.kitLocalizableTable)
            let dd: String = WYLocalized("WYLocalizable_62", table: WYBasisKitConfig.kitLocalizableTable)
            
            return messageTimestamp.wy_timestampConvertDate(.custom(format: "MM\(mm)dd\(dd) HH:mm"), config.showAmPmSymbol)
            
        default:
            
            let yyyy: String = WYLocalized("WYLocalizable_60", table: WYBasisKitConfig.kitLocalizableTable)
            let mm: String = WYLocalized("WYLocalizable_61", table: WYBasisKitConfig.kitLocalizableTable)
            let dd: String = WYLocalized("WYLocalizable_62", table: WYBasisKitConfig.kitLocalizableTable)
            
            return messageTimestamp.wy_timestampConvertDate(.custom(format: "yyyy\(yyyy)MM\(mm)dd\(dd) HH:mm"), config.showAmPmSymbol)
        }
    }
}
