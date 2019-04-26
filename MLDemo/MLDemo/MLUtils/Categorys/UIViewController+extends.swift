//
//  UIViewController+extends.swift
//  MLDemo
//
//  Created by raoml on 2019/4/23.
//  Copyright © 2019 raoml. All rights reserved.
//

import UIKit

extension UIViewController {
    
    private static var kPopGestureRecognizerEnabledKey = "PopGestureRecognizerEnabledKey"
    private static var kBarCoustomViewKey = "BarCoustomViewKey"
    
    // 是否允许控制器右滑返回
    public var popGestureRecognizerEnabled: NSNumber {
        get {
            let enableNb = objc_getAssociatedObject(self, &UIViewController.kPopGestureRecognizerEnabledKey) as? NSNumber
            return enableNb ?? NSNumber(booleanLiteral: true)
        }
        set {
            objc_setAssociatedObject(self, &UIViewController.kPopGestureRecognizerEnabledKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    // 自定义的导航栏
    public var yy_barCoustomView: YYCoustomBarView {
        var barCoustomView = objc_getAssociatedObject(self, &UIViewController.kBarCoustomViewKey) as? YYCoustomBarView
        if barCoustomView == nil {
            barCoustomView = YYCoustomBarView(viewController: self, originHeight: self.yy_navigationBarHeight(), minHeight: self.yy_navigationBarHeight())
            objc_setAssociatedObject(self, &UIViewController.kBarCoustomViewKey, barCoustomView, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        return barCoustomView!
    }
    
    // 导航栏高度
    public func yy_navigationBarHeight() -> CGFloat {
        return UIApplication.shared.statusBarFrame.height + (self.navigationController?.navigationBar.frame.height ?? 0.0)
    }
    
}
