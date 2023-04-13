//
//  WYChatEmojiView.swift
//  WYBasisKit
//
//  Created by 官人 on 2023/4/3.
//  Copyright © 2023 官人. All rights reserved.
//

import UIKit

class WYEmojiView: UIView {
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView.wy_shared(scrollDirection: emojiViewScrollDirection,delegate: self, dataSource: self, superView: self)
        collectionView.wy_register("UICollectionViewCell", .cell)
        collectionView.isPagingEnabled = emojiViewIsPagingEnabled
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        return collectionView
    }()
    
    init() {
        super.init(frame: .zero)
        self.collectionView.backgroundColor = emojiViewBackgroundColor
        let resourcePath = (((Bundle(for: WYLocalizableClass.self).path(forResource: "Emoji", ofType: "plist")) ?? (Bundle.main.path(forResource: "Emoji", ofType: "plist"))) ?? "")
        
        emojiViewDataSource = try! NSDictionary(contentsOf: URL(string: "file://".appending(resourcePath))!, error: ()) as! [String : String]
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

extension WYEmojiView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emojiViewDataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
}

private class WYLocalizableClass {}
