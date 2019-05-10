//
//  YYPopoverViewController.swift
//  MLDemo
//
//  Created by raoml on 2019/5/10.
//  Copyright © 2019 raoml. All rights reserved.
//

import UIKit

class YYPopoverViewController: YYBaseViewController {
    
    private var popoItems: [PDPopoverItem] = {
        var items = [PDPopoverItem]()
        for i in 0 ..< 5 {
            let aItem = PDPopoverItem(UIImage.yy_imageFromBundle("pic_ava_lm"), "item\(i) test", completion: {
                print("click ....")
            })
            items.append(aItem)
        }
        return items
    }()
    
    private lazy var leftTopBtn = self.createButton(title: "LeftDown", selector: #selector(didClickOnLeftTop(sender:)))
    
    private lazy var rightTopBtn = self.createButton(title: "RightDown", selector: #selector(didClickOnRightTop(sender:)))
   
    private lazy var leftBottomBtn = self.createButton(title: "LeftUp", selector: #selector(didClickOnLeftBottom(sender:)))
    
    private lazy var rightBottomBtn = self.createButton(title: "RightUp", selector: #selector(didClickOnRightBottom(sender:)))
    
    private lazy var midLeftBtn = self.createButton(title: "AutoVer", selector: #selector(didClickOnMidLeft(sender:)))
    
    private lazy var midRightBtn = self.createButton(title: "AutoHor", selector: #selector(didClickOnMidRight(sender:)))
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Popover"
        
        self.view.addSubview(self.leftTopBtn)
        self.view.addSubview(self.rightTopBtn)
        self.view.addSubview(self.leftBottomBtn)
        self.view.addSubview(self.rightBottomBtn)
        self.view.addSubview(self.midLeftBtn)
        self.view.addSubview(self.midRightBtn)

        self.leftTopBtn.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 120.0, height: 44.0))
            make.top.equalToSuperview().offset(self.yy_navigationBarHeight() + 50.0)
            make.left.equalToSuperview().offset(50.0)
        }
        
        self.rightTopBtn.snp.makeConstraints { (make) in
            make.size.centerY.equalTo(self.leftTopBtn)
            make.right.equalToSuperview().offset(-50.0)
        }
        
        self.leftBottomBtn.snp.makeConstraints { (make) in
            make.left.size.equalTo(self.leftTopBtn)
            make.bottom.equalToSuperview().offset(-100.0)
        }
        
        self.rightBottomBtn.snp.makeConstraints { (make) in
            make.right.size.equalTo(self.rightTopBtn)
            make.centerY.equalTo(self.leftBottomBtn)
        }
        
        self.midLeftBtn.snp.makeConstraints { (make) in
            make.left.size.equalTo(self.leftTopBtn)
            make.centerY.equalToSuperview()
        }
        
        self.midRightBtn.snp.makeConstraints { (make) in
            make.right.size.equalTo(self.rightTopBtn)
            make.centerY.equalToSuperview()
        }
        
    }
    
}

// MARK: - Private Meds
extension YYPopoverViewController {
    
    private func createButton(title: String, selector: Selector) -> UIButton {
        let aBtn = UIButton()
        aBtn.layer.masksToBounds = true
        aBtn.layer.cornerRadius = 22.0
        aBtn.layer.borderColor = UIColor.blue.cgColor
        aBtn.layer.borderWidth = 1.0
        aBtn.setTitleColor(UIColor.blue, for: .normal)
        aBtn.setTitle(title, for: .normal)
        aBtn.addTarget(self, action: selector, for: .touchUpInside)
        return aBtn
    }
    
    @objc func didClickOnLeftTop(sender: UIButton) {
        YYPopoverController.yy_popover(items: self.popoItems, direction: .down, showInViewController: self, fromView: sender).show()
    }
    
    @objc func didClickOnRightTop(sender: UIButton) {
        YYPopoverController.yy_popover(items: self.popoItems, direction: .down, showInViewController: self, fromView: sender).show()
    }
    
    @objc func didClickOnLeftBottom(sender: UIButton) {
        YYPopoverController.yy_popover(items: self.popoItems, direction: .up, showInViewController: self, fromView: sender).show()
    }
    
    @objc func didClickOnRightBottom(sender: UIButton) {
        YYPopoverController.yy_popover(items: self.popoItems, direction: .up, showInViewController: self, fromView: sender).show()
    }
    
    @objc func didClickOnMidLeft(sender: UIButton) {
        YYPopoverController.yy_popover(items: self.popoItems, direction: .autoVertical, showInViewController: self, fromView: sender).show()
    }
    
    @objc func didClickOnMidRight(sender: UIButton) {
        YYPopoverController.yy_popover(items: self.popoItems, direction: .autoHorizontal, showInViewController: self, fromView: sender).show()
    }
    
}
