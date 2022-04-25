//
//  WYFlowLayoutAlignmentController.swift
//  WYBasisKit
//
//  Created by jacke·xu on 2022/2/15.
//  Copyright © 2022 Jacke·xu. All rights reserved.
//

import UIKit

class WYFlowLayoutAlignmentCell: UICollectionViewCell {
    
    let bgview = UIView()
    let titleView = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .clear
        
        bgview.backgroundColor = .wy_dynamic(.black, .white)
        contentView.addSubview(bgview)
        bgview.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        titleView.textColor = .orange
        titleView.font = .systemFont(ofSize: 15)
        titleView.numberOfLines = 0
        titleView.lineBreakMode = .byTruncatingTail
        bgview.addSubview(titleView)
        titleView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.centerY.equalToSuperview()
        }
    }
    
    func reload(text: String) {
        let attributedText = NSMutableAttributedString(string: text)
        attributedText.wy_lineSpacing(lineSpacing: 3, alignment: .left)
        titleView.attributedText = attributedText
    }
    
    class func sharedWidth(text: String) -> CGFloat {
        let textWidth = text.wy_calculateWidth(controlHeight: 30, controlFont: UIFont.systemFont(ofSize: 15), lineSpacing: 3, wordsSpacing: 0)
        
        if ((textWidth + 20) > maxWith()) {
            return maxWith()
        }
        return textWidth + 20
    }
    
    class func sharedHeight(text: String) -> CGFloat {
        let textWidth = text.wy_calculateWidth(controlHeight: 30, controlFont: UIFont.systemFont(ofSize: 15), lineSpacing: 3, wordsSpacing: 0)
        
        if ((textWidth + 20) > maxWith()) {
            let textHeight = text.wy_calculateHeight(controlWidth: maxWith(), controlFont: UIFont.systemFont(ofSize: 15), lineSpacing: 3, wordsSpacing: 0)
            return textHeight + (30 - UIFont.systemFont(ofSize: 15).lineHeight)
        }
        return 30
    }
    
    class func maxWith() ->CGFloat {
        return wy_screenWidth - 20;
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class WYFlowLayoutAlignmentController: UIViewController {
    
    let titles = ["1-关关", "2-关关雎鸠", "3-关关雎鸠，在河之洲。", "4-关关雎鸠", "5-关关雎鸠，在河", "6-悠哉", "7-钟鼓乐", "8-关关雎鸠，在河之洲。窈窕淑女，君子好逑。", "9-在河之洲。窈窕淑女，君子", "10-关关雎鸠，在河之洲。窈窕淑女，君子好逑。参差荇菜，左右流之。窈窕淑女，寤寐求之。求之不得，寤寐思服", "11-参差荇菜，左右采之。窈窕淑女，琴瑟友之。参差荇菜，左右芼之。窈窕淑女，钟鼓乐之", "12-窈窕淑女，君子", "13-窈窕淑女，君子好逑", "14-左右", "15-参差荇", "16-菜，左右采之。窈窕", "17-悠哉，辗转反侧。参", "18-君子好逑", "19-菜，左右流之。窈窕淑女，寤寐求之。求之不得，寤寐思服。悠哉悠哉，辗转反侧。参差荇菜，左右采之。窈窕淑女，琴瑟友之", "20-参差荇菜，左右流之", "21-关关雎鸠，在河之洲。窈窕淑女，君子好逑。参差荇菜，左右流之。窈窕淑女，寤寐求之。求之不得，寤寐思服。悠哉悠哉，辗转反侧。参差荇菜，左右采之。窈窕淑女，琴瑟友之。参差荇菜，左右芼之。窈窕淑女，钟鼓乐之。", "22-关关雎鸠，在河之洲。窈窕淑女，君子好逑。参差荇菜，左右流之。窈窕淑女，寤寐求之。求之不得，寤寐思服。悠哉悠哉，辗转反侧。参差荇菜", "23-关关雎鸠，在河之洲。窈窕淑女", "24-关关雎鸠，在河之洲。窈窕淑女，君子好逑。", "25-关关雎鸠，在河之洲。窈窕淑女，君子好逑。参差荇菜，左右流之。窈窕淑女，寤寐求之。求之不得，寤寐思服。悠哉悠哉，辗转反侧。参差荇菜，左右采之。窈窕淑女，琴瑟友之。参差荇菜，左右芼之。窈窕淑女，钟鼓乐之。"]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        
        let flowLayout = WYAlignmentFlowLayout(.left, delegate: self)
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = 10
        flowLayout.minimumInteritemSpacing = 10
        flowLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        let collctionView = UICollectionView.wy_shared(frame: CGRect(x: 0, y: wy_navViewHeight, width: wy_screenWidth, height: wy_screenWidth), flowLayout: flowLayout, delegate: self, dataSource: self, backgroundColor: .white, superView: view)
        collctionView.wy_register("WYFlowLayoutAlignmentCell", .cell)
        
        collctionView.reloadData()
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

extension WYFlowLayoutAlignmentController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, WYAlignmentFlowLayoutDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: WYFlowLayoutAlignmentCell = collectionView.dequeueReusableCell(withReuseIdentifier: "WYFlowLayoutAlignmentCell", for: indexPath) as! WYFlowLayoutAlignmentCell
        cell.reload(text: titles[indexPath.item])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = WYFlowLayoutAlignmentCell.sharedWidth(text: titles[indexPath.item])
        let textHeight = WYFlowLayoutAlignmentCell.sharedHeight(text: titles[indexPath.item])
        return CGSize(width: cellWidth, height: textHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.contentView.wy_clearVisual()
        cell.contentView.wy_add(cornerRadius: 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        wy_print("点击了：\(titles[indexPath.item])")
    }
}
