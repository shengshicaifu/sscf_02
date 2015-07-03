//
//  TransRecordViewController.swift
//  盛世财富
//  登录
//  Created by zengchang on 15-3-17.
//  Copyright (c) 2015年 sscf88. All rights reserved.
//

import Foundation
import UIKit
/**
*  登录
*/
class LoginViewController: UIViewController,UITextFieldDelegate {
    @IBOutlet weak var usernameLabel: UITextField!
    @IBOutlet weak var passwordLabel: UITextField!
    @IBOutlet weak var login: UIButton!
    @IBOutlet weak var regist: UIButton!
    var maxlength = 12
    var tabTag:Int?//用于记录是从那个tab点击跳转到登录页面，登录后需要返回到这个页面，102是消息页面，105是我的账号页面

    override func viewDidLoad() {
        super.viewDidLoad()
        usernameLabel.delegate = self
        passwordLabel.delegate = self
        
        Common.customerButton(login)
        Common.customerButton(regist)
        Common.addBorder(usernameLabel)
        Common.addBorder(passwordLabel)
        Common.addLeftImage(usernameLabel, imageName: "人.png")
        Common.addLeftImage(passwordLabel, imageName: "密码.png")
        
        usernameLabel.text = NSUserDefaults.standardUserDefaults().stringForKey("username")
        
    }
    
    
    @IBAction func loginTapped(sender: AnyObject) {
        self.loginAction()
    }

    func loginAction(){
        resignAll()
        var name = usernameLabel.text
        var pwd = passwordLabel.text
        if name.isEmpty {
            AlertView.showMsg("请填写用户名", parentView: self.view)
            return
        }
        if !Common.isTelephone(name) && !Common.isUserName(name) {
            AlertView.showMsg("用户名只能是手机号或6到20位的英文字母和数字", parentView: self.view)
            return
        }
        
        if pwd.isEmpty {
            AlertView.showMsg("请填写密码", parentView: self.view)
            return
        }
        if !Common.isPassword(pwd) {
            AlertView.showMsg(Common.passwordErrorTip, parentView: self.view)
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
                loading.startLoading(self.view)
                var manager = AFHTTPRequestOperationManager()
                var url = Common.serverHost + "/App-Login"
                var token = NSUserDefaults.standardUserDefaults().objectForKey("token") as? String
                var params = ["userName":self.usernameLabel.text,"userPass":self.passwordLabel.text,"userFlag":0]
                manager.responseSerializer.acceptableContentTypes = NSSet(array: ["text/html"]) as Set<NSObject>
                manager.POST(url, parameters: params,
                    success: { (op:AFHTTPRequestOperation!, data:AnyObject!) -> Void in
                        var result = data as! NSDictionary
                        //NSLog("个人信息：%@", result)
                        let code = result["code"] as? Int
                        if(code == 200){
                            let user = NSUserDefaults.standardUserDefaults()
                            let proInfo:NSDictionary = result["data"]?["proInfo"] as! NSDictionary
                            
                            user.setObject(self.usernameLabel.text, forKey: "username")
                            user.setObject(result["data"]?["token"], forKey: "token")
                            
                            user.setObject(proInfo.objectForKey("total_all"),forKey: "usermoney")
                            user.setObject(proInfo.objectForKey("account_money"), forKey: "accountMoney")
                            
                            var userInfo = result["data"]?["userInfo"] as! NSDictionary
                            if let birthday = userInfo.objectForKey("birthday") as? String {
                                user.setObject(birthday, forKey: "birthday")
                            }else{
                                user.setObject("", forKey: "birthday")
                                
                            }
                            if let gender = userInfo.objectForKey("gender") as? String {
                                user.setObject(gender, forKey: "gender")
                            }else{
                                user.setObject("", forKey: "gender")
                                
                            }
                            if let headpic = userInfo.objectForKey("headpic") as? String {
                                user.setObject(headpic, forKey: "headpic")
                            }else{
                                user.setObject("", forKey: "headpic")
                                
                            }
                            
                            user.setObject(userInfo["pinPass"], forKey: "pinpass")
                            user.setObject(userInfo["cellphone"], forKey: "phone")
                            
                            //保存身份证及身份证验证信息
                            user.setObject(userInfo["idCard"]?["isVerify"], forKey: "isVerify")
                            if let isUpload = userInfo["idCard"]?["isUpload"] as? String{
                                user.setObject(isUpload, forKey: "isUpload")
                            }else{
                                user.setObject("", forKey: "isUpload")
                            }
                            
                            //                            //银行卡绑定信息
                            if let bank = userInfo["bank"] as? NSDictionary {
                                user.setObject(bank["bank_num"], forKey:"bankCardNo")
                                user.setObject(bank["bank_city"], forKey:"bankCity")
                                user.setObject(bank["bank_name"], forKey:"bankName")
                                user.setObject(bank["bank_province"], forKey:"bankProvince")
                                user.setObject(bank["bank_address"], forKey:"bankBranch")
                            }else{
                                user.setObject("", forKey:"bankCardNo")
                                user.setObject("", forKey:"bankCity")
                                user.setObject("", forKey:"bankName")
                                user.setObject("", forKey:"bankProvince")
                                user.setObject("", forKey:"bankBranch")
                            }
                            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                            self.dismiss()
                        }else if(code == 0){
                            loading.stopLoading()
                            AlertView.alert("提示", message: result["message"] as! String, buttonTitle: "确定", viewController: self)
                        }
                    },failure: { (op:AFHTTPRequestOperation!, error:NSError!) -> Void in
                        loading.stopLoading()
                        AlertView.alert("提示", message:"服务器异常，请稍候再试", buttonTitle: "确定", viewController: self)
                    }
                )
                
            })
        }
        reach.startNotifier()

    }
    
    @IBAction func returnKey(sender: AnyObject) {
        dismiss()
    }
    
    //关闭当前页面
    func dismiss(){
        self.dismissViewControllerAnimated(true, completion: nil)
        
        //NSLog("登录窗的父窗体是%@", self.presentingViewController!)
        if self.presentingViewController is UITabBarController {
            var tabbarController = self.presentingViewController as! UITabBarController
          //  NSLog("当前选择的标签是%i", tabbarController.selectedIndex)
            if self.tabTag != nil {
                if Common.isLogin() {
                    if self.tabTag == 102 {
                        tabbarController.selectedIndex = 1
                    }else if self.tabTag == 105 {
                        tabbarController.selectedIndex = 4
                    }else if self.tabTag == 103 {
                        tabbarController.selectedIndex = 2
                    }
                }else{
                    tabbarController.selectedIndex = 0
                }
            }
        }
    }
    

    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        resignAll()
    }


    func textFieldShouldReturn(textField: UITextField) -> Bool {
        resignAll()
        if textField == usernameLabel {
            passwordLabel.becomeFirstResponder()
        }else if textField == passwordLabel {
            self.loginAction()
        }
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if range.location > 19 {
            return false
        }
        return true
    }
    
    func resignAll(){
        usernameLabel.resignFirstResponder()
        passwordLabel.resignFirstResponder()
    }
}