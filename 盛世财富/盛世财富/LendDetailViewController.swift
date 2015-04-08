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
        mainTable.delegate = self
        mainTable.dataSource = self
        eHttp.delegate = self
        
        eHttp.get(self.timeLineUrl + "",viewContro :self,{
            self.mainTable.reloadData()
        })
    }
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //点击事件
    }
    
    
    
    func didRecieveResult(result: NSDictionary){
        if(result["data"]?.valueForKey("list") != nil){
            self.tmpListData = result["data"]?.valueForKey("list") as NSMutableArray //list数据
            //            self.page = result["data"]?["page"] as Int
            self.mainTable.reloadData()
        }
    }
}

