//
//  NewDetailScrollViewController.swift
//  盛世财富
//
//  Created by 云笺 on 15/6/11.
//  Copyright (c) 2015年 sscf88. All rights reserved.
//

import UIKit

class NewDetailScrollViewController: UIViewController {
    var id:String?
    var type:String?
    @IBOutlet weak var InterestRateLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var borrowMoney: UILabel!
    @IBOutlet weak var borrowName: UILabel!
    @IBOutlet weak var borrowMinLabel: UILabel!
    @IBOutlet weak var addTime: UILabel!
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var Secondiew: UIView!
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var thirdView: UIView!
    @IBOutlet weak var borrowDuration: UILabel!
    @IBOutlet weak var borrowRate: UILabel!
    @IBOutlet weak var _scrollView: UIScrollView!
    @IBOutlet weak var restTime: UILabel!
    var timeLineUrl = Common.serverHost + "/app-invest-detailcontent-id-"
    var tmpListData: NSMutableArray = NSMutableArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
       self.view.addSubview(_scrollView)
        _scrollView.addSubview(firstView)
        _scrollView.addSubview(Secondiew)
        _scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, CGRectGetMaxY(Secondiew.frame) + 20)
       
        Common.customerBgView(firstView)
        Common.customerBgView(Secondiew)
        Common.customerButton(buyButton)
        
        //View点击事件
        thirdView.userInteractionEnabled = true
        var singleTap :UIGestureRecognizer = UITapGestureRecognizer(target: self, action: "ViewTouch:")
        thirdView.addGestureRecognizer(singleTap)
        
        loading.startLoading(self.view)
//        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        if id != nil {
            let manager =  AFHTTPRequestOperationManager()
            let params = ["id" : id!]
            println(id)
            let  url = timeLineUrl+"\(id!)"
            manager.responseSerializer.acceptableContentTypes = NSSet(array: ["text/html"]) as Set<NSObject>
            manager.POST(url,
                parameters: params,
                success: { (operation: AFHTTPRequestOperation!,responseObject: AnyObject! ) in
                    //                println(responseObject)
                    //NSLog("表弟详情返回结果%@", responseObject as! NSDictionary)
                    var json = responseObject as! NSDictionary
                    var data = json["data"] as! NSDictionary
                    //标题
                    var borrowinfo = data["borrowinfo"] as! NSDictionary
                    println("borrowinfo\(borrowinfo)")
                    //借款人信息 ，标的介绍
                    var memberinfo = data["memberinfo"] as! NSDictionary
                    println("memberinfo\(memberinfo)")
                    var InterestRate = borrowinfo["borrow_interest_rate"] as! String
                    var units = borrowinfo["duration_unit"] as!  String
                    self.InterestRateLabel.text = "\(InterestRate)%"
                    self.borrowMinLabel.text = borrowinfo["borrow_min"] as? String
                    self.borrowName.text = borrowinfo["borrow_name"] as? String
                    var borrow_money = borrowinfo["borrow_money"] as! NSString
                    var borrow_money_tmp:NSInteger = borrow_money.integerValue
                    var bm:String
                    if borrow_money_tmp > 10000 {
                        borrow_money_tmp = borrow_money_tmp / 10000
                        bm = "\(borrow_money_tmp)万元"
                    } else {
                        bm = "\(borrow_money_tmp)元"
                    }

                    self.borrowMoney.text = bm
                    var addTime =  borrowinfo["add_time"] as! NSString
                    var DoubleTime = addTime.doubleValue
                    self.addTime.text = Common.threeDateFromTimestamp(DoubleTime)
                    
                    self.borrowRate.text = "\(InterestRate)%"
                    var borrow = borrowinfo["borrow_duration"] as! String
                    self.borrowDuration.text = "\(borrow)"+"\(units)"
                    var progress = borrowinfo["progress"] as! NSString
                    self.progressLabel.text = "\(progress.floatValue)%"
                    var progressFloat = progress.floatValue/100
                    self.progressView.progress = progressFloat
                    
                    var lefttime = borrowinfo["lefttime"] as! Int
                    if lefttime > 0 {
                        var leftDay = lefttime / (24*3600)
                        var leftHour = (lefttime % (24*3600))/3600
                        var leftMinute = (lefttime % 3600)/60
                        var leftSecond = (lefttime % 60)
                        
                        self.restTime.text = "\(leftDay)天\(leftHour)时\(leftMinute)分\(leftSecond)秒"
                        
                        
                    }else{
                        self.restTime.text = "已结束"
                        self.buyButton.enabled = false
                        
                    }
                    var unit = borrowinfo["progress"] as! NSString

                    
                        println(self.id)
                        //根据借款状态和募集期来判断该标是否可买
                        //借款状态
                         var canBuy:Bool = true//表示标是否能买
                        var status = borrowinfo["borrow_status"] as! NSString
                        switch status {
                        case "4":
                            //复审中
                            canBuy = false
                            self.buyButton.enabled = false
                        case "6":
                            //还款中
                            canBuy = false
                            self.buyButton.enabled = false
                        case "7":
                            //已完成
                            canBuy = false
                            self.buyButton.enabled = false
                        default:
                            break
                        }
                        //募集期小于当前日期的不能投
                        var collectTimeStr = borrowinfo["collect_time"] as? NSString
                        if collectTimeStr != nil {
                            var curTime = NSDate().timeIntervalSince1970
                            if collectTimeStr?.doubleValue < curTime {
                               canBuy = false
                            }
                        }
//                    self.pview.backgroundColor = UIColor.whiteColor()
//                    if self.pview.viewWithTag(1) != nil {
//                        self.pview.viewWithTag(1)?.removeFromSuperview()
//                    }
//                    if self.pview.viewWithTag(2) != nil {
//                        self.pview.viewWithTag(2)?.removeFromSuperview()
//                    }
//                    if canBuy {
//                        var progress = CircleView()
//                        progress.tag = 1
//                        progress.type = "1"
//                        progress.backgroundColor = UIColor.whiteColor()
//                        progress.frame = CGRectMake(0, 0, self.pview.frame.width - 15, self.pview.frame.height - 15)
//                        progress.percent = unit.doubleValue/100.0
//                        progress.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "buy:"))
//                        self.pview.addSubview(progress)
//                    }else{
//                        var progress = CircleView()
//                        progress.tag = 2
//                        progress.type = "2"
//                        progress.backgroundColor = UIColor.whiteColor()
//                        progress.frame = CGRectMake(0, 0, self.pview.frame.width - 15, self.pview.frame.height - 15)
//                        progress.percent = 0.0
////                        progress.tip = statusTipLabel.text!
//                        self.pview.addSubview(progress)
//                        
//                    }
//
                        loading.stopLoading()
                      
                   
                },
                failure: {(operation:AFHTTPRequestOperation!,error : NSError!) in
                    println(error)
                    loading.stopLoading()
                   
                }
            )
        }

    }

   func ViewTouch(sender: AnyObject!) {
        let myStoryBoard = self.storyboard
        let anotherView = myStoryBoard?.instantiateViewControllerWithIdentifier("bidListViewController") as! BidListViewController
        anotherView.bidId = id
        self.navigationController?.pushViewController(anotherView, animated: true)
//        self.presentViewController(anotherView, animated: true, completion: nil)
    }
    @IBAction func buyBid(sender: AnyObject!) {
        let myStoryBoard = self.storyboard
//        let anotherView:UITableViewController = myStoryBoard.instanceViewControllerWithIdentifier("bidConfirmViewController") as! BidConfirmViewController
        let anotherView = myStoryBoard?.instantiateViewControllerWithIdentifier("bidConfirmViewController") as! BidConfirmViewController
        anotherView.id = id
        anotherView.type = type
        self.navigationController?.pushViewController(anotherView, animated: true)
//        self.presentViewController(anotherView, animated: true, completion: nil)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
}
