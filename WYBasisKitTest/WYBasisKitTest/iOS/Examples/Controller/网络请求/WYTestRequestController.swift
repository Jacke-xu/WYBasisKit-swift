//
//  WYTestRequestController.swift
//  WYBasisKit
//
//  Created by 官人 on 2021/10/26.
//  Copyright © 2021 官人. All rights reserved.
//

import UIKit
import os_object

class WYTestRequestController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        
        let textView = UITextView()
        textView.frame = CGRect(x: 0, y: wy_navViewHeight, width: wy_screenWidth, height: wy_screenHeight - wy_navViewHeight)
        textView.isEditable = false
        textView.textColor = .black
        view.addSubview(textView)
        
//        let array: [String] = []
//        let append: String = "\"WYLocalizable_"
//        var textString = "/*\n  WYLocalizable.strings\n  WYBasisKit\n\n  Created by 官人 on 2020/11/21.\n  Copyright © 2020 官人. All rights reserved.\n*/\n\n"
//        for index in 0..<array.count {
//            textString = textString + ((index < 9) ? (append + "0" + "\(index+1)" + "\"" + " = " + "\"" + "\(array[index])" + "\";") : (append + "\(index + 1)" + "\""  + " = " + "\"" + "\(array[index])" + "\";")) + "\n\n"
//            textView.text = textString
//        }
        
        let cacheKey = "testCache"
        var config = WYNetworkConfig.default
        config.requestCache = WYNetworkRequestCache(cacheKey: cacheKey)
        config.debugModeLog = false
        config.domain = "https://www.fastmock.site/mock/a768f2ffec3131e5b3d361fe098da4b5/networkRequest/"
        //config.originObject = true
        config.mapper = [.data: "source"]
        

        let storageData: WYStorageData = WYStorage.takeOut(forKey: cacheKey, path: (config.requestCache?.cachePath.path) ?? "")

        let delay: TimeInterval = ((storageData.isInvalid == false) && (storageData.userData != nil)) ? 2 : 0

        WYActivity.showLoading("加载中", in: view, delay: delay)

        WYNetworkManager.request(method: .post, path: "outerArray", config: config) {[weak self] result in

            guard self != nil else {return}

            switch result {

            case .success(let success):

                wy_print((success.isCache ? "是" : "不是") + "缓存数据" + "\n" + "\((config.originObject ? success.origin : success.parse))")

                textView.text = (config.originObject ? success.origin : success.parse)

                if success.isCache == false {
                    WYActivity.dismissLoading(in: self!.view)
                }

                if success.storage != nil {
                    wy_print("缓存路径：\((success.storage?.path?.path) ?? "")")
                }
                break

            case .error(let error):
                wy_print("\(error)")
                WYActivity.dismissLoading(in: self!.view)
                WYActivity.showInfo(error.describe)
                break

            case .progress(_):
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
