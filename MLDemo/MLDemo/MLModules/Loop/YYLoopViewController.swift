//
//  YYLoopViewController.swift
//  MLDemo
//
//  Created by raoml on 2019/5/17.
//  Copyright © 2019 raoml. All rights reserved.
//

import UIKit

class YYLoopViewController: YYBaseViewController {

    private lazy var mScrollView: UIScrollView = { [unowned self] in
        let aScrollView = UIScrollView(frame: self.view.bounds)
        aScrollView.contentSize = CGSize(width: self.view.bounds.width, height: 2*self.view.bounds.height)
        return aScrollView
    }()
    
    private lazy var loopView: YYLoopView = {
        let aLoopView = YYLoopView(frame: CGRect(x: 0, y: self.yy_navigationBarHeight(), width: self.view.bounds.width, height: 150.0), config: (autoScroll: true, interval: 2.0))
        aLoopView.setImages([UIImage.yy_imageFromBundle("pic_bg_ikun", "jpg")!,
                             UIImage.yy_imageFromBundle("pic_bg_duice", "jpg")!,
                             UIImage.yy_imageFromBundle("pic_bg_ikun", "jpg")!,
                             UIImage.yy_imageFromBundle("pic_bg_duice", "jpg")!],
                            imageUrls: nil)
        return aLoopView
    }()
    
    private lazy var changeSourceBtn: UIButton = { [unowned self] in
        let aBtn = UIButton(frame: CGRect(x: (self.loopView.bounds.width - 100.0) * 0.5, y: self.loopView.frame.maxY + 50.0, width: 100.0, height: 44.0))
        aBtn.setTitle("切换数据源", for: .normal)
        aBtn.setTitleColor(UIColor.blue, for: .normal)
        aBtn.setTitleColor(UIColor.lightGray, for: .highlighted)
        aBtn.addTarget(self, action: #selector(didClickOnChangeSourceButton(sender:)), for: .touchUpInside)
        return aBtn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Loop View"

        self.view.addSubview(self.mScrollView)
        self.mScrollView.addSubview(self.loopView)
        self.mScrollView.addSubview(self.changeSourceBtn)
    }
    
    @objc func didClickOnChangeSourceButton(sender: UIButton) {
        let randomNum = arc4random()%3
        if randomNum == 0 {
            self.loopView.setImages([UIImage.yy_imageFromBundle("pic_bg_ikun", "jpg")!],
                                    imageUrls: nil)
        }else if randomNum == 1 {
            self.loopView.setImages([UIImage.yy_imageFromBundle("pic_bg_duice", "jpg")!,
                                     UIImage.yy_imageFromBundle("pic_bg_ikun", "jpg")!],
                                    imageUrls: nil)
        }else {
            self.loopView.setImages([UIImage.yy_imageFromBundle("pic_bg_duice", "jpg")!,
                                     UIImage.yy_imageFromBundle("pic_bg_ikun", "jpg")!,
                                     UIImage.yy_imageFromBundle("pic_bg_duice", "jpg")!,
                                     UIImage.yy_imageFromBundle("pic_bg_ikun", "jpg")!],
                                    imageUrls: nil)
        }
    }

}
