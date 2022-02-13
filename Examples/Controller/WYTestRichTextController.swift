//
//  WYTestRichTextController.swift
//  WYBasisKit
//
//  Created by Jacke·xu on 2021/1/15.
//  Copyright © 2021 Jacke·xu. All rights reserved.
//

import UIKit

class WYTestRichTextController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .wy_random
        
        // Do any additional setup after loading the view.
        let label = UILabel()
        let str = "治性之道，必审己之所有余而强其所不足，盖聪明疏通者戒于太察，寡闻少见者戒于壅蔽，勇猛刚强者戒于太暴，仁爱温良者戒于无断，湛静安舒者戒于后时，广心浩大者戒于遗忘。必审己之所当戒而齐之以义，然后中和之化应，而巧伪之徒不敢比周而望进。"
        label.numberOfLines = 0
        let attribute = NSMutableAttributedString(string: str)
        
        attribute.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 20), range: NSMakeRange(0, str.count))
        attribute.wy_colorsOfRanges(colorsOfRanges: [[UIColor.blue: "勇猛刚强"], [UIColor.orange: "仁爱温良者戒于无断"], [UIColor.purple: "安舒"]])
        attribute.wy_lineSpacing(lineSpacing: 5, string: attribute.string)
        
        label.attributedText = attribute
        label.textAlignment = NSTextAlignment.center
        label.wy_clickEffectColor = .green
        label.wy_addRichText(strings: ["勇猛刚强", "仁爱温良者戒于无断", "安舒"]) { [weak self] (string, range, index) in
            //wy_print("string = \(string), range = \(range), index = \(index)")
            
            WYActivity.showInfo("string = \(string), range = \(range), index = \(index)", in: self?.view, position: .middle)
        }
        label.wy_addRichText(strings: ["勇猛刚强", "仁爱温良者戒于无断", "安舒"], delegate: self)
        view.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.left.right.centerY.equalToSuperview()
        }
        
        let marginLabel = UILabel()
        marginLabel.text = "测试内边距"
        marginLabel.font = .systemFont(ofSize: 18)
        marginLabel.backgroundColor = .green
        marginLabel.textColor = .orange
        
        let attrText = NSMutableAttributedString(string: marginLabel.text!)
        attrText.wy_innerMargin(firstLineHeadIndent: 10, tailIndent: -10)
        
        marginLabel.numberOfLines = 0
        marginLabel.attributedText = attrText
        view.addSubview(marginLabel)
        
        marginLabel.sizeToFit()
        marginLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalTo(marginLabel.wy_width + 10)
            make.bottom.equalToSuperview().offset(-150)
        }
        
        wy_print("每行显示的分别是 \(String(describing: label.attributedText?.wy_stringPerLine(controlWidth: wy_screenWidth))), 一共 \(String(describing: label.attributedText?.wy_numberOfRows(controlWidth: wy_screenWidth))) 行")
    }
    
    deinit {
        wy_print("deinit")
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

extension WYTestRichTextController: WYRichTextDelegate {
    
    func wy_didClick(richText: String, range: NSRange, index: NSInteger) {
        
        //wy_print("string = \(richText), range = \(range), index = \(index)")
        WYActivity.showInfo("string = \(richText), range = \(range), index = \(index)", in: self.view, position: .middle)
    }
}
