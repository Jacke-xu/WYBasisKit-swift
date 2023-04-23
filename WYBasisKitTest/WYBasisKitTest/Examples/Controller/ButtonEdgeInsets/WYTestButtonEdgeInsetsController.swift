//
//  WYTestButtonEdgeInsetsController.swift
//  WYBasisKitTest
//
//  Created by Miraitowa on 2023/4/21.
//

import UIKit

class WYTestButtonEdgeInsetsController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .white

        let button: UIButton = UIButton(type: .custom)
        button.wy_nTitle = "自定义图片和文本控件位置"
        button.wy_nImage = UIImage.wy_find("tabbar_right_selected")
        button.wy_makeVisual { make in
            make.wy_cornerRadius(5)
            make.wy_borderWidth(1)
            make.wy_borderColor(.wy_random)
        }
        button.wy_title_nColor = .red
        view.addSubview(button)
        button.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo(200)
            make.centerY.equalToSuperview()
        }
        button.wy_updateInsets(position: .imageRightTitleLeft, spacing: 5)
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
