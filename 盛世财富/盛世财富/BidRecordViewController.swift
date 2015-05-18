//
//  BidRecordViewController.swift
//  盛世财富
//  投标记录
//  Created by 肖典 on 15/5/16.
//  Copyright (c) 2015年 sscf88. All rights reserved.
//

import Foundation
import UIKit
class BidRecordViewController:UITableViewController,UITableViewDataSource,UITableViewDelegate {
    
    var data:NSMutableArray = NSMutableArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        if let token = NSUserDefaults.standardUserDefaults().objectForKey("token") as? String {
            loading.startLoading(self.view)
            self.tableView.scrollEnabled = false
            let afnet = AFHTTPRequestOperationManager()
            let url = Constant.getServerHost() + "/App-Myinvest-getAllTending"
            let param = ["to":token]
            
            afnet.POST(url, parameters: param, success: { (opration:AFHTTPRequestOperation!, res:AnyObject!) -> Void in
                NSLog("投标记录：%@",res as! NSDictionary)
                
                if let d = res["data"] as? NSMutableArray{
                    self.data = d
                    self.tableView.reloadData()
                }

                
                loading.stopLoading()
                self.tableView.scrollEnabled = true
                }, failure: { (opration:AFHTTPRequestOperation!, error:NSError!) -> Void in
                    AlertView.alert("错误", message: error.localizedDescription, buttonTitle: "确定", viewController: self)
                    self.tableView.reloadData()
                    loading.stopLoading()
                    self.tableView.scrollEnabled = true
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "投标记录"
        }
        return ""
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("list")  as! UITableViewCell
        var name = cell.contentView.viewWithTag(100) as! UILabel
        var time = cell.contentView.viewWithTag(101) as! UILabel
        var money = cell.contentView.viewWithTag(102) as! UILabel
        var row = indexPath.row
        if data.count > 0{
//            println(data[row])
            name.text = data[row].valueForKey("borrow_name") as? String
            
            var timeNumber = data[row].valueForKey("borrow_time") as! NSString
            var interval = timeNumber.doubleValue
            var date = NSDate(timeIntervalSince1970: interval)
            var formatter = NSDateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            time.text = formatter.stringFromDate(date)
            
            money.text = data[row].objectForKey("investor_capital") as? String
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if data.count > 0 {
            return data.count
        }
        return 20
    }
}