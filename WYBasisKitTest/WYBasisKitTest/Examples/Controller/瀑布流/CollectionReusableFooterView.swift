//
//  CollectionReusableFooterView.swift
//  WYBasisKitTest
//
//  Created by Miraitowa on 2023/5/16.
//

import UIKit

class CollectionReusableFooterView: UICollectionReusableView {
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
