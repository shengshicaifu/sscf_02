//
//  ModifyLoginPasswordViewController.swift
//  盛世财富
//  修改登录密码
//  Created by 云笺 on 15/5/16.
//  Copyright (c) 2015年 sscf88. All rights reserved.
//

import UIKit

class ModifyLoginPasswordViewController: UIViewController {

    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var oldPassLabel: UILabel!
    @IBOutlet weak var oldPassTextField: UITextField!
    
    @IBOutlet weak var newPassLabel: UILabel!
    @IBOutlet weak var newPassTextField: UITextField!
    
    @IBOutlet weak var confirmPassLabel: UILabel!
    @IBOutlet weak var confirmPassTextField: UITextField!
    
    @IBOutlet weak var okButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //设置输入框区域的背景边框
        Common.customerBgView(bgView)
        
        //设置文本和输入框的边框
        Common.addBorder(oldPassLabel)
        Common.addBorder(oldPassTextField)
        Common.addBorder(newPassLabel)
        Common.addBorder(newPassTextField)
        
        Common.customerButton(okButton)
        
    }


    @IBAction func modifyTapped(sender: UIButton) {
        resignAll()
        var oldpass = oldPassTextField.text
        var newpass = newPassTextField.text
        var confirmpass = confirmPassTextField.text
        if oldpass.isEmpty {
            AlertView.showMsg("请输入原密码", parentView: self.view)
            return
        }
        if !Common.isPassword(oldpass) {
            AlertView.showMsg(Common.passwordErrorTip, parentView: self.view)
            return
        }
        if newpass.isEmpty {
            AlertView.showMsg("请输入新密码", parentView: self.view)
            return
        }
        if !Common.isPassword(newpass) {
            AlertView.showMsg(Common.passwordErrorTip, parentView: self.view)
            return
        }

        if confirmpass.isEmpty {
            AlertView.showMsg("请输入确认密码", parentView: self.view)
            return
        }
        if newpass != confirmpass {
            AlertView.showMsg("两次密码不一致", parentView: self.view)
            return
        }
        //其他输入限制再加
        //检查手机网络
        var reach = Reachability(hostName: Common.domain)
        reach.unreachableBlock = {(r:Reachability!) -> Void in
            dispatch_async(dispatch_get_main_queue(), {

                AlertView.alert("提示", message: "网络连接有问题，请检查手机网络", buttonTitle: "确定", viewController: self)
            })
        }
        
        reach.reachableBlock = {(r:Reachability!) -> Void in
            dispatch_async(dispatch_get_main_queue(), {

                var manager = AFHTTPRequestOperationManager()
                var url = Common.serverHost + "/App-Ucenter-setPassWord"
                var token = NSUserDefaults.standardUserDefaults().objectForKey("token") as? String
                var params = ["oldpass":oldpass,"newpass":newpass,"to":token]
                loading.startLoading(self.view)
                manager.responseSerializer.acceptableContentTypes = NSSet(array: ["text/html"]) as Set<NSObject>
                manager.POST(url, parameters: params,
                    success: { (op:AFHTTPRequestOperation!, data:AnyObject!) -> Void in
                        loading.stopLoading()
                        var result = data as! NSDictionary
                        var code = result["code"] as! Int
                        if code == -1 {
                            AlertView.showMsg("请登录后再试", parentView: self.view)
                        }else if code == 0 {
                            AlertView.showMsg("修改密码失败，请稍候再试", parentView: self.view)
                        }else if code == 200 {
                            NSLog("修改登录密码成功")
                            AlertView.alert("提示", message: "修改登录密码成功", buttonTitle: "确定", viewController: self, callback: { (alertAction:UIAlertAction!) -> Void in
                                self.navigationController?.popViewControllerAnimated(true)
                            })
                        }
                        
                    },failure: { (op:AFHTTPRequestOperation!, error:NSError!) -> Void in
                        loading.stopLoading()
                        AlertView.alert("提示", message: "服务器错误", buttonTitle: "确定", viewController: self)
                    }
                )
            })
        }
        reach.startNotifier()
    }
    
    //MARK:- 隐藏键盘
    override func viewWillAppear(animated: Bool) {
        DaiDodgeKeyboard.addRegisterTheViewNeedDodgeKeyboard(self.view)
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        DaiDodgeKeyboard.removeRegisterTheViewNeedDodgeKeyboard()
        super.viewWillDisappear(animated)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        resignAll()
        return true
    }
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        resignAll()
    }
    
    func resignAll() {
        oldPassTextField.resignFirstResponder()
        newPassTextField.resignFirstResponder()
        confirmPassTextField.resignFirstResponder()
    }
}
