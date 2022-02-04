//
//  WYQRCodeController.swift
//  WYBasisKit
//
//  Created by Miraitowa on 2022/2/4.
//  Copyright © 2022 Jacke·xu. All rights reserved.
//

import UIKit

class WYQRCodeController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        view.backgroundColor = .white
        
        //let qrData = try! JSONSerialization.data(withJSONObject: ["url1": "www.baidu.com", "url2": "www.apple.com"], options: [JSONSerialization.WritingOptions.prettyPrinted])
        let qrData = "哈哈😄".data(using: .utf8)!
        
        let imageView = UIImageView(image: UIImage.wy_createQrCode(with: qrData, size: CGSize(width: 350, height: 350), waterImage: UIImage.wy_named("WYBasisKit_60*60")))
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        // 获取二维码信息
        guard let infoArr = recognitionQRCode(qrCodeImage: imageView.image!) else {return}
        wy_print("二维码信息 = \(infoArr)")
    }
    
    /* *  @param qrCodeImage 二维码的图片
       *  @return 结果的数组 */
    fileprivate func recognitionQRCode(qrCodeImage: UIImage) -> [String]? {
        
        //1. 创建过滤器
        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: nil)

        //2. 获取CIImage
        guard let ciImage = CIImage(image: qrCodeImage) else { return nil }

        //3. 识别二维码
        guard let features = detector?.features(in: ciImage) else { return nil }

        //4. 遍历数组, 获取信息
        var resultArr = [String]()
        for feature in features {
            
            //resultArr.append(feature.type)
            resultArr.append((feature as! CIQRCodeFeature).messageString ?? "")
        }
        
        return resultArr
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
