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
        print(API_base)
        print(API_sms)
        
        let view = UIView.init(frame: CGRect(x: screenWidth/2-100, y: screenHeight/2-100, width: 200, height: 200));
        view.backgroundColor = UIColor.init(wy_hexColor: "C0C0C0");
        self.view.addSubview(view);
        let font = pxFont(fontSize: 20)
        print(font);
        
        print(view.backgroundColor?.wy_hexColor ?? "")
        
        let fonta = UIFont.systemFont(ofSize: 15)
        print("a = %@   6= %@",fonta,fonta.wy_adjustFont!)
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
