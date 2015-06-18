//
//  FindViewController.swift
//  盛世财富
//
//  Created by 莫文琼 on 15/6/4.
//  Copyright (c) 2015年 sscf88. All rights reserved.
//

import UIKit
/**
*  发现
*  搜索功能
*/
class FindViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate {
    let sectionsTableIdentifier = "SectionsTableIndentifier"
    var names: [String: [String]]!//待搜索的数据源
    var keys: [String]!//数据源的索引
    @IBOutlet weak var tableView: UITableView!
    var searchController: UISearchController!//搜索控制器
    
    var data:NSMutableArray = NSMutableArray()
    var count = 20
    var searchString:String? = ""
    
    var searchTextField:UITextField!//搜索框
    var searchCancelButton:UIButton!//搜索取消按钮
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: sectionsTableIdentifier)
        
        //自定义搜索框
        //输入框
        var customerHeaderView = UIView(frame: CGRectMake(0, 0, tableView.frame.width, 44))
        searchTextField = UITextField()
        searchTextField.placeholder = "查找理财产品"
        searchTextField.borderStyle = UITextBorderStyle.RoundedRect
        searchTextField.setTranslatesAutoresizingMaskIntoConstraints(false)
        searchTextField.delegate = self
        searchTextField.addTarget(self, action: "change:", forControlEvents: UIControlEvents.EditingChanged)
        searchTextField.tintColor = UIColor.grayColor()
        customerHeaderView.addSubview(searchTextField)
        
        
        
        searchTextField.becomeFirstResponder()
        //取消按钮
        searchCancelButton = UIButton()
        searchCancelButton.setTitle("取消", forState: UIControlState.Normal)
        //searchCancelButton.sizeToFit()
        searchCancelButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        searchCancelButton.addTarget(self, action: "cancel", forControlEvents: UIControlEvents.TouchUpInside)
        customerHeaderView.addSubview(searchCancelButton)
        
        
        var searchTextFieldConstraint = NSLayoutConstraint(item: searchTextField, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: customerHeaderView, attribute: NSLayoutAttribute.Leading, multiplier: 1.0, constant: 10)
        customerHeaderView.addConstraint(searchTextFieldConstraint)
        
        searchTextFieldConstraint = NSLayoutConstraint(item: searchTextField, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: customerHeaderView, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0)
        customerHeaderView.addConstraint(searchTextFieldConstraint)
        
        searchTextFieldConstraint = NSLayoutConstraint(item: searchTextField, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: searchCancelButton, attribute: NSLayoutAttribute.Leading, multiplier: 1.0, constant: -10)
        customerHeaderView.addConstraint(searchTextFieldConstraint)
        
        
        var searchCancelButtonConstraint =  NSLayoutConstraint(item: searchCancelButton, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: customerHeaderView, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0)
        customerHeaderView.addConstraint(searchCancelButtonConstraint)
        searchCancelButtonConstraint = NSLayoutConstraint(item: searchCancelButton, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: customerHeaderView, attribute: NSLayoutAttribute.Trailing, multiplier: 1.0, constant: -10)
        customerHeaderView.addConstraint(searchCancelButtonConstraint)
        
        
        self.navigationItem.titleView = customerHeaderView
        self.setupRefresh()
        
        self.tableView.scrollEnabled = false
    }
    
    //取消，清空数据
    func cancel(){
        NSLog("清空数据")
        searchTextField.resignFirstResponder()
        data.removeAllObjects()
        searchTextField.text = ""
        searchString = ""
        self.tableView.reloadData()
        self.tableView.scrollEnabled = false
    }
    
    func change(sender:UITextField){
        searchString = sender.text
        NSLog("搜索框正在输入:%@",searchString!)
        if !searchString!.isEmpty {
            NSLog("开始搜索")
            getData(searchString!, actionType: "0")
        }else{
           cancel()
        }
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
            }else{
                self.tableView.headerEndRefreshing()
            }
            
        })
        self.tableView.addFooterWithCallback(){
            if !self.searchString!.isEmpty {
                NSLog("搜索，上拉加载")
                self.getData(self.searchString!, actionType: "2")
            }else{
                self.tableView.footerEndRefreshing()
            }
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
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return self.data.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(sectionsTableIdentifier) as! UITableViewCell
        var cellDictionary = self.data.objectAtIndex(indexPath.row) as! NSDictionary
        var borrowName = cellDictionary.objectForKey("borrow_name") as? String
        var id = cellDictionary.objectForKey("id") as? String
        cell.textLabel?.text = borrowName!//borrow_name
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var lendDetailViewController = self.storyboard?.instantiateViewControllerWithIdentifier("NewDetailScrollViewController") as! NewDetailScrollViewController
        //不使用隐藏域来保存数据，有问题。根据下标在data中获取数据再传到下个页面
        if self.data.count > 0 {
            var cellDictionary = self.data.objectAtIndex(indexPath.row) as! NSDictionary
            lendDetailViewController.id = cellDictionary.objectForKey("id") as? String
            lendDetailViewController.type = cellDictionary.objectForKey("borrow_type") as? String
            
            lendDetailViewController.hidesBottomBarWhenPushed = true
            
            self.navigationController?.pushViewController(lendDetailViewController, animated: true)
        }
    }
    
    //MARK:- 隐藏键盘
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func viewWillAppear(animated: Bool) {
        DaiDodgeKeyboard.addRegisterTheViewNeedDodgeKeyboard(self.view)
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        DaiDodgeKeyboard.removeRegisterTheViewNeedDodgeKeyboard()
        super.viewWillDisappear(animated)
    }
    
}
