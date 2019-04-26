//
//  YYActionSheetView.swift
//  ShoppingMall
//
//  Created by raoml on 2019/3/25.
//  Copyright © 2019 yyhj. All rights reserved.
//

import UIKit

private let kRowHeight: CGFloat = 50.0
private let kSectionHeight: CGFloat = 5.0
private let kFootViewReuseIdentifier = "kFootViewReuseIdentifierID"

class YYActionSheetView: UIView {

    private var actionSheetItems: [[YYActionSheetItem]]!
    private var handler: ((_ actionSheetItem: YYActionSheetItem) -> Void)?
    
    private lazy var titleLabel: UILabel = {
        let aLabel = UILabel()
        aLabel.font = UIFont.systemFont(ofSize: 18.0)
        aLabel.textColor = kBlackTextColor
        aLabel.numberOfLines = 0
        return aLabel
    }()
    
    private lazy var messageLabel: UILabel = {
        let aLabel = UILabel()
        aLabel.font = UIFont.systemFont(ofSize:14.0)
        aLabel.textColor = kLightGrayTextColor
        aLabel.numberOfLines = 0
        return aLabel
    }()
    
    private lazy var mTableView: UITableView = { [unowned self] in
        let aTableView = UITableView(frame: .zero, style: .plain)
        aTableView.dataSource = self
        aTableView.delegate = self
        aTableView.backgroundColor = kPageColor
        aTableView.separatorColor = kLineColor
        aTableView.separatorInset = UIEdgeInsets(top: 0, left: 15.0, bottom: 0, right: 15.0)
        aTableView.rowHeight = kRowHeight
        aTableView.bounces = false
        aTableView.tableFooterView = UIView()
        return aTableView
    }()
    
    private lazy var topStackView: UIStackView = { [unowned self] in
        let aStackView = UIStackView(arrangedSubviews: [self.titleLabel, self.messageLabel])
        aStackView.axis = .vertical
        aStackView.spacing = 5.0
        aStackView.alignment = .center
        return aStackView
    }()
    
    private lazy var mTopView: UIView = { [unowned self] in
        let aView = UIView()
        aView.backgroundColor = UIColor.white
        aView.addSubview(self.topStackView)
        aView.addSubview(self.topSeparateView)
        return aView
    }()
    
    private lazy var topSeparateView: UIView = {
        let aView = UIView()
        aView.backgroundColor = kLineColor
        return aView
    }()
    
    private lazy var mStackView: UIStackView = { [unowned self] in
        let aStackView = UIStackView(arrangedSubviews: [self.mTopView, self.mTableView])
        aStackView.axis = .vertical
        aStackView.alignment = .fill
        return aStackView
    }()
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(title: String?, message: String?, actionSheetItems: [[YYActionSheetItem]], handler: ((_ actionSheetItem: YYActionSheetItem) -> Void)?) {
        super.init(frame: .zero)
        self.backgroundColor = UIColor.white
        
        self.actionSheetItems = actionSheetItems
        self.handler = handler
        
        self.addSubview(self.mStackView)

        self.titleLabel.text = title
        self.messageLabel.text = message
        
        if title == nil {
            self.titleLabel.isHidden = true
            self.topStackView.removeArrangedSubview(self.titleLabel)
        }
        
        if message == nil {
            self.messageLabel.isHidden = true
            self.topStackView.removeArrangedSubview(self.messageLabel)
        }
        
        if title == nil && message == nil {
            self.mTopView.isHidden = true
            self.mStackView.removeArrangedSubview(self.mTopView)
        }
        
        self.topStackView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10.0).priority(.high)
            make.bottom.equalToSuperview().offset(-10.0)
            make.width.equalToSuperview().offset(-32.0)
            make.centerX.equalToSuperview()
        }
        
        self.topSeparateView.snp.makeConstraints { (make) in
            make.width.centerX.bottom.equalToSuperview()
            make.height.equalTo(1.0)
        }
        
        self.mTopView.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
        }
        
        
        self.mTableView.snp.makeConstraints { (make) in
            make.height.equalTo(self.fetchTableViewHeight()).priority(.low)
        }
        
        self.mStackView.snp.makeConstraints { (make) in
            make.width.equalTo(UIScreen.main.bounds.size.width)
            make.edges.equalToSuperview()
        }
        
    }
    
    func fetchTableViewHeight() -> CGFloat {
        
        if self.actionSheetItems.isEmpty {
            return 0
        }
        
        let sectionHeight = kSectionHeight*CGFloat((self.actionSheetItems.count - 1))
        
        var cellHeight: CGFloat = 0.0
        for items in self.actionSheetItems {
            cellHeight += kRowHeight*CGFloat(items.count)
        }
        
        return sectionHeight + cellHeight
    }
    
    func config(handler: ((_ actionSheetItem: YYActionSheetItem) -> Void)?) {
        self.handler = handler
    }
    
}

extension YYActionSheetView: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.actionSheetItems.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.actionSheetItems[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = YYActionSheetCell.dequeueReusableCell(tableView: tableView)
        cell.config(actionSheetItem: self.actionSheetItems[indexPath.section][indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let actionSheetItem = self.actionSheetItems[indexPath.section][indexPath.row]
        self.handler?(actionSheetItem)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == self.actionSheetItems.count - 1 {
            return 0.01
        }else {
            return kSectionHeight
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: kFootViewReuseIdentifier)
        if headerView == nil {
            headerView = UITableViewHeaderFooterView(reuseIdentifier: kFootViewReuseIdentifier)
            headerView?.contentView.backgroundColor = kPageColor
        }
        return headerView!
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        var footView = tableView.dequeueReusableHeaderFooterView(withIdentifier: kFootViewReuseIdentifier)
        if footView == nil {
            footView = UITableViewHeaderFooterView(reuseIdentifier: kFootViewReuseIdentifier)
            footView?.contentView.backgroundColor = kPageColor
        }
        return footView!
    }
    
}


struct YYActionSheetItem {
    
    var handler: (() -> Void)?
    
    var title: String
    var textColor: UIColor?
    
    init(title: String, textColor: UIColor? = kBlackTextColor , handler: (() -> Void)? = nil) {
        
        self.title = title
        self.textColor = textColor
        self.handler = handler
    }
    
}


private let kYYActionSheetCellID = "YYActionSheetCellID"
class YYActionSheetCell: UITableViewCell {
    
    private lazy var titleLabel: UILabel = {
        let aLabel = UILabel()
        aLabel.font = UIFont.systemFont(ofSize: 18.0)
        aLabel.textColor = kBlackTextColor
        return aLabel
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectedBackgroundView = {
            let aView = UIView()
            aView.backgroundColor = khighlightedColor
            return aView
        }()
        
        self.contentView.addSubview(self.titleLabel)
        
        self.titleLabel.snp.makeConstraints { (make) in
            make.width.lessThanOrEqualToSuperview().offset(32.0)
            make.height.lessThanOrEqualToSuperview()
            make.center.equalToSuperview()
        }
    }
    
    static func dequeueReusableCell(tableView: UITableView) -> YYActionSheetCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: kYYActionSheetCellID) as? YYActionSheetCell
        if cell == nil {
            cell = YYActionSheetCell(style: .default, reuseIdentifier: kYYActionSheetCellID)
        }
        return cell!
    }
    
    public func config(actionSheetItem: YYActionSheetItem) {
        self.titleLabel.text = actionSheetItem.title
        self.titleLabel.textColor = actionSheetItem.textColor
    }
    
}
