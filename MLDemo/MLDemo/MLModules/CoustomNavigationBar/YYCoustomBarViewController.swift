//
//  YYCoustomBarViewController.swift
//  MLDemo
//
//  Created by raoml on 2019/4/26.
//  Copyright © 2019 raoml. All rights reserved.
//

import UIKit

enum CoustomBarType: String {
    case noraml = "常规样式"
    case wangYiMusic = "网易云音乐个人主页"
    case taoBao = "淘宝首页"
}

class YYCoustomBarViewController: YYBaseTableViewController {

    private var barType: CoustomBarType = .wangYiMusic
    
    init(barType: CoustomBarType) {
        super.init(style: .plain)
        self.title = barType.rawValue
        self.barType = barType
    }        
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var headerBarHeight: CGFloat = self.yy_navigationBarHeight()
        
        switch self.barType {
        case .wangYiMusic:
            headerBarHeight = 280.0
            self.statusBarStyle = .lightContent
            self.yy_barCoustomView.setNavigationBar(color: UIColor.clear, image: nil)
            self.yy_barCoustomView.setNavigationBarBackgroundImage(UIImage.yy_imageFromBundle("pic_bg_ikun", "jpg"), imageUrl: nil)
            
            self.yy_barCoustomView.setContentElementView(ACHeaderView()) { (make) in
                make.top.equalToSuperview().offset(self.yy_navigationBarHeight())
                make.bottom.width.centerX.equalToSuperview()
            }
            self.yy_barCoustomView.setNavigationBarBounceAndAlpha(bindScrollView: self.tableView, bounceEnable: true, changeAlphaEnable: true, beginOffset: 0, progressHeight: 0) { [unowned self] (alpha, barHeight) in
                self.yy_barCoustomView.setSeparateLineViewHidden(barHeight > self.yy_navigationBarHeight())
            }
        case .taoBao:
            self.yy_barCoustomView.setNavigationBar(color: UIColor.clear, image: nil)
            self.yy_barCoustomView.setNavigationBarBackgroundImage(UIImage.yy_imageFromBundle("pic_bg_duice", "jpg"), imageUrl: URL(string: "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1557140528010&di=7bf07c0aaa7920ee57861a5434264061&imgtype=0&src=http%3A%2F%2Fyf.southcn.com%2Fcontent%2Fimages%2Fattachement%2Fjpg%2Fsite4%2F20151109%2F00266c69629817aa9bb83e.jpg"))
            let backgroundView: YYHitFilterView = {
                let aView = YYHitFilterView()
                aView.backgroundColor = UIColor.orange
                return aView
            }()
            self.yy_barCoustomView.setContentElementView(backgroundView) { (make) in
                make.edges.equalToSuperview()
            }
            self.yy_barCoustomView.setNavigationBarBounceAndAlpha(bindScrollView: self.tableView, bounceEnable: true, changeAlphaEnable: true, beginOffset: -self.yy_navigationBarHeight(), progressHeight: 60.0) { [unowned self] (alpha, barHeight) in
                backgroundView.alpha = alpha
                self.statusBarStyle = alpha > 0.5 ? .lightContent : .default
                self.yy_barCoustomView.setSeparateLineViewHidden(barHeight > self.yy_navigationBarHeight())
            }
        default:
            self.yy_barCoustomView.setNavigationBar(color: UIColor.orange, image: nil)
            self.yy_barCoustomView.setNavigationBarBounceAndAlpha(bindScrollView: self.tableView, bounceEnable: true, changeAlphaEnable: true, beginOffset: self.yy_navigationBarHeight(), progressHeight: 100.0) { [unowned self] (alpha, barHeight) in
                self.statusBarStyle = alpha > 0.5 ? .lightContent : .default
                self.yy_barCoustomView.setSeparateLineViewHidden(barHeight > self.yy_navigationBarHeight())
            }
        }
        
        self.yy_barCoustomView.setBarHeight(headerBarHeight, nil)
        
        if headerBarHeight - self.yy_navigationBarHeight() > 0 {
            self.tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.size.width, height: headerBarHeight - self.yy_navigationBarHeight()))
        }
    }

}

extension YYCoustomBarViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "cellId"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        }
        cell!.textLabel?.text = String(format: "cell: %p", cell!)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerIdentifier = "headerIdentifier"
        var headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerIdentifier)
        if headerView == nil {
            headerView = UITableViewHeaderFooterView(reuseIdentifier: headerIdentifier)
            headerView?.contentView.backgroundColor = UIColor.white
            headerView?.addSubview({
                let aLabel = UILabel(frame: CGRect(x: 16.0, y: 0, width: 100.0, height: 35.0))
                aLabel.text = "这是分区头"
                return aLabel
            }())
        }
        return headerView
    }
    
}


class ACHeaderView: YYHitFilterView {
    
    private lazy var mContentView: YYHitFilterView = { [unowned self] in
        let aView = YYHitFilterView()
        aView.backgroundColor = YYHexColor("000000", 0.3)
        aView.addSubview(self.avatarBtn)
        aView.addSubview(self.nameLabel)
        aView.addSubview(self.aBtn)
        aView.addSubview(self.bBtn)
        return aView
    }()
    
    private var avatarBtn: UIButton = {
        let aBtn = UIButton()
        aBtn.addTarget(self, action: #selector(didClickOnAview(send:)), for: .touchUpInside)
        aBtn.setImage(UIImage.yy_imageFromBundle("pic_ava_lm"), for: .normal)
        return aBtn
    }()
    
    private var nameLabel: UILabel = {
        let aLabel = UILabel()
        aLabel.textColor = UIColor.white
        aLabel.text = "小猫咪~~"
        return aLabel
    }()
    
    private var aBtn: UIButton = {
        let aBtn = UIButton()
        aBtn.layer.cornerRadius = 15.0
        aBtn.layer.masksToBounds = true
        aBtn.layer.borderWidth = 1.0
        aBtn.layer.borderColor = UIColor.white.cgColor
        aBtn.contentEdgeInsets = UIEdgeInsets(top: 0, left: 20.0, bottom: 0, right: 20.0)
        aBtn.setTitle("按钮A", for: .normal)
        aBtn.setTitleColor(UIColor.lightGray, for: .highlighted)
        aBtn.addTarget(self, action: #selector(didClickOnAview(send:)), for: .touchUpInside)
        return aBtn
    }()
    
    private var bBtn: UIButton = {
        let aBtn = UIButton()
        aBtn.layer.cornerRadius = 15.0
        aBtn.layer.masksToBounds = true
        aBtn.layer.borderWidth = 1.0
        aBtn.layer.borderColor = UIColor.white.cgColor
        aBtn.contentEdgeInsets = UIEdgeInsets(top: 0, left: 20.0, bottom: 0, right: 20.0)
        aBtn.setTitle("按钮B", for: .normal)
        aBtn.setTitleColor(UIColor.lightGray, for: .highlighted)
        aBtn.addTarget(self, action: #selector(didClickOnAview(send:)), for: .touchUpInside)
        return aBtn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.clipsToBounds = true
        
        self.addSubview(self.mContentView)
        self.setupSubviewsConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupSubviewsConstraints() {
        self.mContentView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview().offset(-20.0)
        }
        
        self.avatarBtn.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10.0)
            make.left.greaterThanOrEqualToSuperview()
            make.right.lessThanOrEqualToSuperview()
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 60.0, height: 60.0))
        }
        
        self.nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.avatarBtn.snp.bottom).offset(10.0)
            make.left.greaterThanOrEqualToSuperview()
            make.right.lessThanOrEqualToSuperview()
            make.centerX.equalToSuperview()
        }
        
        self.aBtn.snp.makeConstraints { (make) in
            make.top.equalTo(self.nameLabel.snp.bottom).offset(10.0)
            make.left.greaterThanOrEqualToSuperview()
            make.height.equalTo(30.0)
        }
        
        self.bBtn.snp.makeConstraints { (make) in
            make.left.equalTo(self.aBtn.snp.right).offset(20.0)
            make.right.lessThanOrEqualToSuperview()
            make.bottom.equalToSuperview().offset(-10.0)
            make.height.centerY.equalTo(self.aBtn)
        }
    }
    
    
    @objc func didClickOnAview(send: UIButton) {
        print("\(String(format: "***点击了%p", send))")
    }
    
}
