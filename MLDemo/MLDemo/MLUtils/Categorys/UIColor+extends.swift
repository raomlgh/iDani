//
//  UIColor+extends.swift
//  MLDemo
//
//  Created by raoml on 2019/4/23.
//  Copyright © 2019 raoml. All rights reserved.
//

import UIKit

public let kMainColor           = YYHexColor("FF4C4C")
public let kPageColor           = YYHexColor("F1F2F3")
public let kNavBarClolor        = YYHexColor("FFFFFF")
public let kBlueColor           = YYHexColor("4D7CFF")
public let kLineColor           = YYHexColor("E6EAF5")
public let kBlackTextColor      = YYHexColor("333333")
public let kGrayTextColor       = YYHexColor("666666")
public let kLightGrayTextColor  = YYHexColor("999999")
public let khighlightedColor    = YYHexColor("999999", 0.3)

func YYHexColor(_ hexString: String, _ alpha: CGFloat = 1.0) -> UIColor
{
    var cString = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
    if cString.hasPrefix("#") {
        cString = (cString as NSString).substring(from: 1)
    }
    if cString.hasPrefix("0X") {
        cString = (cString as NSString).substring(from: 2)
    }
    if cString.count != 6 {
        return UIColor.clear
    }
    
    let rString = (cString as NSString).substring(to: 2)
    let gString = ((cString as NSString).substring(from: 2) as NSString).substring(to: 2)
    let bString = ((cString as NSString).substring(from: 4) as NSString).substring(to: 2)
    
    var r:UInt32 = 0, g:UInt32 = 0, b:UInt32 = 0
    
    Scanner(string: rString).scanHexInt32(&r)
    Scanner(string: gString).scanHexInt32(&g)
    Scanner(string: bString).scanHexInt32(&b)
    
    return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: alpha)
}
