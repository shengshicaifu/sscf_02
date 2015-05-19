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
        if let token = NSUserDefaults.standardUserDefaults().objectForKey("token") as? String {
            let afnet = AFHTTPRequestOperationManager()
            let param = ["to":token]
            let url = Constant.getServerHost() + "/App-Ucenter-userInfo"
            loading.startLoading(self.tableView)
            afnet.POST(url, parameters: param, success: { (opration:AFHTTPRequestOperation!, res:AnyObject!) -> Void in
                let code = res["code"] as! Int
                let message = res["message"] as! String
                let data  = res["data"] as! NSDictionary
                let proInfo = data.objectForKey("proInfo") as! NSDictionary
                println(res)
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
                loading.stopLoading()
                }) { (opration:AFHTTPRequestOperation!, error:NSError!) -> Void in
                    loading.stopLoading()
                    AlertView.alert("错误", message: error.localizedDescription, buttonTitle: "确定", viewController: self)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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