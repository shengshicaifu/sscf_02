//
//  UserMoneyViewController.swift
//  盛世财富
//  资产管理
//  Created by 肖典 on 15/5/15.
//  Copyright (c) 2015年 sscf88. All rights reserved.
//

import Foundation
import UIKit
class UserMoneyViewController:UITableViewController {
    @IBOutlet weak var accountMoney: UILabel!
    @IBOutlet weak var totalAll: UILabel!
    @IBOutlet weak var moneyCollect: UILabel!
    @IBOutlet weak var rewardMoney: UILabel!
    @IBOutlet weak var vexperince: UILabel!
    @IBOutlet weak var moneyFreeze: UILabel!
    @IBOutlet weak var ljtxje: UILabel!
    @IBOutlet weak var ljczje: UILabel!
    @IBOutlet weak var dslxze: UILabel!
    @IBOutlet weak var ljtzje: UILabel!
    @IBOutlet weak var kyAll: UILabel!
    @IBOutlet weak var jzlx: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //下拉刷新
        var rc = UIRefreshControl()
        rc.attributedTitle = NSAttributedString(string: "下拉刷新")
        rc.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = rc
        getData("0")
        

    }
    
    func refresh(){
        if self.refreshControl!.refreshing {
            self.refreshControl?.attributedTitle = NSAttributedString(string: "加载中...")
            getData("1")
        }
        
    }
    

    func getData(actionType:String){
        //检查手机网络
        var reach = Reachability(hostName: Common.domain)
        reach.reachableBlock = {(r:Reachability!) -> Void in
            //NSLog("网络可用")
            dispatch_async(dispatch_get_main_queue(), {
                if let token = NSUserDefaults.standardUserDefaults().objectForKey("token") as? String {
                    let afnet = AFHTTPRequestOperationManager()
                    let param = ["to":token]
                    let url = Common.serverHost + "/App-Ucenter-userInfo"
                    if actionType == "0" {
                        loading.startLoading(self.tableView)
                    }else{
                        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
                    }
                    
                    afnet.responseSerializer.acceptableContentTypes = NSSet(array: ["text/html"]) as Set<NSObject>
                    afnet.POST(url, parameters: param, success: { (opration:AFHTTPRequestOperation!, res:AnyObject!) -> Void in
                        //NSLog("资产管理：%@", res as! NSDictionary)
                        var resDictionary = res as! NSDictionary
                        var code = resDictionary["code"] as! Int
                        if code == -1 {
                            AlertView.alert("提示", message: "请登录后再使用", buttonTitle: "确定", viewController: self)
                        } else if code == 200 {
                            let code = res["code"] as! Int
                            let message = res["message"] as! String
                            let data  = res["data"] as! NSDictionary
                            let proInfo = data.objectForKey("proInfo") as! NSDictionary
                            
                            self.accountMoney.text = proInfo.objectForKey("account_money") as? String
                            self.totalAll.text = proInfo.objectForKey("total_all") as? String
                            self.moneyCollect.text = proInfo.objectForKey("money_collect") as? String
                            self.rewardMoney.text = proInfo.objectForKey("reward_money") as? String
                            self.vexperince.text = proInfo.objectForKey("vexperince") as? String
                            self.moneyFreeze.text = proInfo.objectForKey("money_freeze") as? String
                            self.ljtxje.text = proInfo.objectForKey("ljtxje") as? String
                            self.ljczje.text = proInfo.objectForKey("ljczje") as? String
                            self.dslxze.text = proInfo.objectForKey("dslxze") as? String
                            self.ljtzje.text = proInfo.objectForKey("ljtzje") as? String
                            self.kyAll.text = proInfo.objectForKey("ky_all") as? String
                            self.jzlx.text = proInfo.objectForKey("jzlx") as? String
                        }
                        //loading.stopLoading()
                        if actionType == "0" {
                           loading.stopLoading()
                        }else{
                           UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                            self.refreshControl?.endRefreshing()
                            self.refreshControl?.attributedTitle = NSAttributedString(string: "下拉刷新")
                        }
                        }) { (opration:AFHTTPRequestOperation!, error:NSError!) -> Void in
                            loading.stopLoading()
                            AlertView.alert("错误", message: error.localizedDescription, buttonTitle: "确定", viewController: self)
                            if actionType == "0" {
                                loading.stopLoading()
                            }else{
                                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                                self.refreshControl?.endRefreshing()
                                self.refreshControl?.attributedTitle = NSAttributedString(string: "下拉刷新")
                            }
                    }
                }
                
            })
        }
        reach.startNotifier()
    }
    
    override func viewWillAppear(animated: Bool) {
        //检查网络
        var reach = Reachability(hostName: Common.domain)
        reach.unreachableBlock = {(r:Reachability!)in
            dispatch_async(dispatch_get_main_queue(), {
                AlertView.alert("提示", message: "网络连接有问题，请检查手机网络", buttonTitle: "确定", viewController: self)
            })
        }
        reach.startNotifier()
        
    }
}