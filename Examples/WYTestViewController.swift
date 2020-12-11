//
//  WYTestViewController.swift
//  WYBasisKit
//
//  Created by jacke·xu on 2020/12/11.
//  Copyright © 2020 jacke·xu. All rights reserved.
//

import UIKit

class WYTestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        // Do any additional setup after loading the view.
        
        let testView = UIView(frame: CGRect(x: 50, y: 500, width: 100, height: 100))
        testView.backgroundColor = .purple
        view.addSubview(testView)
        testView.wy_borderWidth(5).wy_borderColor(.yellow).wy_rectCorner([.bottomLeft, .topRight]).wy_cornerRadius(10).wy_shadowRadius(20).wy_shadowColor(.green).wy_shadowOpacity(0.5).wy_showVisual()
        testView.wy_add(gradualColors: [.orange, .red], gradientDirection: .leftToRight)
        
        let testView2 = UIView()
        testView2.backgroundColor = .purple
        view.addSubview(testView2)
//        testView2.snp.makeConstraints { (make) in
//
//            make.left.equalToSuperview().offset(250)
//            make.top.equalToSuperview().offset(500)
//            make.size.equalTo(CGSize(width: 100, height: 100))
//        }
        testView2.wy_makeVisual { (current) in

            current.wy_borderWidth(5)
            current.wy_borderColor(.orange)
//            current.wy_rectCorner(.topRight)
//            current.wy_cornerRadius(20)
//            current.wy_shadowRadius(30)
//            current.wy_shadowColor(.green)
//            current.wy_shadowOffset(.zero)
//            current.wy_shadowOpacity(0.5)
            current.wy_gradualColors([.yellow, .purple])
            current.wy_gradientDirection(.leftToLowRight)
            current.wy_viewBounds(CGRect(x: 100, y: 100, width: 100, height: 100))
//            current.wy_bezierPath(UIBezierPath(ovalIn: CGRect(x: 250, y: 250, width: 100, height: 50)))
        }
    }
    
    deinit {
        
        wy_print("WYTestViewController release")
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
