//
//  YYMenuViewController.swift
//  MLDemo
//
//  Created by raoml on 2019/4/23.
//  Copyright © 2019 raoml. All rights reserved.
//

import UIKit

class YYMenuViewController: YYBaseTableViewController {

    private let cellTexts = ["导航栏", "Alert、ActionSheet", "Popver"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Menu"
        self.navigationItem.leftBarButtonItem = nil
    }
    
}

extension YYMenuViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cellTexts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellID = "cellId"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellID)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: cellID)
        }
        cell?.textLabel?.text = self.cellTexts[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
            self.navigationController?.pushViewController(YYCoustomBarMenuViewController(), animated: true)
        case 1:
            self.navigationController?.pushViewController(YYAlertViewController(style: .plain), animated: true)
        case 2:
            self.navigationController?.pushViewController(YYPopoverViewController(), animated: true)
        default:
            return
        }
    }
    
}
