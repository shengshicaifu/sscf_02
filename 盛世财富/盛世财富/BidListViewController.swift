//
//  BidListViewController.swift
//  盛世财富
//  投资人列表
//  Created by xiao on 15-3-30.
//  Copyright (c) 2015年 sscf88. All rights reserved.
//

import Foundation

import UIKit

class BidListViewController: UITableViewController,UITableViewDataSource,UITableViewDelegate{


    
    var investorArray:NSArray?//投资人信息
    var bidId:String?//标的id
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        loading.startLoading(self.view)
        self.tableView.scrollEnabled = false
        //获取投资人列表信息
        var manager = AFHTTPRequestOperationManager()
        var url = Common.serverHost + "/App-Invest-investorList"
        var params = ["bid":bidId!]
        manager.responseSerializer.acceptableContentTypes = NSSet(array: ["text/html"]) as Set<NSObject>
        manager.GET(url, parameters: params,
            success: {(operation:AFHTTPRequestOperation!,data:AnyObject!)in
                loading.stopLoading()
                self.tableView.scrollEnabled = true
                var result:NSDictionary = data as! NSDictionary
                if (result["code"] as? Int) == 200 {
                    self.investorArray = result["data"] as? NSArray
                    self.tableView.reloadData()
                }
                 //NSLog("投资人信息:%@", self.investorArray!)
            },
            failure: {(operation:AFHTTPRequestOperation!,error:NSError!)in
                NSLog("获取投资人失败:%@",error)
                AlertView.alert("提示", message: "网络连接有问题，请检查手机网络", buttonTitle: "确定", viewController: self)
                loading.stopLoading()
                self.tableView.scrollEnabled = true
            }
        )
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let count = investorArray?.count{
            return count
        }else{
            return 0
        }
    }
  
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("list") as! UITableViewCell
        
        //NSLog("单元格数据:%@", (investorArray?[indexPath.row] as! NSDictionary))
        
        if let cellData = investorArray?[indexPath.row] as? NSDictionary {
            var userNameLabel = cell.contentView.viewWithTag(101) as! UILabel
            var name = cellData["user_name"] as! NSString
            name = name.substringFromIndex(3)
            userNameLabel.text = (name as String)+"***"
            var investorCapitalLabel = cell.contentView.viewWithTag(102) as! UILabel
            investorCapitalLabel.text = cellData["investor_capital"] as? String
            
            var addTimeLabel = cell.contentView.viewWithTag(103) as! UILabel
            
            var interval = (cellData["add_time"] as! NSString).doubleValue
            var date = NSDate(timeIntervalSince1970: interval)
            var formatter = NSDateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            addTimeLabel.text = formatter.stringFromDate(date)
            
            var indexLabel = cell.contentView.viewWithTag(104) as! UILabel
            indexLabel.text = "\(indexPath.row+1)"
            
        }
        
        
        return cell
    }

}

