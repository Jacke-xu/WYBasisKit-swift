//
//  WYTestDownloadController.swift
//  WYBasisKit
//
//  Created by jacke·xu on 2021/10/3.
//  Copyright © 2021 Jacke·xu. All rights reserved.
//

import UIKit

class WYTestDownloadController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let memoryData = WYStorage.takeOutData(forKey: "AAAAA")
        var localImage: UIImage? = nil
        if memoryData.userData != nil {
            localImage = UIImage(data: memoryData.userData!)
        }else {
            wy_print("\(memoryData.error!)")
        }

        let localImageView = UIImageView()
        localImageView.backgroundColor = .orange
        localImageView.image = localImage
        self.view.addSubview(localImageView)
        localImageView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(wy_screenHeight / 2)
        }

        let downloadImageView = UIImageView()
        downloadImageView.backgroundColor = .orange
        self.view.addSubview(downloadImageView)
        downloadImageView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(wy_screenHeight / 2)
        }
        
        WYActivity.showLoading(in: self.view)
        WYNetworkManager.download(path: "https://www.apple.com.cn/v/iphone-13-pro/b/images/overview/camera/macro/macro_photography__dphcvz878gia_large_2x.jpg", assetName: "AAAAA") { result in
            
            switch result {
                
            case .progress(let progress):
                
                wy_print("\(progress.progress)")
                
                break
            case .success(let success):
                
                WYActivity.dismissLoading(in: self.view)
                
                let assetObj: WYDownloadModel? = WYDownloadModel.deserialize(from: success.origin)

                wy_print("assetObj = \(String(describing: assetObj))")

                let imagePath: String = assetObj?.assetPath ?? ""
                let image = UIImage(contentsOfFile: imagePath)
                downloadImageView.image = image

                let diskCachePath = assetObj?.diskPath ?? ""

                let asset: String = (assetObj?.assetName ?? "") + "." + (assetObj?.mimeType ?? "")

                let memoryData: WYStorageData = WYStorage.storageData(forKey: "AAAAA", data: image!.jpegData(compressionQuality: 1.0)!, durable: .minute(1))
                if memoryData.error == nil {

                    wy_print("缓存成功 = \(memoryData)")
                    localImageView.image = UIImage(data: memoryData.userData!)
                }else {
                    wy_print("缓存失败 = \(memoryData.error ?? "")")
                }

                WYNetworkManager.clearDiskCache(path: diskCachePath, asset: asset) { error in

                    if error != nil {
                        wy_print("error = \(error!)")
                    }else {
                        wy_print("移除成功")
                    }
                }
                
//                WYNetworkManager.clearDiskCache(path: WYNetworkConfig.default.downloadSavePath.path, asset: asset) { error in
//
//                    if error != nil {
//                        wy_print("error = \(error!)")
//                    }else {
//                        wy_print("下载缓存全部移除成功")
//                    }
//                }
                
                break
            case .error(let error):
                wy_print("\(error)")
                WYActivity.dismissLoading(in: self.view)
                break
            }
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
