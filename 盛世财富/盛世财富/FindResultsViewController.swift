//
//  FindResultsViewController.swift
//  盛世财富
//
//  Created by 莫文琼 on 15/6/4.
//  Copyright (c) 2015年 sscf88. All rights reserved.
//

import UIKit
/**
*  搜索结果
*/
class FindResultsViewController: UITableViewController,UISearchResultsUpdating{

    let sectionsTableIdentifier = "SectionsTableIdentifier"
    var names:[String: [String]] = [String: [String]]()
    var keys: [String] = []
    var filteredNames: [String] = ["aaa","ddd","ccc","sss"]
    
    var data:NSMutableArray = NSMutableArray()
    var count = 10
    var searchString:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NSLog("FindResultsViewController  viewDidLoad")
        // Do any additional setup after loading the view.
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: sectionsTableIdentifier)
        //self.tableView.backgroundColor = UIColor.redColor()
        var frame = self.tableView.frame
        
//        if let t = self.parentViewController?.tabBarController {
//            NSLog("ok")
//            t.tabBar.hidden = true
//        }
        self.setupRefresh()
    }
    
    //MARK:- 刷新
    /**
    下拉刷新和上拉加载
    */
    func setupRefresh(){
        self.tableView.addHeaderWithCallback({
            
            if !self.searchString!.isEmpty {
                NSLog("搜索，下拉刷新")
                self.getData(self.searchString!, actionType: "1")
            }
            
        })
        self.tableView.addFooterWithCallback(){
            if !self.searchString!.isEmpty {
                NSLog("搜索，上拉加载")
                self.getData(self.searchString!, actionType: "2")
            }
        }
    }

    //内容改变时开始搜索
    func updateSearchResultsForSearchController(searchController: UISearchController){
        
        searchString = searchController.searchBar.text//搜索内容
        if !searchString!.isEmpty {
            //开始搜索
            NSLog("开始搜索")
            getData(searchString!, actionType: "0")
        }
        
    }
    
    /**
    搜索标
    
    :param: name       标名称
    :param: actionType 操作类型
                      1:搜索
                      2:上拉加载
    */
    func getData(name:String,actionType:String){
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

                UIApplication.sharedApplication().networkActivityIndicatorVisible = true
                let afnet = AFHTTPRequestOperationManager()
                let url = Common.serverHost + "/App-Index-search"
                
                //各种类型的操作参数不一样
                var lastId:String = ""
                if actionType == "0" || actionType == "1"{
                    //1:进入页面加载
                    lastId = ""
                }else if actionType == "2" {
                    //2:上拉加载
                    if self.data.count > 0 {
                        var lastObject = self.data.objectAtIndex(self.data.count - 1) as? NSDictionary
                        lastId = lastObject?.objectForKey("id") as! String
                    }
                }
                
                
                let param = ["name":name,"lastId":lastId,"count":self.count]
                NSLog("搜索参数%@", param)
                afnet.responseSerializer.acceptableContentTypes = NSSet(array: ["text/html"]) as Set<NSObject>
                afnet.POST(url, parameters: param,
                    success: { (opration:AFHTTPRequestOperation!, res:AnyObject!) -> Void in

                        var result = res as! NSDictionary
//                        if let d = result["data"] as? NSArray {
//                            for(var i=0;i<d.count;i++){
//                                println(d[i]["id"] as! String)
//                            }
//                        }
                        //NSLog("搜索结果%@", result)
                        var resultData = result["data"] as! NSDictionary
                        
                        //根据操作类型对返回的数据进行处理
                        if actionType == "0" || actionType == "1" {
                            //1:进入页面加载
                            //先清空data中的数据，再把获取的数据加入到data中
                            if let d = resultData["list"] as? NSArray{
                                self.data.removeAllObjects()
                                self.data.addObjectsFromArray(d as [AnyObject])
                            }else{
                                self.data.removeAllObjects()
                            }
                        }else if actionType == "2" {
                            //3:上拉加载
                            //将获取到的数据加到data的末尾
                            self.tableView.footerEndRefreshing()
                            if let d = resultData["list"] as? NSArray {
                                self.data.addObjectsFromArray(d as [AnyObject])
                            }
                        }
                        //table重新加载数据
                        self.tableView.reloadData()
                        
                        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                        if actionType == "1" {
                            self.tableView.headerEndRefreshing()
                        }else if actionType == "2" {
                            self.tableView.footerEndRefreshing()
                        }
                    },
                    failure: { (opration:AFHTTPRequestOperation!, error:NSError!) -> Void in
                        AlertView.alert("错误", message: error.localizedDescription, buttonTitle: "确定", viewController: self)
                        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                        if actionType == "1" {
                            self.tableView.headerEndRefreshing()
                        }else if actionType == "2" {
                            self.tableView.footerEndRefreshing()
                        }
                })
            })
        }
        
        reach.startNotifier()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(sectionsTableIdentifier) as! UITableViewCell
        cell.textLabel?.text = (self.data.objectAtIndex(indexPath.row) as! NSDictionary).objectForKey("borrow_name") as? String
        return cell
    }


}
