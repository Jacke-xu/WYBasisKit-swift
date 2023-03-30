//
//  WYTableViewGroupedController.swift
//  WYBasisKit
//
//  Created by 官人 on 2021/7/4.
//  Copyright © 2021 官人. All rights reserved.
//

import UIKit

class WYGroupedHeaderView: UITableViewHeaderFooterView {
    
    let bannerView = WYBannerView()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = .white
        
        bannerView.backgroundColor = .wy_random
        contentView.addSubview(bannerView)
        bannerView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 300, height: 600))
            make.edges.equalToSuperview()
        }
    }
    
    func reload(images: [String]) {
        bannerView.reload(images: images)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class WYTableViewGroupedController: UIViewController {
    
    lazy var tableView: UITableView = {

        let tableview = UITableView.wy_shared(style: .grouped, separatorStyle: .singleLine, delegate: self, dataSource: self, superView: view)
        tableview.wy_register("UITableViewCell", .cell)
        tableview.wy_register("WYGroupedHeaderView", .headerFooterView)
        tableview.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-wy_tabBarHeight)
        }
        return tableview
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.title = WYLocalizedString("测试tableview Grouped模式", "Test tableview Grouped mode")
        tableView.backgroundColor = UIColor.wy_dynamic(.white, .black)
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

extension WYTableViewGroupedController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let headerView: WYGroupedHeaderView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "WYGroupedHeaderView") as! WYGroupedHeaderView
        headerView.reload(images: ["https://p.qqan.com/up/2021-7/16261459342701887.jpg",
                                   "https://p.qqan.com/up/2021-7/16261459347670454.jpg",
                                   "https://p.qqan.com/up/2021-7/16261459345506147.jpg",
                                   "https://p.qqan.com/up/2021-7/16261459348844893.jpg",
                                   "https://p.qqan.com/up/2021-7/16261459344331708.jpg",
                                   "https://p.qqan.com/up/2021-7/16261459343183637.jpg",
                                   "https://p.qqan.com/up/2021-7/16261459349940230.jpg",
                                   "https://p.qqan.com/up/2021-7/16261459352807355.jpg",
                                   "https://p.qqan.com/up/2021-7/16261459353902692.jpg"])

        return headerView
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        cell.textLabel?.text = "\(indexPath.row)"
        cell.textLabel?.textColor = UIColor.wy_dynamic(.black, .white)
        cell.textLabel?.font = .systemFont(ofSize: wy_fontSize(15, WYBasisKitConfig.defaultScreenPixels))

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
