//
//  YYPopoverDefaultView.swift
//  MLDemo
//
//  Created by raoml on 2019/5/10.
//  Copyright © 2019 raoml. All rights reserved.
//

import UIKit

private let kMaxWidth: CGFloat = 200.0
private let kMaxShowRows: Int = 5
private let kDefaultRowHight: CGFloat = 44.0
private let kMargin: CGFloat = 16.0

typealias ClickRowCallback = (_ item: PDPopoverItem) -> Void

class YYPopoverDefaultView: UIView {

    // 数据源
    private var popoverItems: [PDPopoverItem]!
    // Cell行高
    private var rowHeight: CGFloat = kDefaultRowHight
    // Size上限
    private var contentSize: CGSize = CGSize(width: kMaxWidth, height: CGFloat(Float(kMaxShowRows)) * kDefaultRowHight)
    // 选中回调
    private var clickRowBlock: ClickRowCallback?
    
    private lazy var mTableView: UITableView = { [unowned self] in
        let aTableView = UITableView(frame: .zero, style: .plain)
        aTableView.backgroundColor = self.backgroundColor
        aTableView.dataSource = self
        aTableView.delegate = self
        aTableView.showsVerticalScrollIndicator = false
        aTableView.rowHeight = self.rowHeight
        aTableView.separatorColor = kPageColor
        aTableView.separatorInset = UIEdgeInsets(top: 0, left: kMargin, bottom: 0, right: kMargin)
        aTableView.tableFooterView = UIView()
        return aTableView
    }()
    
    init(popoverItems: [PDPopoverItem], maxWidth: CGFloat = kMaxWidth, maxShowRows: Int = kMaxShowRows, rowHight: CGFloat = kDefaultRowHight) {
        super.init(frame: .zero)
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = 8.0
        self.layer.masksToBounds = true
        
        self.popoverItems = popoverItems
        self.rowHeight = rowHight
        self.contentSize = CGSize(width: CGFloat(fmaxf(Float(maxWidth), Float(2*kMargin))), height: CGFloat(max(min(popoverItems.count, maxShowRows), 1)) * rowHeight)
        
        self.addSubview(self.mTableView)
        self.mTableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.size.equalTo(self.contentSize).priority(.high)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 设置选中回调
    public func configClickItemCallback(completion: ClickRowCallback?) {
        self.clickRowBlock = completion
    }
    
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension YYPopoverDefaultView: UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.popoverItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = PDPopoverDefaultCell.dequeueReusableCell(tableView: tableView)
        cell.configPopoverItem(self.popoverItems[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.clickRowBlock?(self.popoverItems[indexPath.row])
    }
    
}


private let kCellReuseIdentifier = "PDPopoverDefaultCellId"

class PDPopoverDefaultCell: UITableViewCell {
    
    private lazy var contentBtn: UIButton = {
        let aBtn = UIButton()
        aBtn.isUserInteractionEnabled = false
        aBtn.contentHorizontalAlignment = .left
        aBtn.contentEdgeInsets = UIEdgeInsets(top: 0, left: kMargin, bottom: 0, right: kMargin)
        aBtn.setTitleColor(UIColor.black, for: .normal)
        return aBtn
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(self.contentBtn)
        
        self.contentBtn.snp.makeConstraints { (make) in
            make.size.equalToSuperview()
            make.center.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func dequeueReusableCell(tableView: UITableView) -> PDPopoverDefaultCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: kCellReuseIdentifier) as? PDPopoverDefaultCell
        if cell == nil {
            cell = PDPopoverDefaultCell(style: .default, reuseIdentifier: kCellReuseIdentifier)
        }
        return cell!
    }
    
    public func configPopoverItem(_ item: PDPopoverItem) {
        self.contentBtn.setImage(item.image, for: .normal)
        self.contentBtn.setTitle(item.title, for: .normal)
    }
    
}


typealias PDItemClickCallback = () -> Void

struct PDPopoverItem {
    
    private(set) var image: UIImage?
    private(set) var title: String?
    private(set) var itemClickCallback: PDItemClickCallback?
    
    init(_ image: UIImage?, _ title: String?, completion: PDItemClickCallback?) {
        self.image = image
        self.title = title
        self.itemClickCallback = completion
    }
    
}
