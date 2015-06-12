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
        //首页
        var homeItem = items[0]
        homeItem.image = UIImage(named: "0_home")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        homeItem.selectedImage = UIImage(named: "0_home_blue")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        //消息
        var newsItem = items[1]
        newsItem.image = UIImage(named: "0_news")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        newsItem.selectedImage = UIImage(named: "0_news_blue")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        //newsItem.badgeValue = "5"
        //中间的tabitem
        var moneyItem = items[2]
        moneyItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)
        var image = UIImage(named: "logo")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        moneyItem.image = image
        moneyItem.selectedImage = image
        //发现
        var searchItem = items[3]
        searchItem.image = UIImage(named: "0_search")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        searchItem.selectedImage = UIImage(named: "0_search_blue")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        //我的账号
        var userItem = items[4]
        userItem.image = UIImage(named: "0_user")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        userItem.selectedImage = UIImage(named: "0_user_blue")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)

        
        self.delegate = self
    }
    
    
    //点击tab的时候，判断是否有登录，如果没有登录就跳转到登录页面
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool{
        var tag = viewController.tabBarItem.tag
        if (tag == 105) || (tag == 102) {
            //消息和我的账号需要判断登录
            var user = NSUserDefaults()

            if !Common.isLogin(){
                var loginViewController = self.storyboard?.instantiateViewControllerWithIdentifier("loginViewController") as! LoginViewController
                loginViewController.tabTag = tag
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