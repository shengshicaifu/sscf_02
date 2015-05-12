//
//  LendDetailViewController.swift
//  盛世财富
//
//  Created by xiao on 15-3-17.
//  Copyright (c) 2015年 sscf88. All rights reserved.
//



import UIKit

class LendDetailViewController: UITableViewController ,UITableViewDataSource,UITableViewDelegate{

    
    @IBOutlet weak var buyButton: UIBarButtonItem!
    @IBOutlet weak var borrowName: UILabel!

    //标题
    @IBOutlet weak var borrowDuration: UILabel!
    @IBOutlet weak var borrowInterestRate: UILabel!
    @IBOutlet weak var borrowMoney: UILabel!
    @IBOutlet weak var mainTable: UITableView!
    //借款人信息
    @IBOutlet weak var userEnducation: UILabel!
    @IBOutlet weak var userMarray: UILabel!
    @IBOutlet weak var userAge: UILabel!
    @IBOutlet weak var userSex: UILabel!
    @IBOutlet weak var userName: UILabel!
    //标的介绍
    @IBOutlet weak var addTime: UILabel!
    @IBOutlet weak var leftTime: UILabel!
    @IBOutlet weak var biao: UILabel!
    @IBOutlet weak var repayType: UILabel!
//    @IBOutlet weak var progressLabel: UILabel!
//    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var need: UILabel!
    //项目介绍
    @IBOutlet weak var loanMoney: UILabel!
    @IBOutlet weak var interestRate: UILabel!
    @IBOutlet weak var borrowMin: UILabel!
    @IBOutlet weak var finIncomedes: UILabel!
    @IBOutlet weak var vouchNeed: UILabel!
    @IBOutlet weak var borrowDate: UILabel!
    var timeLineUrl = "http://www.sscf88.com/app-invest-detailcontent-id-"
    var tmpListData: NSMutableArray = NSMutableArray()
    var eHttp: HttpController = HttpController()
    var id:String?

    override func viewDidLoad() {
        super.viewDidLoad()
        mainTable.dataSource = self
        mainTable.delegate = self
        println(id!)
        if id != nil {
            let manager =  AFHTTPRequestOperationManager()
            let params = ["id" : id!]
            
            let  url = timeLineUrl+"\(id!)"
            manager.GET(url,
                parameters: nil,
                success: { (operation: AFHTTPRequestOperation!,responseObject: AnyObject! ) in
//                println("responseObject:"+responseObject.description!)
                   
                    var json = responseObject as! NSDictionary
                    var data = json["data"] as! NSDictionary
                   //标题
                    var borrowinfo = data["borrowinfo"] as! NSDictionary
                   //借款人信息 ，标的介绍
                    var memberinfo = data["memberinfo"] as! NSDictionary
                    println(borrowinfo)
                    if data.count>0{
                    //标的介绍
                    var add_time = borrowinfo["add_time"] as! NSString
                        
                    var biao = borrowinfo["biao"] as! NSString
                    
                    var progress = borrowinfo["progress"] as! NSString
                    var type = borrowinfo["repaymentType"] as! NSString
                    
                    if let needFloat = borrowinfo["need"] as? Float {
                        self.need.text = "\(needFloat)"
                    }
                    
                        
                        
                        
                    //标题
                    var borrow_name = borrowinfo["borrow_name"] as! NSString!
                    var borrow_money = borrowinfo["borrow_money"] as! NSString!
                    var borrow_interest_rate = borrowinfo["borrow_interest_rate"] as! NSString!
                    var borrow_duration = borrowinfo["borrow_duration"]
                        as! NSString!
//                    //借款人信息
                    var user_name = memberinfo["user_name"]as!  NSString!
                    var sex = memberinfo["sex"] as! NSString!
                    var age = memberinfo["age"]as! NSString!
                    var marry = memberinfo["marry"]as! NSString!
                    var education = memberinfo["education"] as! NSString!
                    //项目介绍
//                        if var  vouchNeed = borrowinfo["vouch_need"] as? Float{
//                            self.vouchNeed.text = vouchNeed
//                        }
//                    var  finIncomedes = borrowinfo["fin_incomedes"] as NSString
                    var borrowmin = borrowinfo["borrow_min"] as! NSString
                        
                    //标的介绍
                    
//                    
                    self.progressLabel.text = "\(progress)%"
                    var progressFloat = progress.floatValue/100
                    self.progressView.progress = progressFloat
                        
                        
                        
                        
                    var addTimeDouble = add_time.doubleValue
//                    addTimeDouble = addTimeDouble!*
//                    add_time = add_time!*1000
                    var dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    var addTime = dateFormatter.stringFromDate(NSDate(timeIntervalSince1970: addTimeDouble))
                    self.addTime.text = addTime
                        
//                    self.leftTime.text = lefttime
                    self.biao.text = "\(biao)次"
                    self.repayType.text = type as String

                    //借款人信息
                    self.userName.text = user_name as String
                    self.userSex.text = sex as String
                    self.userAge.text = age as String
                    self.userEnducation.text = education as String
                    self.userMarray.text = marry as String
                    //标题
                    self.borrowMoney.text = borrow_money as String
                    self.borrowInterestRate.text = "\(borrow_interest_rate)%"
                    self.borrowDuration.text = "\(borrow_duration)个月"
                    //项目介绍
                    self.borrowMin.text = borrowmin as String
                    self.interestRate.text = "\(borrow_interest_rate)%"
                    self.loanMoney.text = "\(borrow_money)元"
//                    self.finIncomedes.text = finIncomedes
                    self.borrowDate.text = "\(borrow_duration)个月"
//                    var borrowNameTextLabel =  self.mainTable.headerViewForSection(0)?.textLabel
//                    var frame = borrowNameTextLabel!.frame
//                    borrowNameTextLabel?.frame = CGRectMake(frame.origin.x, frame.origin.y,self.view.frame.width, frame.height)
//                    borrowNameTextLabel?.text = borrow_name
                    self.borrowName.text = borrow_name as String
                    var lefttime = borrowinfo["lefttime"] as! Int
                    if lefttime > 0 {
                        self.leftTime.text = "\(lefttime)"
                    }else{
                        self.leftTime.text = "已结束"
                        self.buyButton.enabled = false
                        
                        
                    }
                        
                    
                    
                        
                }
                },
                failure: {(operation:AFHTTPRequestOperation!,error : NSError!) in
                println("jsonerror:"+error.localizedDescription)
            })
        }
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "buy"{
            var vc = segue.destinationViewController as! LendDetailViewController
            vc.id = self.id
        }
        
    }

}

