//
//  InvestorSummaryTableViewController.swift
//  盛世财富
//  投资总表
//  Created by 云笺 on 15/5/16.
//  Copyright (c) 2015年 sscf88. All rights reserved.
//

import UIKit

class InvestorSummaryViewController: UITableViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var lab1: UILabel!
    @IBOutlet weak var lab2: UILabel!
    @IBOutlet weak var lab3: UILabel!
    @IBOutlet weak var lab4: UILabel!
    @IBOutlet weak var lab5: UILabel!
    @IBOutlet weak var lab6: UILabel!
    @IBOutlet weak var lab7: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        //下拉刷新
        var rc = UIRefreshControl()
        rc.attributedTitle = NSAttributedString(string: "下拉刷新")
        rc.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = rc
        
        loading.startLoading(self.tableView)
        
        //获取网络数据
        var manager = AFHTTPRequestOperationManager()
        var url = Constant.getServerHost() + "/App-Myinvest-summary"
        var params = ["to":NSUserDefaults.standardUserDefaults().objectForKey("token") as! NSString]
        NSLog("投资总表参数：%@", params)
        manager.responseSerializer.acceptableContentTypes = NSSet(array: ["text/html"]) as Set<NSObject>
        manager.POST(url, parameters: params,
            success: { (op:AFHTTPRequestOperation!, data:AnyObject!) -> Void in
                var result = data as! NSDictionary
                NSLog("投资总表：%@", result)
                var code = result["code"] as! Int
                if code == -1 {
                    AlertView.alert("提示", message: "请登录后再试", buttonTitle: "确定", viewController: self)
                }else if code == 0 {
                    AlertView.alert("提示", message: "您还没有投资", buttonTitle: "确定", viewController: self)
                }else if code == 200 {
                    var investInfo = result["data"] as! NSDictionary
                    var inving_count = investInfo["inving_count"] as! NSString
                    self.lab1.text = "\(inving_count)标"
                    
                    var recing_money = investInfo["recing_money"] as! NSString
                    var recing_count = investInfo["recing_count"] as! NSString
                    self.lab2.text = "¥\(recing_money)/\(recing_count)标"
                    
                    var reced_money = investInfo["reced_money"] as! NSInteger
                    var reced_count = investInfo["reced_count"] as! NSInteger
                    self.lab3.text = "¥\(reced_money)/\(reced_count)标"
                    
                    var overdue_money = investInfo["overdue_money"] as! NSString
                    var overdue_count = investInfo["overdue_count"] as! NSString
                    self.lab4.text = "¥\(overdue_money)/\(overdue_count)期"
                    
                    var himInvest = investInfo["himInvest"] as! NSString
                    self.lab5.text = "¥\(himInvest)"
                    
                    var total_invest = investInfo["total_invest"] as! NSString
                    self.lab6.text = "¥\(total_invest)"
                    
                    var total_income = investInfo["total_income"] as! NSInteger
                    self.lab7.text = "¥\(total_income)"
                    
                }
                
                loading.stopLoading()
                
            },failure:{ (op:AFHTTPRequestOperation!,error: NSError!) -> Void in
                loading.stopLoading()
                AlertView.alert("提示", message: "网络连接有问题，请检查手机网络", buttonTitle: "确定", viewController: self)
            }
        )
        
    }
    
    //刷新
    func refresh(){
        if self.refreshControl!.refreshing {
            self.refreshControl?.attributedTitle = NSAttributedString(string: "加载中...")
            getData()
        }
    }
    
    
    func getData(){
        //loading.startLoading(self.tableView)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        //获取网络数据
        var manager = AFHTTPRequestOperationManager()
        var url = Constant.getServerHost() + "/App-Myinvest-summary"
        var params = ["to":NSUserDefaults.standardUserDefaults().objectForKey("token") as! NSString]
        NSLog("投资总表参数：%@", params)
        manager.responseSerializer.acceptableContentTypes = NSSet(array: ["text/html"]) as Set<NSObject>
        manager.POST(url, parameters: params,
            success: { (op:AFHTTPRequestOperation!, data:AnyObject!) -> Void in
                //loading.stopLoading()
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                var result = data as! NSDictionary
                NSLog("投资总表：%@", result)
                var code = result["code"] as! Int
                if code == -1 {
                    AlertView.alert("提示", message: "请登录后再试", buttonTitle: "确定", viewController: self)
                }else if code == 0 {
                    AlertView.alert("提示", message: "您还没有投资", buttonTitle: "确定", viewController: self)
                }else if code == 200 {
                    var investInfo = result["data"] as! NSDictionary
                    var inving_count = investInfo["inving_count"] as! NSString
                    self.lab1.text = "\(inving_count)标"
                    
                    var recing_money = investInfo["recing_money"] as! NSString
                    var recing_count = investInfo["recing_count"] as! NSString
                    self.lab2.text = "¥\(recing_money)/\(recing_count)标"
                    
                    var reced_money = investInfo["reced_money"] as! NSInteger
                    var reced_count = investInfo["reced_count"] as! NSInteger
                    self.lab3.text = "¥\(reced_money)/\(reced_count)标"
                    
                    var overdue_money = investInfo["overdue_money"] as! NSString
                    var overdue_count = investInfo["overdue_count"] as! NSString
                    self.lab4.text = "¥\(overdue_money)/\(overdue_count)期"
                    
                    var himInvest = investInfo["himInvest"] as! NSString
                    self.lab5.text = "¥\(himInvest)"
                    
                    var total_invest = investInfo["total_invest"] as! NSString
                    self.lab6.text = "¥\(total_invest)"
                    
                    var total_income = investInfo["total_income"] as! NSInteger
                    self.lab7.text = "¥\(total_income)"
                    
                }
                
             
                self.refreshControl?.endRefreshing()
                self.refreshControl?.attributedTitle = NSAttributedString(string: "下拉刷新")
             
                
            },failure:{ (op:AFHTTPRequestOperation!,error: NSError!) -> Void in
                //loading.stopLoading()
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                AlertView.alert("提示", message: "网络连接有问题，请检查手机网络", buttonTitle: "确定", viewController: self)
                
            }
        )
    }

}

