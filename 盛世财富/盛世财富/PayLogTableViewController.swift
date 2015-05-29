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
                var url = Common.serverHost + "/App-Pay-paylog"
                var token = NSUserDefaults.standardUserDefaults().objectForKey("token") as? String
                var params = ["to":token!]
                manager.responseSerializer.acceptableContentTypes = NSSet(array: ["text/html"]) as Set<NSObject>
                manager.POST(url, parameters: params,
                    success: { (op:AFHTTPRequestOperation!, data:AnyObject!) -> Void in
                        loading.stopLoading()
                        
                        var result = data as! NSDictionary
                        //NSLog("充值记录：%@", result)
                        var code = result["code"] as! Int
                        if code == -1 {
                            AlertView.alert("提示", message: "请登录后再使用", buttonTitle: "确定", viewController: self)
                        }else if code == 0 {
                            AlertView.alert("提示", message: "查询失败，请稍候再试", buttonTitle: "确定", viewController: self)
                        }else if code == 200 {
                            self.payLogArray = result["data"]?["list"] as? NSArray
                            var successMoneyTemp = result["data"]?["success_money"] as? NSString
                            var failMoneyTemp = result["data"]?["fail_money"] as? NSString
                            
                            if (successMoneyTemp == nil || successMoneyTemp!.length == 0) {
                                self.successMoney = "0.00"
                            } else {
                                self.successMoney = successMoneyTemp! as String
                            }
                            
                            if (failMoneyTemp == nil || failMoneyTemp!.length == 0) {
                                self.failMoney = "0.00"
                            } else {
                                self.failMoney = failMoneyTemp! as String
                            }
                            
                            if self.payLogArray?.count > 0 {
                                self.tableView.reloadData()
                            } else {
//                                var label = UILabel(frame: CGRectMake(0, 0, 100, 20))
//                                label.text = "没有记录"
//                                self.tableView.addSubview(label)
                            }
                            
                        }
                    },failure: { (op:AFHTTPRequestOperation!, error:NSError!) -> Void in
                        loading.stopLoading()
                        AlertView.alert("提示", message: "服务器错误", buttonTitle: "确定", viewController: self)
                    }
                )

                
            })
        }
      
        reach.startNotifier()
    }


    // MARK: - Table view data source
    
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
    
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        NSLog("viewForHeaderInSection")
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        //创建效果视图实例
        let blurView = UIVisualEffectView(effect: blurEffect)
        
        var header = UIView()
        header.frame = CGRectMake(0, 0, self.view.frame.width, 100)
        header.backgroundColor = UIColor.whiteColor()
        header.addSubview(blurView)
        
        var successMoneyLabel = UILabel()
        var failMoneyLabel = UILabel()
        successMoneyLabel.text = self.successMoney
        successMoneyLabel.frame = CGRectMake(15, 40, 100, 50)
        successMoneyLabel.textColor = UIColor.redColor()
        successMoneyLabel.font = UIFont(name: "Arial", size: 20)
        
        failMoneyLabel.text = self.failMoney
        failMoneyLabel.frame = CGRectMake(250, 40, 100, 50)
        failMoneyLabel.textColor = UIColor.grayColor()
        failMoneyLabel.font = UIFont(name: "Arial", size: 20)
        
        
        var l1 = UILabel()
        l1.text = "成功金额"
        l1.textColor = UIColor.grayColor()
        l1.font = UIFont(name: "Arial", size: 14)
        l1.frame = CGRectMake(15, 20, 100, 30)
        
        var l2 = UILabel()
        l2.text = "失败金额"
        l2.textColor = UIColor.grayColor()
        l2.font = UIFont(name: "Arial", size: 14)
        l2.frame = CGRectMake(250, 20, 100, 30)
        
        header.addSubview(successMoneyLabel)
        header.addSubview(failMoneyLabel)
        header.addSubview(l1)
        header.addSubview(l2)
        return header
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = payLogArray?.count {
            return count
        } else {
            
            return 0
        }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("payLogCell", forIndexPath: indexPath) as! UITableViewCell

        var moneyLabel = cell.viewWithTag(101) as! UILabel
        var statusLabel = cell.viewWithTag(102) as! UILabel
        var addTimeLabel = cell.viewWithTag(103) as! UILabel
        
        var cellData = self.payLogArray?[indexPath.row] as! NSDictionary
        moneyLabel.text = (cellData["money"] as? String)! + "元"
        statusLabel.text = cellData["status"] as? String
        var addTimeDouble = (cellData["add_time"] as? NSString)?.doubleValue
        addTimeLabel.text = Common.dateFromTimestamp(addTimeDouble!)
        
        return cell
    }
    
}
