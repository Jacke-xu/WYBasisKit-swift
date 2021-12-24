//
//  WYTestInterfaceOrientationController.swift
//  WYBasisKit
//
//  Created by Miraitowa on 2021/12/23.
//  Copyright © 2021 Jacke·xu. All rights reserved.
//

import UIKit
import CloudKit

class WYTestInterfaceOrientationController: UIViewController {
    
    let label = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        
        navigationItem.title = "设置屏幕旋转方向"
        
        /*
         *  实现屏幕旋转步骤
         *  1.在AppDelegate中创建 interfaceOrientation 属性，即：
         var interfaceOrientation: UIInterfaceOrientation = UIInterfaceOrientation.portrait {
             didSet{
                 UIDevice.current.setValue(AppDelegate.shared().interfaceOrientation.rawValue, forKey: "orientation")
                 UIViewController.attemptRotationToDeviceOrientation()
             }
         }
         
         *  2.在AppDelegate中重写屏幕旋转代理方法，即：
         switch interfaceOrientation {
         case .portrait:
             return .portrait
         case .portraitUpsideDown:
             return .portraitUpsideDown
         case .landscapeLeft:
             return .landscapeLeft
         case .landscapeRight:
             return .landscapeRight
         default:
             return .all
         }
         
         *  3.在需要做旋转的时候，动态设置AppDelegate中创建的 interfaceOrientation 属性
         
         *  4.在旋转结束时，恢复设置AppDelegate中创建的 interfaceOrientation 属性
         */
        
        label.textColor = .wy_dynamic(.black, .white)
        label.backgroundColor = .purple
        label.font = .systemFont(ofSize: 15)
        label.text = sharedInterfaceOrientationString()
        label.textAlignment = .center
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(layoutInterfaceOrientation))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(tap)
    }
    
    @objc func layoutInterfaceOrientation() {
        
        UIAlertController.wy_show(style: .alert, message: "设置屏幕方向", actions: ["竖向", "横向-左", "横向-右", "纵向-颠倒"]) {[weak self] actionStr, textFieldTexts in
            
            DispatchQueue.main.async {
                
                if actionStr != self?.label.text {
                    
                    switch actionStr {
                    case "竖向":
                        AppDelegate.shared().interfaceOrientation = .portrait

                    case "横向-左":
                        AppDelegate.shared().interfaceOrientation = .landscapeLeft

                    case "横向-右":
                        AppDelegate.shared().interfaceOrientation = .landscapeRight
                        
                    case "纵向-颠倒":
                        AppDelegate.shared().interfaceOrientation = .portraitUpsideDown
                        
                    default:
                        break
                    }
                    
                    self?.label.text = self?.sharedInterfaceOrientationString()
                }
            }
        }
    }
    
    func sharedInterfaceOrientationString() -> String {
        
        var string: String = ""
        switch AppDelegate.shared().interfaceOrientation {
        case .portrait:
            string = "竖向"
        case .landscapeLeft:
            string = "横向-左"
        case .landscapeRight:
            string = "横向-右"
        case .portraitUpsideDown:
            string = "纵向-颠倒"
        default:
            string = "未知"
        }
        return string
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AppDelegate.shared().interfaceOrientation = .portrait
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
