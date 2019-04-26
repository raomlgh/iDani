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
        var beginOffset: CGFloat = 0.0
        var progressHeight: CGFloat = 0.0
        
        switch self.barType {
        case .wangYiMusic:
            headerBarHeight = 280.0
            self.yy_barCoustomView.setNavigationBar(color: UIColor.clear, image: nil)
            self.yy_barCoustomView.setNavigationBarBackgroundImage(UIImage.yy_imageFromBundle("pic_bg_ikun"), imageUrl: nil)
            self.yy_barCoustomView.setContentSubview(ACHeaderView()) { (make) in
                make.size.bottom.equalToSuperview()
            }
        case .taoBao:
            beginOffset = -100.0
            progressHeight = 100.0
            self.yy_barCoustomView.setNavigationBar(color: nil, image: UIImage.yy_imageFromBundle("pic_bg_ikun"))
        default:
            progressHeight = 100.0
            self.yy_barCoustomView.setNavigationBar(color: UIColor.orange, image: nil)
        }
        
        self.yy_barCoustomView.setBarHeight(headerBarHeight, nil)
        self.yy_barCoustomView.setNavigationBarBounceAndAlpha(bindScrollView: self.tableView, bounceEnable: true, changeAlphaEnable: true, beginOffset: beginOffset, progressHeight: progressHeight) { [unowned self] (alpha, barHeight) in
            self.yy_barCoustomView.setSeparateLineViewHidden(barHeight > self.yy_navigationBarHeight())
        }
        
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
        aLabel.text = "Hello word!!!"
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
        aBtn.addTarget(self, action: #selector(didClickOnAview(send:)), for: .touchUpInside)
        return aBtn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
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
