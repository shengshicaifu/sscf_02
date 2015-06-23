//
//  IndexTableViewController.swift
//  盛世财富
//
//  Created by 莫文琼 on 15/6/2.
//  Copyright (c) 2015年 sscf88. All rights reserved.
//

import UIKit

class IndexTableViewController:UITableViewController,UITableViewDataSource,UITableViewDelegate {
    @IBOutlet var mainView: UITableView!
    var protectDays:String? = "0"//累计保驾护航天数
    var totalInvest:String? = "0"//总共放贷金额
    var userCount:String? = "0"//会员数量

    var photos:NSMutableArray? = NSMutableArray()//滚动图片
    //var viewsArray = NSMutableArray()//滚动图片视图
    
    var adView:UIView?//广告视图
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        //显示广告
        showAd()

        //下拉刷新---------------------------
        var rc = UIRefreshControl()
        rc.attributedTitle = NSAttributedString(string: "下拉刷新")
        rc.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = rc
        getData("0")
    
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

    }
    var viewsArray = NSMutableArray()
    //滚动图
    func headScrollImages(){
        //NSLog("加载图片:%@",self.photos!)
        if self.photos != nil {
            
            viewsArray.removeAllObjects()
            for var i=0;i<self.photos?.count;i++ {
                var imageDic = self.photos?[i] as? NSDictionary
                var imageUrl = imageDic?.objectForKey("img") as! String
                var imageData = NSData(contentsOfURL: NSURL(string: "http://www.sscf88.com"+imageUrl)!)
                
                var tempImageView = UIImageView(frame:CGRectMake(0, 64, self.view.layer.frame.width, 175))//代码指定位置
                
                //tempImageView.image = UIImage(named:"\(i)\(i)-1.png")//图片名
                tempImageView.image = UIImage(data: imageData!)
                tempImageView.contentMode = UIViewContentMode.ScaleAspectFill
                tempImageView.clipsToBounds = true
                viewsArray.addObject(tempImageView)//添加
                
            }
            //scrollview滚动
            var mainScorllView = YYCycleScrollView(frame: CGRectMake(0, 64, self.view.layer.frame.width, 175), animationDuration: 1.0)
            mainScorllView.fetchContentViewAtIndex = {(pageIndex:Int)->UIView in
                return self.viewsArray.objectAtIndex(pageIndex) as! UIView
            }
            
            mainScorllView.totalPagesCount = {()->Int in
                //图片的个数
                return self.viewsArray.count;
            }
            mainScorllView.TapActionBlock = {(pageIndex:Int)->() in
                //此处根据点击的索引跳转到指定的页面
                var contentViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ContentViewController") as! ContentViewController
                var url = self.photos?[pageIndex]["url"] as? String
                contentViewController.contentUrl = "http://www.sscf88.com" + url!
                self.navigationController?.pushViewController(contentViewController, animated: true)
            }
            self.tableView.tableHeaderView = mainScorllView
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
    
    //下拉刷新
    func refresh(){
        if self.refreshControl!.refreshing {
            self.refreshControl?.attributedTitle = NSAttributedString(string: "加载中")
            getData("1")
        }

    }
    
    /**
    获取数据
    
    :param: actionType 操作类型
             0:进入页面获取数据
             1:下拉刷新获取数据
    */
    func getData(actionType:String){
        
        
        //检查手机网络
        var reach = Reachability(hostName: Common.domain)
        reach.unreachableBlock = {(r:Reachability!) -> Void in
            //NSLog("网络不可用")
            dispatch_async(dispatch_get_main_queue(), {
                if actionType == "1" {
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    self.refreshControl?.endRefreshing()
                    self.refreshControl?.attributedTitle = NSAttributedString(string: "下拉刷新")
                }
                AlertView.alert("提示", message: "网络连接有问题，请检查网络是否连接", buttonTitle: "确定", viewController: self)
            })
        }

        reach.reachableBlock = {(r:Reachability!) -> Void in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            //获取网络数据
            var manager = AFHTTPRequestOperationManager()
            var url = Common.serverHost + "/App-Index"
            var params = [:]
            manager.responseSerializer.acceptableContentTypes = NSSet(array: ["text/html"]) as Set<NSObject>
            manager.GET(url, parameters: params,
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
                        var photoArray = info["photoes"] as? NSArray//滚动图
                        
                        self.protectDays = "\(protectDaysDouble)"
                        self.totalInvest = "\(totalInvestDouble)"
                        self.userCount = "\(userCountDouble)"
                        if actionType == "0" {
                            self.photos?.removeAllObjects()
                            if photoArray != nil {
                                self.photos?.addObjectsFromArray(photoArray! as [AnyObject])
                                //设置滚动图
                                self.headScrollImages()
                            }
                        }
                        
                    }
                    //获取数据后重新加载表格
                    self.tableView.reloadData()
                    if actionType == "1" {
                        self.refreshControl?.endRefreshing()
                        self.refreshControl?.attributedTitle = NSAttributedString(string: "下拉刷新")
                    }

                },failure:{ (op:AFHTTPRequestOperation!,error: NSError!) -> Void in
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    if actionType == "1" {
                        self.refreshControl?.endRefreshing()
                        self.refreshControl?.attributedTitle = NSAttributedString(string: "下拉刷新")
                    }
                    NSLog("首页错误%@", error)
                    AlertView.alert("提示", message: "网络连接有问题，请检查网络是否连接", buttonTitle: "确定", viewController: self)
                    
                }
            )

        }
        reach.startNotifier()
    }


    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 120
    }

    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
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
  
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("indexCell", forIndexPath: indexPath) as! UITableViewCell
        var img = cell.viewWithTag(1) as! UIImageView
        var l1 = cell.viewWithTag(2) as! UILabel
        var l2 = cell.viewWithTag(3) as! UILabel
        var l3 = cell.viewWithTag(4) as! UILabel
        var type = cell.viewWithTag(5) as! UILabel
        type.hidden = true
        
        var i:UIImage = UIImage()
        var t1 = ""
        var t2 = ""
        var t3 = ""
        
        switch indexPath.row {
            case 0:
               i = UIImage(named: "1_money.png")!
               t1 = "专享理财"
               t2 = "新手标、活动标，100%本息保障"
               t3 = "期限灵活  多重选择"
               break
            case 1:
                i = UIImage(named: "1_pigmoney.png")!
                t1 = "债权转让计划"
                t2 = "11%-17%预期年收益，100%本息保障"
                t3 = "1-12个月  低风险  高收益"
               break
            case 2:
                i = UIImage(named: "1_americanmoney.png")!
                t1 = "受益权转让计划"
                t2 = "11%-16.5%预期年收益，100%本息保障"
                t3 = "优质高端选择  5万起投"
               break
            default:break
        }
        
        img.image = i
        l1.text = t1
        l2.text = t2
        l3.text = t3
        
        return cell
    }

    //给新的界面传值
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var row = self.tableView.indexPathForSelectedRow()!.row
        
        var nextView:AllListViewController!
        if segue.identifier == "allList"{
            nextView = segue.destinationViewController as! AllListViewController
            nextView.type = "\(row)"
        }
        if nextView != nil {
            nextView!.hidesBottomBarWhenPushed = true
        }
    }
    

}
