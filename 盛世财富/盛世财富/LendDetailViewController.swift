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
    var timeLineUrl = Constant.getServerHost() + "/app-invest-detailcontent-id-"
    var tmpListData: NSMutableArray = NSMutableArray()
//    var eHttp: HttpController = HttpController()
    var id:String?
    var bidTitle:String?
    var percent:String?
    var type:String?
    var duration:String?
    var per_transferData:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        mainTable.dataSource = self
        mainTable.delegate = self
        loading.startLoading(self.view)
        mainTable.scrollEnabled = false
        //println(id!)
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
                    //println(borrowinfo)
                    if data.count>0{
                    //标的介绍
                    var add_time = borrowinfo["add_time"] as! NSString
                        
                    var biao = borrowinfo["biao"] as! NSString
                    
                    var progress = borrowinfo["progress"] as! NSString
                    var type = borrowinfo["repaymentType"] as! NSString
                    
                    if var needFloat = borrowinfo["need"] as? Float {
                        self.need.text = "\(needFloat)元"
                    }
                    
                    self.type = borrowinfo["borrow_type"] as? String
                    self.per_transferData = borrowinfo["per_transferData"] as? String
                        
                    //标题
                    var borrow_name = borrowinfo["borrow_name"] as! NSString!
                    self.bidTitle = borrow_name as String
                        
                        
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
                        
                        
                    var borrow_interest_rate = borrowinfo["borrow_interest_rate"] as! NSString!
                    self.percent = borrow_interest_rate as String
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
                    self.progressLabel.text = "\(progress.integerValue)%"
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
                    
                    self.borrowInterestRate.text = "\(borrow_interest_rate)%"
                    self.borrowDuration.text = "\(borrow_duration)个月"
                        
                    self.duration = borrow_duration as? String
                    //项目介绍
                    self.borrowMin.text = borrowmin as String
                    self.interestRate.text = "\(borrow_interest_rate)%"
                    self.loanMoney.text = bm
//                    self.finIncomedes.text = finIncomedes
                    self.borrowDate.text = "\(borrow_duration)个月"
//                    var borrowNameTextLabel =  self.mainTable.headerViewForSection(0)?.textLabel
//                    var frame = borrowNameTextLabel!.frame
//                    borrowNameTextLabel?.frame = CGRectMake(frame.origin.x, frame.origin.y,self.view.frame.width, frame.height)
//                    borrowNameTextLabel?.text = borrow_name
                    self.borrowName.text = borrow_name as String
                    var lefttime = borrowinfo["lefttime"] as! Int
                    if lefttime > 0 {
                        var leftDay = lefttime / (24*3600)
                        var leftHour = (lefttime % (24*3600))/3600
                        var leftMinute = (lefttime % 3600)/60
                        var leftSecond = (lefttime % 60)
                        
                        self.leftTime.text = "\(leftDay)天\(leftHour)时\(leftMinute)分\(leftSecond)秒"
                        
                        
                    }else{
                        self.leftTime.text = "已结束"
                        self.buyButton.enabled = false
                        
                        
                    }
//                    print(123)
                    loading.stopLoading()
                    self.mainTable.scrollEnabled = true
                }
                },
                failure: {(operation:AFHTTPRequestOperation!,error : NSError!) in
//                println("jsonerror:"+error.localizedDescription)
//                AlertView.showMsg("服务器异常，请稍后再试", parentView: self.view)
                    loading.stopLoading()
                    self.mainTable.scrollEnabled = true
                    let alert = UIAlertController(title: "提示", message: "服务器异常，请稍后再试", preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.Cancel, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
            })
        }
        
        
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "buy"{
            var vc = segue.destinationViewController as! BidConfirmViewController
            vc.id = self.id
            vc.percent = self.percent
            vc.bidTitle = self.bidTitle
            vc.type = self.type
            vc.duration = self.duration
            vc.per_transferData = self.per_transferData
        }else if segue.identifier == "investorSegue" {
            var vc = segue.destinationViewController as! BidListViewController
            vc.bidId = self.id
        }
        
    }
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0.1
        }
        return 35
    }
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1{
            let v = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 35))
            let title = UILabel(frame:CGRect(x: 13, y: 10, width: v.frame.width, height: 18))
            title.text = "借款人信息"
            title.font = UIFont(name: "System", size: 16)
            title.textColor = UIColor.grayColor()
            v.addSubview(title)
            return v
        }
        if section == 2{
            let v = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 35))
            let title = UILabel(frame:CGRect(x: 13, y: 10, width: v.frame.width, height: 18))
            title.text = "项目介绍"
            title.font = UIFont(name: "System", size: 16)
            title.textColor = UIColor.grayColor()
            v.addSubview(title)
            return v
        }
        return UIView()
    }
    override func viewWillAppear(animated: Bool) {
        //        检查网络
        var reach = Reachability(hostName: Constant.getDomain())
        reach.unreachableBlock = {(r:Reachability!)in
            dispatch_async(dispatch_get_main_queue(), {
                var alert = UIAlertController(title: "提示", message: "网络连接有问题，请检查手机网络", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "确定", style: .Cancel, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            })
        }
        reach.startNotifier()
        
        
    }
}

