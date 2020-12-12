//
//  WYTestAnimationController.swift
//  WYBasisKit
//
//  Created by jacke·xu on 2020/12/12.
//  Copyright © 2020 jacke·xu. All rights reserved.
//

import UIKit

class WYTestAnimationController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let button = UIButton(type: .custom)
        button.setTitle("让约束支持动画", for: .normal)
        button.titleLabel?.numberOfLines = 0
        button.wy_setBackgroundColor(.orange, forState: .normal)
        view.addSubview(button)
        button.addTarget(self, action: #selector(clickButton(sender:)), for: .touchUpInside)
        button.snp.makeConstraints { (make) in

            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(100)
            make.size.equalTo(CGSize(width: 100, height: 100))
        }
    }
    
    @objc func clickButton(sender: UIButton) {

        /// 约束控件实现动画的关键是在animate方法中调用父视图的layoutIfNeeded方法
        UIView.animate(withDuration: 2) {

            sender.snp.updateConstraints { (make) in

                make.top.equalToSuperview().offset(350)
            }
            sender.superview!.layoutIfNeeded()
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
