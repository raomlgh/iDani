//
//  YYAlertViewController.swift
//  YYAlertController
//
//  Created by raoml on 2019/4/22.
//  Copyright © 2019 raoml. All rights reserved.
//

import UIKit
import RxSwift

class YYAlertViewController: YYBaseTableViewController {
        
    private let titles = ["Alert", "ActionSheet", "Coustom"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "自定义弹窗"
    }

}

extension YYAlertViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.titles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellID = "cellId"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellID)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: cellID)
        }
        cell?.textLabel?.text = self.titles[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let alt = YYAlertController.yy_alertController(title: "这是标题", message: "哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈")
            alt.addAction(action: YYAlertAction(title: "取消", style: .cancel, handler: nil))
            alt.addAction(action: YYAlertAction(title: "确定", style: .destructive, handler: nil))
            alt.show()
            
        case 1:
            let item0 = YYActionSheetItem(title: "item0", textColor: UIColor.black, handler: nil)
            let item1 = YYActionSheetItem(title: "item1", textColor: UIColor.black, handler: nil)
            let item2 = YYActionSheetItem(title: "item2", textColor: UIColor.black, handler: nil)
            let item3 = YYActionSheetItem(title: "取消", textColor: UIColor.red, handler: nil)
            YYAlertController.yy_actionSheetController(title: "这是标题", message: "哈哈哈哈哈哈哈哈哈", actionSheetItems: [[item0, item1, item2], [item3]]).show()
            
        case 2:
            let aTextField = UITextField()
            aTextField.backgroundColor = kPageColor
            aTextField.placeholder = "输入内容"
            let aView = UIView()
            aView.backgroundColor = UIColor.white
            aView.addSubview(aTextField)
            aView.snp.makeConstraints { (make) in
                make.size.equalTo(CGSize(width: 300, height: 100))
            }
            aTextField.snp.makeConstraints { (make) in
                make.width.equalToSuperview()
                make.height.equalTo(44)
                make.center.equalToSuperview()
            }
            
            let alt = YYAlertController(coustomView: aView, responseKeyboard: true, preferredStyle: .alert)
            alt.addAction(action: YYAlertAction(title: "取消", style: .cancel, handler: nil))
            alt.addAction(action: YYAlertAction(title: "确定", style: .destructive, handler: nil))
            alt.addAction(action: YYAlertAction(title: "完成", style: .destructive, handler: { (_) in
                aTextField.resignFirstResponder()
            }))
            
            alt.show { (_) in
                aTextField.becomeFirstResponder()
            }
        default:
            return
        }
    }
    
}

