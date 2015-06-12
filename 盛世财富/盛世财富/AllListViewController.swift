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

    var timeLineUrl = Common.serverHost + "/app-invest-content"
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
                //UIColor(red: 68/255.0, green: 163/255.0, blue: 242/255.0, alpha: 1.0)
                conditionMenuView!.backgroundColor = UIColor(red: 68/255.0, green: 163/255.0, blue: 242/255.0, alpha: 1.0)
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
//                    if self.listData.isKindOfClass(NSMutableArray) {
//                        NSLog("listData是NSMutableArray")
//                    }
                    self.listData = NSMutableArray()
                    self.listData.removeAllObjects()
                    AlertView.alert("提示", message: "没有找到数据", buttonTitle: "确定", viewController: self)
                }
                
//                for var i=0 ; i < self.listData.count; i++ {
//                    NSLog("筛选结果%@",(self.listData[i] as! NSDictionary)["id"] as! String)
//                }
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
//        NSLog("viewDidLoad")
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
                self.mainTable.hidden = false
                
                self.mainTable.reloadData()
                
            },
            failure:{ (op:AFHTTPRequestOperation!,error:NSError!) -> Void in
                loading.stopLoading()
                //AlertView.alert("提示", message: "服务器错误", buttonTitle: "确定", viewController: self)
            }
        )
        setupRefresh()
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
            //记录最后一个[标的]的ID号码
            var borrow_id = 0
            
            var count = self.listData.count
            if count > 0 {
                borrow_id = (self.listData[count - 1].valueForKey("id") as! NSString).integerValue
            }
//            NSLog("最后一个[标的]的ID号码:%i", borrow_id)
            var params = ["borrow_id":borrow_id,"borrow_status":self.status,"borrow_money":self.money,"borrow_duration":self.period]
            var manager = AFHTTPRequestOperationManager()
            manager.responseSerializer.acceptableContentTypes = NSSet(array: ["text/html"]) as Set<NSObject>
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            manager.POST(self.timeLineUrl, parameters: params,
                success: { (op:AFHTTPRequestOperation!, data:AnyObject!) -> Void in
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    
                    var result:NSDictionary = data as! NSDictionary
                    
                    self.tmpListData = result["data"]?.valueForKey("list") as! NSMutableArray //list数据
                    
                    //self.mainTable.reloadData()
                    self.mainTable.footerEndRefreshing()
                    
                    var newList = NSMutableArray()
                    if self.listData.count > 0 {
                        newList.addObjectsFromArray(self.listData as [AnyObject])
                    }
                    if(self.tmpListData.count > 0){
                        newList.addObjectsFromArray(self.tmpListData as [AnyObject])
                    }
                    self.listData = newList
                    self.mainTable.reloadData()
                    self.tmpListData = NSMutableArray()

                },
                failure:{ (op:AFHTTPRequestOperation!,error:NSError!) -> Void in
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    self.mainTable.footerEndRefreshing()
                    AlertView.alert("提示", message: "服务器错误", buttonTitle: "确定", viewController: self)
                }
            )
        })
    }

    //MARK:-  table
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
//                var circleProgressTheme = MDRadialProgressTheme()
//                circleProgressTheme.completedColor = UIColor(red: 68/255.0, green: 138/255.0, blue: 255/255.0, alpha: 1.0)
//                circleProgressTheme.incompletedColor = UIColor(red: 235/255.0, green: 235/255.0, blue: 235/255.0, alpha: 1.0)
//                circleProgressTheme.centerColor = UIColor.clearColor()
//                circleProgressTheme.centerColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1.0)
//                circleProgressTheme.sliceDividerHidden = true
//                circleProgressTheme.labelColor = UIColor(red: 251/255.0, green: 44/255.0, blue: 55/255.0, alpha: 1.0)
//                circleProgressTheme.labelShadowColor = UIColor.whiteColor()
//                circleProgressTheme.drawIncompleteArcIfNoProgress = true
//                var circleProgress = MDRadialProgressView(frame: CGRectMake(0, 0, pview.frame.width, pview.frame.height), andTheme: circleProgressTheme)
//                circleProgress.progressTotal = 100
//                circleProgress.progressCounter = UInt(unit.integerValue)
//                circleProgress.tag = 1
//                //为进度条添加点击事件购买
//                circleProgress.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "buy:"))
                
                var progress = CircleView()
                progress.tag = 1
                progress.type = "1"
                progress.backgroundColor = UIColor.whiteColor()
                progress.frame = CGRectMake(0, 0, pview.frame.width - 15, pview.frame.height - 15)
                progress.percent = unit.doubleValue/100.0
                progress.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "buy:"))
                pview.addSubview(progress)
                
                //percent.textColor = UIColor(red: 253/255.0, green: 134/255.0, blue: 143/255.0, alpha: 1.0)
            }else{
                //不能买
                //提示
//                statusTipLabel.sizeToFit()
//                statusTipLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
//                statusTipLabel.tag = 2
//                pview.addSubview(statusTipLabel)
//                
//                //为提示加约束
//                var statusTipLabelConstraint = NSLayoutConstraint(item: statusTipLabel, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: pview, attribute: NSLayoutAttribute.Leading, multiplier: 1.0, constant: 10)
//                pview.addConstraint(statusTipLabelConstraint)
//                
//                statusTipLabelConstraint = NSLayoutConstraint(item: statusTipLabel, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: pview, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0)
//                pview.addConstraint(statusTipLabelConstraint)
                var progress = CircleView()
                progress.tag = 2
                progress.type = "2"
                progress.backgroundColor = UIColor.whiteColor()
                progress.frame = CGRectMake(0, 0, pview.frame.width - 15, pview.frame.height - 15)
                progress.percent = 0.0
                progress.tip = statusTipLabel.text!
                pview.addSubview(progress)
                
                //percent.textColor = UIColor(red: 216/255.0, green: 216/255.0, blue: 216/255.0, alpha: 1.0)
            }

        }else{
            
            AlertView.alert("提示", message: "没有找到数据", buttonTitle: "确定", viewController: self)
        }
        return cell
        
    }
    
    //点击进度条购买
    func buy(sender:UIGestureRecognizer){
        if let tableCell = sender.view?.superview?.superview?.superview as? UITableViewCell {
            var indexPath = self.mainTable.indexPathForCell(tableCell)!
            NSLog("购买选中的行%i", indexPath.row)
            var d = self.listData[indexPath.row] as! NSDictionary
            var id = d.objectForKey("id") as! String
            NSLog("购买选中的id%@",id)
            var bidConfirmViewController = self.storyboard?.instantiateViewControllerWithIdentifier("BidConfirmViewController") as! BidConfirmViewController
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

