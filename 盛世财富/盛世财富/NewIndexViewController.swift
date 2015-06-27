//
//  NewIndexViewController.swift
//  盛世财富
//
//  Created by 肖典 on 15/6/22.
//  Copyright (c) 2015年 sscf88. All rights reserved.
//

import Foundation
import UIKit
class NewIndexViewController:UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    
    var currentButton = 0//当前点击按钮
    
    var protectDays:String? = "0"//累计保驾护航天数
    var totalInvest:String? = "0"//总共放贷金额
    var userCount:String? = "0"//会员数量
    var photos:NSMutableArray = NSMutableArray()//滚动图片
    var listData: NSMutableArray = NSMutableArray()//存储获取到的标列表数据
    var viewsArray = NSDictionary()//滚动图片视图
    
    var refreshControl = UIRefreshControl()
    
    var adView:UIView?//广告视图

    //MARK:- uiviewcontroller
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //首页图片标题
        var titleView = UIView(frame: CGRectMake(0, 0, 200, 44))
        var imgView = UIImageView()
        imgView.image = UIImage(named: "0_title.png")
        imgView.frame = CGRectMake(10, 9, 180, 26)
        imgView.contentMode = UIViewContentMode.ScaleAspectFit
        imgView.autoresizesSubviews = true
        imgView.autoresizingMask = UIViewAutoresizing.FlexibleLeftMargin|UIViewAutoresizing.FlexibleTopMargin|UIViewAutoresizing.FlexibleWidth|UIViewAutoresizing.FlexibleHeight
        titleView.addSubview(imgView)
        self.navigationItem.titleView = titleView
        
        //弹框显示活动
        //self.showAd()
        
        refreshControl.addTarget(self, action: "refreshData", forControlEvents: UIControlEvents.ValueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "松开后自动刷新")
        self.tableView.addSubview(refreshControl)
        getData("0",listType: "\(currentButton)")
        setupRefresh()
    }
    
    override func viewWillAppear(animated: Bool) {
        if tableView.indexPathForSelectedRow() != nil {
            self.tableView.deselectRowAtIndexPath(tableView.indexPathForSelectedRow()!, animated: true)
        }
    }
    
    //MARK:- 弹出广告
    //弹框显示活动
    func showAd(){
        
        //广告图
        var adImageView = UIImageView(image: UIImage(named: "ad_1")!)
        adImageView.frame = CGRectMake(20.0, 100.0, self.view.frame.width-40, self.view.frame.height-200)
        adImageView.contentMode = UIViewContentMode.ScaleAspectFit
        adImageView.autoresizesSubviews = true
        adImageView.autoresizingMask = UIViewAutoresizing.FlexibleLeftMargin|UIViewAutoresizing.FlexibleTopMargin|UIViewAutoresizing.FlexibleWidth|UIViewAutoresizing.FlexibleHeight
        adImageView.backgroundColor = UIColor(red: 253/255.0, green: 170/255.0, blue: 36/255.0, alpha: 1.0)
        adImageView.layer.cornerRadius = 20
        adImageView.userInteractionEnabled = true
        adImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "adTapped"))
        adImageView.alpha = 0.0
        //关闭按钮
        var closeImageView = UIImageView(image: UIImage(named:"close")!)
        closeImageView.frame = CGRectMake(self.view.frame.width-60, 100, 40, 40)
        closeImageView.contentMode = UIViewContentMode.ScaleAspectFit
        closeImageView.autoresizesSubviews = true
        closeImageView.autoresizingMask = UIViewAutoresizing.FlexibleLeftMargin|UIViewAutoresizing.FlexibleTopMargin|UIViewAutoresizing.FlexibleWidth|UIViewAutoresizing.FlexibleHeight
        closeImageView.layer.cornerRadius = 20
        closeImageView.layer.masksToBounds = true
        closeImageView.userInteractionEnabled = true
        closeImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "adCloseTapped"))
        closeImageView.alpha = 0.0
        //广告主视图
        adView = UIView(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height))
        adView!.backgroundColor = UIColor.blackColor()
        //adView!.alpha = 0.5
        adView?.backgroundColor = UIColor(white: 0.0, alpha: 0.0)
        adView!.addSubview(adImageView)
        adView!.addSubview(closeImageView)
        //adView!.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "adBackgroundTapped"))
        self.tabBarController?.view.addSubview(adView!)
        UIView.animateWithDuration(2.0, animations: { () -> Void in
            adImageView.alpha = 1.0
            closeImageView.alpha = 1.0
            self.adView?.backgroundColor = UIColor(white: 0.0, alpha: 0.7)
        })
        
    }
    
    func adTapped(){
        //NSLog("点击了活动页面")
        if adView != nil {
            adView?.removeFromSuperview()
        }
    }
    
    func adCloseTapped(){
        //NSLog("点击了活动关闭按钮")
        if adView != nil {
            adView?.removeFromSuperview()
        }
    }
    func adBackgroundTapped(){
        //NSLog("点击了活动背景")
        if adView != nil {
            adView?.removeFromSuperview()
        }
    }
    //MARK:- 选择理财产品
    @IBAction func tapIn(sender:UIButton){
        switch sender.tag {
        case 11:
            currentButton = 0
        case 12:
            currentButton = 1
        case 13:
            currentButton = 2
        case 14:
            currentButton = 3
        default:
            break
        }
        sender.selected = true
        self.tableView.reloadData()
        self.listData.removeAllObjects()
        self.getData("0", listType: "\(currentButton)")
    }
    
    //MARK:- 获取数据
    /**
    获取滚动图片，网站投资数据，列表数据
    
    :param: actionType 0:进入页面获取数据  1:下拉刷新获取数据  2:上拉加载
    :param: listType   0:全部  1:债权转让  2:定期理财  3:受益权转让
    */
    func getData(actionType:String,listType:String){
        
        //检查手机网络
        var reach = Reachability(hostName: Common.domain)
        reach.unreachableBlock = {(r:Reachability!) -> Void in
            //NSLog("网络不可用")
            dispatch_async(dispatch_get_main_queue(), {
                if actionType == "1" {
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    self.refreshControl.endRefreshing()
                    self.refreshControl.attributedTitle = NSAttributedString(string: "下拉刷新")
                }
                AlertView.alert("提示", message: "网络连接有问题，请检查网络是否连接", buttonTitle: "确定", viewController: self)
            })
        }
        
        reach.reachableBlock = {(r:Reachability!) -> Void in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            var manager = AFHTTPRequestOperationManager()
            var url = ""
            var params = [:]
            manager.responseSerializer.acceptableContentTypes = NSSet(array: ["text/html"]) as Set<NSObject>
            
            if actionType != "2" {
                //不为上拉加载，获取滚动图和网站数据
                url = Common.serverHost + "/App-Index"
                manager.POST(url, parameters: params,
                    success: { (op:AFHTTPRequestOperation!, data:AnyObject!) -> Void in
                        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                        
                        var result = data as! NSDictionary
                        //NSLog("首页：%@", result)
                        var code = result["code"] as! Int
                        if code == 200 {
                            var info = result["data"] as! NSDictionary
                            var protectDaysDouble = info["protect_days"] as! Int//累计保驾护航天数
                            var totalInvestDouble = info["total_invest"] as! Int//总共放贷金额
                            var userCountDouble = info["user_count"] as! Int//会员数量
                            var photoArray = info["photoes"] as? NSDictionary//滚动图
                            
                            self.protectDays = "\(protectDaysDouble)"
                            self.totalInvest = "\(totalInvestDouble)"
                            self.userCount = "\(userCountDouble)"
                            //if actionType == "0" {
                                self.photos.removeAllObjects()
                                if photoArray != nil {
                                    var parray = photoArray?.objectForKey("inner") as! NSArray
                                    self.photos.addObjectsFromArray(parray as [AnyObject])
                                    //NSLog("photos = %@", self.photos)
                                    //设置滚动图
                                    self.headScrollImages()
                                }
                            //}
                            
                        }
                        //获取数据后重新加载表格
                        //self.tableView.reloadData()
                        if actionType == "1" {
                            self.refreshControl.endRefreshing()
                            self.refreshControl.attributedTitle = NSAttributedString(string: "下拉刷新")
                        }
                        
                        
                        
                        
                        
                        params = ["pageSize":"10"]
                        //获取标列表数据
                        switch listType {
                        case "0":
                            //全部商品
                            url = Common.serverHost + "/app-invest-content"
                            if actionType == "2" {
                                //记录最后一个[标的]的ID号码
                                var borrow_id = 0
                                var count = self.listData.count
                                if count > 0 {
                                    borrow_id = (self.listData[count - 1].valueForKey("id") as! NSString).integerValue
                                    params = ["borrow_id":"\(borrow_id)","pageSize":"10"]
                                }
                            }
                            
                            break
                        case "1":
                            //债权转让商品
                            url = Common.serverHost + "/App-Invest-getBiaoList"
                            if actionType == "2" {
                                //记录最后一个[标的]的ID号码
                                var borrow_id = 0
                                var count = self.listData.count
                                if count > 0 {
                                    borrow_id = (self.listData[count - 1].valueForKey("id") as! NSString).integerValue
                                    params = ["borrow_id":"\(borrow_id)","count":"4"]
                                }
                            }else{
                                params = ["count":"4"]
                            }
                            
                            break
                        case "2":
                            //定期理财
                            url = Common.serverHost + "/App-Invest-getActiveList"
                            if actionType == "2" {
                                //记录最后一个[标的]的ID号码
                                var borrow_id = 0
                                var count = self.listData.count
                                if count > 0 {
                                    borrow_id = (self.listData[count - 1].valueForKey("id") as! NSString).integerValue
                                    params = ["borrow_id":"\(borrow_id)","pageSize":"10"]
                                }
                            }
                            break
                        case "3":
                            //受益权转让
                            url = Common.serverHost + "/App-Beneficial"
                            if actionType == "2" {
                                //记录最后一个[标的]的ID号码
                                var borrow_id = 0
                                var count = self.listData.count
                                if count > 0 {
                                    borrow_id = (self.listData[count - 1].valueForKey("id") as! NSString).integerValue
                                    params = ["borrow_id":"\(borrow_id)","pageSize":"10"]
                                }
                            }
                            break
                        default:
                            url = Common.serverHost + "/app-invest-content"
                            if actionType == "2" {
                                //记录最后一个[标的]的ID号码
                                var borrow_id = 0
                                var count = self.listData.count
                                if count > 0 {
                                    borrow_id = (self.listData[count - 1].valueForKey("id") as! NSString).integerValue
                                    params = ["borrow_id":"\(borrow_id)","pageSize":"10"]
                                }
                            }
                            break
                        }
                        
                        if actionType == "0" {
                            loading.startLoading(self.view)
                        }else if (actionType == "1" || actionType == "2"){
                            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
                        }
                        //NSLog("url = %@", url)
                        //NSLog("params = %@", params)
                        manager.POST(url, parameters: params,
                            success: { (op:AFHTTPRequestOperation!, data:AnyObject!) -> Void in
                                var result:NSDictionary = data as! NSDictionary
                                //NSLog("标的列表结果%@", result)
                                if actionType == "0" {
                                    loading.stopLoading()
                                }else if actionType == "1"{
                                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                                    self.tableView.headerEndRefreshing()
                                }else if actionType == "2"{
                                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                                    self.tableView.footerEndRefreshing()
                                }
                                
                                if (listType == "0") || (listType == "2") {
                                    //0:全部  2:定期理财
                                    if (actionType == "0" || actionType == "1"){
                                        //下拉刷新要删除旧数据
                                        self.listData.removeAllObjects()
                                    }
                                    if let resultList = result["data"]?["list"] as? NSArray {
                                        self.listData.addObjectsFromArray(resultList as [AnyObject])
                                    }
                                }else if listType == "3" {
                                    //3:受益权转让
                                    if (actionType == "0" || actionType == "1" || actionType == "2"){
                                        //下拉刷新要删除旧数据
                                        self.listData.removeAllObjects()
                                    }
                                    if let resultList = result["data"] as? NSArray {
                                        self.listData.addObjectsFromArray(resultList as [AnyObject])
                                    }
                                    
                                }else if listType == "1" {
                                    //1:债权转让
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
                                //                    for(var i=0;i<self.listData.count;i++){
                                //                        var dic = self.listData[i] as! NSDictionary
                                //                        println(dic["id"] as! String)
                                //                    }
                                self.tableView.reloadData()
                                if actionType == "0" {
                                    if let chooseView = self.view.viewWithTag(123) {
                                        self.tableView.setContentOffset(CGPointMake(0, 150), animated: true)
                                    }
                                }
                            },
                            failure:{ (op:AFHTTPRequestOperation!,error:NSError!) -> Void in
                                if actionType == "0" {
                                    loading.stopLoading()
                                }else if actionType == "1"{
                                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                                    self.tableView.headerEndRefreshing()
                                }else if actionType == "2"{
                                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                                    self.tableView.footerEndRefreshing()
                                }
                                AlertView.alert("提示", message: "服务器错误", buttonTitle: "确定", viewController: self)
                            }
                        )

                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                    },failure:{ (op:AFHTTPRequestOperation!,error: NSError!) -> Void in
                        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                        if actionType == "1" {
                            self.refreshControl.endRefreshing()
                            self.refreshControl.attributedTitle = NSAttributedString(string: "下拉刷新")
                        }
                        AlertView.alert("提示", message: error.description, buttonTitle: "确定", viewController: self)
                        
                    }
                )
            }

        }
        reach.startNotifier()
    }
    //为table添加下拉刷新和上拉加载功能
    func setupRefresh(){
//        //下拉刷新
//        self.tableView.addHeaderWithCallback({
//            self.getData("1")
//        })
        
        //上拉加载
        self.tableView.addFooterWithCallback({
            self.getData("2",listType:"\(self.currentButton)")
        })
    }
    
    func refreshData() {
        if self.refreshControl.refreshing {
            self.refreshControl.attributedTitle = NSAttributedString(string: "加载中")
            getData("1",listType:"\(currentButton)")
        }
    }
    
    var mainScorllView:YYCycleScrollView?
    
    //MARK:- 滚动图
    func headScrollImages(){
        //NSLog("加载图片:%@",self.photos)
        if self.photos.count > 0{
            var picarray = NSMutableArray()
            //第一次将远程获取到的图片保存到本地，以后再获取时，判断url在本地是否存在，如果存在则使用本地数据，否则获取远程数据。当本地保存的滚动图片超过10张的时候，清除掉
            var userDefaults = NSUserDefaults.standardUserDefaults()
            var indexImagesArray:NSMutableArray! = NSMutableArray()
            if let arr = userDefaults.objectForKey("indexImages") as? NSArray {
                indexImagesArray.addObjectsFromArray(arr as [AnyObject])
            }

            for var i=0;i<self.photos.count;i++ {
                var imageDic = self.photos[i] as? NSDictionary
                var imageUrl = imageDic?.objectForKey("img") as! String
                var imageNsstring = NSString(string: imageUrl)
                var imageName = imageNsstring.substringFromIndex(15)//截取图片地址的最后一段随机名称
                
                var imageData:NSData? = NSData()
                
                var flag = false // true 本地有  false本地没有
                var dataTemp:NSData?
                for var i=0;i<indexImagesArray.count;i++ {
                    var dic = indexImagesArray[i] as! NSDictionary
                    
                    if let data = dic.objectForKey(imageName) as? NSData {
                        //从本地获取
                        flag = true
                        dataTemp = data
                        break
                    }else{
                        //远程获取
                        flag = false
                    }
                }
                
                if flag {
                    //从本地获取
                    imageData = dataTemp
                    //NSLog("从本地获取%@", imageUrl)
                }else{
                    //远程获取
                    //NSLog("从远程获取%@", imageUrl)
                    imageData = NSData(contentsOfURL: NSURL(string: Common.serverHost+imageUrl)!)
                    var d = NSMutableDictionary()
                    d.setValue(imageData, forKey: imageName)
                    indexImagesArray.insertObject(d, atIndex: 0)//将新获取的数据放到数组的开头
                }
                

                var tempImageView = UIImageView(frame:CGRectMake(0, 64, self.view.layer.frame.width, 175))//代码指定位置
                tempImageView.image = UIImage(data: imageData!)
                tempImageView.contentMode = UIViewContentMode.ScaleAspectFill
                tempImageView.clipsToBounds = true
                picarray.addObject(tempImageView)//添加到滚动区域
                
            }
            
            
            //保存的图片张数不能超过photos.count
            if indexImagesArray.count > self.photos.count {
                indexImagesArray.removeObjectsInRange(NSMakeRange(self.photos.count, indexImagesArray.count - self.photos.count))
            }
            
            
            //将图片重新保存本地
            userDefaults.setObject(indexImagesArray, forKey: "indexImages")
            
//            viewsArray = NSDictionary()
            
            
            //scrollview滚动
            mainScorllView = YYCycleScrollView(frame: CGRectMake(0, 64, self.view.layer.frame.width, 175), animationDuration: 1.0)
            //mainScorllView?.contentViews.removeAllObjects()
            mainScorllView!.fetchContentViewAtIndex = {(pageIndex:Int)->UIView in
                return picarray.objectAtIndex(pageIndex) as! UIView
            }
            
            mainScorllView!.totalPagesCount = {()->Int in
                //图片的个数
                return picarray.count;
            }
            mainScorllView!.TapActionBlock = {(pageIndex:Int)->() in
                //此处根据点击的索引跳转到指定的页面
                var contentViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ContentViewController") as! ContentViewController
//                var url = self.photos?[pageIndex]["url"] as String
//                contentViewController.contentUrl = "http://www.sscf88.com" + url!
//                self.navigationController?.pushViewController(contentViewController, animated: true)
            }
            self.tableView.tableHeaderView = mainScorllView
        }
    }


    
    //MARK:- tableview
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell?
        let sec = indexPath.section
        let row = indexPath.row
        if sec == 0{
            cell = tableView.dequeueReusableCellWithIdentifier("choose") as? UITableViewCell
            
            var all:UIButton?
            var wallet:UIButton?
            var pig:UIButton?
            var money:UIButton?
            if let _all:UIButton = cell!.viewWithTag(11) as? UIButton{
                _all.addTarget(self, action: "tapIn:", forControlEvents: UIControlEvents.TouchDown)
                all = _all
            }
            if let _wallet:UIButton = cell!.viewWithTag(12) as? UIButton{
                _wallet.addTarget(self, action: "tapIn:", forControlEvents: UIControlEvents.TouchDown)
                wallet = _wallet
            }
            if let _pig:UIButton = cell!.viewWithTag(13) as? UIButton{
                _pig.addTarget(self, action: "tapIn:", forControlEvents: UIControlEvents.TouchDown)
                pig = _pig
            }
            if let _money:UIButton = cell!.viewWithTag(14) as? UIButton{
                _money.addTarget(self, action: "tapIn:", forControlEvents: UIControlEvents.TouchDown)
                money = _money
            }
            switch currentButton{
            case 0:
                all?.selected = true
                wallet?.selected = false
                pig?.selected = false
                money?.selected = false
            case 1:
                all?.selected = false
                wallet?.selected = true
                pig?.selected = false
                money?.selected = false

            case 2:
                all?.selected = false
                wallet?.selected = false
                pig?.selected = true
                money?.selected = false

            case 3:
                all?.selected = false
                wallet?.selected = false
                pig?.selected = false
                money?.selected = true
            default:
                break
            }
        }
        if sec == 1{
            cell = tableView.dequeueReusableCellWithIdentifier("list") as? UITableViewCell
            if self.listData.count > 0 {
                let rowData = self.listData[indexPath.row] as! NSDictionary
                var title = cell?.viewWithTag(1) as! UILabel
                var rate = cell?.viewWithTag(2) as! UILabel
                var period = cell?.viewWithTag(3) as! UILabel
                var availMoney = cell?.viewWithTag(4) as! UILabel
                
                if currentButton != 3 {
                    title.text = rowData.valueForKey("borrow_name") as? String
                    var r = rowData.valueForKey("borrow_interest_rate") as? String
                    rate.text = "\(r!)%"
                    
                    var borrow_duration = rowData.valueForKey("borrow_duration") as? String
                    var duration_unit = rowData.valueForKey("duration_unit") as? String
                    
                    period.text = borrow_duration! + duration_unit!
                    
                    var needStr = rowData.valueForKey("need") as? Double
                    availMoney.text = "\(needStr!)元"
                    
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
                    
                    
                    var pview = (cell?.viewWithTag(5))!
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
                        var unit = rowData.valueForKey("progress") as! NSString
                        var progress = CircleView()
                        progress.tag = 1
                        progress.type = "1"
                        progress.backgroundColor = UIColor.whiteColor()
                        progress.frame = CGRectMake(0, 0, pview.frame.width , pview.frame.height)
                        progress.percent = unit.doubleValue/100.0
                        progress.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "buy:"))
                        pview.addSubview(progress)
                    }else{
                        //不能买
                        var progress = CircleView()
                        progress.tag = 2
                        progress.type = "2"
                        progress.backgroundColor = UIColor.whiteColor()
                        progress.frame = CGRectMake(0, 0, pview.frame.width , pview.frame.height)
                        progress.percent = 0.0
                        progress.tip = statusTipLabel.text!
                        pview.addSubview(progress)
                    }

                }else{
                    //受益权转让
                    title.text = rowData.valueForKey("borrow_name") as? String
                    var r = rowData.valueForKey("borrow_interest_rate") as? String
                    rate.text = "\(r!)%"
                    
                    var borrow_duration = rowData.valueForKey("borrow_duration") as? String
                    period.text = "\(borrow_duration!)个月"
                    
                    var needStr = rowData.valueForKey("surplus_money") as? String
                    availMoney.text = "\(needStr!)元"
                    
                    var status = rowData["status"] as! NSString
                    var pview = (cell?.viewWithTag(5))!
                    pview.backgroundColor = UIColor.whiteColor()
                    if pview.viewWithTag(1) != nil {
                        pview.viewWithTag(1)?.removeFromSuperview()
                    }
                    if pview.viewWithTag(2) != nil {
                        pview.viewWithTag(2)?.removeFromSuperview()
                    }
                    if status == "1" {
                        //能买
                        //圆形进度条
                        var progress = CircleView()
                        progress.incompleteFontColor = progress.completeFontColor
                        progress.tag = 1
                        progress.type = "2"
                        progress.backgroundColor = UIColor.whiteColor()
                        progress.frame = CGRectMake(0, 0, pview.frame.width , pview.frame.height)
                        progress.percent = 100/100.0
                        progress.tip = "立即投资"
                        progress.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "buy:"))
                        pview.addSubview(progress)
                        
                    }else{
                        //不能买
                        var progress = CircleView()
                        progress.tag = 2
                        progress.type = "2"
                        progress.backgroundColor = UIColor.whiteColor()
                        progress.frame = CGRectMake(0, 0, pview.frame.width , pview.frame.height)
                        progress.percent = 0.0
                        progress.tip = "已结束"
                        pview.addSubview(progress)
                    }
                }
                
            }
        }
        return cell!
    }
    
    
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0{
        var view = UIView(frame: CGRectMake(0, 0, self.tableView.frame.width, 30))
        view.backgroundColor = UIColor(red: 230/250.0, green: 230/250.0, blue: 230/250.0, alpha: 1.0)
        
        var l1 = UILabel()
        l1.text = "安全运营:\(protectDays!)天"
        l1.font = UIFont(name: "Arial", size: 12)
        l1.sizeToFit()
        //l1.adjustsFontSizeToFitWidth = true
        l1.setTranslatesAutoresizingMaskIntoConstraints(false)
        view.addSubview(l1)
        var l1Constraint = NSLayoutConstraint(item: l1, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Leading, multiplier: 1.0, constant: 20)
        view.addConstraint(l1Constraint)
        l1Constraint = NSLayoutConstraint(item: l1, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0)
        view.addConstraint(l1Constraint)
        l1Constraint = NSLayoutConstraint(item: l1, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Width, multiplier: 0.5, constant: -20)
        view.addConstraint(l1Constraint)
        
        var l2 = UILabel()
        l2.text = "累计放贷:¥\(totalInvest!)元"
        l2.font = UIFont(name: "Arial", size: 12)
        l2.sizeToFit()
        l2.textAlignment = NSTextAlignment.Right
        //l2.adjustsFontSizeToFitWidth = true
        l2.setTranslatesAutoresizingMaskIntoConstraints(false)
        view.addSubview(l2)
        
        var l2Constraint = NSLayoutConstraint(item: l2, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Trailing, multiplier: 1.0, constant: -20)
        view.addConstraint(l2Constraint)
        l2Constraint = NSLayoutConstraint(item: l2, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0)
        view.addConstraint(l2Constraint)
        l2Constraint = NSLayoutConstraint(item: l2, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Width, multiplier: 0.5, constant: -20)
        view.addConstraint(l2Constraint)
        //        l2Constraint = NSLayoutConstraint(item: l2, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: l1, attribute: NSLayoutAttribute.Trailing, multiplier: 1.0, constant: 20)
        //        view.addConstraint(l2Constraint)
        
        return view
        }
        return UIView()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }
        if section == 1{
            return self.listData.count
        }
        return 0
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) ->   CGFloat{
        if indexPath.section == 0{
            return 90
        }
        if indexPath.section == 1{
            return 110
        }
        return 0
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        if section == 0{
            return 20
        }
        return 0.001
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- 页面跳转
    //跳到标的详情
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "lendDetail" {
            //            var vc = segue.destinationViewController as! LendDetailViewController
            var selectedRow = self.tableView.indexPathForSelectedRow()?.row
            var dic = self.listData[selectedRow!] as! NSDictionary
            
            var vc = segue.destinationViewController as! NewDetailScrollViewController
            vc.hidesBottomBarWhenPushed = true
            vc.id = dic.objectForKey("id") as? String
        }
    }
    
    func buy(sender:UIGestureRecognizer){
        if let tableCell = sender.view?.superview?.superview?.superview as? UITableViewCell {
            var indexPath = self.tableView.indexPathForCell(tableCell)!
//            NSLog("购买选中的行%i", indexPath.row)
            var d = self.listData[indexPath.row] as! NSDictionary
            var id = d.objectForKey("id") as! String
//            NSLog("购买选中的id%@",id)
            
            if self.currentButton == 3 {
                //跳到受益权购买页面
                if Common.isLogin() == false {
                    AlertView.alert("提示", message: "请先登录", okButtonTitle: "确定", cancelButtonTitle: "取消", viewController: self, okCallback: { (action:UIAlertAction!) -> Void in
                        var loginViewController = self.storyboard?.instantiateViewControllerWithIdentifier("loginViewController") as! LoginViewController
                        self.presentViewController(loginViewController, animated: true, completion: nil)
                        }, cancelCallback: { (action:UIAlertAction!) -> Void in
                            
                    })
                    return
                }
                var b = self.storyboard?.instantiateViewControllerWithIdentifier("BeneficialPowerConfirmViewController") as! BeneficialPowerConfirmViewController
                b.id = id
                self.navigationController?.pushViewController(b, animated: true)
            
            }else{
                var bidConfirmViewController = self.storyboard?.instantiateViewControllerWithIdentifier("bidConfirmViewController") as! BidConfirmViewController
                bidConfirmViewController.id = id
                bidConfirmViewController.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(bidConfirmViewController, animated: true)
            }
            
            
        }
    }
    
    var contentOffsetY:CGFloat = 0
    var oldContentOffsetY:CGFloat = 0
    var newContentOffsetY:CGFloat = 0
    //MARK:- 滚动
    //开始拖拽视图
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        contentOffsetY = scrollView.contentOffset.y
    }
    // 滚动时调用此方法(手指离开屏幕后)
    func scrollViewDidScroll(scrollView: UIScrollView) {
        //NSLog("scrollView.contentOffset:%f, %f", scrollView.contentOffset.x, scrollView.contentOffset.y)
        newContentOffsetY = scrollView.contentOffset.y
        if (newContentOffsetY > oldContentOffsetY && oldContentOffsetY > contentOffsetY) {  // 向上滚动

            //NSLog("up")

        } else if (newContentOffsetY < oldContentOffsetY && oldContentOffsetY < contentOffsetY) { // 向下滚动
            //NSLog("down")
        }else {

            //NSLog("dragging")
            
        }
        
        if scrollView.dragging {// 拖拽
            //NSLog("scrollView.dragging")
            //NSLog("contentOffsetY: %f", contentOffsetY)
            NSLog("newContentOffsetY: %f", scrollView.contentOffset.y)
            
            //创建筛选条件
            if scrollView.contentOffset.y > 130 {
                var chooseView = self.view.viewWithTag(123)
                if chooseView == nil {
                    //创建
                    var v = UIView(frame: CGRectMake(0, 64, self.view.frame.width, 90))
                    var recognizer = UISwipeGestureRecognizer(target: self, action: "toTop:")
                    recognizer.direction = UISwipeGestureRecognizerDirection.Up
                    v.addGestureRecognizer(recognizer)
                    v.backgroundColor = UIColor.whiteColor()
                    v.alpha = 0.9
                    v.tag = 123
                    
                    var effectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Light))
                    effectView.frame = v.frame
                    v.addSubview(effectView)
                    
                    var vFrame = v.frame
                    var imageWidth:CGFloat = 42
                    var btn1 = UIButton(frame: CGRectMake(vFrame.width/8 - imageWidth/2, 8, imageWidth, imageWidth))
                    var btn2 = UIButton(frame: CGRectMake(vFrame.width*3/8 - imageWidth/2, 8, imageWidth, imageWidth))
                    var btn3 = UIButton(frame: CGRectMake(vFrame.width*5/8 - imageWidth/2, 8, imageWidth, imageWidth))
                    var btn4 = UIButton(frame: CGRectMake(vFrame.width*7/8 - imageWidth/2, 8, imageWidth, imageWidth))
                    btn1.tag = 201
                    btn2.tag = 202
                    btn3.tag = 203
                    btn4.tag = 204
                    btn1.setBackgroundImage(UIImage(named: "all"), forState: UIControlState.Normal)
                    btn1.setBackgroundImage(UIImage(named: "all_blue"), forState: UIControlState.Selected)
                    
                    btn2.setBackgroundImage(UIImage(named: "wallet"), forState: UIControlState.Normal)
                    btn2.setBackgroundImage(UIImage(named: "wallet_blue"), forState: UIControlState.Selected)
                    
                    btn3.setBackgroundImage(UIImage(named: "pig"), forState: UIControlState.Normal)
                    btn3.setBackgroundImage(UIImage(named: "pig_blue"), forState: UIControlState.Selected)
                    
                    btn4.setBackgroundImage(UIImage(named: "money"), forState: UIControlState.Normal)
                    btn4.setBackgroundImage(UIImage(named: "money_blue"), forState: UIControlState.Selected)
                    
                    btn1.addTarget(self, action: "choosed:", forControlEvents: UIControlEvents.TouchUpInside)
                    btn2.addTarget(self, action: "choosed:", forControlEvents: UIControlEvents.TouchUpInside)
                    btn3.addTarget(self, action: "choosed:", forControlEvents: UIControlEvents.TouchUpInside)
                    btn4.addTarget(self, action: "choosed:", forControlEvents: UIControlEvents.TouchUpInside)
                    btn1.adjustsImageWhenHighlighted = false
                    btn2.adjustsImageWhenHighlighted = false
                    btn3.adjustsImageWhenHighlighted = false
                    btn4.adjustsImageWhenHighlighted = false
                    
                    var lab1 = UILabel(frame: CGRectMake(0, 60, vFrame.width/4, 20))
                    lab1.text = "全部"
                    lab1.textAlignment = NSTextAlignment.Center
                    lab1.font = UIFont(name: "Arial", size: 14)
                    
                    
                    var lab2 = UILabel(frame: CGRectMake(vFrame.width/4, 60, vFrame.width/4, 20))
                    lab2.text = "债权转让"
                    lab2.textAlignment = NSTextAlignment.Center
                    lab2.font = UIFont(name: "Arial", size: 14)
                    
                    var lab3 = UILabel(frame: CGRectMake(vFrame.width*2/4, 60, vFrame.width/4, 20))
                    lab3.text = "定期理财"
                    lab3.textAlignment = NSTextAlignment.Center
                    lab3.font = UIFont(name: "Arial", size: 14)
                    
                    var lab4 = UILabel(frame: CGRectMake(vFrame.width*3/4, 60, vFrame.width/4, 20))
                    lab4.text = "受益权转让"
                    lab4.textAlignment = NSTextAlignment.Center
                    lab4.font = UIFont(name: "Arial", size: 14)
                    
                    if currentButton == 0 {
                        btn1.selected = true
                        btn2.selected = false
                        btn3.selected = false
                        btn4.selected = false
                    }else if currentButton == 1 {
                        btn2.selected = true
                        btn1.selected = false
                        btn3.selected = false
                        btn4.selected = false
                    }else if currentButton == 2 {
                        btn3.selected = true
                        btn1.selected = false
                        btn2.selected = false
                        btn4.selected = false
                    }else{
                        btn4.selected = true
                        btn1.selected = false
                        btn2.selected = false
                        btn3.selected = false
                    }
                    
                    v.addSubview(btn1)
                    v.addSubview(btn2)
                    v.addSubview(btn3)
                    v.addSubview(btn4)
                    v.addSubview(lab1)
                    v.addSubview(lab2)
                    v.addSubview(lab3)
                    v.addSubview(lab4)
                    
                    self.view.addSubview(v)
                }
            }else{
                var chooseView = self.view.viewWithTag(123)
                if chooseView != nil {
                    //删除
                    chooseView?.removeFromSuperview()
                }
            }
            
            if ((scrollView.contentOffset.y - contentOffsetY) > 5.0) {  // 向上拖拽
                
                
                
                // 隐藏导航栏和选项栏
                
                // [self layoutView];
                
                //[_viewController.navigationController setNavigationBarHidden:YES animated:YES];
                
                //self.navigationController?.setNavigationBarHidden(true, animated: true)
                
                //[_viewController.navigationController setToolbarHidden:!hidden animated:YES];
                
                //_viewController.tabBarController.tabBar.hidden = YES;
                self.tabBarController?.tabBar.hidden = true
                
                
            }else if ((contentOffsetY - scrollView.contentOffset.y) > 5.0) {   // 向下拖拽
                
                
                
                // 显示导航栏和选项栏
                
                //[self layoutView];
                
                
                
                //[_viewController.navigationController setNavigationBarHidden:NO animated:YES];
                //self.navigationController?.setNavigationBarHidden(false, animated: true)
                //[_viewController.navigationController setToolbarHidden:NO animated:YES];
                
                self.tabBarController?.tabBar.hidden = false
                
                
                
            } else {
                
                
                
            }
        }

    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        //NSLog("scrollViewDidEndDragging")
        oldContentOffsetY = scrollView.contentOffset.y
    }
    
    func choosed(sender:UIButton){
        
        var chooseView = sender.superview
        var b1 = chooseView?.viewWithTag(201) as! UIButton
        var b2 = chooseView?.viewWithTag(202) as! UIButton
        var b3 = chooseView?.viewWithTag(203) as! UIButton
        var b4 = chooseView?.viewWithTag(204) as! UIButton
        switch sender.tag {
            case 201:
                currentButton = 0
                b2.selected = false
                b3.selected = false
                b4.selected = false
            case 202:
                currentButton = 1
                b1.selected = false
                b3.selected = false
                b4.selected = false
            case 203:
                currentButton = 2
                b1.selected = false
                b2.selected = false
                b4.selected = false
            case 204:
                currentButton = 3
                b1.selected = false
                b2.selected = false
                b3.selected = false
            default:
                break
        }
        sender.selected = true
        //self.tableView.reloadData()
        self.listData.removeAllObjects()
        self.getData("0", listType: "\(currentButton)")
        
//        if chooseView != nil {
//            chooseView?.removeFromSuperview()
//        }
    }
    
    
    func toTop(recognizer:UISwipeGestureRecognizer){
        //NSLog("扫")
        if recognizer.direction == UISwipeGestureRecognizerDirection.Up {
            //NSLog("向上扫")
            self.tableView.setContentOffset(CGPointMake(0, 150), animated: true)
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}