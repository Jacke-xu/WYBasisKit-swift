//
//  WYCenterController.swift
//  WYBasisKit
//
//  Created by Jacke·xu on 2020/12/3.
//  Copyright © 2020 Jacke·xu. All rights reserved.
//

import UIKit

class WYCenterController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let testView = UIView()
        testView.backgroundColor = .purple
        testView.frame = CGRect(x: 20, y: 200, width: wy_screenWidth-40, height: 300)
        view.addSubview(testView)
        
        let testView2 = UIView()
        testView2.backgroundColor = .green
        testView2.frame = CGRect(x: 10, y: 100, width: wy_screenWidth-60, height: 200)
        testView.addSubview(testView2)
        
        testView.layer.addSublayer(CALayer.drawDashLine(direction: .leftToRight, bounds: CGRect(x: wy_screenWidth(10, WYBasisKitConfig.defaultScreenPixels), y: 100, width: wy_screenWidth(315, WYBasisKitConfig.defaultScreenPixels), height: wy_screenWidth(2.5, WYBasisKitConfig.defaultScreenPixels)), color: .orange))
        
        testView.layer.addSublayer(CALayer.drawDashLine(direction: .topToBottom, bounds: CGRect(x: wy_screenWidth(10, WYBasisKitConfig.defaultScreenPixels), y: 100, width: wy_screenWidth(2.5, WYBasisKitConfig.defaultScreenPixels), height: wy_screenWidth(190, WYBasisKitConfig.defaultScreenPixels)), color: .black))
        
        view.layer.addSublayer(CALayer.drawDashLine(direction: .leftToRight, bounds: CGRect(x: 20, y: 200, width: wy_screenWidth-40, height: 2.5), color: .orange))
        
        view.layer.addSublayer(CALayer.drawDashLine(direction: .topToBottom, bounds: CGRect(x: 10, y: 100, width: 2.5, height: wy_screenWidth-60), color: .black))

        // Do any additional setup after loading the view.
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
