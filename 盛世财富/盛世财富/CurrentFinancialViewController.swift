//
//  CurrentFinancialViewController.swift
//  盛世财富
//
//  Created by 肖典 on 15/6/11.
//  Copyright (c) 2015年 sscf88. All rights reserved.
//

import Foundation
import UIKit
/**
*  实时财务 新
*/
class CurrentFinancialViewController:UITableViewController,UITableViewDataSource,UITableViewDelegate {
    @IBOutlet weak var roundView1: UIView!
    @IBOutlet weak var roundView2: UIView!
    @IBOutlet weak var roundView3: UIView!
    @IBOutlet weak var roundView4: UIView!
    @IBOutlet weak var m1Label: UILabel!//总资产
    @IBOutlet weak var m2Label: UILabel!//可用现金余额
    @IBOutlet weak var m3Label: UILabel!//资金余额
    @IBOutlet weak var m4Label: UILabel!//待收本息余额
    @IBOutlet weak var m5Label: UILabel!//待审核提现
    @IBOutlet weak var m6Label: UILabel!//处理中提现
    @IBOutlet weak var m7Label: UILabel!//累计盈亏总额
    @IBOutlet weak var m8Label: UILabel!//净赚利息
    @IBOutlet weak var m9Label: UILabel!//收到奖金
    @IBOutlet weak var m10Label: UILabel!//提现手续费
    @IBOutlet weak var m11Label: UILabel!//充值手续费
    @IBOutlet weak var m12Label: UILabel!//累计投资金额
    @IBOutlet weak var m13Label: UILabel!//充值金额
    @IBOutlet weak var m14Label: UILabel!//提现金额
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        toRound(roundView1)
        toRound(roundView2)
        toRound(roundView3)
        roundView4.layer.cornerRadius = 8
        
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
                        
                        var resDictionary = res as! NSDictionary
                        var code = resDictionary["code"] as! Int
                        if code == -1 {
                            AlertView.alert("提示", message: "请登录后再使用", buttonTitle: "确定", viewController: self)
                        } else if code == 200 {
                            let code = res["code"] as! Int
                            let message = res["message"] as! String
                            let data  = res["data"] as! NSDictionary
                            let proInfo = data.objectForKey("proInfo") as! NSDictionary
                            //NSLog("实时财务：%@", proInfo)
                            self.m1Label.text = self.replaceToDefault(proInfo.objectForKey("total_all") as? String)
                            self.m2Label.text = self.replaceToDefault(proInfo.objectForKey("account_money") as? String)
                            self.m3Label.text = self.replaceToDefault(proInfo.objectForKey("reward_money") as? String)
                            self.m4Label.text = self.replaceToDefault(proInfo.objectForKey("money_collect") as? String)
                            self.m5Label.text = self.replaceToDefault(proInfo.objectForKey("dsh_money") as? String)
                            self.m6Label.text = self.replaceToDefault(proInfo.objectForKey("clz_money") as? String)
                            self.m7Label.text = self.replaceToDefault(proInfo.objectForKey("ky_all") as? String)
                            self.m8Label.text = self.replaceToDefault(proInfo.objectForKey("jzlx") as? String)
                            self.m9Label.text = self.replaceToDefault(proInfo.objectForKey("ljjj") as? String)
                            self.m10Label.text = self.replaceToDefault(proInfo.objectForKey("ljtxsxf") as? String)
                            self.m11Label.text = self.replaceToDefault(proInfo.objectForKey("ljczsxf") as? String)
                            self.m12Label.text = self.replaceToDefault(proInfo.objectForKey("ljtzje") as? String)
                            self.m13Label.text = self.replaceToDefault(proInfo.objectForKey("ljczje") as? String)
                            self.m14Label.text = self.replaceToDefault(proInfo.objectForKey("ljtxje") as? String)
                            
                        }
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

    
    
    func toRound(view:UIView){
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        var sublayer = CALayer()
        sublayer.frame = CGRectMake(4, 4, 8, 8)
        sublayer.cornerRadius = 4
        sublayer.backgroundColor = UIColor.whiteColor().CGColor
        view.layer.addSublayer(sublayer)
    }
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        return 0.001
    }
    
    func replaceToDefault(str:String?) -> String{
        if str == nil{
            return "0.00"
        }
        if str!.isEmpty {
            return "0.00"
        }
        return str!
    }
}