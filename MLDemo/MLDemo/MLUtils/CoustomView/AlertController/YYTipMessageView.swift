//
//  YYTipMessageView.swift
//  ShoppingMall
//
//  Created by raoml on 2019/3/22.
//  Copyright © 2019 yyhj. All rights reserved.
//

import UIKit

class YYTipMessageView: UIView {

    private lazy var titleLabel: UILabel = {
        let aLabel = UILabel()
        aLabel.font = UIFont.systemFont(ofSize: 18.0)
        aLabel.textColor = kBlackTextColor
        aLabel.numberOfLines = 0
        return aLabel
    }()
    
    private lazy var messageLabel: UILabel = {
        let aLabel = UILabel()
        aLabel.font = UIFont.systemFont(ofSize: 14.0)
        aLabel.textColor = kGrayTextColor
        aLabel.numberOfLines = 0
        return aLabel
    }()
    
    private lazy var mStackView: UIStackView = {
        let aStackView = UIStackView()
        aStackView.axis = .vertical
        aStackView.spacing = 15.0
        aStackView.alignment = .center
        return aStackView
    }()
    
    /**
     初始化
     @param title 标题
     @param message 描述信息
     */
    convenience init(title: String?, message: String?) {
        self.init()        
        self.backgroundColor = UIColor.white
        
        if title?.isEmpty == false {
            self.titleLabel.text = title
            self.mStackView.addArrangedSubview(self.titleLabel)
        }
        
        if message?.isEmpty == false {
            self.messageLabel.text = message
            self.mStackView.addArrangedSubview(self.messageLabel)
        }
        
        self.addSubview(self.mStackView)
        self.mStackView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(20.0)
            make.bottom.equalToSuperview().offset(-20.0)
            make.left.equalToSuperview().offset(16.0)
            make.right.equalToSuperview().offset(-16.0)
            make.width.equalTo(UIScreen.main.bounds.size.width - 92.0)
        }
    }
    
}

