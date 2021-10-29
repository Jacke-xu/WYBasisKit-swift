//
//  WYTestBannerController.swift
//  WYBasisKit
//
//  Created by Jacke·xu on 2020/12/15.
//  Copyright © 2020 Jacke·xu. All rights reserved.
//

import UIKit

class WYTestBannerController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        
        let net_images = ["https://p.qqan.com/up/2021-7/16261459342701887.jpg",
                      "https://p.qqan.com/up/2021-7/16261459347670454.jpg",
                      "https://p.qqan.com/up/2021-7/16261459345506147.jpg",
                      "https://p.qqan.com/up/2021-7/16261459348844893.jpg",
                      "https://p.qqan.com/up/2021-7/16261459344331708.jpg",
                      "https://p.qqan.com/up/2021-7/16261459343183637.jpg",
                      "https://p.qqan.com/up/2021-7/16261459349940230.jpg",
                      "https://p.qqan.com/up/2021-7/16261459352807355.jpg",
                      "https://p.qqan.com/up/2021-7/16261459353902692.jpg"]

        let local_images = [UIImage.wy_named("banner_1"),
                            UIImage.wy_named("banner_2"),
                            UIImage.wy_named("banner_3"),
                            UIImage.wy_named("banner_4"),
                            UIImage.wy_named("banner_5"),
                            UIImage.wy_named("banner_6"),
                            UIImage.wy_named("banner_7"),
                            UIImage.wy_named("banner_8"),
                            UIImage.wy_named("banner_9")]

        let bannerView = WYBannerView()
        bannerView.bannerBackgroundColor = .purple
        bannerView.reload(images: local_images, describes: ["banner_0", "banner_1", "banner_2", "banner_3", "banner_4", "banner_5", "banner_6", "banner_7", "banner_8"])
        view.addSubview(bannerView)
        bannerView.snp.makeConstraints { make in
            make.left.centerY.right.equalToSuperview()
            make.height.equalTo(600)
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

extension WYTestBannerController: WYBannerViewDelegate {

    func didClick(_ bannerView: WYBannerView, _ index: NSInteger) {
        wy_print("index = \(index)")
    }

    func didScroll(_ bannerView: WYBannerView, _ offset: CGPoint, _ index: NSInteger) {
        wy_print("index = \(index), offset = \(offset)")
    }
}
