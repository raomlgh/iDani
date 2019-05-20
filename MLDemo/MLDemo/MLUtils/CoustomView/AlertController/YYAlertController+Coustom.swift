//
//  YYAlertControllerExtension.swift
//  ShoppingMall
//
//  Created by raoml on 2019/3/22.
//  Copyright © 2019 yyhj. All rights reserved.
//

import Foundation

extension YYAlertController {
    
    /// AlertView
    static func yy_alertController(title: String?, message: String?) -> YYAlertController {        
        return YYAlertController(coustomView: YYTipMessageView(title: title, message: message), preferredStyle: .alert)
    }
    
    
    /// ActionSheet
    static func yy_actionSheetController(title: String?, message:String?, actionSheetItems:[[YYActionSheetItem]]) -> YYAlertController {        
        let coustomView = YYActionSheetView(title: title, message: message, actionSheetItems: actionSheetItems, handler: nil)

        let alt = YYAlertController(coustomView: coustomView, preferredStyle: .actionSheet)

        coustomView.config { [weak alt] (actionSheetItem) in
            alt?.hidden(completion: {
                actionSheetItem.handler?()
            })
        }
        
        return alt
    }
    
}
