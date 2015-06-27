//
//  BidRecordViewController.swift
//  盛世财富
//
//  Created by 肖典 on 15/5/16.
//  Copyright (c) 2015年 sscf88. All rights reserved.
//

import Foundation
import UIKit
/**
*  投标记录
*/
class BidRecordViewController:UITableViewController,UITableViewDataSource,UITableViewDelegate {
    
    var data:NSMutableArray = NSMutableArray()
    
    var type:Int = 1
    var count:String = "10"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.getData("\(type)",actionType:"1")
        self.setupRefresh()
        
        //为tableview添加手势
        var gesture1 = UISwipeGestureRecognizer(target: self, action: "handleSwipe:")
        gesture1.direction = UISwipeGestureRecognizerDirection.Right
        self.tableView.addGestureRecognizer(gesture1)
        
        var gesture2 = UISwipeGestureRecognizer(target: self, action: "handleSwipe:")
        gesture2.direction = UISwipeGestureRecognizerDirection.Left
        self.tableView.addGestureRecognizer(gesture2)
        
    }
    
    func handleSwipe(gesture:UISwipeGestureRecognizer){
        var direction = gesture.direction
        if direction == UISwipeGestureRecognizerDirection.Left {
            NSLog("向左")
            var i = choose.selectedSegmentIndex + 1
            if i > 3 {
                choose.selectedSegmentIndex = 0
                i = 0
            }else{
                choose.selectedSegmentIndex = i
            }
            
            self.type = i + 1
            getData("\(self.type)",actionType:"1")
            
        }else if direction == UISwipeGestureRecognizerDirection.Right {
            NSLog("向右")
            var i = choose.selectedSegmentIndex - 1
            if i < 0 {
                choose.selectedSegmentIndex = 3
                i = 3
            }else{
                choose.selectedSegmentIndex = i
            }
            
            self.type = i + 1
            getData("\(self.type)",actionType:"1")
        }
    }

    //MARK:- 刷新
    /**
    下拉刷新和上拉加载
    */
    func setupRefresh(){
        self.tableView.addHeaderWithCallback({
            NSLog("投标记录，下拉刷新")
            self.getData("\(self.type)", actionType: "2")
        })
        self.tableView.addFooterWithCallback(){
            NSLog("投标记录，上拉加载")
            self.getData("\(self.type)", actionType: "3")
        }
    }
    
    
    /**
    获取投标纪录
    :param: bidType     投标记录类型 1:竞标中  2:回收中  3:逾期  4:已回收
    :param: actionType  操作类型  1:进入页面加载   2:下拉刷新   3:上拉加载
    */
    func getData(bidType:String,actionType:String){
        //检查手机网络
        var reach = Reachability(hostName: Common.domain)
        reach.unreachableBlock = {(r:Reachability!) -> Void in
            //NSLog("网络不可用")
            dispatch_async(dispatch_get_main_queue(), {
                AlertView.alert("提示", message: "网络连接有问题，请检查网络是否连接", buttonTitle: "确定", viewController: self)
            })
        }
        
        reach.reachableBlock = {(r:Reachability!) -> Void in
            //NSLog("网络可用")
            dispatch_async(dispatch_get_main_queue(), {
                if let token = NSUserDefaults.standardUserDefaults().objectForKey("token") as? String {

                    if actionType == "1" {
                        loading.startLoading(self.view)
                    }else{
                        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
                    }
                    
                    
                    self.tableView.scrollEnabled = false
                    let afnet = AFHTTPRequestOperationManager()
                    let url = Common.serverHost + "/App-Myinvest-getTending"
                    
                    //各种类型的操作参数不一样
                    var lastId:String = ""
                    if actionType == "1" {
                        //1:进入页面加载
                        lastId = ""
                    }else if actionType == "2" {
                        //2:下拉刷新
                        lastId = ""
                    }else if actionType == "3" {
                        //3:上拉加载
                        if self.data.count > 0 {
                            var lastObject = self.data.objectAtIndex(self.data.count - 1) as? NSDictionary
                            lastId = lastObject?.objectForKey("id") as! String
                        }
                    }
                    
                    
                    let param = ["to":token,"type":bidType,"lastId":lastId,"count":self.count]
                    NSLog("投标记录参数%@", param)
                    afnet.responseSerializer.acceptableContentTypes = NSSet(array: ["text/html"]) as Set<NSObject>
                    afnet.POST(url, parameters: param,
                        success: { (opration:AFHTTPRequestOperation!, res:AnyObject!) -> Void in
                            //NSLog("投标%@记录：%@",bidType,res as! NSDictionary)
                            var result = res as! NSDictionary
                            if let d = result["data"] as? NSArray {
                                for(var i=0;i<d.count;i++){
                                    println(d[i]["id"] as! String)
                                }
                            }
                            
                            
                            
                            
                            
                            //根据操作类型对返回的数据进行处理
                            if actionType == "1" {
                             //1:进入页面加载
                             //先清空data中的数据，再把获取的数据加入到data中
                                if let d = res["data"] as? NSArray{
                                    self.data.removeAllObjects()
                                    self.data.addObjectsFromArray(d as [AnyObject])
    //                                for(var i=0;i<self.data.count;i++){
    //                                    println(self.data[i]["borrow_name"] as! String)
    //                                }
                                }else{
                                    self.data.removeAllObjects()
                                }
                            }else if actionType == "2" {
                            //2:下拉刷新
                            //获取最新的数据，将这些数据与本地data中前count条数据进行比较，有新的数据就加入到data中，否则就不加
                                self.tableView.headerEndRefreshing()
                                if let d = res["data"] as? NSArray {
                                    var newRefreshData = NSMutableArray()//获取的与本地不一样的最新的数据
                                    for(var i=0;i<d.count;i++){
                                        var romoteBidId = d[i]["id"] as! String
                                        var localBidId = self.data[i]["id"] as! String
                                        if romoteBidId != localBidId {
                                            //如果获取数据的投标记录id与本地投标记录id不一样就添加
                                            newRefreshData.addObject(d[i])
                                        }
                                    }
                                    //有新的数据就加入到data中
                                    self.data.addObjectsFromArray(newRefreshData as [AnyObject])
                                }
                                
                                
                                
                            }else if actionType == "3" {
                            //3:上拉加载
                            //将获取到的数据加到data的末尾
                                self.tableView.footerEndRefreshing()
                                if let d = res["data"] as? NSArray {
                                    NSLog("上拉加载%@获取记录条数%i", bidType,d.count)
                                    self.data.addObjectsFromArray(d as [AnyObject])
                                }else{
                                    NSLog("上拉加载%@没有拿到数据", bidType)
                                }
                                
                            }
                            //table重新加载数据
                            self.tableView.reloadData()
                            
                            if actionType == "1" {
                                loading.stopLoading()
                            }else if actionType == "2"{
                                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                                self.tableView.headerEndRefreshing()
                            }else if actionType == "3" {
                                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                                self.tableView.footerEndRefreshing()
                            }
                            
                            self.tableView.scrollEnabled = true
                        },
                        failure: { (opration:AFHTTPRequestOperation!, error:NSError!) -> Void in
                            AlertView.alert("错误", message: error.localizedDescription, buttonTitle: "确定", viewController: self)
                            if actionType == "1" {
                                loading.stopLoading()
                            }else if actionType == "2"{
                                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                                self.tableView.headerEndRefreshing()
                            }else if actionType == "3" {
                                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                                self.tableView.footerEndRefreshing()
                            }
                            self.tableView.scrollEnabled = true
                    })
                }
                
                
            })
        }
        
        reach.startNotifier()
    }
    
    
    //MARK:- tableview
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    var choose:UISegmentedControl!
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var v = UIView(frame: CGRectMake(0, 0, self.tableView.frame.width, 45))
        v.backgroundColor = UIColor(red: 82/255.0, green: 180/255.0, blue: 245/255.0, alpha: 1.0)
        choose = UISegmentedControl(frame: CGRectMake(0, 0, v.frame.width, v.frame.height))
        choose.tintColor = UIColor.clearColor()  //UIColor(red: 82/255.0, green: 180/255.0, blue: 245/255.0, alpha: 1.0)
        var font = UIFont(name: "HelveticaNeue", size: 16.0)
        var fontColor = UIColor.whiteColor()
        var att = NSDictionary(objects: [font!,fontColor], forKeys: [NSFontAttributeName,NSForegroundColorAttributeName]) as [NSObject : AnyObject]
        choose.setTitleTextAttributes(att, forState: UIControlState.Selected)
        
        fontColor = UIColor.lightTextColor()
        att = NSDictionary(objects: [font!,fontColor], forKeys: [NSFontAttributeName,NSForegroundColorAttributeName]) as [NSObject : AnyObject]
        choose.setTitleTextAttributes(att
            , forState: UIControlState.Normal)
        
        choose.layer.cornerRadius = 0
        choose.insertSegmentWithTitle("竞标中", atIndex: 0, animated: true)
        choose.insertSegmentWithTitle("回收中", atIndex: 1, animated: true)
        choose.insertSegmentWithTitle("逾期", atIndex: 2, animated: true)
        choose.insertSegmentWithTitle("已回收", atIndex: 3, animated: true)
        
        choose.selectedSegmentIndex = (self.type - 1)
        choose.layer.cornerRadius = 0
        choose.addTarget(self, action: "choosed:", forControlEvents: UIControlEvents.ValueChanged)
        
        v.addSubview(choose)
        return v
    }
    
    func choosed(seg:UISegmentedControl){
        NSLog("选择了%i",seg.selectedSegmentIndex)
        self.type = (seg.selectedSegmentIndex + 1)
        getData("\(self.type)",actionType:"1")
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("list")  as! UITableViewCell
        var name = cell.contentView.viewWithTag(100) as! UILabel
        var time = cell.contentView.viewWithTag(101) as! UILabel
        var money = cell.contentView.viewWithTag(102) as! UILabel
        var row = indexPath.row
        if data.count > 0{
//            println(data[row])
            name.text = data[row].valueForKey("borrow_name") as? String
            
            var timeNumber = data[row].valueForKey("invest_time") as! NSString
            var interval = timeNumber.doubleValue
            var date = NSDate(timeIntervalSince1970: interval)
            var formatter = NSDateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            time.text = formatter.stringFromDate(date)
            
            money.text = data[row].objectForKey("investor_capital") as? String
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if data.count > 0 {
            return data.count
        }
        return 0
    }
}



