//
//  YYBaseViewController.swift
//  MLDemo
//
//  Created by raoml on 2019/4/23.
//  Copyright © 2019 raoml. All rights reserved.
//

import UIKit

class YYBaseViewController: UIViewController {
    
    open var statusBarStyle: UIStatusBarStyle = .default {
        didSet {
            if statusBarStyle == oldValue {
                return
            }
            
            // 更新StatusBar
            self.setNeedsStatusBarAppearanceUpdate()
            
            // 标题颜色
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18.0), NSAttributedString.Key.foregroundColor: statusBarStyle == .default ? UIColor.black : UIColor.white]
            
            // BarButtonItems
            if let leftItems = self.navigationItem.leftBarButtonItems {
                for item in leftItems {
                    item.tintColor = statusBarStyle == .default ? UIColor.black : UIColor.white
                }
            }
            
            if let rightItems = self.navigationItem.rightBarButtonItems {
                for item in rightItems {
                    item.tintColor = statusBarStyle == .default ? UIColor.black : UIColor.white
                }
            }
        }
    }
    
    override func loadView() {
        super.loadView()
        
        // 设置自定义导航栏        
        self.view.addSubview(self.yy_barCoustomView)
        self.yy_barCoustomView.snp.makeConstraints { (make) in
            make.top.width.centerX.equalToSuperview().priority(.required)
        }
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.hidesBottomBarWhenPushed = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = kPageColor
        
        // 设置BackBarButtonItem
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage.yy_imageFromBundle("back_arrow"), style: .plain, target: self, action: #selector(back(sender:)))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.view.bringSubviewToFront(self.yy_barCoustomView)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return self.statusBarStyle
    }
    
    
    deinit {
        print("*** \(NSStringFromClass(self.classForCoder)) deinit ***♻️")
    }

}

// MARK: - Private Meds
private extension YYBaseViewController {
    
    @objc private func back(sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

// MARK: - Public Meds
extension YYBaseViewController {
    
}
