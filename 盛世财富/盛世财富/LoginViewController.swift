//
//  TransRecordViewController.swift
//  盛世财富
//  登录
//  Created by zengchang on 15-3-17.
//  Copyright (c) 2015年 sscf88. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: UIViewController,UITextFieldDelegate {
    @IBOutlet weak var usernameLabel: UITextField!
    @IBOutlet weak var passwordLabel: UITextField!
    @IBOutlet weak var login: UIButton!
    @IBOutlet weak var regist: UIButton!
//    var timeLineUrl = Common.serverHost + "/App-Login"//链接地址

//    var eHttp: HttpController = HttpController()//新建一个httpController
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameLabel.delegate = self
        passwordLabel.delegate = self
        login.layer.cornerRadius = 5
        regist.layer.cornerRadius = 5
        regist.layer.borderColor = UIColor.grayColor().CGColor
        regist.layer.borderWidth = 1
        
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
        if !Common.isUserName(name) {
            AlertView.showMsg(Common.userNameErrorTip, parentView: self.view)
            return
        }
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
                    NSLog("登录返回信息%@", result)
                    if let code = result["code"] as? Int{
                        
                        
                        if(code == 200){
                            let user = NSUserDefaults.standardUserDefaults()
                            let proInfo:NSDictionary = result["data"]?["proInfo"] as! NSDictionary
                            user.setObject(self.usernameLabel.text, forKey: "username")
                            user.setObject(result["data"]?["token"], forKey: "token")
                            
                            user.setObject(proInfo.objectForKey("total_all"),forKey: "usermoney")
                            
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
                            user.setObject(userInfo["idCard"]?["isUpload"], forKey: "isUpload")
                            //银行卡绑定信息
                            user.setObject(userInfo["bank"]?["bank_num"], forKey:"bankCardNo")
                            user.setObject(userInfo["bank"]?["bank_city"], forKey:"bankCity")
                            user.setObject(userInfo["bank"]?["bank_name"], forKey:"bankName")
                            user.setObject(userInfo["bank"]?["bank_province"], forKey:"bankProvice")
                            user.setObject(userInfo["bank"]?["bank_address"], forKey:"bankBranch")
                            
                            self.dismissViewControllerAnimated(true, completion: nil)
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
        self.dismissViewControllerAnimated(true, completion: nil)
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