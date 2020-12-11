//
//  WYLeftController.swift
//  WYBasisKit
//
//  Created by jacke·xu on 2020/12/3.
//  Copyright © 2020 jacke-xu. All rights reserved.
//

import UIKit

class WYLeftController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationItem.title = WYLocalizedString("知道了")
        
        let button = UIButton(type: .custom)
        button.backgroundColor = UIColor.wy_dynamicColor(light: .green, dark: .orange)
        button.titleLabel?.numberOfLines = 0
        button.setTitle("亮色/中文(中英文切换看导航栏)", for: .normal)
        view.addSubview(button)
        button.addTarget(self, action: #selector(clickButton(sender:)), for: .touchUpInside)
        button.snp.makeConstraints { (make) in

            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(100)
            make.size.equalTo(CGSize(width: 100, height: 100))
        }
        button.wy_add(rectCorner: [.topLeft, .bottomRight], cornerRadius: 10, borderColor: .orange, borderWidth: 5, shadowColor: .purple, shadowRadius: 20, shadowOpacity: 0.5, shadowOffset: .zero, gradualColors: [.orange, .red], gradientDirection: .topToBottom)

        
        let number = WYTestView.sequencing { (make) in
            
            make.add(num: 5)
            make.add(num: 2)
            make.subtract(num: 3)
        }
        wy_print("number = \(number)")
    }
    
    @objc func clickButton(sender: UIButton) {
        
        let testViewController = WYTestViewController()
        navigationController?.pushViewController(testViewController, animated: true)
        
        /// 约束控件实现动画的关键是在animate方法中调用父视图的layoutIfNeeded方法
        UIView.animate(withDuration: 2) {
            
            sender.snp.updateConstraints { (make) in
                
                make.top.equalToSuperview().offset(350)
            }
            sender.superview!.layoutIfNeeded()
            
        }completion: { (_) in
            
            WYLocalizableManager.shared.switchLanguage(language: .chinese) {

                if #available(iOS 13.0, *) {
                    UIApplication.shared.wy_switchAppDisplayBrightness(style: .light)
                }
            }
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
