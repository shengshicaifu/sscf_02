//
//  ModifyPhoneStepSecondViewController.swift
//  盛世财富
//  修改手机号码第二步
//  Created by 云笺 on 15/5/20.
//  Copyright (c) 2015年 sscf88. All rights reserved.
//

import UIKit

class ModifyPhoneStepSecondViewController: UIViewController {
    
    var f_id:String?

    @IBOutlet weak var styleView: UIView!
    @IBOutlet weak var newPhoneTextField: UITextField!
    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var getCodeButton: UIButton!
    @IBOutlet weak var okButton: UIButton!
    var timer:NSTimer!

    override func viewDidLoad() {
        super.viewDidLoad()
        Common.addBorder(newPhoneTextField)
        Common.customerButton(okButton)
        Common.customerBgView(styleView)
        // Do any additional setup after loading the view.
    }
    
    //获取验证码
    @IBAction func getCodeTapped(sender: UIButton) {
        resignAll()
        var phone = newPhoneTextField.text
        if phone.isEmpty {
            AlertView.alert("提示", message: "请填写新的手机号码", buttonTitle: "确定", viewController: self)
            newPhoneTextField.becomeFirstResponder()
            return
        }
        
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
                //禁用获取验证码按钮60秒
                self.getCodeButton.enabled = false
                self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "repeat", userInfo: nil, repeats: true)
                
                //获取验证码
                var url = Common.serverHost + "/App-Ucenter-sendphone"
                var token = NSUserDefaults.standardUserDefaults().objectForKey("token") as? String
                var params = ["to":token,"cellphone":phone]
                var manager = AFHTTPRequestOperationManager()
                manager.responseSerializer.acceptableContentTypes = NSSet(array: ["text/html"]) as Set<NSObject>
                //loading.startLoading(self.view)
                UIApplication.sharedApplication().networkActivityIndicatorVisible = true
                manager.POST(url, parameters: params,
                    success: { (op:AFHTTPRequestOperation!, data:AnyObject!) -> Void in
                        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                        
                        var result = data as! NSDictionary
                        //NSLog("验证码%@", result)
                        var code = result["code"] as! Int
                        var msg:String = ""
                        if code == 0 {
                            msg = "验证码生送失败，请重试!"
                        }else if code == 1 {
                            msg = "手机号已被别人使用!"
                        }else if code == 100 {
                            msg = "短信验证码发送成功"
                        }
                        AlertView.showMsg(msg, parentView: self.view)
                    },
                    failure:{ (op:AFHTTPRequestOperation!, error:NSError!) -> Void in
                        loading.stopLoading()
                        AlertView.alert("提示", message: "服务器错误", buttonTitle: "确定", viewController: self)
                    }
                )

                
            })
        }
      
        reach.startNotifier()
    }
    
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
    
    
    //确定绑定新的手机号码
    @IBAction func okTapped(sender: UIButton) {
        resignAll()
        var phone = newPhoneTextField.text
        if phone.isEmpty {
//            AlertView.alert("提示", message: "请填写新的手机号码", buttonTitle: "确定", viewController: self)
            AlertView.showMsg("请填写新的手机号码", parentView: self.view)
            //newPhoneTextField.becomeFirstResponder()
            return
        }
        if !Common.isTelephone(phone) {
            AlertView.showMsg(Common.telephoneErrorTip, parentView: self.view)
            return
        }
        
        var code = codeTextField.text
        if code.isEmpty {
//            AlertView.alert("提示", message: "请填写手机验证码", buttonTitle: "确定", viewController: self)
//            codeTextField.becomeFirstResponder()
            AlertView.showMsg("请填写手机验证码", parentView: self.view)
            return
        }
        
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
                manager.responseSerializer.acceptableContentTypes = NSSet(array: ["text/html"]) as Set<NSObject>
                var url = Common.serverHost + "/App-Ucenter-alertPhone"
                var userDefaults = NSUserDefaults.standardUserDefaults()
                var token = userDefaults.objectForKey("token") as? String
                var params = ["to":token,"step":"2","cellphone":phone,"code":code,"f_id":self.f_id]
                loading.startLoading(self.view)
                manager.POST(url, parameters: params,
                    success: { (op:AFHTTPRequestOperation!, data:AnyObject!) -> Void in
                        loading.stopLoading()
                        var result = data as! NSDictionary
                        var resultCode = result["code"] as! Int
                        if resultCode == -1 {
                            AlertView.alert("提示", message: "请登录后再使用", buttonTitle: "确定", viewController: self)
                            
                        } else if resultCode == 0 {
                            AlertView.alert("提示", message: "手机验证码错误", buttonTitle: "确定", viewController: self)
                            self.codeTextField.becomeFirstResponder()
                        } else if resultCode == 200 {
                            userDefaults.setObject(phone, forKey: "phone")
                            
                            //self.performSegueWithIdentifier("modifyPhoneNextStepSegue", sender: self)
                            //连着返回两次到
                            AlertView.alert("提示", message: "绑定手机号码成功", buttonTitle: "确定", viewController: self, callback: { (alertAction:UIAlertAction!) -> Void in
                                var count = self.navigationController?.viewControllers.count
                                var destiationController = self.navigationController?.viewControllers[count! - 3] as! UIViewController
                                self.navigationController?.popToViewController(destiationController, animated: true)
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
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        var str = string as NSString
        var lengthOfString:NSInteger = str.length;
        for (var loopIndex:NSInteger = 0; loopIndex < lengthOfString; loopIndex++) {//只允许数字输入
            var character:unichar = str.characterAtIndex(loopIndex)
            if (character < 48) {
                return false
            } // 48 unichar for 0
            if (character > 57){
                return false
            } // 57 unichar for 9
        }
        var inputString = textField.text as NSString
        // Check for total length
        var proposedNewLength:NSInteger = inputString.length - range.length + str.length;
        if (proposedNewLength >= 11) {
            return false
        }//限制长度
        return true
        
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == newPhoneTextField {
            codeTextField.becomeFirstResponder()
        }else if textField == codeTextField{
            resignAll()
        }
        
        return true
    }
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        resignAll()
        
    }
    
    func resignAll(){
        newPhoneTextField.resignFirstResponder()
        codeTextField.resignFirstResponder()
    }

}
