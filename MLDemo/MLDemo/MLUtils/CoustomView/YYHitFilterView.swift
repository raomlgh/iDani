//
//  YYHitFilterView.swift
//  MLDemo
//
//  Created by raoml on 2019/4/26.
//  Copyright © 2019 raoml. All rights reserved.
//

import UIKit

public class YYHitFilterView: UIView {

    /// 自己本身不响应事件, 但子视图响应
    public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if self.point(inside: point, with: event) {
            var hitView: UIView?
            
            for sView in self.subviews {
                guard sView.isUserInteractionEnabled && !sView.isHidden && sView.alpha != 0 else {
                    continue
                }
                
                let convertedPoint = sView.convert(point, from: self)
                let sHitView = sView.hitTest(convertedPoint, with: event)
                if sHitView != self {
                    hitView = sHitView
                }
                
                guard hitView == nil else {
                    break
                }
            }
            
            return hitView
        }
        
        return super.hitTest(point, with: event)
    }

}
