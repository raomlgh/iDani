//
//  YYLoopViewCell.swift
//  MLDemo
//
//  Created by raoml on 2019/5/17.
//  Copyright © 2019 raoml. All rights reserved.
//

import UIKit

class YYLoopViewCell: UICollectionViewCell {
    
    private lazy var imgView: UIImageView = {
        let aImgView = UIImageView()
        aImgView.contentMode = UIView.ContentMode.scaleAspectFill
        aImgView.clipsToBounds = true
        return aImgView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.addSubview(self.imgView)
        
        self.imgView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Public Meds
extension YYLoopViewCell {
    
    public func configImages(_ image: UIImage?, url: URL?) {
        if let image = image {
            self.imgView.image = image
        }else {
            self.imgView.kf.setImage(with: url)
        }
    }
    
}
