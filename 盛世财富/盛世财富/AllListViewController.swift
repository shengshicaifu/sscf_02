//
//  AllListViewController.swift
//  盛世财富
//
//  Created by xiao on 15-3-16.
//  Copyright (c) 2015年 sscf88. All rights reserved.
//


import UIKit

class AllListViewController: UIViewController ,UITableViewDataSource,UITableViewDelegate,HttpProtocol{
    var eHttp: HttpController = HttpController()
    var base: baseClass = baseClass()
    var timeLineUrl = "http://www.sscf88.com/app-invest-content"
    var tmpListData: NSMutableArray = NSMutableArray()
    var listData: NSMutableArray = NSMutableArray()
    var page = 1 //page
    var imageCache = Dictionary<String,UIImage>()
    var tid: String = ""
    var sign: String = ""
    var isCheck: String = ""
    let refreshControl = UIRefreshControl()
    
    
    
    
    @IBOutlet weak var mainTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        eHttp.delegate = self
        eHttp.get(self.timeLineUrl,viewContro : self)
        self.setupRefresh()
        
    }
    //Refresh func
    func setupRefresh(){
        self.mainTable.addHeaderWithCallback({
            let delayInSeconds:Int64 =  1000000000  * 2
            var popTime:dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW,delayInSeconds)
            dispatch_after(popTime, dispatch_get_main_queue(), {
                self.mainTable.reloadData()
                self.mainTable.headerEndRefreshing()
            })
        })
        
                self.mainTable.addFooterWithCallback({
                    var nextPage = String(self.page + 1)
                    var tmpTimeLineUrl = self.timeLineUrl + "&page=" + nextPage as NSString
                    self.eHttp.delegate = self
                    self.eHttp.get(tmpTimeLineUrl,viewContro :self)
                    let delayInSeconds:Int64 = 1000000000 * 2
                    var popTime:dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW,delayInSeconds)
                    dispatch_after(popTime, dispatch_get_main_queue(), {
                        self.mainTable.footerEndRefreshing()
                        if(self.tmpListData != self.listData){
                            if(self.tmpListData.count != 0){
                                var tmpListDataCount = self.tmpListData.count
                                for(var i:Int = 0; i < tmpListDataCount; i++){
                                    self.listData.addObject(self.tmpListData[i])
                                }
                            }
                            self.mainTable.reloadData()
                            self.tmpListData.removeAllObjects()
                        }
                    })
                })
    }
    func didRecieveResult(result: NSDictionary){
        if(result["data"]?.valueForKey("list") != nil){
            self.tmpListData = result["data"]?.valueForKey("list") as NSMutableArray //list数据
            //            self.page = result["data"]?["page"] as Int
            self.mainTable.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 15
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.mainTable.dequeueReusableCellWithIdentifier("allList") as UITableViewCell
        var money = cell.viewWithTag(100) as UILabel
        var percent = cell.viewWithTag(101) as UILabel
        var month = cell.viewWithTag(102) as UILabel
        var title = cell.viewWithTag(103) as UILabel
        var row = indexPath.row
        if tmpListData.count > 0 {
            money.text = tmpListData[row].valueForKey("borrow_money")! as NSString
            percent.text = tmpListData[row].valueForKey("borrow_interest_rate")! as NSString
            month.text = tmpListData[row].valueForKey("borrow_duration")! as NSString
            title.text = tmpListData[row].valueForKey("borrow_name")! as NSString
        }
        return cell
        
    }


}

