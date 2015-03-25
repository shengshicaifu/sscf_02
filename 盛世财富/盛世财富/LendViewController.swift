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
    @IBOutlet weak var circle: UIActivityIndicatorView!
    
//    var dicList = Array<Dictionary<String,String>>()
    var dicList = NSMutableArray()
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
        
        
        var arr = NSArray()
        println(arr[0])
    }
    
    override func viewDidAppear(animated: Bool) {
        
        
        
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
        
        
        
        
        var val = indexPath.section.hashValue
        var row = indexPath.row
        
        if val == 0{
            cell = self.mainTable.dequeueReusableCellWithIdentifier("list") as UITableViewCell
            var image = cell.viewWithTag(100) as UIImageView
            var title = cell.viewWithTag(101) as UILabel
            var restMoney = cell.viewWithTag(102) as UILabel
            
            var url = "http://www.sscf88.com/app-invest-content"
            var params:NSDictionary!
            //        circle.hidden = false
            //        circle.startAnimating()
            
            
            var manager = AFHTTPRequestOperationManager()
            
            manager.GET(url, parameters: params, success: { (operation:AFHTTPRequestOperation!,responseObject: AnyObject!) -> Void in
                println("in")
                var json = responseObject as NSDictionary
                var code: Int = json["code"] as Int
                if code == 200 {
                    var anyArr:[AnyObject] = (json["data"] as NSDictionary)["list"] as [AnyObject]
                    for element in anyArr {
                        var temp:NSDictionary = element as NSDictionary
                        title.text = temp["add_time"] as String
                        restMoney.text = temp["area"] as String
                    }
                    
                }
                println("inner:\(self.dicList)")
                }, failure: {(operation:AFHTTPRequestOperation!,error:NSError!) in
                    
                    var alert = UIAlertController(title: "消息", message: "列表加载失败，请稍后重试", preferredStyle: UIAlertControllerStyle.Alert)
                    var action = UIAlertAction(title: "确定", style: UIAlertActionStyle.Default, handler: nil)
                    alert.addAction(action)
                    self.presentViewController(alert, animated: true, completion: nil)
                    println("error")
            })
            
//            var period = cell.viewWithTag(103) as UILabel
//            var totalMoney = cell.viewWithTag(104) as UILabel
//            var percent = cell.viewWithTag(105) as UILabel
            
            print("outer:\(dicList)")
        }
        if val == 1 {
            cell = self.mainTable.dequeueReusableCellWithIdentifier("person") as UITableViewCell
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
            return "投资理财"
        }else if section == 1{
            return "我的账户"
        }else{
            return ""
        }
    }
}
