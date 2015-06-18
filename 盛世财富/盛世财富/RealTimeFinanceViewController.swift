//
//  RealTimeFinanceViewController.swift
//  盛世财富
//
//  Created by 云笺 on 15/6/6.
//  Copyright (c) 2015年 sscf88. All rights reserved.
//

import UIKit
/**
*  实时财务 旧
*/
class RealTimeFinanceViewController: UIViewController {

    @IBOutlet weak var lowRate: UILabel!
    @IBOutlet weak var highRate: UILabel!
    @IBOutlet weak var financeMoney: UILabel!
    @IBOutlet weak var financeDay: UILabel!
    @IBOutlet weak var memberNo: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
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
                var manager = AFHTTPRequestOperationManager()
                var url = Common.serverHost + "/App-Index"
                var params = [:]
                manager.responseSerializer.acceptableContentTypes = NSSet(array: ["text/html"]) as Set<NSObject>
                manager.POST(url, parameters: params,
                    success: { (op:AFHTTPRequestOperation!, data:AnyObject!) -> Void in
                        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                        var result = data as! NSDictionary
                        //NSLog("首页：%@", result)
                        var code = result["code"] as! Int
                        if code == 200 {
                            var info = result["data"] as! NSDictionary
                            self.financeDay.text = info["protect_days"] as? String//累计保驾护航天数
                            self.financeMoney.text = info["total_invest"] as? String//总共放贷金额
                            self.memberNo.text = info["user_count"] as? String//会员数量
                            var investMax = info["invest_max"] as? String//最高年利率
                            var investmin = info["invest_min"] as? String //最低年利率
                            self.highRate.text = "\(investMax!)%"
                            self.lowRate.text = "\(investmin!)%"
                        }
                        
                    },failure:{ (op:AFHTTPRequestOperation!,error: NSError!) -> Void in
                        AlertView.alert("提示", message: "网络连接有问题，请检查网络是否连接", buttonTitle: "确定", viewController: self)
                        
                    }
                )
                
            })
        }
        reach.startNotifier()
    }

}
