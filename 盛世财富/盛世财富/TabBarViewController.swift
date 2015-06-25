//
//  TabBarViewController.swift
//  盛世财富
//  理财，我的账号，更多tab页控制器
//  Created by 肖典 on 15/5/6.
//  Copyright (c) 2015年 sscf88. All rights reserved.
//

import Foundation
import UIKit
enum ModalPresentingType {
    case Present, Dismiss
}
class TabBarViewController : UITabBarController,UITabBarControllerDelegate,UIViewControllerTransitioningDelegate ,UIViewControllerAnimatedTransitioning {
    
    var modalPresentingType: ModalPresentingType?

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
        if (tag == 105) || (tag == 102) || (tag == 103) {
            //消息和我的账号需要判断登录
            var user = NSUserDefaults()

            if !Common.isLogin(){
                var loginViewController = self.storyboard?.instantiateViewControllerWithIdentifier("loginViewController") as! LoginViewController
                loginViewController.tabTag = tag
                loginViewController.transitioningDelegate = self
                self.presentViewController(loginViewController, animated: true, completion: nil)
                return false
            }
            return true
            
        }
        return true
    }
    
    //MARK:- 交互动画
    
    //UIViewControllerTransitioningDelegate
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        modalPresentingType = ModalPresentingType.Present
        return self
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        modalPresentingType = ModalPresentingType.Dismiss
        return self
    }
    
    //UIViewControllerAnimatedTransitioning
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return 0.6
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView()
        
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        
        var destView: UIView!
        var destTransfrom = CGAffineTransformIdentity
        let screenHeight = UIScreen.mainScreen().bounds.size.height
        
        if modalPresentingType == ModalPresentingType.Present {
            destView = toViewController.view
            destView.transform = CGAffineTransformMakeTranslation(0, screenHeight)
            containerView.addSubview(toViewController.view)
        } else if modalPresentingType == ModalPresentingType.Dismiss {
            destView = fromViewController.view
            destTransfrom = CGAffineTransformMakeTranslation(0, screenHeight)
            containerView.insertSubview(toViewController.view, belowSubview: fromViewController.view)
        }
        
        UIView.animateWithDuration(transitionDuration(transitionContext), delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0,
            options: UIViewAnimationOptions.CurveLinear, animations: {
                destView.transform = destTransfrom
            }, completion: {completed in
                transitionContext.completeTransition(true)
        })
    }

    
}