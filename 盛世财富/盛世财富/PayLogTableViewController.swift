//
//  PayLogTableViewController.swift
//  盛世财富
//  充值记录
//  Created by 云笺 on 15/5/23.
//  Copyright (c) 2015年 sscf88. All rights reserved.
//

import UIKit

class PayLogTableViewController: UITableViewController,UITableViewDataSource,UITableViewDelegate {

    var payLogArray:NSArray?
    var failMoney:String?
    var successMoney:String?
    
    var timeLineUrl = Common.serverHost + "/App-Pay-paylog"
    var tmpListData: NSMutableArray = NSMutableArray()
    var listData: NSMutableArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.dataSource = self
        self.tableView.delegate = self
        //检查手机网络
        var reach = Reachability(hostName: Common.domain)
        reach.unreachableBlock = {(r:Reachability!) -> Void in
            //NSLog("网络不可用")
            dispatch_async(dispatch_get_main_queue(), {

                AlertView.alert("提示", message: "网络连接有问题，请检查手机网络", buttonTitle: "确定", viewController: self)
            })
        }
        
        reach.reachableBlock = {(r:Reachability!) -> Void in
           //NSLog("网络可用")
            dispatch_async(dispatch_get_main_queue(), {
                loading.startLoading(self.tableView)
                var manager = AFHTTPRequestOperationManager()
//                var url = Common.serverHost + "/App-Pay-paylog"
                var token = NSUserDefaults.standardUserDefaults().objectForKey("token") as? String
                var params = ["to":token!]
                manager.responseSerializer.acceptableContentTypes = NSSet(array: ["text/html"]) as Set<NSObject>
                manager.POST(self.timeLineUrl, parameters: params,
                    success: { (op:AFHTTPRequestOperation!, data:AnyObject!) -> Void in
                        loading.stopLoading()
                        
                        var result = data as! NSDictionary
//                        NSLog("充值记录：%@", result)
                        var code = result["code"] as! Int
                        println(code)
                        if code == -1 {
                            AlertView.alert("提示", message: "请登录后再使用", buttonTitle: "确定", viewController: self)
                        }else if code == 0 {
                            AlertView.alert("提示", message: "查询失败，请稍候再试", buttonTitle: "确定", viewController: self)
                        }else if code == 200 {
                            if let list = result["data"]?["list"] as? NSMutableArray {
                                self.tmpListData = list
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
                                
                                
                                if self.tmpListData.count > 0 {
                                    self.tableView.reloadData()
                                    
                                } else {
                                    
                                    
                                    //                                var label = UILabel(frame: CGRectMake(0, 0, 100, 20))
                                    //                                label.text = "没有记录"
                                    //                                self.tableView.addSubview(label)
                                }
                                
                            }else{
//
                            }
                            EmptyView.showEmptyView(self.view)
                        }
                        
                    },failure: { (op:AFHTTPRequestOperation!, error:NSError!) -> Void in
                        loading.stopLoading()
                        AlertView.alert("提示", message: "服务器错误", buttonTitle: "确定", viewController: self)
                    }
                )

                
            })
        }
      
        reach.startNotifier()
        setupRefresh()
    }

    //为table添加下拉刷新和上拉加载功能
    func setupRefresh(){
        let user = NSUserDefaults.standardUserDefaults()
        //下拉刷新
        self.tableView.addHeaderWithCallback({
            //println("下拉刷新")
            var params = ["to":user.objectForKey("token") as! String]
            var manager = AFHTTPRequestOperationManager()
            manager.responseSerializer.acceptableContentTypes = NSSet(array: ["text/html"]) as Set<NSObject>
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            manager.POST(self.timeLineUrl, parameters: params,
                success: { (op:AFHTTPRequestOperation!, data:AnyObject!) -> Void in
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    var result:NSDictionary = data as! NSDictionary
                    //println(result)
                    if let list = result["data"]?.valueForKey("list") as? NSMutableArray {
                        self.listData = list
                    }
                    self.tableView.reloadData()
                    self.tableView.headerEndRefreshing()
                    
                },
                failure:{ (op:AFHTTPRequestOperation!,error:NSError!) -> Void in
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    self.tableView.headerEndRefreshing()
                    AlertView.alert("提示", message: "服务器错误", buttonTitle: "确定", viewController: self)
                }
            )
        })
        
        //上拉加载
        self.tableView.addFooterWithCallback({
            //记录最后一个[标的]的ID号码
            var borrow_id = 0
            
            var count = self.listData.count
            if count > 0 {
                borrow_id = (self.listData[count - 1].valueForKey("id") as! NSString).integerValue
            }
            //            NSLog("最后一个[标的]的ID号码:%i", borrow_id)
            var params = ["to":user.objectForKey("token") as! String,"lastId":borrow_id]
            var manager = AFHTTPRequestOperationManager()
            manager.responseSerializer.acceptableContentTypes = NSSet(array: ["text/html"]) as Set<NSObject>
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            manager.POST(self.timeLineUrl, parameters: params,
                success: { (op:AFHTTPRequestOperation!, data:AnyObject!) -> Void in
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    
                    var result:NSDictionary = data as! NSDictionary
                    self.tableView.footerEndRefreshing()
                    var d = result.valueForKey("data") as! NSDictionary
                    if let list = d.valueForKey("list") as? NSMutableArray {
                        self.tmpListData = list //list数据
                        //self.mainTable.reloadData()
                        
                        
                        var newList = NSMutableArray()
                        if self.listData.count > 0 {
                            newList.addObjectsFromArray(self.listData as [AnyObject])
                        }
                        if(self.tmpListData.count > 0){
                            newList.addObjectsFromArray(self.tmpListData as [AnyObject])
                        }
                        
                        self.listData = newList
                        self.tableView.reloadData()
                        self.tmpListData = NSMutableArray()
                    }else{
                        AlertView.alert("提示", message: "没有更多数据了！", buttonTitle: "确定", viewController: self)
                    }
                },
                failure:{ (op:AFHTTPRequestOperation!,error:NSError!) -> Void in
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    self.tableView.footerEndRefreshing()
                    AlertView.alert("提示", message: "服务器错误", buttonTitle: "确定", viewController: self)
                }
            )
        })
    }


    // MARK: - Table view data source
    
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
    
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        //NSLog("viewForHeaderInSection")
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        //创建效果视图实例
        let blurView = UIVisualEffectView(effect: blurEffect)
        
        var header = UIView()
        header.frame = CGRectMake(0, 0, self.view.frame.width, 100)
        header.backgroundColor = UIColor.whiteColor()
        header.addSubview(blurView)
        
        
        var l1 = UILabel()
        l1.text = "成功金额"
        l1.textColor = UIColor.grayColor()
        l1.font = UIFont(name: "Arial", size: 14)
        //l1.frame = CGRectMake(15, 20, 100, 30)
        l1.sizeToFit()
        l1.setTranslatesAutoresizingMaskIntoConstraints(false)
        l1.textAlignment = NSTextAlignment.Center
        header.addSubview(l1)
        var l1Constraint = NSLayoutConstraint(item: l1, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: header, attribute: NSLayoutAttribute.Width, multiplier: 0.5, constant: 0)
        header.addConstraint(l1Constraint)

        l1Constraint = NSLayoutConstraint(item: l1, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: header, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 30)
        header.addConstraint(l1Constraint)
        
        var l2 = UILabel()
        l2.text = "失败金额"
        l2.textColor = UIColor.grayColor()
        l2.font = UIFont(name: "Arial", size: 14)
        //l2.frame = CGRectMake(250, 20, 100, 30)
        l2.sizeToFit()
        l2.setTranslatesAutoresizingMaskIntoConstraints(false)
        l2.textAlignment = NSTextAlignment.Center
        header.addSubview(l2)
        var l2Constraint = NSLayoutConstraint(item: l2, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: header, attribute: NSLayoutAttribute.Width, multiplier: 0.5, constant: 0)
        header.addConstraint(l2Constraint)
        l2Constraint = NSLayoutConstraint(item: l2, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: l1, attribute: NSLayoutAttribute.Trailing, multiplier: 1.0, constant: 0)
        header.addConstraint(l2Constraint)
        l2Constraint = NSLayoutConstraint(item: l2, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: header, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 30)
        header.addConstraint(l2Constraint)

        
        
        
        var successMoneyLabel = UILabel()
        successMoneyLabel.text = self.successMoney
        //successMoneyLabel.frame = CGRectMake(15, 40, 100, 50)
        successMoneyLabel.textColor = UIColor.redColor()
        successMoneyLabel.font = UIFont(name: "Arial", size: 20)
        successMoneyLabel.sizeToFit()
        successMoneyLabel.textAlignment = NSTextAlignment.Center
        successMoneyLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        header.addSubview(successMoneyLabel)
        
        var sConstraint = NSLayoutConstraint(item: successMoneyLabel, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: l1, attribute: NSLayoutAttribute.Width, multiplier: 1.0, constant: 0)
        header.addConstraint(sConstraint)
        
        sConstraint = NSLayoutConstraint(item: successMoneyLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: l1, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 10)
        header.addConstraint(sConstraint)
        sConstraint = NSLayoutConstraint(item: successMoneyLabel, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: header, attribute: NSLayoutAttribute.Leading, multiplier: 1.0, constant: 0)
        header.addConstraint(sConstraint)
        
        
        
        
        var failMoneyLabel = UILabel()
        failMoneyLabel.text = self.failMoney
        //failMoneyLabel.frame = CGRectMake(250, 40, 100, 50)
        failMoneyLabel.textColor = UIColor.grayColor()
        failMoneyLabel.font = UIFont(name: "Arial", size: 20)
        failMoneyLabel.textAlignment = NSTextAlignment.Center
        failMoneyLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        header.addSubview(failMoneyLabel)
        
        var fConstraint = NSLayoutConstraint(item: failMoneyLabel, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: l2, attribute: NSLayoutAttribute.Width, multiplier: 1.0, constant: 0)
        header.addConstraint(fConstraint)
        
        fConstraint = NSLayoutConstraint(item: failMoneyLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: l2, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 10)
        header.addConstraint(fConstraint)
        
        fConstraint = NSLayoutConstraint(item: failMoneyLabel, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: successMoneyLabel, attribute: NSLayoutAttribute.Trailing, multiplier: 1.0, constant: 0)
        header.addConstraint(fConstraint)

        
        
        return header
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        if(self.listData.count == 0){
            
            if(self.tmpListData.count != 0){
                
                self.listData = self.tmpListData
            }
        }
        return listData.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("payLogCell", forIndexPath: indexPath) as! UITableViewCell

        var moneyLabel = cell.viewWithTag(101) as! UILabel
        var statusLabel = cell.viewWithTag(102) as! UILabel
        var addTimeLabel = cell.viewWithTag(103) as! UILabel
        if self.listData.count > 0 {
            var cellData = self.listData[indexPath.row] as! NSDictionary
            moneyLabel.text = (cellData["money"] as? String)! + "元"
            statusLabel.text = cellData["status"] as? String
            var addTimeDouble = (cellData["add_time"] as? NSString)?.doubleValue
            addTimeLabel.text = Common.dateFromTimestamp(addTimeDouble!)
        }else{
            
        }
        return cell
    }
    
}
