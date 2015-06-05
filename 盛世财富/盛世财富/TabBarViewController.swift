//
//  TabBarViewController.swift
//  盛世财富
//  理财，我的账号，更多tab页控制器
//  Created by 肖典 on 15/5/6.
//  Copyright (c) 2015年 sscf88. All rights reserved.
//

import Foundation
import UIKit

class TabBarViewController : UITabBarController,UITabBarControllerDelegate{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var items = self.tabBar.items as! [UITabBarItem]
        //消息
        var newsItem = items[1]
        newsItem.badgeValue = "5"
        //中间的tabitem
        var moneyItem = items[2]
        moneyItem.imageInsets = UIEdgeInsetsMake(8, 0, -8, 0)
        self.delegate = self
    }
    
    
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool{
        var tag = viewController.tabBarItem.tag
        if (tag == 105) || (tag == 102) || (tag == 103){
            //我的账号
            var user = NSUserDefaults()

            if !Common.isLogin(){
                var loginViewController = self.storyboard?.instantiateViewControllerWithIdentifier("loginViewController") as! LoginViewController
                
                //var nav = tabBarController.selectedViewController as? UINavigationController
                //nav?.showViewController(loginViewController, sender: nil)
                self.presentViewController(loginViewController, animated: true, completion: nil)
                return false
            }
            return true
            
        }
        return true
    }
    
    
//    override func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem!) {
//        var index = tabBar.selectedItem;
//
//        if item.title == "" {
//            var user = NSUserDefaults()
//            
//            if Common.isLogin(){
//                
//            }else{
//                var view = self.storyboard?.instantiateViewControllerWithIdentifier("loginViewController") as! LoginViewController
//                self.presentViewController(view, animated: true, completion: nil)
//            }
//        }
//        if index?.title == "我的账号" {
//            var user = NSUserDefaults()
//            
//            if Common.isLogin(){
//                
//            }else{
//                var view = self.storyboard?.instantiateViewControllerWithIdentifier("loginViewController") as! LoginViewController
//                self.presentViewController(view, animated: true, completion: nil)
//            }
//        }
//    }
    
}