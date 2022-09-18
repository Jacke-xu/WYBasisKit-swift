//
//  WYLeftController.swift
//  WYBasisKit
//
//  Created by Jacke·xu on 2020/12/3.
//  Copyright © 2020 Jacke·xu. All rights reserved.
//

import UIKit

class WYLeftController: UIViewController {
    
    let cellHeaders: [String] = [WYLocalizedString("暗夜/白昼模式", "Dark night/day mode"),
                                 WYLocalizedString("约束view添加动画", "Constrain the view to add animation"),
                                 WYLocalizedString("边框、圆角、阴影、渐变", "Borders, rounded corners, shadows, gradients"),
                                 "Banner",
                                 "RichText",
                                 "无限层折叠TableView", "测试tableView", "测试下载", "测试网络请求", "测试屏幕旋转", "测试二维码", "加载Gif图", "瀑布流", "直播、点播播放器"]

    let cellTitles: [[String]] = [[WYLocalizedString("暗夜/白昼模式", "Dark night/day mode")],
                                  [WYLocalizedString("约束view添加动画", "Constrain the view to add animation")],
                                  [WYLocalizedString("边框、圆角、阴影、渐变", "Borders, rounded corners, shadows, gradients")],
                                  ["Banner"],
                                  ["RichText"],
                                  ["无限层折叠TableView"],["测试tableView.plain模式", "测试tableView.grouped模式"], ["下载"], ["网络请求"], ["屏幕旋转"], ["二维码"], ["Gif"], ["瀑布流"], ["直播、点播播放器"]]

    let controller: [[String]] = [["WYTestDarkNightModeController"],
                                ["WYTestAnimationController"],
                                ["WYTestVisualController"],
                                ["WYTestBannerController"],
                                ["WYTestRichTextController"],
                                ["WYMultilevelTableViewController"],["WYTableViewPlainController", "WYTableViewGroupedController"], ["WYTestDownloadController"],["WYTestRequestController"],
                                  ["WYTestInterfaceOrientationController"], ["WYQRCodeController"], ["WYParseGifController"], ["WYFlowLayoutAlignmentController"], ["WYTestLiveStreamingController"]]

    lazy var tableView: UITableView = {

        let tableview = UITableView.wy_shared(style: .plain, separatorStyle: .singleLine, delegate: self, dataSource: self, superView: view)
        tableview.wy_register("UITableViewCell", .cell)
        tableview.wy_register("WYLeftControllerHeaderView", .headerFooterView)
        tableview.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-wy_tabBarHeight)
        }
        return tableview
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        navigationItem.title = WYLocalizedString("各种测试样例", "Various test examples")
        tableView.backgroundColor = UIColor.wy_dynamic(.white, .black)
        
        WYProtocolManager.shared.add(delegate: self)
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

extension WYLeftController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {

        return cellHeaders.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return cellTitles[section].count
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {

        return (section == (cellHeaders.count - 1)) ? UITableView.automaticDimension : 0.01
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let headerView: WYLeftControllerHeaderView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "WYLeftControllerHeaderView") as! WYLeftControllerHeaderView
        headerView.titleView.text = cellHeaders[section]

        return headerView
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {

        if section == (cellHeaders.count - 1) {

            if (tableView.footerView(forSection: section) == nil) {

                let contentView = UIView()

                let content = UILabel()
                content.text = WYLocalizedString("最后一个分区", "Last partition")
                content.textAlignment = .right
                contentView.addSubview(content)
                content.snp.makeConstraints { (make) in
                    make.edges.equalToSuperview()
                    make.height.equalTo(tableView.sectionFooterHeight)
                }
                return contentView
            }else {

                return tableView.footerView(forSection: section)
            }
        }else {

            return nil
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)

        cell.textLabel?.text = cellTitles[indexPath.section][indexPath.row]
        cell.textLabel?.textColor = UIColor.wy_dynamic(.black, .white)
        //cell.textLabel?.adjustsFontSizeToFitWidth = true
        cell.textLabel?.font = .wy_systemFont(ofSize: 15)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)
        let className: String = controller[indexPath.section][indexPath.row]
        wy_showViewController(className: className)
    }
}

extension WYLeftController: WYProtocoDelegate {
    
    func test() {
        wy_print("按钮开始向下移动")
    }
    
    func test2() {
        wy_print("按钮开始归位")
    }
}
