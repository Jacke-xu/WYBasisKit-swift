//
//  WYRightController.swift
//  WYBasisKit
//
//  Created by jacke·xu on 2020/12/3.
//  Copyright © 2020 jacke-xu. All rights reserved.
//

import UIKit

class WYRightController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        var controllerAry: [UIViewController] = []
        var titleAry: [String] = []
        var simageAry: [UIImage] = []
        var dimageAry: [UIImage] = []
        
        for index in 0..<20 {
            
            let controller = UIViewController()
            controller.view.backgroundColor = .wy_randomColor
            controllerAry.append(controller)
            
            simageAry.append(UIImage(named: "tabbar_right_selected")!)
            dimageAry.append(UIImage(named: "tabbar_right_default")!)
            
            titleAry.append("测试" + "\(index)")
        }
        
        let pagingView = WYPagingView()
        view.addSubview(pagingView)
        pagingView.snp.makeConstraints { (make) in
            
            make.left.bottom.right.equalToSuperview()
            make.top.equalToSuperview().offset(wy_navViewHeight)
        }
        pagingView.delegate = self
        pagingView.bar_Height = 80
        //pagingView.bar_bg_defaultColor = .orange
        pagingView.layout(controllerAry: controllerAry, titleAry: titleAry, defaultImageAry: dimageAry, selectedImageAry: simageAry, superViewController: self)
        pagingView.itemDidScroll { (pagingIndex) in
            
            wy_print("pagingIndex = \(pagingIndex)")
        }
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

extension WYRightController: WYPagingViewDelegate {
    
    func itemDidScroll(_ pagingIndex: NSInteger) {
        
        //wy_print("pagingIndex = \(pagingIndex)")
    }
}
