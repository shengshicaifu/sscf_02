//
//  AllListViewController.swift
//  盛世财富
//
//  Created by xiao on 15-3-16.
//  Copyright (c) 2015年 sscf88. All rights reserved.
//


import UIKit
/**
*  投资列表
*/
class AllListViewController: UIViewController ,UITableViewDataSource,UITableViewDelegate{
    var eHttp: HttpController = HttpController()

    var url1 = Common.serverHost + "/app-invest-content"//所有标
    var url2 = Common.serverHost + "/App-Invest-getActiveList"//活动标
    var url3 = Common.serverHost + "/App-Invest-getBiaoList"//组合标
    var url = ""
    var listData: NSMutableArray = NSMutableArray()//存储获取到的标列表数据
    var page = 1 //page
    var type = "0"//0:专享理财 1:债权转让计划  2:受益权转让计划
    @IBOutlet weak var circle: UIActivityIndicatorView!
    @IBOutlet weak var mainTable: UITableView!
    
    
    var conditionMenuView:UIView?
    var isConditionMenuViewVisiable = false
    
    var statusValue:Int = 0
    var moneyValue:Int = 0
    var periodValue:Int = 0
    
    var status:String = "0"
    var money:String = "0"
    var period:String = "0"
    
    //MARK:- view delegate
    override func viewDidLoad() {
        super.viewDidLoad()
        mainTable.delegate = self
        
        //判断标列表的类型
        NSLog("列表类型:%@", type)
        switch type {
            case "0":
                //专享理财  活动标
                self.url = url2
                self.navigationItem.title = "专享理财"
                break
            case "1":
                //债权转让计划   组合标
                self.url = url3
                self.navigationItem.title = "债权转让计划"
                break
            case "2":
                //受益权转让计划   未定，先用所有标
                self.url = url1
                self.navigationItem.title = "受益权转让计划"
                break
            default:
                self.url = url1
                break
        }

        
        self.getData("0")
        setupRefresh()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        if mainTable.indexPathForSelectedRow() != nil {
            self.mainTable.deselectRowAtIndexPath(mainTable.indexPathForSelectedRow()!, animated: true)
        }
    }
    
    
    //MARK:- 筛选
    @IBAction func showConditionMenuView(sender: UIBarButtonItem) {
        if !isConditionMenuViewVisiable {
            if conditionMenuView == nil {
                conditionMenuView = UIView(frame: CGRectMake(0, -350, self.view.frame.width, 350))
                conditionMenuView?.tag = 1001
                conditionMenuView!.backgroundColor = UIColor(red: 68/255.0, green: 163/255.0, blue: 242/255.0, alpha: 1.0)
                
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
            isConditionMenuViewVisiable = true
        }else {

            UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                conditionMenuView?.frame = CGRectMake(0, -350, self.view.frame.width, 350)
                }) { (Bool) -> Void in
                    
            }
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
        isConditionMenuViewVisiable = false
        
        //加载数据
        getData("0")
    }
    
    
    
    //MARK:- 获取数据
    /**
    加载数据
    
    :param: actionType 0:进入页面和筛选
                       1:下拉刷新
                       2:上拉加载
    */
    func getData(actionType:String){
        
        //获取查询条件
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
        var params = [:]
        if type == "0" || type == "2" {
            params = ["borrow_status":status,"borrow_money":money,"borrow_duration":period]
            
            if actionType == "2" {
                //记录最后一个[标的]的ID号码
                var borrow_id = 0
                var count = self.listData.count
                if count > 0 {
                    borrow_id = (self.listData[count - 1].valueForKey("id") as! NSString).integerValue
                    params = ["borrow_id":"\(borrow_id)","borrow_status":self.status,"borrow_money":self.money,"borrow_duration":self.period]
                }
            }
        }else if type == "1" {
            params = ["count":"4","borrow_status":status,"borrow_money":money,"borrow_duration":period]
            if actionType == "2" {
                //记录最后一个[标的]的ID号码
                var borrow_id = 0
                var count = self.listData.count
                if count > 0 {
                    borrow_id = (self.listData[count - 1].valueForKey("id") as! NSString).integerValue
                    params = ["count":"4","borrow_id":"\(borrow_id)","borrow_status":self.status,"borrow_money":self.money,"borrow_duration":self.period]
                }
            }
        }
        
        
//        NSLog("筛选参数%@", params)
        var manager = AFHTTPRequestOperationManager()
        if actionType == "0" {
           loading.startLoading(self.view)
        }else if (actionType == "1" || actionType == "2"){
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        }
        
        
        manager.responseSerializer.acceptableContentTypes = NSSet(array: ["text/html"]) as Set<NSObject>
        NSLog("地址%@", self.url)
        NSLog("参数%@", params)
        manager.POST(self.url, parameters: params,
            success: { (op:AFHTTPRequestOperation!, data:AnyObject!) -> Void in
                var result:NSDictionary = data as! NSDictionary
                NSLog("标的列表结果%@", result)
                if actionType == "0" {
                    loading.stopLoading()
                }else if actionType == "1"{
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    self.mainTable.headerEndRefreshing()
                }else if actionType == "2"{
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    self.mainTable.footerEndRefreshing()
                }
                
                if (self.type == "0") || (self.type == "2") {
                    //活动标或所有列表
                    if (actionType == "0" || actionType == "1"){
                        //重新获取数据
                        self.listData.removeAllObjects()
                    }
                    if let resultList = result["data"]?["list"] as? NSArray {
                        self.listData.addObjectsFromArray(resultList as [AnyObject])
                    }
                }else if self.type == "1" {
                    //组合标
                    if (actionType == "0" || actionType == "1"){
                        //重新获取数据
                        self.listData.removeAllObjects()
                    }
                    if let array1 = result["data"] as? NSArray {
                        for var i=0;i<array1.count;i++ {
                            var array2 = array1[i] as! NSArray
                            for var j=0;j<array2.count;j++ {
                                if let object = array2[j] as? NSDictionary {
                                    self.listData.addObject(object)
                                }
                            }
                            //self.listData.addObjectsFromArray(array1[i] as! [AnyObject])
                        }
                    }
                }
                self.mainTable.reloadData()
            },
            failure:{ (op:AFHTTPRequestOperation!,error:NSError!) -> Void in
                if actionType == "0" {
                    loading.stopLoading()
                }else if actionType == "1"{
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    self.mainTable.headerEndRefreshing()
                }else if actionType == "2"{
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    self.mainTable.footerEndRefreshing()
                }
                AlertView.alert("提示", message: "服务器错误", buttonTitle: "确定", viewController: self)
            }
        )
        
    }
    
    
    //为table添加下拉刷新和上拉加载功能
    func setupRefresh(){
        //下拉刷新
        self.mainTable.addHeaderWithCallback({
            //println("下拉刷新")
            var params = [:]
            var manager = AFHTTPRequestOperationManager()
            manager.responseSerializer.acceptableContentTypes = NSSet(array: ["text/html"]) as Set<NSObject>
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            manager.POST(self.timeLineUrl, parameters: params,
                success: { (op:AFHTTPRequestOperation!, data:AnyObject!) -> Void in
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    var result:NSDictionary = data as! NSDictionary
                    println(result)
                    self.tmpListData = result["data"]?.valueForKey("list") as! NSMutableArray //list数据
                    self.mainTable.hidden = false
                
                    self.mainTable.reloadData()
                    self.mainTable.headerEndRefreshing()
                    
                },
                failure:{ (op:AFHTTPRequestOperation!,error:NSError!) -> Void in
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    self.mainTable.headerEndRefreshing()
                    AlertView.alert("提示", message: "服务器错误", buttonTitle: "确定", viewController: self)
                }
            )
        })
        
        //上拉加载
        self.mainTable.addFooterWithCallback({
            self.getData("2")
        })
    }

    //MARK:-  table
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return listData.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.mainTable.dequeueReusableCellWithIdentifier("allList") as! UITableViewCell
        var money = cell.viewWithTag(100) as! UILabel//金额
        var percent = cell.viewWithTag(101) as! UILabel//年利收益
        var title = cell.viewWithTag(103) as! UILabel//标题
        var row = indexPath.row
        if listData.count > 0 {
            var rowData = listData[row] as! NSDictionary
            var id = rowData.valueForKey("id") as! String
            title.text = (rowData.valueForKey("borrow_name") as! String)
            var m = rowData.valueForKey("borrow_money") as! NSString
            if m.integerValue > 10000 {
                var wm = m.integerValue/10000
                money.text = "\(wm)万元"
            } else {
                money.text = "\(m)元"
            }
            
            var tmp = rowData.valueForKey("borrow_interest_rate") as! String
            percent.text = "\(tmp)%"
            tmp = rowData.valueForKey("borrow_duration") as! String
            var unit = rowData.valueForKey("progress") as! NSString
            
            
            
            /*该视图根据标的状态来决定放哪种内容，
              1.未结束，放圆形进度条，点击该进度条跳转到购买页面
              2.已结束，放结束图案，无点击事件
            */
            //根据借款状态和募集期来判断该标是否可买
            //借款状态
            var status = rowData["borrow_status"] as! NSString
            var canBuy:Bool = true//表示标是否能买
            var statusTipLabel = UILabel()//不能买的提示
            switch status {
                case "4":
                    canBuy = false
                    statusTipLabel.text = "复审中"
                    break
                case "6":
                    canBuy = false
                    statusTipLabel.text = "还款中"
                    break
                case "7":
                    canBuy = false
                    statusTipLabel.text = "已完成"
                    break
                default:
                    break
            }
            //募集期小于当前日期的不能投
            var collectTimeStr = rowData["collect_time"] as? NSString
            if collectTimeStr != nil {
                var curTime = NSDate().timeIntervalSince1970
                if collectTimeStr?.doubleValue < curTime {
                    canBuy = false
                    statusTipLabel.text = "已结束"
                }
            }
            
            
            var pview = cell.viewWithTag(102)!
            pview.backgroundColor = UIColor.whiteColor()
            if pview.viewWithTag(1) != nil {
                pview.viewWithTag(1)?.removeFromSuperview()
            }
            if pview.viewWithTag(2) != nil {
                pview.viewWithTag(2)?.removeFromSuperview()
            }
            
            if canBuy {
                //能买
                //圆形进度条
                var progress = CircleView()
                progress.tag = 1
                progress.type = "1"
                progress.backgroundColor = UIColor.whiteColor()
                progress.frame = CGRectMake(0, 0, pview.frame.width - 15, pview.frame.height - 15)
                progress.percent = unit.doubleValue/100.0
                progress.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "buy:"))
                pview.addSubview(progress)
            }else{
                //不能买
                var progress = CircleView()
                progress.tag = 2
                progress.type = "2"
                progress.backgroundColor = UIColor.whiteColor()
                progress.frame = CGRectMake(0, 0, pview.frame.width - 15, pview.frame.height - 15)
                progress.percent = 0.0
                progress.tip = statusTipLabel.text!
                pview.addSubview(progress)
            }

        }else{
            
            AlertView.alert("提示", message: "没有找到数据", buttonTitle: "确定", viewController: self)
        }
        return cell
        
    }
    

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if self.listData.count > 0 {
            self.performSegueWithIdentifier("detail", sender: self)
        }
    }
    
    //MARK:- 页面跳转
    //点击进度条购买
    func buy(sender:UIGestureRecognizer){
        if let tableCell = sender.view?.superview?.superview?.superview as? UITableViewCell {
            var indexPath = self.mainTable.indexPathForCell(tableCell)!
            NSLog("购买选中的行%i", indexPath.row)
            var d = self.listData[indexPath.row] as! NSDictionary
            var id = d.objectForKey("id") as! String
            NSLog("购买选中的id%@",id)
            var bidConfirmViewController = self.storyboard?.instantiateViewControllerWithIdentifier("bidConfirmViewController") as! BidConfirmViewController
            bidConfirmViewController.id = id
            self.navigationController?.pushViewController(bidConfirmViewController, animated: true)
        }
    }
    
    
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        if self.listData.count > 0 {
//            var dic = self.listData[indexPath.row] as! NSDictionary
//            self.id = dic.objectForKey("id")  as! String
//            self.type = dic.objectForKey("borrow_type") as? String
////            self.performSegueWithIdentifier("detail", sender: self)
//        }
//    }
    

    override func viewWillAppear(animated: Bool) {
        if mainTable.indexPathForSelectedRow() != nil {
            self.mainTable.deselectRowAtIndexPath(mainTable.indexPathForSelectedRow()!, animated: true)
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "detail" {
            var selectedRow = self.mainTable.indexPathForSelectedRow()?.row
            var dic = self.listData[selectedRow!] as! NSDictionary
            var vc = segue.destinationViewController as! NewDetailScrollViewController
            vc.id = dic.objectForKey("id") as? String
            vc.type = dic.objectForKey("borrow_type") as? String
        }
    }
}

