//
//  WYLeftController.swift
//  WYBasisKit
//
//  Created by jacke·xu on 2020/12/3.
//  Copyright © 2020 jacke-xu. All rights reserved.
//

import UIKit

class WYLeftController: UIViewController {
    
    let cellHeaders: [String] = [WYLocalizedString("暗夜/白昼模式", "Dark night/day mode"),
                                 WYLocalizedString("约束view添加动画", "Constrain the view to add animation"),
                                 WYLocalizedString("边框、圆角、阴影、渐变", "Borders, rounded corners, shadows, gradients"),
                                 "Banner"]
    
    let cellTitles: [[String]] = [[WYLocalizedString("暗夜/白昼模式", "Dark night/day mode")],
                                  [WYLocalizedString("约束view添加动画", "Constrain the view to add animation")],
                                  [WYLocalizedString("边框、圆角、阴影、渐变", "Borders, rounded corners, shadows, gradients")],
                                  ["Banner"]]
    
    let controller: [[String]] = [["WYTestDarkNightModeController"],
                                ["WYTestAnimationController"],
                                ["WYTestVisualController"],
                                ["WYTestBannerController"]]
    
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
        tableView.backgroundColor = UIColor.wy_dynamicColor(light: .white, dark: .black)
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
        cell.textLabel?.textColor = UIColor.wy_dynamicColor(light: .black, dark: .white)
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let className: String = controller[indexPath.section][indexPath.row]
        wy_showViewController(className: className)
    }
}
