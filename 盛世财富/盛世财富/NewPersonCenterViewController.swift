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

    @IBOutlet weak var moneyTickerLabel: ADTickerLabel!

    var ehttp = HttpController()
    var url = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        mainTable.dataSource = self
        mainTable.delegate = self
        //自适应字体大小
        //money.titleLabel!.adjustsFontSizeToFitWidth = true
//        self.navigationController?.navigationBar.barTintColor = UIColor(red: 54/255.0, green: 169/255.0, blue: 245/255.0, alpha: 1)
//        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
        
        head.layer.masksToBounds = true
        head.layer.cornerRadius = 25
        
        //点击个人头像，跳转到账户信息页面
        head.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "toAccountInfo"))
        
//        moneyTickerLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: ""))
        
    }
    
    
    //跳转到账户信息页面
    func toAccountInfo(){
        NSLog("跳转到账户信息页面")
        //判断是否有登录
        var info = NSUserDefaults.standardUserDefaults()
        if info.objectForKey("username") == nil {
            
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
        }else {
            self.navigationItem.title = "请登录"
        }
        if let usermoney:String = user.objectForKey("usermoney") as? String {
            //self.money.setTitle(usermoney, forState: UIControlState.Normal)
            moneyTickerLabel.font = UIFont(name: "", size: 50.0)
            self.moneyTickerLabel.text = usermoney
        }else {
            //self.money.setTitle(" - - ", forState: UIControlState.Normal)
            self.moneyTickerLabel.text = "0"
        }
//        if let headImage:NSData = user.objectForKey("headImage") as? NSData {
//            self.head.image = UIImage(data: headImage)
//        }else if let userpic:String = user.objectForKey("userpic") as? String {
//            if userpic.isEmpty == false {
//                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
//                    let image = NSData(contentsOfURL: NSURL(string: userpic as String)!)
//                    self.head.image = UIImage(data: image!)
//                    user.setObject(image, forKey: "headImage")
//                    //这里写需要大量时间的代码
//                    //                println("这里写需要大量时间的代码")
//                    
//                    dispatch_async(dispatch_get_main_queue(), {
//                        //这里返回主线程，写需要主线程执行的代码
//                        //                    println("这里返回主线程，写需要主线程执行的代码")
//                    })
//                    
//                })
//                let thread = NSThread(target: self, selector: "getHead:", object: userpic)
//                thread.start()
//            }
//        }else {
//            //放默认头像
//        }
        
        
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
    
    override func viewWillAppear(animated: Bool) {
//        var adt = ADTickerLabel(frame: CGRectMake(50, 50, 100, 20))
//        adt.text = "2551"
//        self.tableView.addSubview(adt)
        
        
        //检查是否登录，为登录即禁用页面交互
        if let username = NSUserDefaults.standardUserDefaults().objectForKey("username") as? String{
            self.navigationItem.rightBarButtonItem?.title = ""
            self.tableView.allowsSelection = true
        }else{
            //                println("unsign")
            var barItem = UIBarButtonItem(title: "登录", style: UIBarButtonItemStyle.Plain, target: self, action: "loginBtn")
            
            self.navigationItem.rightBarButtonItem = barItem
            
            self.tableView.allowsSelection = false
            
        }
        
        
        
//        检查网络
        var reach = Reachability(hostName: Constant.getDomain())
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
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == "capitalSegue" {
//            var info = NSUserDefaults.standardUserDefaults()
//            if info.objectForKey("username") == nil {
//                AlertView.alert("提示", message: "请登录后再访问", buttonTitle: "确定", viewController: self)
//                return
//            }
//        }
//    }
    
    
}