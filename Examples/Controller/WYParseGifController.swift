//
//  WYParseGifController.swift
//  WYBasisKit
//
//  Created by jacke·xu on 2022/4/7.
//  Copyright © 2022 Jacke·xu. All rights reserved.
//

import UIKit

class WYParseGifController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        
        let topImageView = UIImageView()
        view.addSubview(topImageView)
        topImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(wy_navViewHeight + wy_screenWidth(20))
        }
        
        let centerImageView = UIImageView()
        view.addSubview(centerImageView)
        centerImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        let gifInfo1: WYGifInfo? = UIImage.wy_gifParse("动图1")
        let gifInfo2: WYGifInfo? = UIImage.wy_gifParse("动图2")
        
        if (gifInfo1 != nil) {
            topImageView.animationImages = gifInfo1!.animationImages
            topImageView.animationDuration = gifInfo1!.animationDuration
            topImageView.animationRepeatCount = 1
            topImageView.startAnimating()
            
            UIView.animate(withDuration: topImageView.animationDuration) {
            }completion: { _ in
                topImageView.image = topImageView.animationImages?.last
            }
        }
        
        if (gifInfo2 != nil) {
            centerImageView.animationImages = gifInfo2!.animationImages
            centerImageView.animationDuration = gifInfo2!.animationDuration
            // animationRepeatCount == 0 表示无限轮播
            centerImageView.animationRepeatCount = 0
            centerImageView.startAnimating()
        }
    }
    
    deinit {
        wy_print("release")
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
