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
        
        wy_print("是否是模拟器：\(UIDevice.wy_simulatorSeries)")
        
        wy_print("是否是ipad：\(UIDevice.wy_iPadSeries)")
        
        wy_print("uudi：\(String(describing: UIDevice.wy_uuid))")
        
        wy_print("系统名称：\(UIDevice.wy_systemName)")
        
        wy_print("设备名称：\(UIDevice.wy_deviceName)")
        
        wy_print("设备版本：\(UIDevice.wy_deviceVersion)")
        
        wy_print("设备型号：\(UIDevice.wy_deviceModel)")
        
        wy_print("是否是版本号：\(UIDevice.wy_isVersion(version: 12.2))")
        
        wy_print("是否是iPhoneXr：\(UIDevice.wy_iPhone_⒍1inch)")
        
        let value : CGFloat = 100.1;
        wy_print("数据转换：\(value.wy_stringValue)")
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
