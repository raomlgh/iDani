//
//  YYBaseTableViewController.swift
//  MLDemo
//
//  Created by raoml on 2019/4/23.
//  Copyright © 2019 raoml. All rights reserved.
//

import UIKit

class YYBaseTableViewController: YYBaseViewController {
    
    private(set) lazy var tableView: UITableView = { [unowned self] in
        let aTableView = UITableView(frame: self.view.bounds, style: self.tableViewStyle)
        aTableView.dataSource = self
        aTableView.delegate = self
        aTableView.backgroundColor = UIColor.clear
        aTableView.tableFooterView = UIView()
        return aTableView
    }()
    
    private var tableViewStyle: UITableView.Style!
    
    init(style: UITableView.Style = .plain) {
        super.init(nibName: nil, bundle: nil)
        self.tableViewStyle = style
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.tableView)
    }

}

extension YYBaseTableViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
}
