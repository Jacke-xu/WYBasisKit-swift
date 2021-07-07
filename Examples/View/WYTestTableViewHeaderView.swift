//
//  WYTestTableViewHeaderView.swift
//  WYBasisKit
//
//  Created by jacke·xu on 2021/7/4.
//  Copyright © 2021 Jacke·xu. All rights reserved.
//

import UIKit

class WYTestTableViewHeaderView: UITableViewHeaderFooterView {
    
    var titleView = UILabel()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .red
        
        titleView.frame = CGRect(x: 20, y: 0, width: wy_screenWidth - 20, height: 30)
        titleView.textColor = .white
        titleView.font = .wy_systemFont(ofSize: 14)
        contentView.addSubview(titleView)
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
