//
//  AllListViewController.swift
//  盛世财富
//  投资列表
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
    var type:String?
    @IBOutlet weak var circle: UIActivityIndicatorView!
    
    
    var conditionMenuView:UIView?
    var isConditionMenuViewVisiable = false
    
    var statusValue:Int = 0
    var moneyValue:Int = 0
    var periodValue:Int = 0
    
    
    //显示筛选菜单
    @IBAction func showConditionMenuView(sender: UIBarButtonItem) {
        if !isConditionMenuViewVisiable {
            conditionMenuView = UIView(frame: CGRectMake(0, 0, self.view.frame.width, 350))
            conditionMenuView!.backgroundColor = UIColor.blackColor()
            conditionMenuView!.alpha = 0.8
            
            //借款状态
            var statusLabel = UILabel(frame: CGRectMake(5, 80, 120, 40))
            statusLabel.text = "借款状态"
            statusLabel.textColor = UIColor.whiteColor()
            conditionMenuView?.addSubview(statusLabel)
            
            var statusCondition = UISegmentedControl(items: ["不限","所有","招标中","已成功","已完成"])
            statusCondition.frame = CGRectMake(5, 120, self.view.frame.width-5, 30)
            statusCondition.selectedSegmentIndex = statusValue
            statusCondition.tintColor = UIColor.whiteColor()
            statusCondition.tag = 101
            conditionMenuView?.addSubview(statusCondition)
            
            //借款金额
            var moneyLabel = UILabel(frame: CGRectMake(5, 150, 120, 40))
            moneyLabel.text = "借款金额(万)"
            moneyLabel.textColor = UIColor.whiteColor()
            conditionMenuView?.addSubview(moneyLabel)
            
            var moneyCondition = UISegmentedControl(items: ["不限","<10","50-200","200-1000",">100"])
            moneyCondition.frame = CGRectMake(5, 190, self.view.frame.width-5, 30)
            moneyCondition.selectedSegmentIndex = moneyValue
            moneyCondition.tintColor = UIColor.whiteColor()
            moneyCondition.tag = 102
            conditionMenuView?.addSubview(moneyCondition)
            
            
            //借款期限
            var periodLabel = UILabel(frame: CGRectMake(5, 220, 120, 40))
            periodLabel.text = "借款期限(月)"
            periodLabel.textColor = UIColor.whiteColor()
            conditionMenuView?.addSubview(periodLabel)
            
            var periodCondition = UISegmentedControl(items: ["不限","<1","1-3","4-6","7-12"])
            periodCondition.frame = CGRectMake(5, 260, self.view.frame.width-5, 30)
            periodCondition.selectedSegmentIndex = periodValue
            periodCondition.tintColor = UIColor.whiteColor()
            periodCondition.tag = 103
            conditionMenuView?.addSubview(periodCondition)
            
            //确定
            var okBtn = UIButton(frame: CGRectMake((self.view.frame.width-150)/2, 300, 150, 30))
            okBtn.setTitle("确定", forState: UIControlState.Normal)
            //okBtn.backgroundColor = UIColor.redColor()
            okBtn.addTarget(self, action: "conditionChoosed", forControlEvents: UIControlEvents.TouchUpInside)
            
            conditionMenuView?.addSubview(okBtn)
            
            self.view.addSubview(conditionMenuView!)
            
            isConditionMenuViewVisiable = true
        }else {
            self.conditionMenuView?.removeFromSuperview()
            isConditionMenuViewVisiable = false
        }
        
    }
    
    //筛选
    func conditionChoosed(){
        statusValue = (self.conditionMenuView?.viewWithTag(101) as! UISegmentedControl).selectedSegmentIndex
        moneyValue = (self.conditionMenuView?.viewWithTag(102) as! UISegmentedControl).selectedSegmentIndex
        periodValue = (self.conditionMenuView?.viewWithTag(103) as! UISegmentedControl).selectedSegmentIndex
    
        self.conditionMenuView?.removeFromSuperview()
        isConditionMenuViewVisiable = false
        
        //加载数据
        getData()
    }
    
    //加载数据
    func getData(){
        var status:String
        switch statusValue {
            case 0:status = "0" ;break
            case 1:status = "0" ;break
            case 2:status = "2" ;break
            case 3:status = "6" ;break
            case 4:status = "7" ;break
            default:status = "0" ;
            
        }
        
        var money:String
        switch moneyValue {
            case 0:money = "0" ;break
            case 1:money = "0|100000" ;break
            case 2:money = "500000|2000000" ;break
            case 3:money = "2000000|10000000" ;break
            case 4:money = "1000000" ;break
            default:money = "0" ;
        }
        
        var period:String
        switch periodValue {
            case 0:period = "0" ;break
            case 1:period = "0|1" ;break
            case 2:period = "1|3" ;break
            case 3:period = "4|6" ;break
            case 4:period = "7|12" ;break
            default:period = "0" ;
        }
        
        var url = self.timeLineUrl
        
//        eHttp.get(url,view :self.view,callback: {
//            self.circle.stopAnimating()
//            self.circle.hidden = true
//            self.mainTable.hidden = false
//            self.mainTable.reloadData()
//        })
        var params = ["Borrow_id":"950", "Borrow_status":status,"Borrow_money":money,"Borrow_duration":period]
        NSLog("筛选参数%@", params)
        var manager = AFHTTPRequestOperationManager()
        manager.GET(url, parameters: params,
            success: { (op:AFHTTPRequestOperation!, data:AnyObject!) -> Void in
                var result:NSDictionary = data as! NSDictionary
                //if(result["data"]?.valueForKey("list") != nil){
                    self.listData = result["data"]?.valueForKey("list") as! NSMutableArray //list数据
                    //NSLog("筛选结果%@",self.listData)
                    self.mainTable.reloadData()
                //}
                
            },
            failure:{ (op:AFHTTPRequestOperation!,error:NSError!) -> Void in
            
            }
        )
        
    }
    
    
    @IBOutlet weak var mainTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        mainTable.delegate = self
        eHttp.delegate = self
        eHttp.get(self.timeLineUrl,view :self.view,callback: {
//            self.mainTable.reloadData()
            self.circle.stopAnimating()
            self.circle.hidden = true
            self.mainTable.hidden = false
            self.mainTable.reloadData()
        })
        
       
        
        setupRefresh()
    }
    
    //为table添加下拉刷新和上拉加载功能
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
            self.eHttp.get(tmpTimeLineUrl as String,view :self.view,callback: {
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
            self.tmpListData = result["data"]?.valueForKey("list") as! NSMutableArray //list数据
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
        let cell = self.mainTable.dequeueReusableCellWithIdentifier("allList") as! UITableViewCell
        var money = cell.viewWithTag(100) as! UILabel
        var percent = cell.viewWithTag(101) as! UILabel
        var month = cell.viewWithTag(102) as! UILabel
        var title = cell.viewWithTag(103) as! UILabel
        var hideId = cell.viewWithTag(99) as! UILabel
        var hideType = UILabel(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        hideType.tag = 98
        var row = indexPath.row
        if listData.count > 0 {
            var tmp = listData[row].valueForKey("borrow_money") as! String
            money.text = "\(tmp)元"
            tmp = listData[row].valueForKey("borrow_interest_rate") as! String
            percent.text = "\(tmp)%"
            tmp = listData[row].valueForKey("borrow_duration") as! String
            var unit = listData[row].valueForKey("duration_unit") as! String
            month.text = "\(tmp)\(unit)"
            title.text = listData[row].valueForKey("borrow_name") as? String
            hideId.text = listData[row].valueForKey("id") as? String
            NSLog("%@,%@", title.text!,listData[row].valueForKey("borrow_status") as! String)
        }
        return cell
        
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var hideId = tableView.cellForRowAtIndexPath(indexPath)?.viewWithTag(99) as! UILabel
        id = hideId.text!
        var hideType = tableView.cellForRowAtIndexPath(indexPath)?.viewWithTag(98) as! UILabel
        type = hideType.text!
        //        self.presentViewController(vc, animated: true, completion: nil)
        self.performSegueWithIdentifier("detail", sender: self)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "detail" {
            var vc = segue.destinationViewController as! LendDetailViewController

            vc.id = self.id	
            vc.type = self.type
        }
//        println("segue:\(segue.identifier)")

    }
    
    override func viewWillAppear(animated: Bool) {
//        println(self.tmpListData.count)
        
        if self.tmpListData.count == 0 && self.listData.count == 0{
            mainTable.hidden = true	
            circle.hidden = false
            circle.startAnimating()
        }
        
    }
}

