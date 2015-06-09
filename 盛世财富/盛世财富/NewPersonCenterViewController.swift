//
//  NewPersonCenterViewController.swift
//  盛世财富
//  我的账号
//  Created by 肖典 on 15/5/6.
//  Copyright (c) 2015年 sscf88. All rights reserved.
//

import Foundation
import UIKit
class NewPersonCenterViewController:UITableViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var mainTable: UITableView!
    @IBOutlet weak var head: UIImageView!

    @IBOutlet weak var moneyView: UIView!
    var textLayer:CACustomTextLayer?

    var ehttp = HttpController()
    var url = ""
    override func viewDidLoad() {
        super.viewDidLoad()
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
        moneyView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "toMoneyInfo"))
        
       // println("textLayer  x:\(textLayer?.frame.origin.x) y\(textLayer?.frame.origin.y) width\(textLayer?.frame.width) height\(textLayer?.frame.height)")
        //println("moneyView  x:\(moneyView?.frame.origin.x) y\(moneyView?.frame.origin.y) width\(moneyView?.frame.width) height\(moneyView?.frame.height)")
        
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
                let afnet = AFHTTPRequestOperationManager()
                let param = ["to":token]
                let url = Common.serverHost + "/App-Ucenter-userInfo"
                //loading.startLoading(self.tableView)
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
                        
                        self.textLayer?.jumpNumberWithDuration(1, fromNumber: 0.0, toNumber: accountMoney.floatValue)
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
            else{
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
            self.navigationController?.pushViewController(controller, animated: true)
        }
        
    }
    
    func loginBtn(){
        var view = self.storyboard?.instantiateViewControllerWithIdentifier("loginViewController") as! LoginViewController
        self.presentViewController(view, animated: true, completion: nil)
    }
    
    func refreshData(){
        var user = NSUserDefaults.standardUserDefaults()
        if let username:String = user.objectForKey("username") as? String {
            self.navigationItem.title = username
            
                
            //获取金额
            if let usermoney:NSString = user.objectForKey("accountMoney") as? NSString {
                textLayer?.jumpNumberWithDuration(1, fromNumber: 0.0, toNumber: usermoney.floatValue)
            }

            
            if let headImage:NSData = user.objectForKey("headImage") as? NSData {
                //如果本地有保存图像，用本地的
                self.head.image = UIImage(data: headImage)
            }else if let userpic:String = user.objectForKey("userpic") as? String {
                //如果本地没有保存图像，但是有图像地址，用远程的，并保存到本地
                if userpic.isEmpty == false {
                
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                        
                        if let image = NSData(contentsOfURL: NSURL(string: userpic as String)!) {
                            self.head.image = UIImage(data: image)
                            user.setObject(image, forKey: "headImage")
                            
                        }
                        
                    })
                }
            }
            
        }else {
            self.navigationItem.title = "请登录"
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
   
    
    func getHead(sender:String){
        
        
        
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
                var alert = UIAlertController(title: "提示", message: "网络连接有问题，请检查手机网络", preferredStyle: .Alert)
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
}