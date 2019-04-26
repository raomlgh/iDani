//
//  UINavigationBar+extends.swift
//  MLDemo
//
//  Created by raoml on 2019/4/24.
//  Copyright © 2019 raoml. All rights reserved.
//

import UIKit

extension UINavigationBar {
    
    static private var kOverlayViewKey = "OverlayViewKey"
    
    // 导航栏上插入的一个View
    public var yy_overlayView: UIView? {
        var overlayView = objc_getAssociatedObject(self, UINavigationBar.kOverlayViewKey) as? UIView
        if overlayView == nil {
            var barBackgroundView: UIView?
            let barBackgroundViewClass: AnyClass!
            if #available(iOS 10, *) {
                barBackgroundViewClass = NSClassFromString("_UIBarBackground")
            }else {
                barBackgroundViewClass = NSClassFromString("_UINavigationBarBackground")
            }
            
            for aView in self.subviews {
                if aView.classForCoder == barBackgroundViewClass {
                    barBackgroundView = aView
                    break
                }
            }
            
            if let barBackgroundView = barBackgroundView {
                overlayView = UIView(frame: barBackgroundView.bounds)
                overlayView!.backgroundColor = UIColor.purple
                barBackgroundView.insertSubview(overlayView!, at: 0)
                objc_setAssociatedObject(self, UINavigationBar.kOverlayViewKey, overlayView, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
        return overlayView
    }        
    
}
