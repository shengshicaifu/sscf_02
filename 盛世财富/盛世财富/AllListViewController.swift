//
//  AllListViewController.swift
//  盛世财富
//  投资列表
//  Created by xiao on 15-3-16.
//  Copyright (c) 2015年 sscf88. All rights reserved.
//


import UIKit

class AllListViewController: UIViewController ,UITableViewDataSource,UITableViewDelegate{
    var eHttp: HttpController = HttpController()
    var base: baseClass = baseClass()
    var timeLineUrl = Constant.getServerHost() + "/app-invest-content"
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
    
    var status:String = "0"
    var money:String = "0"
    var period:String = "0"
    
    //显示筛选菜单
    @IBAction func showConditionMenuView(sender: UIBarButtonItem) {
        if !isConditionMenuViewVisiable {
            if conditionMenuView == nil {
                conditionMenuView = UIView(frame: CGRectMake(0, -350, self.view.frame.width, 350))
                //conditionMenuView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Dark))
                //conditionMenuView?.frame = CGRectMake(0, 0, self.view.frame.width, 350)
                conditionMenuView?.tag = 1001
                
                conditionMenuView!.backgroundColor = UIColor(red: 68/255.0, green: 138/255.0, blue: 255/255.0, alpha: 1.0)
//                conditionMenuView!.alpha = 0.8
                
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
                
                var moneyCondition = UISegmentedControl(items: ["不限","<10","50-200","200-1000",">1000"])
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

            } else {
               (self.conditionMenuView?.viewWithTag(101) as! UISegmentedControl).selectedSegmentIndex = statusValue
                (self.conditionMenuView?.viewWithTag(102) as! UISegmentedControl).selectedSegmentIndex = moneyValue
                (self.conditionMenuView?.viewWithTag(103) as! UISegmentedControl).selectedSegmentIndex = periodValue
            }
            UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                conditionMenuView?.frame = CGRectMake(0, 0, self.view.frame.width, 350)
                }) { (Bool) -> Void in
                    
            }
            
            //self.conditionMenuView?.hidden = false
            isConditionMenuViewVisiable = true
        }else {

            UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                conditionMenuView?.frame = CGRectMake(0, -350, self.view.frame.width, 350)
                }) { (Bool) -> Void in
                    
            }
            //self.conditionMenuView?.hidden = true
            isConditionMenuViewVisiable = false
        }
        
    }
    
    //筛选
    func conditionChoosed(){
        statusValue = (self.conditionMenuView?.viewWithTag(101) as! UISegmentedControl).selectedSegmentIndex
        moneyValue = (self.conditionMenuView?.viewWithTag(102) as! UISegmentedControl).selectedSegmentIndex
        periodValue = (self.conditionMenuView?.viewWithTag(103) as! UISegmentedControl).selectedSegmentIndex
    
        UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
           conditionMenuView?.frame = CGRectMake(0, -350, self.view.frame.width, 350)
        }) { (Bool) -> Void in
            
        }
        
//        UIView.animateWithDuration(0.5, animations: { () -> Void in
//            
//            conditionMenuView?.frame = CGRectMake(0, -350, self.view.frame.width, 350)
//        })
        
        //self.conditionMenuView?.hidden = true
        isConditionMenuViewVisiable = false
        
        //加载数据
        getData()
    }
    
    //加载数据
    func getData(){
//        self.circle.hidden = false
//        self.circle.startAnimating()
        
        switch statusValue {
            case 0:status = "0" ;break
            case 1:status = "0" ;break
            case 2:status = "2" ;break
            case 3:status = "6" ;break
            case 4:status = "7" ;break
            default:status = "0" ;
            
        }
        
        
        switch moneyValue {
            case 0:money = "0" ;break
            case 1:money = "0|100000" ;break
            case 2:money = "500000|2000000" ;break
            case 3:money = "2000000|10000000" ;break
            case 4:money = "10000000|100000000" ;break
            default:money = "0" ;
        }
        
        
        switch periodValue {
            case 0:period = "0" ;break
            case 1:period = "0|1" ;break
            case 2:period = "1|3" ;break
            case 3:period = "4|6" ;break
            case 4:period = "7|12" ;break
            default:period = "0" ;
        }
        
        var url = self.timeLineUrl

        var params = ["borrow_status":status,"borrow_money":money,"borrow_duration":period]
//        NSLog("筛选参数%@", params)
        var manager = AFHTTPRequestOperationManager()
        loading.startLoading(self.view)
        manager.responseSerializer.acceptableContentTypes = NSSet(array: ["text/html"]) as Set<NSObject>
        manager.POST(url, parameters: params,
            success: { (op:AFHTTPRequestOperation!, data:AnyObject!) -> Void in
                //NSLog("listData:%@",self.listData.isKindOfClass(NSMutableArray))
                
//                self.circle.stopAnimating()
//                self.circle.hidden = true
                loading.stopLoading()
                var result:NSDictionary = data as! NSDictionary
                
                if let resultData = result["data"]?.valueForKey("list") as? NSMutableArray {
                    self.listData = resultData
                } else {
                    if self.listData.isKindOfClass(NSMutableArray) {
                        NSLog("listData是NSMutableArray")
                    }
                    self.listData = NSMutableArray()
                    self.listData.removeAllObjects()
                    AlertView.alert("提示", message: "没有找到数据", buttonTitle: "确定", viewController: self)
                }
                
                for var i=0 ; i < self.listData.count; i++ {
                    NSLog("筛选结果%@",(self.listData[i] as! NSDictionary)["id"] as! String)
                }
//                println(self.listData.count)
                self.mainTable.reloadData()
                
                
            },
            failure:{ (op:AFHTTPRequestOperation!,error:NSError!) -> Void in
                loading.stopLoading()
                AlertView.alert("提示", message: "服务器错误", buttonTitle: "确定", viewController: self)
            }
        )
        
    }
    
    
    @IBOutlet weak var mainTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        mainTable.delegate = self
        loading.startLoading(self.view)
        var params = [:]
        var manager = AFHTTPRequestOperationManager()
        manager.responseSerializer.acceptableContentTypes = NSSet(array: ["text/html"]) as Set<NSObject>
        manager.POST(timeLineUrl, parameters: params,
            success: { (op:AFHTTPRequestOperation!, data:AnyObject!) -> Void in
                loading.stopLoading()
                var result:NSDictionary = data as! NSDictionary
                
                self.tmpListData = result["data"]?.valueForKey("list") as! NSMutableArray //list数据

                //self.circle.stopAnimating()
                //self.circle.hidden = true
                self.mainTable.hidden = false
                
                self.mainTable.reloadData()
                
            },
            failure:{ (op:AFHTTPRequestOperation!,error:NSError!) -> Void in
                
            }
        )
        setupRefresh()
    }
    
    //为table添加下拉刷新和上拉加载功能
    func setupRefresh(){
        //下拉刷新
        self.mainTable.addHeaderWithCallback({
            let delayInSeconds:Int64 =  1000000000  * 2
            var popTime:dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW,delayInSeconds)
            dispatch_after(popTime, dispatch_get_main_queue(), {
                self.mainTable.reloadData()
                self.mainTable.headerEndRefreshing()
            })
        })
        
        //上拉加载
        self.mainTable.addFooterWithCallback({
            
            /*
            var nextPage = String(self.page + 1)
            var tmpTimeLineUrl = self.timeLineUrl + "-page-" + nextPage as NSString
            
            
            self.eHttp.delegate = self
            self.eHttp.get(tmpTimeLineUrl as String,view :self.view,callback: {
                self.mainTable.reloadData()
            })
            */
            //记录最后一个[标的]的ID号码
            var borrow_id = 0
            
            var count = self.listData.count
            if count > 0 {
                borrow_id = (self.listData[count - 1].valueForKey("id") as! NSString).integerValue
            }
            NSLog("最后一个[标的]的ID号码:%i", borrow_id)
            var params = ["borrow_id":borrow_id,"borrow_status":self.status,"borrow_money":self.money,"borrow_duration":self.period]
            var manager = AFHTTPRequestOperationManager()
            manager.responseSerializer.acceptableContentTypes = NSSet(array: ["text/html"]) as Set<NSObject>
            manager.POST(self.timeLineUrl, parameters: params,
                success: { (op:AFHTTPRequestOperation!, data:AnyObject!) -> Void in
                    var result:NSDictionary = data as! NSDictionary
                    
                    self.tmpListData = result["data"]?.valueForKey("list") as! NSMutableArray //list数据
                    
                    //self.mainTable.reloadData()
                    self.mainTable.footerEndRefreshing()
                    
                    var newList = NSMutableArray()
                    if self.listData.count > 0 {
                        newList.addObjectsFromArray(self.listData as [AnyObject])
                    }
                    if(self.tmpListData.count > 0){
//                        var tmpListDataCount = self.tmpListData.count
//                        for(var i:Int = 0; i < tmpListDataCount; i++){
//                            self.listData.addObject(self.tmpListData[i])
//                        }
                        newList.addObjectsFromArray(self.tmpListData as [AnyObject])
                    }
                    self.listData = newList
                    self.mainTable.reloadData()
                    self.tmpListData = NSMutableArray()

                },
                failure:{ (op:AFHTTPRequestOperation!,error:NSError!) -> Void in
                    
                }
            )
            
            
            
            
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
        })
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
        var progressLabel = cell.viewWithTag(102) as! UILabel
        var title = cell.viewWithTag(103) as! UILabel
        var hideId = cell.viewWithTag(99) as! UILabel
        
        var progress = cell.viewWithTag(90) as! UIProgressView
        progress.progressTintColor = UIColor(red: 68/255.0, green: 138/255.0, blue: 255/255.0, alpha: 1.0)
        progress.trackTintColor = UIColor(red: 235/255.0, green: 235/255.0, blue: 235/255.0, alpha: 1.0)
        progress.layer.masksToBounds = true
        progress.layer.cornerRadius = 4
        
        var hideType = UILabel(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        hideType.tag = 98
        var row = indexPath.row
//        println(listData.count)
        if listData.count > 0 {
//            println(listData)
            var m = listData[row].valueForKey("borrow_money") as! NSString
            if m.integerValue > 10000 {
                var wm = m.integerValue/10000
                money.text = "\(wm)万元"
            } else {
                money.text = "\(m)元"
            }
            
            var tmp = listData[row].valueForKey("borrow_interest_rate") as! String
            percent.text = "\(tmp)%"
            tmp = listData[row].valueForKey("borrow_duration") as! String
            var unit = listData[row].valueForKey("progress") as! NSString
            progressLabel.text = "\(unit.integerValue)%"
            progressLabel.layer.borderWidth = 1
            progressLabel.layer.borderColor = UIColor(red: 68/255.0, green: 138/255.0, blue: 255/255.0, alpha: 1.0).CGColor
            progressLabel.layer.cornerRadius = 10
            
            
            progress.progress = unit.floatValue/100.0
            title.text = listData[row].valueForKey("borrow_name") as? String
            hideId.text = listData[row].valueForKey("id") as? String
            hideType.text = listData[row].valueForKey("borrow_type") as? String
            cell.addSubview(hideType)
            hideType.hidden = true
            
            //NSLog("%@,%@",listData[row].valueForKey("id") as! String,listData[row].valueForKey("borrow_name") as! String)
        }else{
            
            AlertView.alert("提示", message: "没有找到数据", buttonTitle: "确定", viewController: self)
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

