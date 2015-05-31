//
//  FindPasswordViewController.swift
//  盛世财富
//  找回密码
//  Created by 肖典 on 15/5/25.
//  Copyright (c) 2015年 sscf88. All rights reserved.
//

import Foundation
import UIKit
class FindPasswordViewController:UIViewController {
    @IBOutlet weak var phone: UITextField!
    
    @IBOutlet weak var getCodeButton: UIButton!
    @IBOutlet weak var checkCode: UITextField!
    
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var repeatPassword: UITextField!
    var code = String()
    var timer:NSTimer!
    
    var i = 60
    func repeat(){
        getCodeButton.setTitle("重新发送（\(i)）", forState: UIControlState.Disabled)
        i--
        if i == 0 {
            i = 60
            timer.invalidate()
            getCodeButton.enabled = true
            getCodeButton.setTitle("获取验证码", forState: UIControlState.Normal)
        }
    }
    
    @IBAction func getCheckCode(sender: AnyObject) {
        resignAll()
        if phone.text.isEmpty {
            AlertView.showMsg("请输入手机号", parentView: self.view)
            return
        }
        if !Common.isTelephone(phone.text) {
            AlertView.showMsg(Common.telephoneErrorTip, parentView: self.view)
            return
        }
        
        
        
        let user = NSUserDefaults.standardUserDefaults()
        let url = Common.serverHost+"/App-Login-findPassword"
        let afnet = AFHTTPRequestOperationManager()
        var param:[String:String] = ["phone":phone.text!,"step":"1"]
        //检查手机网络
        var reach = Reachability(hostName: Common.domain)
        reach.unreachableBlock = {(r:Reachability!) -> Void in
            //NSLog("网络不可用")
            dispatch_async(dispatch_get_main_queue(), {
                
                AlertView.alert("提示", message: "网络连接有问题，请检查手机网络", buttonTitle: "确定", viewController: self)
            })
        }
        reach.reachableBlock = {(r:Reachability!) -> Void in
            //NSLog("网络可用")

            dispatch_async(dispatch_get_main_queue(), {
                loading.startLoading(self.view)
                self.getCodeButton.enabled = false
                self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "repeat", userInfo: nil, repeats: true)
                
                afnet.responseSerializer.acceptableContentTypes = NSSet(array: ["text/html"]) as Set<NSObject>
                afnet.POST(url, parameters: param, success: { (opration:AFHTTPRequestOperation!, data:AnyObject!) -> Void in
                    loading.stopLoading()
                    AlertView.showMsg(data["message"] as! String, parentView: self.view)
                    }) { (opration:AFHTTPRequestOperation!, error:NSError!) -> Void in
                        loading.stopLoading()
                        AlertView.alert("错误", message: error.localizedDescription, buttonTitle: "确定", viewController: self)
                }
            })
        }
        reach.startNotifier()
        
    }
    @IBAction func submit(sender: UIButton) {
        resignAll()
        if phone.text.isEmpty {
            AlertView.showMsg("请输入手机号", parentView: self.view)
            return
        }
        if !Common.isTelephone(phone.text) {
            AlertView.showMsg(Common.telephoneErrorTip, parentView: self.view)
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
        if !Common.isPassword(password.text) {
            AlertView.showMsg(Common.passwordErrorTip, parentView: self.view)
            return
        }
        if repeatPassword.text.isEmpty {
            AlertView.showMsg("请重复输入新密码", parentView: self.view)
            return
        }
        if !Common.isPassword(repeatPassword.text) {
            AlertView.showMsg(Common.passwordErrorTip, parentView: self.view)
            return
        }
        if password.text != repeatPassword.text {
            AlertView.showMsg("两次输入的密码不一样", parentView: self.view)
            return
        }
        
        let user = NSUserDefaults.standardUserDefaults()
        let url = Common.serverHost+"/App-Login-findPassword"
        let afnet = AFHTTPRequestOperationManager()
        var param = ["phone":phone.text,"step":"2","code":checkCode.text,"type":"1","new_pass":password.text]
        println(checkCode.text)
        //检查手机网络
        var reach = Reachability(hostName: Common.domain)
        reach.unreachableBlock = {(r:Reachability!) -> Void in
            //NSLog("网络不可用")
            dispatch_async(dispatch_get_main_queue(), {
                
                AlertView.alert("提示", message: "网络连接有问题，请检查手机网络", buttonTitle: "确定", viewController: self)
            })
        }
        
        reach.reachableBlock = {(r:Reachability!) -> Void in
            //NSLog("网络可用")
            dispatch_async(dispatch_get_main_queue(), {
                loading.startLoading(self.view)
                afnet.responseSerializer.acceptableContentTypes = NSSet(array: ["text/html"]) as Set<NSObject>
                afnet.POST(url, parameters: param, success: { (opration:AFHTTPRequestOperation!, data:AnyObject!) -> Void in
                    loading.stopLoading()
                    println(data)
                    AlertView.showMsg(data["message"] as! String, parentView: self.view)
                    }) { (opration:AFHTTPRequestOperation!, error:NSError!) -> Void in
                        loading.stopLoading()
                        AlertView.alert("错误", message: error.localizedDescription, buttonTitle: "确定", viewController: self)
                }
            })
        }
        reach.startNotifier()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        resignAll()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        resignAll()
        return true
    }
    
    func resignAll(){
       
        phone.resignFirstResponder()
        checkCode.resignFirstResponder()
        password.resignFirstResponder()
        repeatPassword.resignFirstResponder()
    }
    
    override func viewWillAppear(animated: Bool) {
        DaiDodgeKeyboard.addRegisterTheViewNeedDodgeKeyboard(self.view)
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        DaiDodgeKeyboard.removeRegisterTheViewNeedDodgeKeyboard()
        super.viewWillDisappear(animated)
    }
    
    @IBAction func closed(sender:AnyObject){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}