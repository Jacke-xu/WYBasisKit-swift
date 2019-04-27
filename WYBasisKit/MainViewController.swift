//
//  MainViewController.swift
//  WYBasisKit
//
//  Created by jacke-xu on 2019/3/14.
//  Copyright © 2019 jacke-xu. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        
        wy_print("网络请求的地址是：\(NetworkAPI.API_sms)")
        
        let font = UIFont.systemFont(ofSize: 15)
        wy_print("自适应的字号是：\(font.wy_adjustFont)")
        
        wy_print("当前语言：\(wy_currentLanguage)")
    }
    //渐进开发中，尽情期待

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
