//
//  YYTabBarController.swift
//  MLDemo
//
//  Created by raoml on 2019/4/23.
//  Copyright © 2019 raoml. All rights reserved.
//

import UIKit

class YYTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewControllers = [self.createNavigationController(rootViewController: YYMenuViewController())]
    }
    
    private func createNavigationController(rootViewController: UIViewController) -> UINavigationController {        
        rootViewController.popGestureRecognizerEnabled = NSNumber(booleanLiteral: false)
        
        let aNaviController = YYNavigationController(rootViewController: rootViewController)
        return aNaviController
    }
    
}
