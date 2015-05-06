//
//  TabBarViewController.swift
//  盛世财富
//
//  Created by 肖典 on 15/5/6.
//  Copyright (c) 2015年 sscf88. All rights reserved.
//

import Foundation
import UIKit

class TabBarViewController : UITabBarController,UITabBarDelegate{
    override func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem!) {
        var index = tabBar.selectedItem;
//        println(index.title)
        if index?.title == "理财" {
            println(1)
        }
//        println(index.title == "我的账户")
        if index?.title == "我的账号" {
            var user = NSUserDefaults()
            
            if let username = user.valueForKey("username") as? String{
                
            }else{
                println("unsign")
                var view = self.storyboard?.instantiateViewControllerWithIdentifier("loginViewController") as LoginViewController
                self.presentViewController(view, animated: true, completion: nil)
            }
        }
        if index?.title == "更多" {
            println(3)
        }
    }
}