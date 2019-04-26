//
//  UIView+extends.swift
//  MLDemo
//
//  Created by raoml on 2019/4/23.
//  Copyright © 2019 raoml. All rights reserved.
//

import UIKit

extension UIView {
    
    var yy_safeInsets: UIEdgeInsets {
        get {
            if #available(iOS 11.0, *) {
                return safeAreaInsets
            }else {
                return UIEdgeInsets.zero
            }
        }
    }
    
}
