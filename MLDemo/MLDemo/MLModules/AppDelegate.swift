//
//  AppDelegate.swift
//  MLDemo
//
//  Created by raoml on 2019/4/23.
//  Copyright © 2019 raoml. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.makeKeyAndVisible()
        self.window?.rootViewController = YYTabBarController()
        
        self.configUsualSettings()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}


extension AppDelegate {
    
    func configUsualSettings() {
        // 适配UITabBar
        UITabBar.appearance().backgroundImage = UIImage.yy_imageFromColor(YYHexColor("FFFFFF", 0.9))
        UITabBar.appearance().shadowImage = UIImage.yy_imageFromColor(YYHexColor("E6EAF5"), size: CGSize(width: UIScreen.main.bounds.size.width, height: 0.5))
        
        // 适配UINavigationBar        
        UINavigationBar.appearance().tintColor = UIColor.black
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().setBackgroundImage(UIImage.yy_imageFromColor(UIColor.clear), for: .default)
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18.0), NSAttributedString.Key.foregroundColor: UIColor.black]
//        UINavigationBar.appearance().backIndicatorImage = UIImage.yy_imageFromBundle("back_arrow")
//        UINavigationBar.appearance().backIndicatorTransitionMaskImage = UIImage.yy_imageFromBundle("back_arrow")
        
        // 适配UIBarButtonItem
        UIBarButtonItem.appearance().tintColor = UIColor.black
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15.0), NSAttributedString.Key.foregroundColor: UIColor.black], for: .normal)
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15.0), NSAttributedString.Key.foregroundColor: UIColor.lightGray], for: .highlighted)
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15.0), NSAttributedString.Key.foregroundColor: UIColor.lightGray], for: .disabled)
        
        // 适配TableView预估高度
        UIScrollView.appearance().contentInsetAdjustmentBehavior = .always
        UITableView.appearance().estimatedRowHeight = 0.0;
        UITableView.appearance().estimatedSectionFooterHeight = 0.0
        UITableView.appearance().estimatedSectionHeaderHeight = 0.0
        
        // 适配UITextField、UITextView光标颜色
        UITextField.appearance().tintColor = YYHexColor("FF4C4C")
        UITextView.appearance().tintColor = YYHexColor("FF4C4C")
    }
    
}

