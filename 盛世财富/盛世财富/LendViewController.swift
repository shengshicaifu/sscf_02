//
//  ViewController.swift
//  盛世财富
//
//  Created by mo on 15-3-12.
//  Copyright (c) 2015年 sscf88. All rights reserved.
//

import UIKit

class LendViewController: UIViewController,UITableViewDataSource,UITableViewDelegate ,HttpProtocol{

    var eHttp: HttpController = HttpController()//新建一个httpController
    var base: baseClass = baseClass()
    var timeLineUrl = Constant.getServerHost() + "/app-invest-content"//链接地址
    var tmpListData: NSMutableArray = NSMutableArray()//临时数据  下拉添加
    var listData: NSMutableArray = NSMutableArray()//存数据
    var page = 1 //page
    var imageCache = Dictionary<String,UIImage>()
    var tid: String = ""
    var sign: String = ""
    
    var id:String?//页面传值的id
    var percent:String?
    var bidName:String?
    var type:String?
    var per_transferData:String?
    var duration:String?
    
    let refreshControl = UIRefreshControl() //apple自带的下拉刷新
    @IBOutlet weak var circle: UIActivityIndicatorView!//读取数据动画
    @IBOutlet weak var mainTable: UITableView!
    var dicList = NSMutableArray()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainTable.delegate = self
        mainTable.dataSource = self
//        mainTable.allowsSelection = false
//        self.navigationController?.navigationBar.barTintColor = UIColor(red: 54/255.0, green: 169/255.0, blue: 245/255.0, alpha: 1)
//        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
       //滚动图-------------------------------
        var viewsArray = NSMutableArray()
        var colorArray = [UIColor.cyanColor(),UIColor.blueColor(),UIColor.greenColor(),UIColor.yellowColor(),UIColor.purpleColor()]
        for  i in 1...4 {
            var tempImageView = UIImageView(frame:CGRectMake(0, 64, self.view.layer.frame.width, 175))//代码指定位置
            tempImageView.image = UIImage(named:"\(i).jpeg")//图片名
            tempImageView.contentMode = UIViewContentMode.ScaleAspectFill
            tempImageView.clipsToBounds = true
            
            viewsArray.addObject(tempImageView)//添加
            
        }
        //scrollview滚动
        var mainScorllView = YYCycleScrollView(frame:CGRectMake(0, 64, self.view.layer.frame.width, 175),animationDuration:10.0)
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
        
        mainTable.tableHeaderView = mainScorllView
        //滚动图-------------------------------
        
        //apple的下拉刷新
        self.refreshControl.addTarget(self, action: "refreshData", forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl.attributedTitle = NSAttributedString(string: "下拉刷新")
        mainTable.addSubview(self.refreshControl)
        
        eHttp.delegate = self
        
        if self.tmpListData.count == 0 && self.listData.count == 0{
            //如果没有获取到数据 就开始动画
            self.mainTable.hidden = true
            self.circle.hidden = false
            self.circle.startAnimating()
            var time = NSTimer.scheduledTimerWithTimeInterval(20, target: self, selector: "stopCircle", userInfo: nil, repeats: false)
            
            
        }
        //http请求
//        NSLog("viewDidLoad")
        var reach = Reachability(hostName: Constant.getDomain())
        reach.reachableBlock = {(r:Reachability!) -> Void in
//
            dispatch_async(dispatch_get_main_queue(), {
                

                self.eHttp.get(self.timeLineUrl,view :self.view,callback: {
                    //callback  隐藏读取动画
                    self.circle.stopAnimating()
                    self.circle.hidden = true
                    //显示tableview
                    self.mainTable.hidden = false
                    self.mainTable.reloadData()
                })
            })
        }
        reach.startNotifier()

        
    }
    //下拉刷新绑定的方法
    func refreshData(){
        if self.refreshControl.refreshing {
//检查手机网络
            var reach = Reachability(hostName: Constant.getDomain())
            reach.unreachableBlock = {(r:Reachability!) -> Void in
                NSLog("网络不可用")
                dispatch_async(dispatch_get_main_queue(), {
                    let alert = UIAlertController(title: "提示", message: "网络连接有问题，请检查手机网络", preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.Cancel, handler: nil))
                    self.refreshControl.endRefreshing()
                    self.presentViewController(alert, animated: true, completion: nil)
                })
            }
            
            reach.reachableBlock = {(r:Reachability!) -> Void in
                NSLog("网络可用")
                dispatch_async(dispatch_get_main_queue(), {
                    self.refreshControl.attributedTitle = NSAttributedString(string: "加载中")
                    self.eHttp.get(self.timeLineUrl,view :self.view,callback: {
                        //停止下拉动画
                        self.refreshControl.endRefreshing()
                        self.mainTable.reloadData()
                        
                    })
                })
            }
          
            reach.startNotifier()
            
        }
    }
    
    
    //读取json并解析
    func didRecieveResult(result: NSDictionary){
        if(result["data"]?.valueForKey("list") != nil){
            self.tmpListData = result["data"]?.valueForKey("list")as! NSMutableArray //list数据
//            self.page = result["data"]?["page"] as Int
            self.mainTable.reloadData()
        }
    }
    //高度
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section.hashValue == 0 {
            return 160
        }else {
            return 90
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func buy(sender: UIButton) {
        let cell = sender.superview?.superview as! UITableViewCell
        let title = cell.viewWithTag(101) as! UILabel
        let percent = cell.viewWithTag(106) as! UILabel
        let id = cell.viewWithTag(99) as! UILabel
        let type = cell.viewWithTag(98) as! UILabel
        self.id = id.text
        self.bidName = title.text
        self.percent = percent.text
        self.type = type.text
        
        let transferData = cell.viewWithTag(90) as! UILabel
        self.per_transferData = transferData.text
        
        let duration = cell.viewWithTag(91) as! UILabel
        self.duration = duration.text

    }
    //点击事件
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.section == 0 {
            if let hideId = tableView.cellForRowAtIndexPath(indexPath)?.viewWithTag(99) as? UILabel{
                id = hideId.text
                if let hideType = tableView.cellForRowAtIndexPath(indexPath)?.viewWithTag(98) as? UILabel {
                    type = hideType.text
                }
                self.performSegueWithIdentifier("detail", sender: self)
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var nextView:UIViewController?
        if segue.identifier == "detail"{
            var vc = segue.destinationViewController as! LendDetailViewController
            vc.id = self.id
            vc.type = self.type
        }
        if segue.identifier == "allList"{
            nextView = segue.destinationViewController as! AllListViewController
        }
        if segue.identifier == "buy"{
            var vc = segue.destinationViewController as! BidConfirmViewController
            vc.id = self.id
            vc.bidTitle = self.bidName
            vc.percent = self.percent
            vc.type = self.type
            
            if self.type != "8" {
                vc.per_transferData = self.per_transferData
                vc.duration = self.duration
            }
        }
        //隐藏tabbar
        if nextView != nil {
            nextView!.hidesBottomBarWhenPushed = true
        }
    }
    //每个section的行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
       if section.hashValue == 0 {
            return 5
        }else{
            return 0
        }
    }
    
    //初始化cell方法
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : UITableViewCell!
        var sec = indexPath.section.hashValue
        var row = indexPath.row
        
        if sec == 0{
            cell = self.mainTable.dequeueReusableCellWithIdentifier("list") as! UITableViewCell
            //重复的控件 必须用viewwithtag获取
            
            var title = cell.viewWithTag(101) as! UILabel
            
            var period = cell.viewWithTag(104) as! UILabel
            var totalMoney = cell.viewWithTag(105) as! UILabel
            var percent = cell.viewWithTag(106) as! UILabel
            var btn = cell.viewWithTag(55) as! UIButton
            //var progress = cell.viewWithTag(110) as! UIProgressView
            var hideId =  UILabel(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            hideId.tag = 99
            var hideType = UILabel(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            hideType.tag = 98
            
            var transferData = UILabel(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            transferData.tag = 90
            var duration = UILabel(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            duration.tag = 91
            
            if tmpListData.count > 0 {
                //图片  会产生阻滞
//                image.image = UIImage(data:NSData(contentsOfURL: NSURL(string: "http://www.sscf88.com/uploadData/ad/2014093013251995.jpg")!)!)
                println(tmpListData[row])
                
                title.text = tmpListData[row].valueForKey("borrow_name") as? String
                
                var d = tmpListData[row].valueForKey("need") as! Double
                var pro = tmpListData[row].objectForKey("progress") as! NSString
                var tmp = tmpListData[row].valueForKey("borrow_duration") as! String
                var unit = tmpListData[row].valueForKey("duration_unit") as! String
                period.text = "\(tmp)\(unit)"
                var totalMoneyTmp = tmpListData[row].valueForKey("borrow_money") as! NSString
                if totalMoneyTmp.integerValue > 10000 {
                    totalMoneyTmp = "\(totalMoneyTmp.integerValue/10000)"
                    totalMoney.text = "\(totalMoneyTmp)万元"
                } else {
                    totalMoney.text = "\(totalMoneyTmp)元"
                }
                //借款状态
                var status = tmpListData[row].objectForKey("borrow_status") as! NSString
                switch status {
                
                case "6":
                    btn.layer.backgroundColor = UIColor.grayColor().CGColor
                    btn.setTitle("还款中", forState: nil)
                    btn.enabled = false
                case "7":
                    btn.layer.backgroundColor = UIColor.grayColor().CGColor
                    btn.setTitle("已完成", forState: nil)
                    btn.enabled = true
                default:
                    break
                }
                
                
                tmp = tmpListData[row].valueForKey("borrow_interest_rate") as! String
                percent.text = "\(tmp)%"
                //progress.progress = pro.floatValue/100.0
                
                transferData.text = tmpListData[row].valueForKey("per_transferData") as? String
                cell.addSubview(transferData)
                transferData.hidden = true
                
                duration.text = tmpListData[row].valueForKey("borrow_duration") as? String
                cell.addSubview(duration)
                duration.hidden = true
                
                hideId.text = tmpListData[row].valueForKey("id") as? String
                cell.addSubview(hideId)
                hideId.hidden = true
                hideType.text = tmpListData[row].valueForKey("borrow_type") as? String
                cell.addSubview(hideType)
                hideType.hidden = true
                
                
                //圆形进度条
                var circleProgress =  cell.viewWithTag(201) as! MDRadialProgressView
                var circleProgressTheme = MDRadialProgressTheme()
                //circleProgressTheme.completedColor = UIColor(red: 90/255.0, green: 212/255.0, blue: 39/255.0, alpha: 1.0)
                circleProgressTheme.completedColor = UIColor(red: 68/255.0, green: 138/255.0, blue: 255/255.0, alpha: 1.0)
                circleProgressTheme.incompletedColor = UIColor(red: 235/255.0, green: 235/255.0, blue: 235/255.0, alpha: 1.0)
                circleProgressTheme.centerColor = UIColor.clearColor()
                circleProgressTheme.centerColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1.0)
                circleProgressTheme.sliceDividerHidden = true
                circleProgressTheme.labelColor = UIColor.blackColor()
                circleProgressTheme.labelShadowColor = UIColor.whiteColor()
                
                circleProgress.theme = circleProgressTheme
                circleProgress.progressTotal = 100
                circleProgress.progressCounter = UInt(pro.integerValue)
                
            }else{
//              如果没有数据，单元格不能点击
                cell.accessoryType = .None
            }
        }
        
        return cell
        
    }
    
    //section数量
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
        
    }
//    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        if section == 0{
//            let v = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 35))
//            let title = UILabel(frame:CGRect(x: 13, y: 10, width: v.frame.width, height: 18))
//            title.text = "投资理财"
//            title.font = UIFont(name: "System", size: 16)
//            title.textColor = UIColor.grayColor()
//            v.addSubview(title)
//            return v
//        }
//        if section == 1{
//            let v = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 35))
//            let title = UILabel(frame:CGRect(x: 13, y: 10, width: v.frame.width, height: 18))
//            title.text = "热销产品"
//            title.font = UIFont(name: "System", size: 16)
//            return v
//        }
//        return UIView()
//    }
//    //section的title
//    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        if section == 0{
//            return "投资列表"
//        }else{
//            return ""
//        }
//    }
    //section的header高度
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    //view将要加载的时候触发的事件
    override func viewWillAppear(animated: Bool) {
        //        println("lendView")
        //隐藏筛选
        
        
        
        //检查是否连接网络
//        NSLog("检查是否连接网络")
        var reach = Reachability(hostName: Constant.getDomain())
        reach.unreachableBlock = {(r:Reachability!) -> Void in
            dispatch_async(dispatch_get_main_queue(), {
                let alert = UIAlertController(title: "提示", message: "网络连接有问题，请检查手机网络", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.Cancel, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                
            })
        }
        reach.startNotifier()
    
    }
    func stopCircle(){
        if self.circle.isAnimating() {
            self.circle.stopAnimating()
            self.circle.hidden = true
            //显示tableview
            self.mainTable.hidden = false
        }
        
    }
    //返回
    @IBAction func closed(segue:UIStoryboardSegue){
    }
}
