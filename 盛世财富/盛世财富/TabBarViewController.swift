//
//  TabBarViewController.swift
//  盛世财富
//  理财，我的账号，更多tab页控制器
//  Created by 肖典 on 15/5/6.
//  Copyright (c) 2015年 sscf88. All rights reserved.
//

import Foundation
import UIKit

class TabBarViewController : UITabBarController,UITabBarDelegate,UITabBarControllerDelegate{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var items = self.tabBar.items as! [UITabBarItem]
        var newsItem = items[1]
        newsItem.badgeValue = "5"
        var moneyItem = items[2]
        moneyItem.imageInsets = UIEdgeInsetsMake(8, 0, -8, 0)
    }
    
    override func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem!) {
        var index = tabBar.selectedItem;
        if index?.title == "理财" {
            
        }
        if index?.title == "我的账号" {
            var user = NSUserDefaults()
            
            if Common.isLogin(){
                
            }else{
                var view = self.storyboard?.instantiateViewControllerWithIdentifier("loginViewController") as! LoginViewController
                self.presentViewController(view, animated: true, completion: nil)
            }
        }
        if index?.title == "更多" {
            
        }
    }
    
}