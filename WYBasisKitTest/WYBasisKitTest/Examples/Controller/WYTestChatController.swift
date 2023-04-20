//
//  WYTestChatController.swift
//  WYBasisKit
//
//  Created by Miraitowa on 2023/3/30.
//  Copyright © 2023 Jacke·xu. All rights reserved.
//

import UIKit

class WYTestChatController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        
        let resourcePath = (((Bundle(for: WYTestChatController.self).path(forResource: "Emoji", ofType: "plist")) ?? (Bundle.main.path(forResource: "Emoji", ofType: "plist"))) ?? "")
        
        inputBarConfig.textButtomImage = UIImage(named: "text")!
        inputBarConfig.voiceButtonImage = UIImage(named: "voice")!
        inputBarConfig.emojiButtomImage = UIImage(named: "xiaolian")!
        inputBarConfig.moreButtomImage = UIImage(named: "jia")!
        inputBarConfig.emojiPattern = "\\[.{1,3}\\]"
        
        emojiViewConfig.emojiSource = try! NSArray(contentsOf: URL(string: "file://".appending(resourcePath))!, error: ()) as! [String]
        
        let chatView = WYChatView()
        view.addSubview(chatView)
        chatView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
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
