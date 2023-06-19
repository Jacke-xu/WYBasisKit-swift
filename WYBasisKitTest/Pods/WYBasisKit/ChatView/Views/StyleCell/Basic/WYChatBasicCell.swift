//
//  WYChatBasicCell.swift
//  WYBasisKit
//
//  Created by Miraitowa on 2023/6/14.
//

import UIKit

/// 通用聊天配置选项
public struct WYBasicChatConfig {
    
    /// 是否显示昵称
    public var showNickname: Bool = false

    /// 默认头像
    public var defaultAvatar: UIImage = UIImage.wy_createImage(from: .wy_random)

    /// 头像contentMode
    public var avatarContentMode: UIView.ContentMode = .scaleAspectFit

    /// 头像size
    public var avatarSize: CGSize = CGSize(width: wy_screenWidth(50), height: wy_screenWidth(50))

    /// 头像圆角半径
    public var avatarCornerRadius: CGFloat = wy_screenWidth(50) / 2

    /// 昵称字体、字号
    public var nicknameFont: UIFont = .systemFont(ofSize: wy_screenWidth(13))

    /// 昵称字体颜色
    public var nicknameColor: UIColor = .black

    /// 昵称过长时截断方式
    public var nicknameBreakMode: NSLineBreakMode = .byTruncatingTail

    /// 时间字体、字号
    public var timeFont: UIFont = .systemFont(ofSize: wy_screenWidth(13))

    /// 时间字体颜色
    public var timeColor: UIColor = .wy_hex("#ECECEC")

    /// 时间过长时截断方式
    public var timeBreakMode: NSLineBreakMode = .byTruncatingTail

    /// 时间对齐方式
    public var timeAlignment: NSTextAlignment = .center
    
    public init() {}
}

class WYChatBasicCell: UITableViewCell {
    
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
    
    override func updateConstraints() {
        super.updateConstraints()
        
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
