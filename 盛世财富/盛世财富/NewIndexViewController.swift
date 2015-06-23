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
    var viewsArray = NSDictionary()//滚动图片视图
    
    var refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl.addTarget(self, action: "refreshData", forControlEvents: UIControlEvents.ValueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "松开后自动刷新")
        self.tableView.addSubview(refreshControl)
        getData("0",listType: "\(currentButton)")
        setupRefresh()
    }
    
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
    }
    /**
    获取数据
    
    :param: actionType 操作类型
    0:进入页面获取数据
    1:下拉刷新获取数据
    2:上拉加载
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
            //获取网络数据
            var manager = AFHTTPRequestOperationManager()
            var url = Common.serverHost + "/App-Index"//没有标的列表数据
            var params = [:]
            manager.responseSerializer.acceptableContentTypes = NSSet(array: ["text/html"]) as Set<NSObject>
            manager.POST(url, parameters: params,
                success: { (op:AFHTTPRequestOperation!, data:AnyObject!) -> Void in
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    
                    var result = data as! NSDictionary
                    NSLog("首页：%@", result)
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
                        if actionType == "0" {
                            self.photos = NSMutableArray()
                            if photoArray != nil {
                                self.photos = photoArray?.objectForKey("inner") as! NSMutableArray
                                //设置滚动图
                                self.headScrollImages()
                            }
                        }
                        
                    }
                    //获取数据后重新加载表格
                    self.tableView.reloadData()
                    if actionType == "1" {
                        self.refreshControl.endRefreshing()
                        self.refreshControl.attributedTitle = NSAttributedString(string: "下拉刷新")
                    }
                    
                },failure:{ (op:AFHTTPRequestOperation!,error: NSError!) -> Void in
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    if actionType == "1" {
                        self.refreshControl.endRefreshing()
                        self.refreshControl.attributedTitle = NSAttributedString(string: "下拉刷新")
                    }
                    AlertView.alert("提示", message: "网络连接有问题，请检查网络是否连接", buttonTitle: "确定", viewController: self)
                    
                }
            )
            
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
   
    //滚动图
    func headScrollImages(){
        //NSLog("加载图片:%@",self.photos!)
        if self.photos.count > 0{
            
            viewsArray = NSDictionary()
            var picarray = NSMutableArray()
            for var i=0;i<self.photos.count;i++ {
                var imageDic = self.photos[i] as? NSDictionary
                var imageUrl = imageDic?.objectForKey("img") as! String
                
                var imageData = NSData(contentsOfURL: NSURL(string: "http://www.sscf88.com"+imageUrl)!)
                
                var tempImageView = UIImageView(frame:CGRectMake(0, 64, self.view.layer.frame.width, 175))//代码指定位置
                
                //tempImageView.image = UIImage(named:"\(i)\(i)-1.png")//图片名
                tempImageView.image = UIImage(data: imageData!)
                tempImageView.contentMode = UIViewContentMode.ScaleAspectFill
                tempImageView.clipsToBounds = true
                picarray.addObject(tempImageView)//添加
                
            }
            //scrollview滚动
            var mainScorllView = YYCycleScrollView(frame: CGRectMake(0, 64, self.view.layer.frame.width, 175), animationDuration: 1.0)
            mainScorllView.fetchContentViewAtIndex = {(pageIndex:Int)->UIView in
                return picarray.objectAtIndex(pageIndex) as! UIView
            }
            
            mainScorllView.totalPagesCount = {()->Int in
                //图片的个数
                return picarray.count;
            }
            mainScorllView.TapActionBlock = {(pageIndex:Int)->() in
                //此处根据点击的索引跳转到指定的页面
                var contentViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ContentViewController") as! ContentViewController
//                var url = self.photos?[pageIndex]["url"] as String
//                contentViewController.contentUrl = "http://www.sscf88.com" + url!
//                self.navigationController?.pushViewController(contentViewController, animated: true)
            }
            self.tableView.tableHeaderView = mainScorllView
        }
    }
    

    func refreshData() {
        if self.refreshControl.refreshing {
            self.refreshControl.attributedTitle = NSAttributedString(string: "加载中")
            getData("1",listType:"\(currentButton)")
        }
    }
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
            return 5
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
}