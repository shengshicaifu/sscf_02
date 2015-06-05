//
//  NewsTableViewController.swift
//  盛世财富
//
//  Created by 莫文琼 on 15/6/2.
//  Copyright (c) 2015年 sscf88. All rights reserved.
//

import UIKit

class NewsTableViewController: UITableViewController,UITableViewDataSource,UITableViewDelegate {
    var tmpListData: NSMutableArray = NSMutableArray()//临时数据  下拉添加
    var ehttp = HttpController()
    var url = ""
    var count:String = "5"
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.setupRefresh()
        self.getDate("0")
        
//        //下拉刷新---------------------------
//        var rc = UIRefreshControl()
//        rc.attributedTitle = NSAttributedString(string: "下拉刷新")
//        rc.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
//        self.refreshControl = rc
//       
    }
    /**
    下拉刷新和上拉加载
    */
    func setupRefresh(){
        self.tableView.addHeaderWithCallback({
           self.getDate("1")
        })
        self.tableView.addFooterWithCallback(){
           self.getDate("2")
        }
    }

    /**
    获取数据
    
    :param: actionType 操作类型
    0:进入页面获取数据
    1:下拉刷新获取数据
    */
    
    func getDate(actionType:String){
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            if let token = NSUserDefaults.standardUserDefaults().objectForKey("token") as? String {
                if actionType == "0" {
                    loading.startLoading(self.view)
                }else{
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = true
                }
                
                
                self.tableView.scrollEnabled = false
                let afnet = AFHTTPRequestOperationManager()
                let param = ["to":token]
                let url = Common.serverHost + "/App-Message"
                afnet.responseSerializer.acceptableContentTypes = NSSet(array: ["text/html"]) as Set<NSObject>
                afnet.POST(url, parameters: param, success: { (opration:AFHTTPRequestOperation!, res:AnyObject!) -> Void in
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    var resDictionary = res as! NSDictionary
//                    var dataNSArray = resDictionary["data"] as? NSArray
                    var code = resDictionary["code"] as! Int
                    //println(resDictionary)
                    //println(code)
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
            }else {
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                self.refreshControl?.endRefreshing()
                self.refreshControl?.attributedTitle = NSAttributedString(string: "下拉刷新")
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tmpListData.count > 0 {
            return tmpListData.count
        }
            return 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("newsCell") as! UITableViewCell
        var titleLabel = cell.viewWithTag(101) as! UILabel
        var msgLabel = cell.viewWithTag(102) as! UILabel
        var sendTimeLabel = cell.viewWithTag(103) as! UILabel
        var hasRead = cell.viewWithTag(104)   as! UILabel
        if tmpListData.count > 0{
            var messageTitle = tmpListData[indexPath.row].objectForKey("title") as! String
            titleLabel.text = messageTitle
            var messageMsg = tmpListData[indexPath.row].objectForKey("msg") as! String
            msgLabel.text = messageMsg
            var sendTime = tmpListData[indexPath.row].objectForKey("send_time") as! NSString
            var sendTimeDouble = sendTime.doubleValue
            var fomartTime = Common.dateFromTimestamp(sendTimeDouble)
            sendTimeLabel.text = fomartTime
            var has_read = tmpListData[indexPath.row].objectForKey("has_read") as! String
            switch has_read{
            case "0":
                hasRead.text = "未读"
                break
            case "1":
                hasRead.text = "已读"
                break
            default:
                hasRead.text = "全部"
                break
            }
                
            
    }
        return cell
    }


}
