//
//  WYTestBannerController.swift
//  WYBasisKit
//
//  Created by jacke·xu on 2020/12/15.
//  Copyright © 2020 jacke·xu. All rights reserved.
//

import UIKit

class WYTestBannerController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        
        let bannerView = WYBannerView(placeholderImage: UIImage(named: "tabbar_left_selected"))
        bannerView.reload(images: ["https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1608033569135&di=4c2c49df88fd975de8a17d014e4645d9&imgtype=0&src=http%3A%2F%2Fattachments.gfan.com%2Fforum%2Fattachments2%2F201304%2F18%2F001339jv88x0qs06vo3qq6.jpg", "https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=3300550661,1121971374&fm=11&gp=0.jpg"], describes: ["图片1", "图片2"])
        view.addSubview(bannerView)
        bannerView.snp.makeConstraints { (make) in
            
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: wy_screenWidth, height: 300))
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
