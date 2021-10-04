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
        
        let imageView = UIImageView()
        imageView.backgroundColor = .orange
        self.view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        WYNetworkManager.download(path: "https://t7.baidu.com/it/u=2478304529,1778129966&fm=193&f=GIF", assetName: "AAAAA", config: .default) { progress in
            wy_print("\(progress)")
        } success: { response in
            
            let assetObj: [String: String] = response as? [String: String] ?? [:]
            
            wy_print("\ndirectoryPath = \(assetObj["directoryPath"] ?? "")\ndiskCache = \(assetObj["diskCache"] ?? "")\nassetPath = \(assetObj["assetPath"] ?? ""), \nmimeType = \(assetObj["mimeType"] ?? ""), \nassetName = \(assetObj["assetName"] ?? "")")
            
            let imagePath: String = assetObj["assetPath"] ?? ""
            let image = UIImage(contentsOfFile: imagePath)
            imageView.image = image
            
            let diskCachePath = assetObj["diskCache"] ?? ""
            
            let asset: String = (assetObj["assetName"] ?? "") + "." + (assetObj["mimeType"] ?? "")

            WYNetworkManager.clearDiskCache(path: diskCachePath, asset: asset) { error in

                if error != nil {
                    wy_print("error = \(error!)")
                }else {
                    wy_print("移除成功")
                }
            }
            
        } failure: { error in
            wy_print("\(error)")
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
