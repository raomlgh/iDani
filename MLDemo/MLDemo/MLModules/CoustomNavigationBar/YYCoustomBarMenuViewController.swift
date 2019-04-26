//
//  YYCoustomBarMenuViewController.swift
//  MLDemo
//
//  Created by raoml on 2019/4/26.
//  Copyright © 2019 raoml. All rights reserved.
//

import UIKit

class YYCoustomBarMenuViewController: YYBaseTableViewController {

    private var barTypes: [CoustomBarType] = [.noraml, .taoBao, .wangYiMusic]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "导航栏样式"
    }
    
}


extension YYCoustomBarMenuViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.barTypes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "cellId"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        }
        cell!.textLabel?.text = self.barTypes[indexPath.row].rawValue
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigationController?.pushViewController(YYCoustomBarViewController(barType: self.barTypes[indexPath.row]), animated: true)
    }
    
}
