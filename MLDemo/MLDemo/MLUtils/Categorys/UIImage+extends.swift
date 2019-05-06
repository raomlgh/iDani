//
//  UIImage+extends.swift
//  MLDemo
//
//  Created by raoml on 2019/4/23.
//  Copyright © 2019 raoml. All rights reserved.
//

import UIKit

extension UIImage {
    
    /**
     根据颜色生成Image
     */
    class func yy_imageFromColor(_ color: UIColor, size: CGSize = CGSize(width: 4, height: 4)) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContext(rect.size)
        
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    /**
     取Bundle.main下的图片     
     */
    class func yy_imageFromBundle(_ name: String, _ ofType: String = "png") -> UIImage? {
        var imagePath = Bundle.main.path(forResource: name + "@" + "\(Int(UIScreen.main.scale))x", ofType: ofType)
        
        if imagePath?.isEmpty ?? true {
            // 当前iOS最高倍图
            var maxScale = 3
            repeat {
                if maxScale == 1 {
                    imagePath = Bundle.main.path(forResource: name, ofType: ofType)
                }else {                    
                    imagePath = Bundle.main.path(forResource: name + "@" + "\(maxScale)x", ofType: ofType)
                }
                maxScale -= 1
            } while (maxScale > 0 && imagePath?.isEmpty ?? true)
        }
        
        guard imagePath?.isEmpty == false else {
            // 找不到对应图片
            return UIImage(named: name)
        }
        
        return UIImage(contentsOfFile: imagePath!)
    }
    
}
