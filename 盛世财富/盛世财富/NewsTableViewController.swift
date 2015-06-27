//
//  NewsTableViewController.swift
//  盛世财富
//
//  Created by 莫文琼 on 15/6/2.
//  Copyright (c) 2015年 sscf88. All rights reserved.
//

import UIKit
/**
*  消息
*/
class NewsTableViewController: UITableViewController,UITableViewDataSource,UITableViewDelegate ,UINavigationControllerDelegate,UIViewControllerAnimatedTransitioning {
    var navigationOperation: UINavigationControllerOperation?
    var tmpListData: NSMutableArray = NSMutableArray()//临时数据  下拉添加
    var ehttp = HttpController()
    var url = ""
    var count:String = "5"
    var id:String? //页面传值的id
    var textLayer:CACustomTextLayer?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.delegate = self
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.setupRefresh()
        self.getDate("0")
        
//        //下拉刷新---------------------------
//        var rc = UIRefreshControl()
//        rc.attributedTitle = NSAttributedString(string: "下拉刷新")
//        rc.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
//        self.refreshControl = rc
//       
    }
    
    func navigationController(navigationController: UINavigationController?!, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController!, toViewController toVC: UIViewController!) -> UIViewControllerAnimatedTransitioning! {
        navigationOperation = operation
        return self
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return 0.5
    }
    
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView()
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        
        var destView: UIView!
        var destTransform: CGAffineTransform!
        var destAlpha:Double! = 0.1
        if navigationOperation == UINavigationControllerOperation.Push {
            containerView.insertSubview(toViewController!.view, aboveSubview: fromViewController!.view)
            destView = toViewController!.view
            //destView.transform = CGAffineTransformMakeScale(0.1, 0.1)
            //destTransform = CGAffineTransformMakeScale(1, 1)
            destView.alpha = 0.1
            destAlpha = 1.0
        } else if navigationOperation == UINavigationControllerOperation.Pop {
            containerView.insertSubview(toViewController!.view, belowSubview: fromViewController!.view)
            destView = fromViewController!.view
            // 如果IDE是Xcode6 Beta4+iOS8SDK，那么在此处设置为0，动画将不会被执行(不确定是哪里的Bug)
            //destTransform = CGAffineTransformMakeScale(0.1, 0.1)
            destAlpha = 0.1
        }
        //        UIView.animateWithDuration(transitionDuration(transitionContext), animations: {
        //            //destView.transform = destTransform
        //            destView.alpha = destAlpha
        //            }, completion: ({
        //                transitionContext.completeTransition(true)
        //        }))
        UIView.animateWithDuration(
            transitionDuration(transitionContext), animations: { () -> Void in
                //destView.transform = destTransform
                if destAlpha == 1.0 {
                    destView.alpha = 1.0
                }else {
                    destView.alpha = 0.1
                }
                
            }) { (completed) -> Void in
                transitionContext.completeTransition(true)
        }
    }

    
    //点击UITextView 跳转到详情页面的方法
    func toNewsDetail(sender:UITapGestureRecognizer){
        var msgLabel = sender.view as! UITextView//得到文本框
        
        var controller = self.storyboard?.instantiateViewControllerWithIdentifier("newsDetail") as! NewsDetailViewController
//        controller.detailItem = 
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    
    /**
    下拉刷新和上拉加载
    */
    func setupRefresh(){
        self.tableView.addHeaderWithCallback({
           self.getDate("1")
        })
        self.tableView.addFooterWithCallback(){
           self.getDate("2")
        }
    }
    
    /**
    获取数据
    
    :param: actionType 操作类型
    0:进入页面获取数据
    1:下拉刷新获取数据
    2:上拉加载获取数据
    */
    func getDate(actionType:String){
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            if let token = NSUserDefaults.standardUserDefaults().objectForKey("token") as? String {
                if actionType == "0" {
                    loading.startLoading(self.view)
                }else{
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = true
                }
                
                var lastId:String = ""
                if actionType == "2" && self.tmpListData.count > 0{
                    var lastObject = self.tmpListData.objectAtIndex(self.tmpListData.count - 1) as? NSDictionary
                    lastId = lastObject?.objectForKey("id") as! String
                }
                
                self.tableView.scrollEnabled = false
                let afnet = AFHTTPRequestOperationManager()
                let param = ["to":token,"count":count,"lastId":lastId]
                let url = Common.serverHost + "/App-Message"
                NSLog("消息参数%@", param)
                afnet.responseSerializer.acceptableContentTypes = NSSet(array: ["text/html"]) as Set<NSObject>
                afnet.POST(url, parameters: param, success: { (opration:AFHTTPRequestOperation!, res:AnyObject!) -> Void in
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    var resDictionary = res as! NSDictionary
                    
                    var a = resDictionary["data"] as! NSArray
                    //println("获取到的数据：")
                    for var i=0;i<a.count;i++ {
                        var c = a[i] as! NSDictionary
                        var b = c["id"] as! String
                        //println(b)
                    }

                    
                    
                    var code = resDictionary["code"] as! Int
//                    self.tmpListData = dataNSArray as! NSMutableArray
//                    println(code)
                    //根据操作类型对返回的数据进行处理
                    if actionType == "0" {
                        //1:进入页面加载
                        //先清空data中的数据，再把获取的数据加入到data中
                        if let d = res["data"] as? NSArray{
//                            NSLog("003")
                            self.tmpListData.removeAllObjects()
//                            NSLog("004")
                            self.tmpListData.addObjectsFromArray(d as [AnyObject])
//                            NSLog("005")
                        }else{
                            self.tmpListData.removeAllObjects()
                        }
                    }else if actionType == "1" {
                        //2:下拉刷新
                        //获取最新的数据，将这些数据与本地data中前count条数据进行比较，有新的数据就加入到data中，否则就不加
                        self.tableView.headerEndRefreshing()
                        if let d = res["data"] as? NSArray {
//                            NSLog("下拉刷新%@获取记录条数%i", d.count)
                            var newRefreshData = NSMutableArray()//获取的与本地不一样的最新的数据
                            for(var i=0;i<d.count;i++){
                                var romoteBidId = d[i]["id"] as! String
                                var localBidId = self.tmpListData[i]["id"] as! String
                                if romoteBidId != localBidId {
                                    //如果获取数据的投标记录id与本地投标记录id不一样就添加
                                    newRefreshData.addObject(d[i])
                                }
                            }
                            //有新的数据就加入到data中
                            self.tmpListData.addObjectsFromArray(newRefreshData as [AnyObject])
                        }
                        
                        
                        
                    }else if actionType == "2" {
                        //3:上拉加载
                        //将获取到的数据加到data的末尾
                        self.tableView.footerEndRefreshing()
                        if let d = res["data"] as? NSArray {
//                            NSLog("下拉刷新%@获取记录条数%i", d.count)
                            self.tmpListData.addObjectsFromArray(d as [AnyObject])
                        }else{
                            //NSLog("下拉刷新%@没有拿到数据")
                        }
                        
                    }
                    //table重新加载数据
                    self.tableView.reloadData()
                    
                    if actionType == "0" {
                        loading.stopLoading()
                    }else if actionType == "1"{
                        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                        self.tableView.headerEndRefreshing()
                    }else if actionType == "2"{
                        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                        self.tableView.footerEndRefreshing()
                    }
                    
                    self.tableView.scrollEnabled = true
                    }) { (opration:AFHTTPRequestOperation!, error:NSError!) -> Void in
                        //loading.stopLoading()
                        if actionType == "0" {
                            loading.stopLoading()
                        }else if actionType == "1"{
                            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                            self.tableView.headerEndRefreshing()
                        }else if actionType == "2"{
                            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                            self.tableView.footerEndRefreshing()
                        }
                        self.tableView.scrollEnabled = true

                    AlertView.alert("错误", message: error.localizedDescription, buttonTitle: "确定", viewController: self)
                }
            }else {
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            }
        }

    //MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tmpListData.count > 0 {
            return tmpListData.count
        }
            return 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("newsCell") as! UITableViewCell
        var titleLabel = cell.viewWithTag(101) as! UILabel
        var msgLabel = cell.viewWithTag(102) as! UITextView
        msgLabel.userInteractionEnabled = false
        var sendTimeLabel = cell.viewWithTag(103) as! UILabel
        //var hasRead = cell.viewWithTag(104)   as! UILabel
        //var hideIdLabel = cell.viewWithTag(105) as! UILabel
        //var flagLabel = cell.viewWithTag(99) as! UILabel
        var row :Int = indexPath.row
        if tmpListData.count > 0{
            var messageTitle = tmpListData[row].objectForKey("title") as! String
            titleLabel.text = messageTitle
            var messageMsg = tmpListData[row].objectForKey("msg") as! String
            msgLabel.text = messageMsg
            id = tmpListData[row].objectForKey("id") as? String
            //hideIdLabel.text = id
            //hideIdLabel.hidden = true
            var sendTime = tmpListData[row].objectForKey("send_time") as! NSString
            var sendTimeDouble = sendTime.doubleValue
            var fomartTime = Common.twoDateFromTimestamp(sendTimeDouble)
            sendTimeLabel.text = fomartTime
            var has_read = tmpListData[row].objectForKey("has_read") as! String
            //hasRead.hidden = true
//            switch has_read{
//            case "0":
//                hasRead.text = "未读"
//                break
//            case "1":
//                hasRead.text = "已读"
//                break
//            default:
//                hasRead.text = "全部"
//                break
//            }
            
//            flagLabel.text = "通知"
//            flagLabel.layer.cornerRadius = 3
//            flagLabel.layer.masksToBounds = true
            
    }
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
        if let indexPath = self.tableView.indexPathForSelectedRow(){
            let object :NSDictionary = tmpListData[indexPath.row] as! NSDictionary
            var destinationViewController = segue.destinationViewController as! NewsDetailViewController
            destinationViewController.detailItem = object
            destinationViewController.hidesBottomBarWhenPushed = true
        }
    }
    

}

