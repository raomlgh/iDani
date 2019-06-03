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

// MARK: - Runtime
private var kPopGestureRecognizerFirstKey: Void?

extension UIView {
    
    /*
     解决UIView的滑动手势与导航栏边缘右滑返回(interactivePopGestureRecognizer)冲突的问题，
     标记为NSNumber(booleanLiteral: true)时，导航栏右滑优先
     */
    public var popGestureRecognizerFirst: NSNumber? {
        get {
            return objc_getAssociatedObject(self, &kPopGestureRecognizerFirstKey) as? NSNumber
        }
        set {
            objc_setAssociatedObject(self, &kPopGestureRecognizerFirstKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
}
