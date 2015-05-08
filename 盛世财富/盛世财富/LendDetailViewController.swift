//
//  LendDetailViewController.swift
//  盛世财富
//
//  Created by xiao on 15-3-17.
//  Copyright (c) 2015年 sscf88. All rights reserved.
//



import UIKit

class LendDetailViewController: UITableViewController ,UITableViewDataSource,UITableViewDelegate{

    


    @IBOutlet weak var borrowDuration: UILabel!
    @IBOutlet weak var borrowInterestRate: UILabel!
    @IBOutlet weak var borrowMoney: UILabel!
    @IBOutlet weak var mainTable: UITableView!
    
    
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
                    //解析json
                println(responseObject)
                    var json = responseObject as NSDictionary
                    var data = json["data"] as NSDictionary
                    if data.count>0{
                    var borrow_info = data["borrow_info"] as NSString!
                    var borrow_money = data["borrow_money"] as NSString!
                    var borrow_interest_rate = data["borrow_interest_rate"] as NSString!
                    var borrow_duration = data["borrow_duration"]
                        as NSString!
                    println(borrow_info)
                    self.borrowMoney.text = borrow_money
                    self.borrowInterestRate.text = borrow_interest_rate+"%"
                    self.borrowDuration.text = borrow_duration+"天"
                    self.mainTable.headerViewForSection(0)?.textLabel.text = borrow_info
                         }
                },
                failure: {(operation:AFHTTPRequestOperation!,error : NSError!) in
                println("jsonerror:"+error.localizedDescription)
            })
        }
        
          println(id!)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  }

