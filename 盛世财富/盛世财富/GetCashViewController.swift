//
//  GetCashViewController.swift
//  盛世财富
//
//  Created by 肖典 on 15/5/25.
//  Copyright (c) 2015年 sscf88. All rights reserved.
//

import Foundation
import UIKit
class GetCashViewController:UIViewController {
    @IBOutlet weak var money: UITextField!
    @IBOutlet weak var payPassword: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func submit(sender: UIButton) {
        if money.text.isEmpty {
            AlertView.showMsg("请输入金额", parentView: self.view)
            return
        }
        if payPassword.text.isEmpty {
            AlertView.showMsg("请输入支付密码", parentView: self.view)
            return
        }
        let user = NSUserDefaults.standardUserDefaults()
        let url = Common.serverHost+"/App-Ucenter-actwithdraw"
        let afnet = AFHTTPRequestOperationManager()
        var param = ["to":user.stringForKey("token"),"txt_Amount":money.text,"txtPassword":payPassword.text]
        afnet.responseSerializer.acceptableContentTypes = NSSet(array: ["text/html"]) as Set<NSObject>
        afnet.POST(url, parameters: param, success: { (opration:AFHTTPRequestOperation!, data:AnyObject!) -> Void in
            
            AlertView.showMsg(data["message"] as! String, parentView: self.view)
            }) { (opration:AFHTTPRequestOperation!, error:NSError!) -> Void in
                AlertView.alert("错误", message: error.localizedDescription, buttonTitle: "确定", viewController: self)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}