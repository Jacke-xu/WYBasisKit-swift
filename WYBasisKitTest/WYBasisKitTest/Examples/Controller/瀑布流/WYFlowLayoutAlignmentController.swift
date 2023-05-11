//
//  WYFlowLayoutAlignmentController.swift
//  WYBasisKit
//
//  Created by 官人 on 2022/2/15.
//  Copyright © 2022 官人. All rights reserved.
//

import UIKit

class WYFlowLayoutAlignmentController: UIViewController {
    
    let headerSource: [String] = ["宽高相等"]
    
    let dataSource: [[String]] = [["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16"]]
    
    lazy var horizontal: UICollectionView = {

        let flowLayout: WYCollectionViewFlowLayout = WYCollectionViewFlowLayout()
        flowLayout.delegate = self
        flowLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView.wy_shared(flowLayout: flowLayout, delegate: self, dataSource: self, superView: view)
        collectionView.wy_register(["WidthAndHeightEqualCell"], [.cell])
        collectionView.isPagingEnabled = false
        collectionView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(wy_navViewHeight)
            make.height.equalTo(wy_screenWidth(235))
        }
        return collectionView
    }()

    lazy var vertical: UICollectionView = {
        let collectionView = UICollectionView.wy_shared(flowLayout: WYCollectionViewFlowLayout(delegate: self), delegate: self, dataSource: self, superView: view)
        collectionView.wy_register(["WidthAndHeightEqualCell"], [.cell])
        collectionView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(wy_navViewHeight + wy_screenWidth(235))
        }
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        horizontal.backgroundColor = .wy_random
        vertical.backgroundColor = .wy_random
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

extension WYFlowLayoutAlignmentController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, WYCollectionViewFlowLayoutDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 48
    }
    
    func wy_collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: wy_randomFloat(minimux: 35, maximum: wy_screenWidth * 5), height: 35)
    }
    
    func wy_collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, numberOfLinesIn section: Int) -> Int {
        return 5
    }
    
    func wy_collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, numberOfColumnsIn section: Int) -> Int {
        return 8
    }
    
    func wy_collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func wy_collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func wy_collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
    }
    
    func wy_collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, flowLayoutAlignmentForSectionAt section: Int) -> WYFlowLayoutAlignment {
        return .left
    }
    
    func wy_collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, flowLayoutStyleForSectionAt section: Int) -> WYWaterfallsFlowLayoutStyle {
        return .heightEqualWidthIsNotEqual
    }
    
    func wy_collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, horizontalScrollItemArrangementDirectionForSectionAt section: Int) -> Bool {
        return true
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: WidthAndHeightEqualCell = collectionView.dequeueReusableCell(withReuseIdentifier: "WidthAndHeightEqualCell", for: indexPath) as! WidthAndHeightEqualCell
        
        cell.textView.text = "\(indexPath.item)"

        return cell
    }
}

class WidthAndHeightEqualCell: UICollectionViewCell {
    
    let textView: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .wy_random
        
        textView.textColor = .white
        textView.textAlignment = .center
        contentView.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
