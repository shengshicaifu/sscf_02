//
//  NewPersonCenterViewController.swift
//  盛世财富
//  我的账号
//  Created by 肖典 on 15/5/6.
//  Copyright (c) 2015年 sscf88. All rights reserved.
//

import Foundation
import UIKit
class NewPersonCenterViewController:UITableViewController,UITableViewDataSource,UITableViewDelegate
    //,UINavigationControllerDelegate ,UIViewControllerAnimatedTransitioning
{
   
    var navigationOperation: UINavigationControllerOperation?
    var interactivePopTransition: UIPercentDrivenInteractiveTransition!
    
    
    @IBOutlet weak var mainTable: UITableView!
    @IBOutlet weak var head: UIImageView!

    @IBOutlet weak var moneyView: UIView!
    var textLayer:CACustomTextLayer?

    var ehttp = HttpController()
    var url = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        self.navigationController?.delegate = self
//        let popRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: Selector("handlePopRecognizer:"))
//        popRecognizer.edges = UIRectEdge.Left
//        self.navigationController!.view.addGestureRecognizer(popRecognizer)
        
        
        
        mainTable.dataSource = self
        mainTable.delegate = self
        
        head.layer.masksToBounds = true
        head.layer.cornerRadius = 35
        
        //点击个人头像，跳转到账户信息页面
        head.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "toAccountInfo"))
        
        
        
        //println("head  x:\(head?.frame.origin.x) y\(head?.frame.origin.y) width\(head?.frame.width) height\(head?.frame.height)")
        
        //钱
        textLayer = CACustomTextLayer()
        textLayer?.string = "0"
        textLayer?.frame = CGRectMake(-10, 0, UIScreen.mainScreen().bounds.width, moneyView.frame.height)
        textLayer?.fontSize = 36.0
        //textLayer?.backgroundColor = UIColor.grayColor().CGColor
        textLayer?.foregroundColor = UIColor.whiteColor().CGColor
        textLayer?.alignmentMode = kCAAlignmentCenter//"center"
        textLayer?.contentsScale = 2.0
        var moneyFrame = moneyView.frame
        var newMoneyFrame = CGRectMake(moneyFrame.origin.x, moneyFrame.origin.y, UIScreen.mainScreen().bounds.width, moneyFrame.height)
        moneyView.frame = moneyFrame
        moneyView.layer.addSublayer(textLayer)
        //moneyView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "toMoneyInfo"))
        
        
        //下拉刷新
        var rc = UIRefreshControl()
        rc.attributedTitle = NSAttributedString(string: "下拉刷新")
        rc.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = rc
        
        
    }
    
   
    
    
    //刷新
    func refresh(){
        if self.refreshControl!.refreshing {
            self.refreshControl?.attributedTitle = NSAttributedString(string: "加载中...")
            if let token = NSUserDefaults.standardUserDefaults().objectForKey("token") as? String {
                
                //检查手机网络
                var reach = Reachability(hostName: Common.domain)
                reach.unreachableBlock = {(r:Reachability!) -> Void in
                    //NSLog("网络不可用")
                    dispatch_async(dispatch_get_main_queue(), {
                        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                        self.refreshControl?.endRefreshing()
                        self.refreshControl?.attributedTitle = NSAttributedString(string: "下拉刷新")
                        AlertView.alert("提示", message: "网络连接有问题，请检查网络是否连接", buttonTitle: "确定", viewController: self)
                    })
                }
                reach.reachableBlock = {(r:Reachability!) -> Void in
                    let afnet = AFHTTPRequestOperationManager()
                    let param = ["to":token]
                    let url = Common.serverHost + "/App-Ucenter-userInfo"
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = true
                    afnet.responseSerializer.acceptableContentTypes = NSSet(array: ["text/html"]) as Set<NSObject>
                    afnet.POST(url, parameters: param, success: { (opration:AFHTTPRequestOperation!, res:AnyObject!) -> Void in
                        var resDictionary = res as! NSDictionary
                        var code = resDictionary["code"] as! Int
                        if code == -1 {
                            AlertView.alert("提示", message: "请登录后再使用", buttonTitle: "确定", viewController: self)
                        } else if code == 200 {
                            let data  = res["data"] as! NSDictionary
                            let proInfo = data.objectForKey("proInfo") as! NSDictionary
                            var totalAll = proInfo.objectForKey("total_all") as! NSString
                            var accountMoney = proInfo.objectForKey("account_money")  as! NSString
                            NSUserDefaults.standardUserDefaults().setObject(totalAll, forKey: "usermoney")
                            
                            NSUserDefaults.standardUserDefaults().setObject(accountMoney, forKey: "accountMoney")
                            
                            self.textLayer?.jumpNumberWithDuration(1, fromNumber: 0.0, toNumber: totalAll.floatValue)
                        }
                        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                        self.refreshControl?.endRefreshing()
                        self.refreshControl?.attributedTitle = NSAttributedString(string: "下拉刷新")
                        }) { (opration:AFHTTPRequestOperation!, error:NSError!) -> Void in
                            //loading.stopLoading()
                            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                            self.refreshControl?.endRefreshing()
                            self.refreshControl?.attributedTitle = NSAttributedString(string: "下拉刷新")
                            AlertView.alert("错误", message: error.localizedDescription, buttonTitle: "确定", viewController: self)
                    }

                }
                reach.startNotifier()
            }else{
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                self.refreshControl?.endRefreshing()
                self.refreshControl?.attributedTitle = NSAttributedString(string: "下拉刷新")
            }
        }
    }
    
    //跳到资产管理
    func toMoneyInfo(){
        if !Common.isLogin() {
            
            AlertView.alert("提示", message: "请登录后再访问", buttonTitle: "确定", viewController: self)
            
        } else {
            
            self.performSegueWithIdentifier("moneySegue", sender: nil)
        }
        
    }
    
    
    //跳转到账户信息页面
    func toAccountInfo(){
//        NSLog("跳转到账户信息页面")
        //判断是否有登录
        if !Common.isLogin() {
            
            AlertView.alert("提示", message: "请登录后再访问", buttonTitle: "确定", viewController: self)
            
        } else {
            
            var controller = self.storyboard?.instantiateViewControllerWithIdentifier("AccountInfoTableViewController") as! AccountInfoTableViewController
            controller.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(controller, animated: true)
        }
        
    }
    
    func loginBtn(){
        var view = self.storyboard?.instantiateViewControllerWithIdentifier("loginViewController") as! LoginViewController
        self.presentViewController(view, animated: true, completion: nil)
    }
    
    func refreshData(){
        var user = NSUserDefaults.standardUserDefaults()
        self.navigationItem.title = user.objectForKey("username") as? String
        //获取金额
        if let usermoney:NSString = user.objectForKey("usermoney") as? NSString {
            textLayer?.jumpNumberWithDuration(1, fromNumber: 0.0, toNumber: usermoney.floatValue)
        }

        
        if let headImage:NSData = user.objectForKey("headImage") as? NSData {
            //如果本地有保存图像，用本地的
            self.head.image = UIImage(data: headImage)
            return
        }
        var userpicUrl = user.objectForKey("headpic") as? String
        if (userpicUrl != nil) &&  !(userpicUrl!.isEmpty) {
            //如果本地没有保存图像，但是有图像地址，用远程的，并保存到本地
            //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                
                if let image = NSData(contentsOfURL: NSURL(string: userpicUrl!)!) {
                    self.head.image = UIImage(data: image)
                    user.setObject(image, forKey: "headImage")
                }
            //})
        }
        
    }
    
    //section的header高度
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0.1
        }
        if section == 1{
            return 10
        }
        if section == 2{
            return 10
        }
        return 10
    }
    
//    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        
//    }
    
    override func viewWillAppear(animated: Bool) {
        
        
        //检查是否登录，为登录即禁用页面交互
        if Common.isLogin(){
            self.navigationItem.rightBarButtonItem?.title = ""
            self.tableView.allowsSelection = true
            self.tableView.reloadData()
        }else{
            //                println("unsign")
            var barItem = UIBarButtonItem(title: "登录", style: UIBarButtonItemStyle.Plain, target: self, action: "loginBtn")
            self.navigationItem.rightBarButtonItem = barItem
            self.navigationItem.rightBarButtonItem?.tintColor = UIColor.whiteColor()
            self.tableView.allowsSelection = false
            self.tableView.reloadData()
        }
        
        
        
//        检查网络
        var reach = Reachability(hostName: Common.domain)
        reach.unreachableBlock = {(r:Reachability!)in
            dispatch_async(dispatch_get_main_queue(), {
                var alert = UIAlertController(title: "提示", message: "网络连接有问题，请检查网络是否连接", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "确定", style: .Cancel, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            })
        }
        reach.startNotifier()
        if let username = NSUserDefaults.standardUserDefaults().objectForKey("username") as? String{
            self.navigationItem.rightBarButtonItem?.title = ""
        }
        refreshData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var destinationViewController = segue.destinationViewController as! UIViewController
        destinationViewController.hidesBottomBarWhenPushed = true
    }
    
    //MARK:- 交互动画
//    func handlePopRecognizer(popRecognizer: UIScreenEdgePanGestureRecognizer) {
//        var progress = popRecognizer.translationInView(navigationController!.view).x / navigationController!.view.bounds.size.width
//        progress = min(1.0, max(0.0, progress))
//        
//        println("\(progress)")
//        if popRecognizer.state == UIGestureRecognizerState.Began {
//            println("Began")
//            self.interactivePopTransition = UIPercentDrivenInteractiveTransition()
//            self.navigationController!.popViewControllerAnimated(true)
//        } else if popRecognizer.state == UIGestureRecognizerState.Changed {
//            self.interactivePopTransition!.updateInteractiveTransition(progress)
//            //            updateWithPercent(progress)
//            println("Changed")
//        } else if popRecognizer.state == UIGestureRecognizerState.Ended || popRecognizer.state == UIGestureRecognizerState.Cancelled {
//            if progress > 0.5 {
//                self.interactivePopTransition!.finishInteractiveTransition()
//            } else {
//                self.interactivePopTransition!.cancelInteractiveTransition()
//            }
//            //            finishBy(progress < 0.5)
//            println("Ended || Cancelled")
//            self.interactivePopTransition = nil
//        }
//    }
//    // UINavigationControllerDelegate
//    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        //        if operation == UINavigationControllerOperation.Push {
//        navigationOperation = operation
//        return self
//        
//        //        }
//        //        return nil
//    }
//    
//    func navigationController(navigationController: UINavigationController, interactionControllerForAnimationController animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
//        if self.interactivePopTransition == nil {
//            return nil
//        }
//        return self.interactivePopTransition
//    }
//    
//    //UIViewControllerTransitioningDelegate
//    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
//        return 0.4
//    }
//    
//    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
//        let containerView = transitionContext.containerView()
//        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
//        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
//        
//        var destView: UIView!
//        var destTransform: CGAffineTransform!
//        var destAlpha = CGFloat(0.1)
//        if navigationOperation == UINavigationControllerOperation.Push {
//            containerView.insertSubview(toViewController!.view, aboveSubview: fromViewController!.view)
//            destView = toViewController!.view
////            destView.transform = CGAffineTransformMakeScale(0.1, 0.1)
////            destTransform = CGAffineTransformMakeScale(1, 1)
//            destView.alpha = 0.1
//            destAlpha = 1.0
//        } else if navigationOperation == UINavigationControllerOperation.Pop {
//            containerView.insertSubview(toViewController!.view, belowSubview: fromViewController!.view)
//            destView = fromViewController!.view
//            // 如果IDE是Xcode6 Beta4+iOS8SDK，那么在此处设置为0，动画将不会被执行(不确定是哪里的Bug)
////            destTransform = CGAffineTransformMakeScale(0.01, 0.01)
//            destAlpha = 0.1
//        }
//
//        UIView.animateWithDuration(
//            transitionDuration(transitionContext), animations: { () -> Void in
////                destView.transform = destTransform
//                 destView.alpha = destAlpha
//            }) { (completed) -> Void in
//                transitionContext.completeTransition(true)
//        }
//    }
    

    
}