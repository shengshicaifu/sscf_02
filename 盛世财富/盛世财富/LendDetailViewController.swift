//
//  LendDetailViewController.swift
//  盛世财富
//
//  Created by xiao on 15-3-17.
//  Copyright (c) 2015年 sscf88. All rights reserved.
//



import UIKit

class LendDetailViewController: UITableViewController ,UITableViewDataSource,UITableViewDelegate,HttpProtocol{

    
    @IBOutlet weak var mainTable: UITableView!
    
    
    var timeLineUrl = "http://www.sscf88.com/app-invest-detailcontent-id-"
    var tmpListData: NSMutableArray = NSMutableArray()
    var eHttp: HttpController = HttpController()
    var id:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        mainTable.dataSource = self
        mainTable.delegate = self
        eHttp.delegate = self
//        if id != nil {
//            eHttp.get(self.timeLineUrl + "\(id)",viewContro :self,{
//                self.mainTable.reloadData()
//            })
//        }
        
        println(id!)
        
        
    }
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //点击事件
    }
    
    
    
    func didRecieveResult(result: NSDictionary){
//        if(result["data"]?.valueForKey("list") != nil){
//            self.tmpListData = result["data"]?.valueForKey("list") as NSMutableArray //list数据
//            //            self.page = result["data"]?["page"] as Int
//            self.mainTable.reloadData()
//        }
    }
}

