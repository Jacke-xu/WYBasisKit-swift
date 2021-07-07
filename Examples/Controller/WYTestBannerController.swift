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
        
//        let bannerView = WYBannerView()
//        bannerView.unlimitedCarousel = false
//        bannerView.automaticCarousel = false
//        bannerView.reload(images: ["https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1608033569135&di=4c2c49df88fd975de8a17d014e4645d9&imgtype=0&src=http%3A%2F%2Fattachments.gfan.com%2Fforum%2Fattachments2%2F201304%2F18%2F001339jv88x0qs06vo3qq6.jpg", "https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=3300550661,1121971374&fm=11&gp=0.jpg", "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fa3.att.hudong.com%2F65%2F38%2F16300534049378135355388981738.jpg&refer=http%3A%2F%2Fa3.att.hudong.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1612157791&t=83cd181f4e38dc17ee30457edfd82f7f", "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fa4.att.hudong.com%2F27%2F67%2F01300000921826141299672233506.jpg&refer=http%3A%2F%2Fa4.att.hudong.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1612157791&t=e664dffafebf21d2e5e46b9b4bbe0a71", "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fa4.att.hudong.com%2F43%2F83%2F01300000241358124822839175242.jpg&refer=http%3A%2F%2Fa4.att.hudong.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1612157874&t=bc7d28e2415b2339c3d91cb33f7755a7"])
//        bannerView.delegate = self
//        view.addSubview(bannerView)
//        bannerView.snp.makeConstraints { (make) in
//
//            make.centerX.equalToSuperview()
//            make.top.equalToSuperview().offset(wy_navViewHeight)
//            make.size.equalTo(CGSize(width: wy_screenWidth, height: 220))
//        }
//        bannerView.backgroundColor = .wy_hex("f3f3f3")
//        bannerView.wy_add(rectCorner: .allCorners, cornerRadius: 10)

//        let fadeBanner = WYBannerView()
//        bannerView.unlimitedCarousel = false
//        bannerView.automaticCarousel = false
//        fadeBanner.switchModel = .fade
//        fadeBanner.reload(images: ["https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1608033569135&di=4c2c49df88fd975de8a17d014e4645d9&imgtype=0&src=http%3A%2F%2Fattachments.gfan.com%2Fforum%2Fattachments2%2F201304%2F18%2F001339jv88x0qs06vo3qq6.jpg", "https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=3300550661,1121971374&fm=11&gp=0.jpg", "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fa3.att.hudong.com%2F65%2F38%2F16300534049378135355388981738.jpg&refer=http%3A%2F%2Fa3.att.hudong.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1612157791&t=83cd181f4e38dc17ee30457edfd82f7f", "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fa4.att.hudong.com%2F27%2F67%2F01300000921826141299672233506.jpg&refer=http%3A%2F%2Fa4.att.hudong.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1612157791&t=e664dffafebf21d2e5e46b9b4bbe0a71", "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fa4.att.hudong.com%2F43%2F83%2F01300000241358124822839175242.jpg&refer=http%3A%2F%2Fa4.att.hudong.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1612157874&t=bc7d28e2415b2339c3d91cb33f7755a7"])
//        fadeBanner.delegate = self
//        view.addSubview(fadeBanner)
//        fadeBanner.snp.makeConstraints { (make) in
//
//            make.centerX.equalToSuperview()
//            make.top.equalTo(bannerView.snp.bottom).offset(20)
//            make.size.equalTo(CGSize(width: wy_screenWidth, height: 220))
//        }
//        fadeBanner.backgroundColor = .wy_hex("f3f3f3")
//        fadeBanner.wy_add(rectCorner: .allCorners, cornerRadius: 10)
//
//        let bannerView = WYBannerView()
//        bannerView.backgroundColor = .orange
//        bannerView.unlimitedCarousel = true
//        bannerView.autoCarousel = true
//        bannerView.delegate = self
//        view.addSubview(bannerView)
//        bannerView.snp.makeConstraints { make in
//            make.left.equalToSuperview().offset(wy_screenWidth(20))
//            make.right.equalToSuperview().offset(-wy_screenWidth(20))
//            make.height.equalTo(300)
//            make.center.equalToSuperview()
//        }
//        bannerView.didClick { index in
//            wy_print("index = \(index)")
//        }
//        bannerView.didScroll { offset, index in
//            wy_print("index = \(index), offset = \(offset)")
//        }
//        //bannerView.show()
//        bannerView.show(["https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1608033569135&di=4c2c49df88fd975de8a17d014e4645d9&imgtype=0&src=http%3A%2F%2Fattachments.gfan.com%2Fforum%2Fattachments2%2F201304%2F18%2F001339jv88x0qs06vo3qq6.jpg", "https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=3300550661,1121971374&fm=11&gp=0.jpg", "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fa3.att.hudong.com%2F65%2F38%2F16300534049378135355388981738.jpg&refer=http%3A%2F%2Fa3.att.hudong.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1612157791&t=83cd181f4e38dc17ee30457edfd82f7f", "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fa4.att.hudong.com%2F27%2F67%2F01300000921826141299672233506.jpg&refer=http%3A%2F%2Fa4.att.hudong.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1612157791&t=e664dffafebf21d2e5e46b9b4bbe0a71", "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fa4.att.hudong.com%2F43%2F83%2F01300000241358124822839175242.jpg&refer=http%3A%2F%2Fa4.att.hudong.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1612157874&t=bc7d28e2415b2339c3d91cb33f7755a7"], ["测试", "测试2", "测试3", "测试4", "测试5"])
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
