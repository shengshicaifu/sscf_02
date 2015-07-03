//
//  PayLogTableViewController.swift
//  盛世财富
//  充值记录
//  Created by 云笺 on 15/5/23.
//  Copyright (c) 2015年 sscf88. All rights reserved.
//

import UIKit
/**
*  交易记录，包括充值和提现
*/
class PayLogTableViewController: UITableViewController,UITableViewDataSource,UITableViewDelegate {

    var payLogArray:NSArray?
    var failMoney:String?
    var successMoney:String?
    
    var paylogUrl = Common.serverHost + "/App-Pay-paylog"//充值
    var withDrawLogUrl = Common.serverHost + "/App-Ucenter-withDrawLog"//提现

    var listData: NSMutableArray = NSMutableArray()
    var choose = UISegmentedControl(items: ["充值记录","提现记录"])
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.dataSource = self
        self.tableView.delegate = self
    
        choose.frame = CGRectMake(0, 0, 130, 30)
        choose.selectedSegmentIndex = 0
        choose.addTarget(self, action: "choosed:", forControlEvents: UIControlEvents.ValueChanged)
        self.navigationItem.titleView = choose

        self.getData("0")
        setupRefresh()
    }
    
    //选择充值，提现
    func choosed(seg:UISegmentedControl){
        self.getData("0")
    }

    //为table添加下拉刷新和上拉加载功能
    func setupRefresh(){
        let user = NSUserDefaults.standardUserDefaults()
        //下拉刷新
        self.tableView.addHeaderWithCallback({
            self.getData("1")
        })
        
        //上拉加载
        self.tableView.addFooterWithCallback({
            self.getData("2")
        })
    }

    //MARK:- 获取数据
    
    /**
    获取数据
    :param: actionType actionType 0:进入页面
    1:下拉刷新
    2:上拉加载
    */
    func getData(actionType:String){
        
        
        //检查手机网络
        var reach = Reachability(hostName: Common.domain)
        reach.unreachableBlock = {(r:Reachability!) -> Void in
            //NSLog("网络不可用")
            dispatch_async(dispatch_get_main_queue(), {
                if actionType == "1" {
                    self.tableView.headerEndRefreshing()
                }else if actionType == "2" {
                    self.tableView.footerEndRefreshing()
                }
                AlertView.alert("提示", message: "网络连接有问题，请检查网络是否连接", buttonTitle: "确定", viewController: self)
            })
        }
        
        reach.reachableBlock = {(r:Reachability!) -> Void in
            //NSLog("网络可用")
            dispatch_async(dispatch_get_main_queue(), {
                if self.choose.selectedSegmentIndex == 0 {
                    if actionType == "0" {
                        loading.startLoading(self.tableView)
                    }else{
                        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
                    }
                    
                    var manager = AFHTTPRequestOperationManager()
                    var token = NSUserDefaults.standardUserDefaults().objectForKey("token") as! String
                    var params = ["to":token]
                    if actionType == "2"{
                        var borrow_id = 0
                        var count = self.listData.count
                        if count > 0 {
                            borrow_id = (self.listData[count - 1].valueForKey("id") as! NSString).integerValue
                        }
                        params = ["to":token,"lastId":"\(borrow_id)"]
                    }
                    
                    manager.responseSerializer.acceptableContentTypes = NSSet(array: ["text/html"]) as Set<NSObject>
                    manager.POST(self.paylogUrl, parameters: params,
                        success: { (op:AFHTTPRequestOperation!, data:AnyObject!) -> Void in
                            if actionType == "0" {
                                loading.stopLoading()
                            }else if actionType == "1" {
                                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                                self.tableView.headerEndRefreshing()
                            }else if actionType == "2" {
                                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                                self.tableView.footerEndRefreshing()
                            }
                            
                            var result = data as! NSDictionary
                            //NSLog("充值返回结果%@", result)
                            var code = result["code"] as! Int
                            if code == -1 {
                                AlertView.alert("提示", message: "请登录后再使用", buttonTitle: "确定", viewController: self)
                            }else if code == 0 {
                                AlertView.alert("提示", message: "查询失败，请稍候再试", buttonTitle: "确定", viewController: self)
                            }else if code == 200 {
                                if let array = result["data"]?["list"] as? NSArray {
                                    if(actionType == "0" || actionType == "1"){
                                        self.listData.removeAllObjects()
                                    }
                                    self.listData.addObjectsFromArray(array as [AnyObject])
                                    self.tableView.reloadData()
                                    if let successMoneyTemp = result["data"]?["success_money"] as? String {
                                        self.successMoney = successMoneyTemp
                                    }else{
                                        self.successMoney = "0.00"
                                    }
                                    if let failMoneyTemp = result["data"]?["fail_money"] as? String{
                                        self.failMoney = failMoneyTemp
                                    }else{
                                        self.failMoney = "0.00"
                                    }
                                }else{
                                    if actionType != "2" {
                                        self.listData.removeAllObjects()
                                        self.tableView.reloadData()
                                    }
                                }
                            }
                            
                        },failure: { (op:AFHTTPRequestOperation!, error:NSError!) -> Void in
                            if actionType == "0" {
                                loading.stopLoading()
                            }else if actionType == "1" {
                                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                                self.tableView.headerEndRefreshing()
                            }else if actionType == "2" {
                                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                                self.tableView.footerEndRefreshing()
                            }
                            
                            AlertView.alert("提示", message: "服务器错误", buttonTitle: "确定", viewController: self)
                        }
                    )
                }
                else if self.choose.selectedSegmentIndex == 1 {
                    if actionType == "0" {
                        loading.startLoading(self.tableView)
                    }else{
                        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
                    }
                    
                    var manager = AFHTTPRequestOperationManager()
                    var token = NSUserDefaults.standardUserDefaults().objectForKey("token") as! String
                    var params = ["to":token]
                    if actionType == "2"{
                        var borrow_id = 0
                        var count = self.listData.count
                        if count > 0 {
                            borrow_id = (self.listData[count - 1].valueForKey("id") as! NSString).integerValue
                        }
                        params = ["to":token,"lastId":"\(borrow_id)"]
                    }
                    //NSLog("提现url = %@",self.withDrawLogUrl)
                    //NSLog("提现params = %@", params)
                    manager.responseSerializer.acceptableContentTypes = NSSet(array: ["text/html"]) as Set<NSObject>
                    manager.POST(self.withDrawLogUrl, parameters: params,
                        success: { (op:AFHTTPRequestOperation!, data:AnyObject!) -> Void in
                            if actionType == "0" {
                                loading.stopLoading()
                            }else if actionType == "1" {
                                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                                self.tableView.headerEndRefreshing()
                            }else if actionType == "2" {
                                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                                self.tableView.footerEndRefreshing()
                            }
                            
                            var result = data as! NSDictionary
                            //NSLog("提现返回结果%@", result)
                            var code = result["code"] as! Int
                            if code == -1 {
                                AlertView.alert("提示", message: "请登录后再使用", buttonTitle: "确定", viewController: self)
                            }else if code == 0 {
                                AlertView.alert("提示", message: "查询失败，请稍候再试", buttonTitle: "确定", viewController: self)
                            }else if code == 200 {
                                if let array = result["data"]?["list"] as? NSArray {
                                    if(actionType == "0" || actionType == "1"){
                                        self.listData.removeAllObjects()
                                    }
                                    self.listData.addObjectsFromArray(array as [AnyObject])
                                    self.tableView.reloadData()
                                }else{
                                    if actionType != "2" {
                                        self.listData.removeAllObjects()
                                        self.tableView.reloadData()
                                    }
                                }
                            }
                            
                        },failure: { (op:AFHTTPRequestOperation!, error:NSError!) -> Void in
                            if actionType == "0" {
                                loading.stopLoading()
                            }else if actionType == "1" {
                                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                                self.tableView.headerEndRefreshing()
                            }else if actionType == "2" {
                                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                                self.tableView.footerEndRefreshing()
                            }
                            
                            AlertView.alert("提示", message: error.localizedDescription, buttonTitle: "确定", viewController: self)
                        }
                    )
                }

            })
        }
        reach.startNotifier()
    }

    // MARK: - Table view data source
    
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }

    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return listData.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("payLogCell", forIndexPath: indexPath) as! UITableViewCell
        if self.choose.selectedSegmentIndex == 0 {
            var moneyLabel = cell.viewWithTag(101) as! UILabel
            var statusLabel = cell.viewWithTag(102) as! UILabel
            var addTimeLabel = cell.viewWithTag(103) as! UILabel
            if self.listData.count > 0 {
                var cellData = self.listData[indexPath.row] as! NSDictionary
                moneyLabel.text = (cellData["money"] as? String)! + "元"
                statusLabel.text = cellData["status"] as? String
                var addTimeDouble = (cellData["add_time"] as? NSString)?.doubleValue
                addTimeLabel.text = Common.dateFromTimestamp(addTimeDouble!)
            }
        }else {
            var moneyLabel = cell.viewWithTag(101) as! UILabel
            var statusLabel = cell.viewWithTag(102) as! UILabel
            var addTimeLabel = cell.viewWithTag(103) as! UILabel
            if self.listData.count > 0 {
                var cellData = self.listData[indexPath.row] as! NSDictionary
                var money = cellData["withdraw_allmoney"] as? Double
                moneyLabel.text = "\(money!)元"
                statusLabel.text = cellData["status"] as? String
                var addTimeDouble = (cellData["add_time"] as? NSString)?.doubleValue
                addTimeLabel.text = Common.dateFromTimestamp(addTimeDouble!)
            }
        }
        
        return cell
    }
    
}
