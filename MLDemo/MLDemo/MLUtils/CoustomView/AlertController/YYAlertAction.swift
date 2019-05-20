//
//  YYAlertAction.swift
//  ShoppingMall
//
//  Created by raoml on 2019/3/22.
//  Copyright © 2019 yyhj. All rights reserved.
//

import UIKit

class YYAlertAction: UIButton {
    
    var actionHandler: ((YYAlertAction) -> Void)?
    var dissmisHandler: ((YYAlertAction) -> Void)?
    
    convenience init(title: String?, style: UIAlertAction.Style, handler: ((_ action: YYAlertAction) -> Void)?) {
        self.init()
        
        self.backgroundColor = UIColor.white
        self.titleLabel?.font = UIFont.systemFont(ofSize: 16.0)
        self.setBackgroundImage(UIImage.yy_imageFromColor(khighlightedColor), for: .highlighted)
        self.setTitle(title, for: .normal)
        self.addTarget(self, action: #selector(didClick(action:)), for: .touchUpInside)
        
        switch style {
        case .cancel:
            self.setTitleColor(kBlackTextColor, for: .normal)
        case .destructive:
            self.setTitleColor(kMainColor, for: .normal)
        default:
            self.setTitleColor(kBlackTextColor, for: .normal)
        }
        
        self.actionHandler = handler
        
        self.setupSeparateView()
    }
    
}

private extension YYAlertAction {
    
    /// 设置顶部分割线
    func setupSeparateView() {
        let separateView = UIView()
        separateView.backgroundColor = kLineColor
        
        self.addSubview(separateView)
        
        separateView.snp.makeConstraints { (make) in
            make.top.width.centerX.equalToSuperview()
            make.height.equalTo(1.0)
        }
    }
    
    @objc func didClick(action: YYAlertAction) {
        self.dissmisHandler?(action)
    }
    
}
