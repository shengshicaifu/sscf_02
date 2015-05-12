//
//  ViewController.swift
//  盛世财富
//
//  Created by mo on 15-3-12.
//  Copyright (c) 2015年 sscf88. All rights reserved.
//

import UIKit

class LendViewController1: UIViewController,UITableViewDataSource,UITableViewDelegate ,HttpProtocol{
    
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
    
    @IBOutlet weak var topImage: UIImageView!
   
    var timer:NSTimer?
    
    var count = 1
    func timerFunction(){
        
        topImage.image = UIImage(named: String(count)+".jpg")
        count++
        if count > 4 {
            count = 1
        }
    }
    @IBOutlet weak var circle: UIActivityIndicatorView!
    
    //    var dicList = Array<Dictionary<String,String>>()
    var dicList = NSMutableArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        mainTable.delegate = self
        
        var viewsArray = NSMutableArray()
        var colorArray = [UIColor.cyanColor(),UIColor.blueColor(),UIColor.greenColor(),UIColor.yellowColor(),UIColor.purpleColor()]
        for  i in 1...4 {
            var tempImageView = UIImageView(frame:CGRectMake(0, 0, 380, 100))
            tempImageView.image = UIImage(named:"\(i).jpg")
            tempImageView.contentMode = UIViewContentMode.ScaleAspectFill
            tempImageView.clipsToBounds = true
            viewsArray.addObject(tempImageView)
        }
        
        var mainScorllView = YYCycleScrollView(frame:CGRectMake(0, 0, 380, 100),animationDuration:10.0)
        mainScorllView.fetchContentViewAtIndex = {(pageIndex:Int)->UIView in
            return viewsArray.objectAtIndex(pageIndex) as! UIView
        }
        
        mainScorllView.totalPagesCount = {()->Int in
            //图片的个数
            return 4;
        }
        mainScorllView.TapActionBlock = {(pageIndex:Int)->() in
            //此处根据点击的索引跳转到指定的页面
            println("点击了\(pageIndex)")
        }
        self.view.addSubview(mainScorllView)
        
//        timer = NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector: "timerFunction", userInfo: nil, repeats: true)
//        timer?.fire()
//        
//        //右划
//        var swipeGesture = UISwipeGestureRecognizer(target: self, action: "handleSwipeGesture:")
//        self.view.addGestureRecognizer(swipeGesture)
//        //左划
//        var swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: "handleSwipeGesture:")
//        swipeLeftGesture.direction = UISwipeGestureRecognizerDirection.Left //不设置是右
//        self.view.addGestureRecognizer(swipeLeftGesture)
        
        eHttp.delegate = self
//        eHttp.get(self.timeLineUrl,viewContro :self)
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
        
        //        self.mainTable.addFooterWithCallback({
        //            var nextPage = String(self.page + 1)
        //            var tmpTimeLineUrl = self.timeLineUrl + "&page=" + nextPage as NSString
        //            self.eHttp.delegate = self
        //            self.eHttp.get(tmpTimeLineUrl)
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
    }
    func didRecieveResult(result: NSDictionary){
        if(result["data"]?.valueForKey("list") != nil){
            self.tmpListData = result["data"]?.valueForKey("list") as! NSMutableArray //list数据
            //            self.page = result["data"]?["page"] as Int
            self.mainTable.reloadData()
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section.hashValue == 0 {
            return 160
        }else {
            return 90
        }
    }
    
    //划动手势
    func handleSwipeGesture(sender: UISwipeGestureRecognizer){
        //划动的方向
        var direction = sender.direction
        //判断是上下左右
        switch (direction){
        case UISwipeGestureRecognizerDirection.Left:
            
            count++;//下标++
            break
        case UISwipeGestureRecognizerDirection.Right:
            
            count--;//下标--
            break
            
        default:
            break;
        }
        if count > 4{
            count = 1
        }
        if count < 1 {
            count = 4
        }
        //imageView显示图片
        topImage.image = UIImage(named: "\(count).jpg")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var nextView:UIViewController?
        if segue.identifier == "detail"{
            nextView = segue.destinationViewController as! LendDetailViewController
        }
        if segue.identifier == "allList"{
            nextView = segue.destinationViewController as! AllListViewController
        }
        if nextView != nil {
            nextView!.hidesBottomBarWhenPushed = true
        }
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if section.hashValue == 0 {
            return 5
        }else if section.hashValue == 1  {
            return 1
        }else{
            return 0
        }
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var cell : UITableViewCell!
        var val = indexPath.section.hashValue
        var row = indexPath.row
        
        if val == 0{
            cell = self.mainTable.dequeueReusableCellWithIdentifier("list") as! UITableViewCell
            var image = cell.viewWithTag(100) as! UIImageView
            var title = cell.viewWithTag(101) as! UILabel
            var restMoney = cell.viewWithTag(102) as! UILabel
            var restTime = cell.viewWithTag(103) as! UILabel
            var period = cell.viewWithTag(104) as! UILabel
            var totalMoney = cell.viewWithTag(105) as! UILabel
            var percent = cell.viewWithTag(106) as! UILabel
            
            if tmpListData.count > 0 {
                
                
                title.text = tmpListData[row].valueForKey("borrow_name") as? String
                
                //                if let a = tmpListData[row].valueForKey("need") {
                //                    switch a{
                //                     case let b as Double:println("Double")
                //                     case let b as String:println("String")
                //                    default:break
                //                    }
                //                }
                var d = tmpListData[row].valueForKey("need")! as! Double
                restMoney.text = "\(d)元"
                restTime.text = tmpListData[row].valueForKey("leftdays") as? String
                
                var tmp = tmpListData[row].valueForKey("borrow_duration") as? String
                var unit = tmpListData[row].valueForKey("duration_unit") as? String
                period.text = "\(tmp)\(unit)"
                tmp = tmpListData[row].valueForKey("borrow_money") as? String
                totalMoney.text = "\(tmp)元"
                tmp = tmpListData[row].valueForKey("borrow_interest_rate") as? String
                percent.text = "\(tmp)%"
                
            }
        }
        if val == 1 {
            cell = self.mainTable.dequeueReusableCellWithIdentifier("person") as? UITableViewCell
        }
        
        //        circle.hidden = true
        //        circle.stopAnimating()
        
        
        return cell
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return "投资列表"
        }else if section == 1{
            return "我的账户"
        }else{
            return ""
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
}
