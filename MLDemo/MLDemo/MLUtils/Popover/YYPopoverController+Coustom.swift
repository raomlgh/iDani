//
//  YYPopoverController+Coustom.swift
//  MLDemo
//
//  Created by raoml on 2019/5/9.
//  Copyright © 2019 raoml. All rights reserved.
//

import Foundation
import UIKit

extension YYPopoverController {
    
    static func yy_popover(items: [PDPopoverItem], direction: PopoverDirection, showInViewController: UIViewController, fromView: UIView) -> YYPopoverController {
        let popoverDefaultView = YYPopoverDefaultView(popoverItems: items)
        
        let popover = YYPopoverController(coustomView: popoverDefaultView, direction: direction, showInViewController: showInViewController, fromView: fromView)
        
        popoverDefaultView.configClickItemCallback { [weak popover] (item) in
            popover?.hidden(completion: {
                item.itemClickCallback?()
            })
        }
        
        return popover
    }
    
}
