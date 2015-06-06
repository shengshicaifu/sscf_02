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
    var ehttp = HttpController()
    var url = ""
    var type:String!
    
    
    var protectDays:String? = "0"//累计保驾护航天数
    var totalInvest:String? = "0"//总共放贷金额
    var userCount:String? = "0"//会员数量
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
//滚动图-------------------------------
        //使用多线程获取网络图片
        
        var viewsArray = NSMutableArray()
        //var colorArray = [UIColor.cyanColor(),UIColor.blueColor(),UIColor.greenColor(),UIColor.yellowColor(),UIColor.purpleColor()]
        for  i in 1...3 {
            var tempImageView = UIImageView(frame:CGRectMake(0, 64, self.view.layer.frame.width, 175))//代码指定位置
            tempImageView.image = UIImage(named:"\(i)\(i)-1.png")//图片名
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
            return viewsArray.count;
        }
        mainScorllView.TapActionBlock = {(pageIndex:Int)->() in
            //此处根据点击的索引跳转到指定的页面
            //println("点击了\(pageIndex)")
            
            var contentViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ContentViewController") as! ContentViewController
            contentViewController.contentUrl = "http://61.183.178.86:10080//ktv_zs/"
            self.navigationController?.pushViewController(contentViewController, animated: true)
        }
        
        self.tableView.tableHeaderView = mainScorllView
//滚动图-----------------------------

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
        
//首页图片标题
     
    }
    
    
    func refresh(){
        if self.refreshControl!.refreshing {
            self.refreshControl?.attributedTitle = NSAttributedString(string: "加载中...")
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
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        //获取网络数据
        var manager = AFHTTPRequestOperationManager()
        var url = Common.serverHost + "/App-Index"
        var params = [:]
        manager.responseSerializer.acceptableContentTypes = NSSet(array: ["text/html"]) as Set<NSObject>
        manager.POST(url, parameters: params,
            success: { (op:AFHTTPRequestOperation!, data:AnyObject!) -> Void in
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                var result = data as! NSDictionary
                //NSLog("首页：%@", result)
                var code = result["code"] as! Int
                if code == 200 {
                    var info = result["data"] as! NSDictionary
                    self.protectDays = info["protect_days"] as? String//累计保驾护航天数
                    self.totalInvest = info["total_invest"] as? String//总共放贷金额
                    self.userCount = info["user_count"] as? String//会员数量
                }
                if actionType == "1" {
                    self.refreshControl?.endRefreshing()
                    self.refreshControl?.attributedTitle = NSAttributedString(string: "下拉刷新")
                }
                //获取数据后重新加载表格
                self.tableView.reloadData()
            },failure:{ (op:AFHTTPRequestOperation!,error: NSError!) -> Void in
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                if actionType == "1" {
                    self.refreshControl?.endRefreshing()
                    self.refreshControl?.attributedTitle = NSAttributedString(string: "下拉刷新")
                }
                AlertView.alert("提示", message: "网络连接有问题，请检查手机网络", buttonTitle: "确定", viewController: self)
                
            }
        )

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
               t1 = "债权转让商品，"
               t2 = "12%预期年收益，100%适用保障计划"
               t3 = "稳定收益，安全放心"
               break
            case 1:
                i = UIImage(named: "1_pigmoney.png")!
                t1 = "定期理财"
                t2 = "12%预期年收益，100%适用保障计划"
                t3 = "稳定收益，安全放心"
               break
            case 2:
                i = UIImage(named: "1_americanmoney.png")!
                t1 = "收益权转让商品"
                t2 = "12%预期年收益，100%适用保障计划"
                t3 = "稳定收益，安全放心"
               break
            default:break
        }
        
        img.image = i
        l1.text = t1
        l2.text = t2
        l3.text = t3
        
        return cell
    }
    //点击cell跳转页面
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        
        if let hideType = tableView.cellForRowAtIndexPath(indexPath)?.viewWithTag(5) as?  UILabel{
            type = hideType.text
        }
        self.performSegueWithIdentifier("allList", sender:nil)
}
    //给新的界面传值
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
            var nextView:UIViewController!
            if segue.identifier == "indexCell"{
                nextView = segue.destinationViewController as! AllListViewController
            }
            if nextView != nil {
                nextView!.hidesBottomBarWhenPushed = true
            }
        }
    

}
