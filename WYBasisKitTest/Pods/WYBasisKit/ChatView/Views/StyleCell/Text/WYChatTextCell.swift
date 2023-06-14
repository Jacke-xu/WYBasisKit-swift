//
//  WYChatTextCell.swift
//  WYBasisKit
//
//  Created by Miraitowa on 2023/6/14.
//

import UIKit

/// cell配置选项
//public struct WYChatTextCellConfig: WYChatBasicCellConfig {
//
//}

class WYChatTextCell: WYChatBasicCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
