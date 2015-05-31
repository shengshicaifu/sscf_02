	//
//  AppDelegate.swift
//  盛世财富
//
//  Created by mo on 15-3-12.
//  Copyright (c) 2015年 sscf88. All rights reserved.
//
    
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
//        NSLog("didFinishLaunchingWithOptions")
        // Override point for customization after application launch.
        var storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        
        if !NSUserDefaults.standardUserDefaults().boolForKey("firstLaunch") {
            
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "firstLaunch")
            
            NSUserDefaults.standardUserDefaults().setBool(false, forKey: "showLockPassword")
            
            window?.rootViewController = storyboard.instantiateViewControllerWithIdentifier("UserGuideViewController") as! UserGuideViewController
            
        }else{
            window?.rootViewController = storyboard.instantiateViewControllerWithIdentifier("tabBarViewController") as!TabBarViewController
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "showLockPassword")
        }
        
        
        //设置状态栏字体颜色和背景颜色
        var appearance = UINavigationBar.appearance()
        appearance.barTintColor = UIColor(red: 68/255.0, green: 163/255.0, blue: 242/255.0, alpha: 1.0)
        appearance.tintColor = UIColor.whiteColor()
        appearance.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
        //修改按钮的颜色
        UIBarButtonItem.appearance().tintColor = UIColor.whiteColor()
        
        
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
        
        window?.makeKeyAndVisible()
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
//        NSLog("applicationWillEnterForeground")
        
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.

        
        //设置手势密码
//        if NSUserDefaults.standardUserDefaults().boolForKey("showLockPassword") {
//            //第一次运行的时候不显示手势密码
//            
//            //手势解锁相关
//            if let pswd  = LLLockPassword.loadLockPassword(){
//                
//                self.showLLLockViewController(LLLockViewTypeCheck)
//            }else{
//                self.showLLLockViewController(LLLockViewTypeCreate)
//                
//            }
//        }
        
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
    }
    
    func showLLLockViewController(type:LLLockViewType){
        //if self.window!.rootViewController!.presentingViewController == nil {
            var lockVc = LLLockViewController()
            lockVc.nLockViewType = type
            lockVc.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
            var root = self.window?.rootViewController
            NSLog("root:%@",root!)
            self.window?.rootViewController?.presentViewController(lockVc, animated: true, completion: nil)
        //}
    }


}

