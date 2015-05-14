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
        
        //获取投资人列表信息
        var manager = AFHTTPRequestOperationManager()
        var url = "http://www.sscf88.com/App-Invest-investorList"
        var params = ["bid":bidId!]
        manager.GET(url, parameters: params,
            success: {(operation:AFHTTPRequestOperation!,data:AnyObject!)in
               
                var result:NSDictionary = data as! NSDictionary
                if (result["code"] as? Int) == 200 {
                    self.investorArray = result["data"] as? NSArray
                    self.tableView.reloadData()
                }
                 //NSLog("投资人信息:%@", self.investorArray!)
            },
            failure: {(operation:AFHTTPRequestOperation!,error:NSError!)in
                NSLog("获取投资人失败:%@",error)
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
            userNameLabel.text = cellData["user_name"] as? String
            
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

