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
    var id = ""
    
    @IBOutlet weak var circle: UIActivityIndicatorView!
    @IBOutlet weak var choice: UIButton!
    @IBAction func showSearch(sender: AnyObject) {
        
        if choice.titleLabel?.text == "筛选" {
            showSideMenuView()
            choice.setTitle("确定", forState: nil)
        }
        if choice.titleLabel?.text == "确定" {
            choice.setTitle("筛选", forState: nil)
            eHttp.get(self.timeLineUrl+"-page-2",viewContro :self,{
                self.mainTable.reloadData()
            })
            hideSideMenuView()
        }
    }
    
    
    @IBOutlet weak var mainTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        mainTable.delegate = self
        eHttp.delegate = self
//        eHttp.get(self.timeLineUrl,viewContro : self)
//        self.setupRefresh()
        
//        self.refreshControl.addTarget(self, action: "setupRefresh", forControlEvents: UIControlEvents.ValueChanged)
//        self.refreshControl.attributedTitle = NSAttributedString(string: "下拉刷新")
//        mainTable.addSubview(self.refreshControl)
        eHttp.get(self.timeLineUrl,viewContro :self,{
//            self.mainTable.reloadData()
            self.circle.stopAnimating()
            self.circle.hidden = true
            self.mainTable.hidden = false
            self.mainTable.reloadData()
        })
        
        if choice.titleLabel?.text != "筛选" {
            choice.setTitle("筛选", forState: nil)
        }
        
        setupRefresh()
    }
    
    
//    func refreshData(){
//        if self.refreshControl.refreshing {
//            self.refreshControl.attributedTitle = NSAttributedString(string: "加载中")
//            eHttp.get(self.timeLineUrl,viewContro :self,{
//                self.refreshControl.endRefreshing()
//                self.mainTable.reloadData()
//            })
//            
//        }
//        self.mainTable.addFooterWithCallback({
//            var nextPage = String(self.page + 1)
//            var tmpTimeLineUrl = self.timeLineUrl + "-page-" + nextPage as NSString
//            self.eHttp.delegate = self
//            self.eHttp.get(self.timeLineUrl,viewContro :self,{
//                self.mainTable.reloadData()
//            })
//            let delayInSeconds:Int64 = 1000000000 * 2
//            var popTime:dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW,delayInSeconds)
//            dispatch_after(popTime, dispatch_get_main_queue(), {
//                self.mainTable.footerEndRefreshing()
//                if(self.tmpListData != self.listData){
//                    if(self.tmpListData.count != 0){
//                        var tmpListDataCount = self.tmpListData.count
//                        for(var i:Int = 0; i < tmpListDataCount; i++){
//                            self.listData.addObject(self.tmpListData[i])
//                        }
//                    }
//                    self.mainTable.reloadData()
//                    self.tmpListData.removeAllObjects()
//                }
//            })
//        })
//    }

//    //Refresh func
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
            var tmpTimeLineUrl = self.timeLineUrl + "-page-" + nextPage as NSString
            self.eHttp.delegate = self
            self.eHttp.get(tmpTimeLineUrl,viewContro :self,{
                self.mainTable.reloadData()
            })
            
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
        
        if(self.listData.count == 0){
            
            if(self.tmpListData.count != 0){
                
                self.listData = self.tmpListData
            }
        }
        return listData.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.mainTable.dequeueReusableCellWithIdentifier("allList") as UITableViewCell
        var money = cell.viewWithTag(100) as UILabel
        var percent = cell.viewWithTag(101) as UILabel
        var month = cell.viewWithTag(102) as UILabel
        var title = cell.viewWithTag(103) as UILabel
        var hideId = cell.viewWithTag(99) as UILabel
        var row = indexPath.row
        if listData.count > 0 {
            var tmp = listData[row].valueForKey("borrow_money")! as NSString
            money.text = "\(tmp)元"
            tmp = listData[row].valueForKey("borrow_interest_rate")! as NSString
            percent.text = "\(tmp)%"
            tmp = listData[row].valueForKey("borrow_duration")! as NSString
            var unit = listData[row].valueForKey("duration_unit")! as NSString
            month.text = "\(tmp)\(unit)"
            title.text = listData[row].valueForKey("borrow_name")! as NSString
            hideId.text = listData[row].valueForKey("id")! as NSString
        }
        return cell
        
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var hideId = tableView.cellForRowAtIndexPath(indexPath)?.viewWithTag(99) as UILabel
        id = hideId.text!
        //        self.presentViewController(vc, animated: true, completion: nil)
        self.performSegueWithIdentifier("detail", sender: self)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        hideSideMenuView()
        if segue.identifier == "detail" {
            var vc = segue.destinationViewController as LendDetailViewController

            vc.id = self.id	

        }
        println("segue:\(segue.identifier)")

    }
    
    override func viewWillAppear(animated: Bool) {
        if self.tmpListData.count == 0 {
            mainTable.hidden = true	
            circle.hidden = false
            circle.startAnimating()
        }
        hideSideMenuView()
    }
}

