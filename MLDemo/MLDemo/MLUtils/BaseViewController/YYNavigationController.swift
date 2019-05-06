//
//  YYNavigationController.swift
//  MLDemo
//
//  Created by raoml on 2019/4/23.
//  Copyright © 2019 raoml. All rights reserved.
//

import UIKit

class YYNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.interactivePopGestureRecognizer?.delegate = self
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return self.topViewController?.preferredStatusBarStyle ?? .default
    }
    
}

extension YYNavigationController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        self.interactivePopGestureRecognizer?.isEnabled = viewController.popGestureRecognizerEnabled.boolValue
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        let baseViewController: YYBaseViewController? = viewController as? YYBaseViewController
        if let baseViewController = baseViewController {
            self.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18.0), NSAttributedString.Key.foregroundColor: baseViewController.statusBarStyle == .default ? UIColor.black : UIColor.white]
        }
    }
    
}

extension YYNavigationController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == self.interactivePopGestureRecognizer {
            // 确保self.interactivePopGestureRecognizer优先级最高
            otherGestureRecognizer.require(toFail: gestureRecognizer)
        }
        return true
    }
    
}
