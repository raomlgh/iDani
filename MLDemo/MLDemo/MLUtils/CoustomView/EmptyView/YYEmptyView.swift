//
//  YYEmptyView.swift
//  ShoppingMall
//
//  Created by raoml on 2019/3/15.
//  Copyright © 2019 yyhj. All rights reserved.
//

import UIKit

private let kContentMaxWidth = UIScreen.main.bounds.width - 54.0

class YYEmptyView: UIView {
    
    init(_img: UIImage? = #imageLiteral(resourceName: "icon_no_data"), _title: String? = nil, _message: String? = nil, _actionTitle: String? = nil, _completion:(() -> ())? = nil) {
        super.init(frame: .zero)
        self.backgroundColor = UIColor.white
        
        self.imgTuple = (_img, _img == nil)
        self.titleTuple = (_title, _title == nil)
        self.messageTuple = (_message, _message == nil)
        self.actionTitleTuple = (_actionTitle, _actionTitle == nil)
        self.completion = _completion
        
        self.setupSubviewsAndConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var mStackView: UIStackView = { [unowned self] in
        let aStack = UIStackView()
        aStack.backgroundColor = UIColor.clear
        aStack.axis = .vertical
        aStack.distribution = .fill
        aStack.alignment = .center
        aStack.spacing = 0.0
        return aStack
    }()
    
    private lazy var imgView: UIImageView = { [unowned self] in
        let aImgView = UIImageView(image: self.imgTuple.img)
        aImgView.backgroundColor = UIColor.clear
        aImgView.sizeToFit()
        return aImgView
    }()
    
    private lazy var imgContainerView: UIView = { [unowned self] in
        let aView = UIView()
        aView.backgroundColor = UIColor.white
        aView.addSubview(self.imgView)
        return aView
    }()
    
    private lazy var titleLabel: UILabel = { [unowned self] in
        let aLable = UILabel()
        aLable.text = self.titleTuple.text
        aLable.textColor = kGrayTextColor
        aLable.font = UIFont.systemFont(ofSize: 18.0)
        aLable.backgroundColor = UIColor.clear
        aLable.textAlignment = .left
        aLable.numberOfLines = 0
        aLable.preferredMaxLayoutWidth = kContentMaxWidth
        aLable.sizeToFit()
        return aLable
    }()
    
    private lazy var titleContainerView: UIView = {
        let aView = UIView()
        aView.backgroundColor = UIColor.clear
        aView.addSubview(self.titleLabel)
        return aView
    }()
    
    private lazy var messageLabel: UILabel = { [unowned self] in
        let aLable = UILabel()
        aLable.text = self.messageTuple.text
        aLable.textColor = kLightGrayTextColor
        aLable.font = UIFont.systemFont(ofSize: 14.0)
        aLable.backgroundColor = UIColor.clear
        aLable.textAlignment = .center
        aLable.preferredMaxLayoutWidth = kContentMaxWidth
        aLable.numberOfLines = 0
        aLable.sizeToFit()
        return aLable
    }()
    
    private lazy var messageContainerView: UIView = {
        let aView = UIView()
        aView.backgroundColor = UIColor.clear
        aView.addSubview(self.messageLabel)
        return aView
    }()
    
    private lazy var actionBtn: UIButton = { [unowned self] in
        let aBtn = UIButton()
        aBtn.backgroundColor = UIColor.clear
        aBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18.0)
        aBtn.setTitle(self.actionTitleTuple.text, for: .normal)
        aBtn.setTitleColor(UIColor.white, for: .normal)
        aBtn.setBackgroundImage(UIImage.yy_imageFromColor(kMainColor), for: .normal)
        aBtn.setBackgroundImage(UIImage.yy_imageFromColor(YYHexColor("FF4C4C", 0.3)), for: .highlighted)
        aBtn.layer.cornerRadius = 3.0
        aBtn.layer.masksToBounds = true
        aBtn.addTarget(self, action: #selector(didClickOnActionButton(sender:)), for: .touchUpInside)
        return aBtn
    }()
    
    private lazy var actionContainerView: UIView = {
        let aView = UIView()
        aView.backgroundColor = UIColor.clear
        aView.addSubview(self.actionBtn)
        return aView
    }()
    
    private var imgTuple: (img: UIImage?, hidden: Bool)!
    private var titleTuple: (text: String?, hidden: Bool)!
    private var messageTuple: (text: String?, hidden: Bool)!
    private var actionTitleTuple: (text: String?, hidden: Bool)!
    private var completion:(() -> ())?
    
}

// MARK: Private Meds
private extension YYEmptyView {
    
    func setupSubviewsAndConstraints() {
        self.addSubview(self.mStackView)
        
        self.mStackView.snp.makeConstraints { (make) in
            make.top.left.lessThanOrEqualToSuperview().priority(.low)
            make.bottom.right.lessThanOrEqualToSuperview().priority(.low)
            make.center.equalToSuperview()
        }
        
        if self.imgTuple.hidden == false {
            self.mStackView.addArrangedSubview(self.imgContainerView)
            self.imgView.snp.makeConstraints { (make) in
                make.edges.equalToSuperview().inset(UIEdgeInsets.init(top: 5.0, left: 0, bottom: 20.0, right: 0))
            }
        }
        
        if self.titleTuple.hidden == false {
            self.mStackView.addArrangedSubview(self.titleContainerView)
            self.titleLabel.snp.makeConstraints { (make) in
                make.edges.equalToSuperview().inset(UIEdgeInsets.init(top: 5.0, left: 0, bottom: 5.0, right: 0))
            }
        }
        
        if self.messageTuple.hidden == false {
            self.mStackView.addArrangedSubview(self.messageContainerView)
            self.messageLabel.snp.makeConstraints { (make) in
                make.edges.equalToSuperview().inset(UIEdgeInsets.init(top: 5.0, left: 0, bottom: 5.0, right: 0))
            }
        }
        
        if self.actionTitleTuple.hidden == false {
            self.mStackView.addArrangedSubview(self.actionContainerView)
            self.actionBtn.snp.makeConstraints { (make) in
                make.edges.equalToSuperview().inset(UIEdgeInsets.init(top: 30.0, left: 0, bottom: 0, right: 0))
                make.size.equalTo(CGSize(width: kContentMaxWidth, height: 50.0))
            }
        }
    }
    
    @objc func didClickOnActionButton(sender: UIButton) {
        self.completion?()
    }
    
}
