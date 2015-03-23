//
//  ViewController.swift
//  盛世财富
//
//  Created by mo on 15-3-12.
//  Copyright (c) 2015年 sscf88. All rights reserved.
//

import UIKit

class LendViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    
    
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timer = NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector: "timerFunction", userInfo: nil, repeats: true)
        timer?.fire()
        
        //右划
        var swipeGesture = UISwipeGestureRecognizer(target: self, action: "handleSwipeGesture:")
        self.view.addGestureRecognizer(swipeGesture)
        //左划
        var swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: "handleSwipeGesture:")
        swipeLeftGesture.direction = UISwipeGestureRecognizerDirection.Left //不设置是右
        self.view.addGestureRecognizer(swipeLeftGesture)
        
        
        var tap = UITapGestureRecognizer(target: self, action: "tapImage:")
        topImage.addGestureRecognizer(tap)
    }
    
    func tapImage(sender: UITapGestureRecognizer){
        println(1)
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
            nextView = segue.destinationViewController as LendDetailViewController
        }
        if segue.identifier == "allList"{
            nextView = segue.destinationViewController as AllListViewController
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
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : UITableViewCell!
        
        
        //写死内容
        
        var val = indexPath.section.hashValue
        var row = indexPath.row
        
        if val == 0{
            cell = self.mainTable.dequeueReusableCellWithIdentifier("list") as UITableViewCell
            var image = cell.viewWithTag(100) as UIImageView
            var title = cell.viewWithTag(101) as UILabel
            var content = cell.viewWithTag(102) as UILabel

            if row == 0 {
                title.text = "产品1"
                content.text = "产品1的说明产品1的说明产品1的说明产品1的说明产品1的说明产品1的说明产品1的说明产品1的说明产品1的说明产品1的说明产品1的说明产品1的说明产品1的说明产品1的说明产品1的说明产品1的说明产品1的说明产品1的说明产品1的说明产品1的说明产品1的说明产品1的说明产品1的说明产品1的说明产品1的说明产品1的说明产品1的说明产品1的说明产品1的说明产品1的说明产品1的说明"
            }
            if row == 1 {
                title.text = "产品2"
                content.text = "产品2的说明"
            }
            if row == 2 {
                title.text = "产品3"
                content.text = "产品3的说明"
            }
            if row == 3 {
                title.text = "产品4"
                content.text = "产品4的说明"
            }
            if row == 4 {
                title.text = "产品5"
                content.text = "产品5的说明"
            }
        }
        if val == 1 {
            cell = self.mainTable.dequeueReusableCellWithIdentifier("person") as UITableViewCell
        }
        
        
        return cell
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
   
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return "投资理财"
        }else if section == 1{
            return "我的账户"
        }else{
            return ""
        }
    }
}
