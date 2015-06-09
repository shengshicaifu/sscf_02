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
    @IBOutlet weak var styleView: UIView!
    var tabTag:Int?//用于记录是从那个tab点击跳转到登录页面，登录后需要返回到这个页面，102是消息页面，105是我的账号页面
//    var timeLineUrl = Common.serverHost + "/App-Login"//链接地址

//    var eHttp: HttpController = HttpController()//新建一个httpController
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameLabel.delegate = self
        passwordLabel.delegate = self
        
        styleView.layer.borderWidth = 1.0
        styleView.layer.borderColor = UIColor(red: 225/255.0, green: 225/255.0, blue: 225/255.0, alpha: 1.0).CGColor
        var bottomBorder = CALayer()
        bottomBorder.frame = CGRectMake(0.0, usernameLabel.frame.height - 1, usernameLabel.frame.width, 0.5)
        bottomBorder.backgroundColor = UIColor(red: 225/255.0, green: 225/255.0, blue: 225/255.0, alpha: 1.0).CGColor
        usernameLabel.layer.addSublayer(bottomBorder)
       
        //设置登录按钮和注册按钮的样式
        login.setBackgroundImage(UIImage(named: "background"), forState: UIControlState.Normal)
        login.adjustsImageWhenDisabled = true
        login.layer.cornerRadius = 10
        login.layer.masksToBounds = true
        regist.setBackgroundImage(UIImage(named: "ebg"), forState: UIControlState.Normal)
        regist.adjustsImageWhenDisabled = true
        regist.layer.cornerRadius = 10
        regist.layer.masksToBounds = true

        //设置登录输入框左侧图标
        usernameLabel.leftView = UIImageView(image: UIImage(named: "人.png"))
        usernameLabel.leftViewMode = UITextFieldViewMode.Always
        
        passwordLabel.leftView = UIImageView(image: UIImage(named: "密码.png"))
        passwordLabel.leftViewMode = UITextFieldViewMode.Always
        
        usernameLabel.text = NSUserDefaults.standardUserDefaults().stringForKey("username")
        
    }
    
    
    @IBAction func loginTapped(sender: AnyObject) {
//        self.count++
        resignAll()
        var name = usernameLabel.text
        var pwd = passwordLabel.text
        if name.isEmpty {
            AlertView.showMsg("请填写用户名！", parentView: self.view)
            return
        }
//        if !Common.isUserName(name) {
//            AlertView.showMsg(Common.userNameErrorTip, parentView: self.view)
//            return
//        }
        if pwd.isEmpty {
            AlertView.showMsg("请填写密码！", parentView: self.view)
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

                AlertView.alert("提示", message: "网络连接有问题，请检查手机网络", buttonTitle: "确定", viewController: self)
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
                    loading.stopLoading()
                    var result = data as! NSDictionary
                    //NSLog("登录返回信息%@", result)
                    if let code = result["code"] as? Int{
                        
                        
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
                                user.setObject(bank["bank_province"], forKey:"bankProvice")
                                user.setObject(bank["bank_address"], forKey:"bankBranch")
                            }else{
                                user.setObject("", forKey:"bankCardNo")
                                user.setObject("", forKey:"bankCity")
                                user.setObject("", forKey:"bankName")
                                user.setObject("", forKey:"bankProvice")
                                user.setObject("", forKey:"bankBranch")
                            }
                            
                            //self.dismissViewControllerAnimated(true, completion: nil)
                            self.dismiss()
                        }
                        if(code == 0){
                            //报错弹窗
                            AlertView.showMsg(result["message"] as! String, parentView: self.view)
                        }
                    
                    }else{
                        AlertView.showMsg("服务器异常!", parentView: self.view)
                    }
                },failure: { (op:AFHTTPRequestOperation!, error:NSError!) -> Void in
                    loading.stopLoading()
                    AlertView.showMsg("服务器异常!", parentView: self.view)
                }
            )
                
                

                
            })
        }
        reach.startNotifier()
    }


    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //传递数据过去
        if segue.identifier == "loginIdentifier" {
            
        }
    }
    
    @IBAction func returnKey(sender: AnyObject) {
        dismiss()
    }
    
    //关闭当前页面
    func dismiss(){
        self.dismissViewControllerAnimated(true, completion: nil)
        
        NSLog("登录窗的父窗体是%@", self.presentingViewController!)
        if self.presentingViewController is UITabBarController {
            var tabbarController = self.presentingViewController as! UITabBarController
            NSLog("当前选择的标签是%i", tabbarController.selectedIndex)
            if self.tabTag != nil {
                if self.tabTag == 102 {
                    tabbarController.selectedIndex = 1
                }else if self.tabTag == 105 {
                    tabbarController.selectedIndex = 4
                }
            }
        }
    }
    

    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        resignAll()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        resignAll()
        return true
    }
    
    func resignAll(){
        usernameLabel.resignFirstResponder()
        passwordLabel.resignFirstResponder()
    }
}