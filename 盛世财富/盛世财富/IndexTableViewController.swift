//
//  IndexTableViewController.swift
//  盛世财富
//
//  Created by 莫文琼 on 15/6/2.
//  Copyright (c) 2015年 sscf88. All rights reserved.
//

import UIKit

class IndexTableViewController: UITableViewController,UITableViewDataSource,UITableViewDelegate {

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
//滚动图-------------------------------

        
//首页图片标题
        var imgView = UIImageView()
        imgView.image = UIImage(named: "1_49.png")
        self.navigationController?.navigationItem.titleView = imgView
        
//首页图片标题
        
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
        var l1 = UILabel()
        l1.text = "安全运营:365天"
        l1.sizeToFit()
        l1.setTranslatesAutoresizingMaskIntoConstraints(false)
        view.addSubview(l1)
        var l1Constraint = NSLayoutConstraint(item: l1, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Leading, multiplier: 1.0, constant: 20)
        view.addConstraint(l1Constraint)
        l1Constraint = NSLayoutConstraint(item: l1, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0)
        view.addConstraint(l1Constraint)

        
        var l2 = UILabel()
        l2.text = "累计放贷:¥462081004元"
        l2.sizeToFit()
        l2.setTranslatesAutoresizingMaskIntoConstraints(false)
        view.addSubview(l2)
        
        var l2Constraint = NSLayoutConstraint(item: l2, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Trailing, multiplier: 1.0, constant: -20)
        view.addConstraint(l2Constraint)
        l2Constraint = NSLayoutConstraint(item: l2, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0)
        view.addConstraint(l2Constraint)
        
        
        return view
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("indexCell", forIndexPath: indexPath) as! UITableViewCell
        var img = cell.viewWithTag(1) as! UIImageView
        var l1 = cell.viewWithTag(2) as! UILabel
        var l2 = cell.viewWithTag(3) as! UILabel
        var l3 = cell.viewWithTag(4) as! UILabel
        
        var i:UIImage = UIImage()
        var t1 = ""
        var t2 = ""
        var t3 = ""
        
        switch indexPath.row {
            case 0:
               i = UIImage(named: "1_41.png")!
               t1 = "热销产品"
               t2 = "每月一投，告别月光"
               t3 = "150人  20%"
               break
            case 1:
                i = UIImage(named: "1_43.png")!
                t1 = "明星单品"
                t2 = "10％预期年收益，100%本金保障"
                t3 = "20万  6%"
               break
            case 2:
                i = UIImage(named: "1_45.png")!
                t1 = "新手推荐"
                t2 = "期限灵活，50元起头"
                t3 = "10000元  8%"
               break
            default:break
        }
        
        img.image = i
        l1.text = t1
        l2.text = t2
        l3.text = t3
        
        return cell
    }
    

}
