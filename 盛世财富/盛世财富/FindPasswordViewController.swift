//
//  FindPasswordViewController.swift
//  盛世财富
//
//  Created by 肖典 on 15/5/25.
//  Copyright (c) 2015年 sscf88. All rights reserved.
//

import Foundation
import UIKit
class FindPasswordViewController:UIViewController {
    @IBOutlet weak var phone: UITextField!
    
    @IBOutlet weak var checkCode: UITextField!
    
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var repeatPassword: UITextField!
    var code = String()
    @IBAction func getCheckCode(sender: AnyObject) {
        if phone.text.isEmpty {
            AlertView.showMsg("请输入手机号", parentView: self.view)
            return
        }
        let user = NSUserDefaults.standardUserDefaults()
        let url = Common.serverHost+"/App-Login-findPassword"
        let afnet = AFHTTPRequestOperationManager()
        var param = ["to":user.stringForKey("token")]
        afnet.responseSerializer.acceptableContentTypes = NSSet(array: ["text/html"]) as Set<NSObject>
        afnet.POST(url, parameters: nil, success: { (opration:AFHTTPRequestOperation!, data:AnyObject!) -> Void in
            
            AlertView.showMsg(data["message"] as! String, parentView: self.view)
            }) { (opration:AFHTTPRequestOperation!, error:NSError!) -> Void in
                AlertView.alert("错误", message: error.localizedDescription, buttonTitle: "确定", viewController: self)
        }

    }
    @IBAction func submit(sender: UIButton) {
        if phone.text.isEmpty {
            AlertView.showMsg("请输入手机号", parentView: self.view)
            return
        }
        if checkCode.text.isEmpty {
            AlertView.showMsg("请输入验证码", parentView: self.view)
            return
        }

        if password.text.isEmpty {
            AlertView.showMsg("请输入新密码", parentView: self.view)
            return
        }
        if repeatPassword.text.isEmpty {
            AlertView.showMsg("请重复输入新密码", parentView: self.view)
            return
        }
        if password.text != repeatPassword.text {
            AlertView.showMsg("两次输入的密码不一样", parentView: self.view)
            return
        }
        
        let user = NSUserDefaults.standardUserDefaults()
        let url = Common.serverHost+"/App-Login-findPassword"
        let afnet = AFHTTPRequestOperationManager()
        var param = ["to":user.stringForKey("token")]
        afnet.responseSerializer.acceptableContentTypes = NSSet(array: ["text/html"]) as Set<NSObject>
        afnet.POST(url, parameters: nil, success: { (opration:AFHTTPRequestOperation!, data:AnyObject!) -> Void in
            
            AlertView.showMsg(data["message"] as! String, parentView: self.view)
            }) { (opration:AFHTTPRequestOperation!, error:NSError!) -> Void in
                AlertView.alert("错误", message: error.localizedDescription, buttonTitle: "确定", viewController: self)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}