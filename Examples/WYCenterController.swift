//
//  WYCenterController.swift
//  WYBasisKit
//
//  Created by jacke·xu on 2020/12/3.
//  Copyright © 2020 jacke-xu. All rights reserved.
//

import UIKit

class WYCenterController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationItem.title = WYLocalizedString("知道了")
        
        let button = UIButton(type: .custom)
        button.backgroundColor = UIColor.wy_dynamicColor(light: .green, dark: .orange)
        button.frame = CGRect(x: 100, y: 100, width: 200, height: 100)
        button.titleLabel?.numberOfLines = 0
        button.setTitle("暗夜/英文(中英文切换看导航栏)", for: .normal)
        view.addSubview(button)
        button.addTarget(self, action: #selector(clickButton), for: .touchUpInside)
    }
    
    @objc func clickButton() {
        
        WYLocalizableManager.shared.switchLanguage(language: .english) {
            
            if #available(iOS 13.0, *) {
                UIApplication.shared.wy_switchAppDisplayBrightness(style: .dark)
            }
            
            let rootController = ((AppDelegate.shared().window!.rootViewController) as! WYTabBarController)
            rootController.selectedIndex = 1
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
