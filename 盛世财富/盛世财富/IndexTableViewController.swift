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
        }
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        NSThread.sleepForTimeInterval(4)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        self.refreshControl?.endRefreshing()
        self.refreshControl?.attributedTitle = NSAttributedString(string: "下拉刷新")

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
        l1.text = "安全运营:365天"
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
        l2.text = "累计放贷:¥462081004元"
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
               i = UIImage(named: "1_americanmoney.png")!
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
                i = UIImage(named: "1_money.png")!
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
