//
//  TransRecordViewController.swift
//  盛世财富
//  注册
//  Created by zengchang on 15-3-17.
//  Copyright (c) 2015年 sscf88. All rights reserved.
//

import Foundation
import UIKit

class RegisterViewController: UIViewController,UITextFieldDelegate {
    
    

    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var surePwdTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var regist: UIButton!
    @IBOutlet weak var checkBtn: UIButton!
    var timer:NSTimer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkBtn.setTitleColor(UIColor.grayColor(), forState: UIControlState.Disabled)
        codeTextField.delegate = self
        userNameTextField.delegate = self
        surePwdTextField.delegate = self
        passwordTextField.delegate = self
        phoneTextField.delegate = self
        checkBtn.layer.cornerRadius = 5
        Common.customerButton(regist)
        Common.addBorder(userNameTextField)
        Common.addBorder(phoneTextField)
        Common.addBorder(passwordTextField)
        Common.addBorder(surePwdTextField)
        Common.addBorder(codeTextField)
        Common.addBorder(checkBtn)
        self.navigationItem.title = "用户注册"
        
        surePwdTextField.leftView = UIImageView(image: UIImage(named: "密码.png"))
        surePwdTextField.leftViewMode = UITextFieldViewMode.Always
        
        passwordTextField.leftView = UIImageView(image: UIImage(named: "密码.png"))
        passwordTextField.leftViewMode = UITextFieldViewMode.Always
        
        phoneTextField.leftView = UIImageView(image: UIImage(named: "电话.png"))
        phoneTextField.leftViewMode = UITextFieldViewMode.Always
        
        codeTextField.leftView = UIImageView(image: UIImage(named: "齿轮.png"))
        codeTextField.leftViewMode = UITextFieldViewMode.Always
        
        userNameTextField.leftView = UIImageView(image: UIImage(named: "人.png"))
        userNameTextField.leftViewMode = UITextFieldViewMode.Always
    }
    
    //发送验证码
    @IBAction func checkTapped(sender: UIButton) {
        var phone = phoneTextField.text
        
        if phone.isEmpty {
            AlertView.showMsg("手机号码不能为空", parentView: self.view)
            return
        }
        
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
                
                //禁用获取验证码按钮60秒
                self.checkBtn.enabled = false
                self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "repeat", userInfo: nil, repeats: true)
                
                //获取验证码
                var url = Common.serverHost + "/App-Register-sendphone"
                var params = ["cellphone":phone]
                var manager = AFHTTPRequestOperationManager()
                UIApplication.sharedApplication().networkActivityIndicatorVisible = true
                manager.responseSerializer.acceptableContentTypes = NSSet(array: ["text/html"]) as Set<NSObject>
                manager.POST(url, parameters: params,
                    success: { (op:AFHTTPRequestOperation!, data:AnyObject!) -> Void in
                        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                        
                        var result = data as! NSDictionary
                        NSLog("验证码%@", result)
                        var code = result["code"] as! Int
                        var msg:String = ""
                        if code == 0 {
                            msg = "验证码生送失败，请重试!"
                        }else if code == 1 {
                            msg = "手机号已被别人使用!"
                        }else if code == 100 {
                            msg = "短信验证码发送成功"
                        }else{
                            msg = result["message"] as! String
                        }
                        AlertView.showMsg(msg, parentView: self.view)
                    },
                    failure:{ (op:AFHTTPRequestOperation!, error:NSError!) -> Void in
                        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                        AlertView.alert("提示", message: "服务器错误", buttonTitle: "确定", viewController: self)
                    }
                )

                
            })
        }
      
        reach.startNotifier()
       
    }
    
    var i = 60
    func repeat(){
        checkBtn.setTitle("重新发送（\(i)）", forState: UIControlState.Disabled)
        i--
        if i == 0 {
            i = 60
            timer.invalidate()
            checkBtn.enabled = true
            checkBtn.setTitle("发送验证码", forState: UIControlState.Normal)
        }
    }
    
    //注册
    @IBAction func registerTapped(sender: AnyObject) {
        resignAll()
        var surePwd = surePwdTextField.text
        var password = passwordTextField.text
        var phone = phoneTextField.text
        var code = codeTextField.text
        var username = userNameTextField.text
        if username.isEmpty {
            AlertView.showMsg("用户名不能为空", parentView: self.view)
            return
        }
        if !Common.isUserName(username) {
            AlertView.showMsg(Common.userNameErrorTip, parentView: self.view)
            return
        }
        if phone.isEmpty {
            AlertView.showMsg("手机号码不能为空", parentView: self.view)
            return
        }
        if !Common.isTelephone(phone) {
            AlertView.showMsg(Common.telephoneErrorTip, parentView: self.view)
            return
        }
        if password.isEmpty {
            AlertView.showMsg("密码不能为空", parentView: self.view)
            return
        }
        if !Common.isPassword(password) {
            AlertView.showMsg(Common.passwordErrorTip, parentView: self.view)
            return
        }
        if password != surePwd{
            AlertView.showMsg("两次输入的密码不一致", parentView: self.view)
            return
        }
        if code.isEmpty{
            AlertView.showMsg("验证码不能为空", parentView: self.view)
            return
        }
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
                //此处执行注册操作
                loading.startLoading(self.view)
                var url = Common.serverHost + "/App-Register-regaction"
                var params = ["cellphone":phone,"pass_word":password,"code":code,"user_name":username]
                var manager = AFHTTPRequestOperationManager()
                manager.responseSerializer.acceptableContentTypes = NSSet(array: ["text/html"]) as Set<NSObject>
                manager.POST(url, parameters: params,
                    success: { (op:AFHTTPRequestOperation!, data:AnyObject!) -> Void in
                        loading.stopLoading()
                        var result = data as! NSDictionary
                        NSLog("注册返回结果：%@",result)
                        var code = result["code"] as! Int
                        if code == 0 {
                            AlertView.showMsg("手机号码不合法", parentView: self.view)
                        } else if code == 1 {
                            AlertView.showMsg("手机号码已经被注册", parentView: self.view)
                        } else if code == 4 {
                            AlertView.showMsg("手机校验码不正确", parentView: self.view)
                        } else if code == 200 {
                            //注册成功,保存基本信息，跳转到我的账号页面
                            
                            NSLog("注册成功")
                            
                            let user = NSUserDefaults.standardUserDefaults()
                            let proInfo:NSDictionary = result["data"]?["proInfo"] as! NSDictionary
                            let userinfo:NSDictionary = result["data"]?["userInfo"] as! NSDictionary
                            user.setObject(result["data"]?["token"], forKey: "token")
                            user.setObject(userinfo.objectForKey("userName"), forKey: "username")
                            if let birthday = userinfo.objectForKey("birthday") as? String {
                                user.setObject(birthday, forKey: "birthday")
                            }else{
                                user.setObject("", forKey: "birthday")
                                
                            }
                            if let gender = userinfo.objectForKey("gender") as? String {
                                user.setObject(gender, forKey: "gender")
                            }else{
                                user.setObject("", forKey: "gender")
                                
                            }
                            if let headpic = userinfo.objectForKey("headpic") as? String {
                                user.setObject(headpic, forKey: "headpic")
                            }else{
                                user.setObject("", forKey: "headpic")
                                
                            }
                            
                            user.setObject(userinfo.objectForKey("pinPass"), forKey: "pinpass")
                            user.setObject(proInfo.objectForKey("total_all"),forKey: "usermoney")
                            user.setObject(phone, forKey: "phone")
                            
                            self.performSegueWithIdentifier("registerToMain", sender: nil)
                        }else{
                            AlertView.showMsg(result["message"] as! String, parentView: self.view)
                        }
                    },
                    failure: { (op:AFHTTPRequestOperation!, error:NSError!) -> Void in
                        NSLog("注册请求失败：%@", error)
                        loading.stopLoading()
                        AlertView.showMsg("注册失败", parentView: self.view)
                    }
                )

                
            })
        }
        reach.startNotifier()
    }
    @IBAction func returnKey(sender:AnyObject){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
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
        userNameTextField.resignFirstResponder()
        surePwdTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        phoneTextField.resignFirstResponder()
        codeTextField.resignFirstResponder()
    }
}