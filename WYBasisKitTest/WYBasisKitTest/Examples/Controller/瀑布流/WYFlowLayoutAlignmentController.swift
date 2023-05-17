//
//  WYFlowLayoutAlignmentController.swift
//  WYBasisKit
//
//  Created by 官人 on 2022/2/15.
//  Copyright © 2022 官人. All rights reserved.
//

import UIKit

class WYFlowLayoutAlignmentController: UIViewController {
    
    let isPagingEnabled: Bool = false
    
    let headerSource: [String] = ["宽高相等"]
    
    lazy var horizontal: UICollectionView = {

        let flowLayout: WYCollectionViewFlowLayout = WYCollectionViewFlowLayout()
        flowLayout.delegate = self
        flowLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView.wy_shared(flowLayout: flowLayout, delegate: self, dataSource: self, superView: view)
        collectionView.wy_register(["WidthAndHeightEqualCell", "CollectionReusableHeaderView", "CollectionReusableFooterView"], [.cell, .headerView, .footerView])
        collectionView.isPagingEnabled = isPagingEnabled
        collectionView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(wy_navViewHeight)
            make.height.equalTo(wy_screenWidth(235))
        }
        return collectionView
    }()

    lazy var vertical: UICollectionView = {
        let collectionView = UICollectionView.wy_shared(flowLayout: WYCollectionViewFlowLayout(delegate: self), delegate: self, dataSource: self, superView: view)
        collectionView.wy_register(["WidthAndHeightEqualCell", "CollectionReusableHeaderView", "CollectionReusableFooterView"], [.cell, .headerView, .footerView])
        collectionView.isPagingEnabled = isPagingEnabled
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

extension WYFlowLayoutAlignmentController: UICollectionViewDelegate, UICollectionViewDataSource, WYCollectionViewFlowLayoutDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 5
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 80
        return wy_randomInteger(minimux: 1, maximum: 129)
//        return 9
//        return 169
    }
    
    func wy_collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == vertical {
            if wy_collectionView(collectionView, layout: collectionViewLayout, flowLayoutAlignmentForSectionAt: indexPath.section) == .default {
                return CGSize(width: 35, height: wy_randomInteger(minimux: 35, maximum: 135))
            }else {
                
                let testString: String = wy_randomString(minimux: 1, maximum: 80)
                
                let testFont: UIFont = .systemFont(ofSize: 15)
                
                let lineSpacing: CGFloat = 5
                
                let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: testString)
                attributedString.wy_lineSpacing(lineSpacing: lineSpacing)
                attributedString.wy_fontsOfRanges(fontsOfRanges: [[testFont: testString]])
                
                let stringWidth: CGFloat = attributedString.wy_calculateWidth(controlHeight: testFont.lineHeight)
                
                let sectionInsets: UIEdgeInsets = wy_collectionView(collectionView, layout: collectionViewLayout, insetForSectionAt: indexPath.section)
                
                let maxWidth: CGFloat = collectionView.frame.size.width - sectionInsets.left - sectionInsets.right
                
                let testWidth: CGFloat = stringWidth > maxWidth ? maxWidth : stringWidth
                
                var testHeight: CGFloat = 35
                if stringWidth > maxWidth {
                    let layoutLine: CGFloat = CGFloat(wy_collectionView(collectionView, layout: collectionViewLayout, itemNumberOfLinesForSectionAt: indexPath.section))
                    let textLine: CGFloat = CGFloat(attributedString.wy_numberOfRows(controlWidth: maxWidth))
                    
                    if layoutLine == 0 {
                        testHeight = textLine * (testFont.lineHeight + lineSpacing) - lineSpacing
                    }else {
                        testHeight = [layoutLine, textLine].min()! * (testFont.lineHeight + lineSpacing) - lineSpacing
                    }
                    testHeight = attributedString.wy_calculateHeight(controlWidth: maxWidth)
                }
                return CGSize(width: testWidth, height: testHeight)
            }
            
        }else {
            return CGSize(width: wy_randomInteger(minimux: 35, maximum: 135), height: 35)
        }
    }
    
    func wy_collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, numberOfLinesIn section: Int) -> Int {
        return 3
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
    
    func wy_collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, itemNumberOfLinesForSectionAt section: NSInteger) -> NSInteger {
        return 3
    }
    
    func wy_collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        //return UIEdgeInsets(top: 15 + CGFloat((section * 5)), left: 15 + CGFloat((section * 5)), bottom: 15 + CGFloat((section * 5)), right: 15 + CGFloat((section * 5)))
    }
    
    func wy_collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, flowLayoutAlignmentForSectionAt section: Int) -> WYFlowLayoutAlignment {
        return .default
    }
    
    func wy_collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, horizontalScrollItemArrangementDirectionForSectionAt section: Int) -> Bool {
        return true
    }
    
    func wy_collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, hoverForHeaderForSectionAt section: NSInteger) -> Bool {
        return true
    }
    
    func wy_collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, spacingBetweenHeaderAndLastPartitionFooter section: NSInteger) -> CGFloat {
        return CGFloat(section) * 10
    }
    
    func wy_collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: NSInteger) -> CGSize {
        return CGSize(width: wy_screenWidth, height: 50)
    }
    
    func wy_collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: NSInteger) -> CGSize {
        return CGSize(width: wy_screenWidth, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: (kind == UICollectionView.elementKindSectionHeader) ? "CollectionReusableHeaderView" : "CollectionReusableFooterView", for: indexPath)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: WidthAndHeightEqualCell = collectionView.dequeueReusableCell(withReuseIdentifier: "WidthAndHeightEqualCell", for: indexPath) as! WidthAndHeightEqualCell
        
        cell.textView.text = "\(indexPath.item + 1)"

        return cell
    }
}

class WidthAndHeightEqualCell: UICollectionViewCell {
    
    let textView: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .wy_random
        
        textView.font = .systemFont(ofSize: 15)
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
