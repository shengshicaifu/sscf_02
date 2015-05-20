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
    
    
    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var surePwdTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var regist: UIButton!
    @IBOutlet weak var checkBtn: UIButton!
    var timer:NSTimer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        surePwdTextField.delegate = self
        passwordTextField.delegate = self
        phoneTextField.delegate = self
        regist.layer.cornerRadius = 5
        checkBtn.layer.cornerRadius = 5
        
        self.navigationItem.title = "用户注册"
        
        surePwdTextField.leftView = UIImageView(image: UIImage(named: "密码.png"))
        surePwdTextField.leftViewMode = UITextFieldViewMode.Always
        
        passwordTextField.leftView = UIImageView(image: UIImage(named: "密码.png"))
        passwordTextField.leftViewMode = UITextFieldViewMode.Always
        
        phoneTextField.leftView = UIImageView(image: UIImage(named: "电话.png"))
        phoneTextField.leftViewMode = UITextFieldViewMode.Always
        
        codeTextField.leftView = UIImageView(image: UIImage(named: "齿轮.png"))
        codeTextField.leftViewMode = UITextFieldViewMode.Always
    }
    
    //发送验证码
    @IBAction func checkTapped(sender: UIButton) {
        var phone = phoneTextField.text
        
        if phone.isEmpty {
            AlertView.showMsg("手机号码不能为空", parentView: self.view)
            return
        }
        
        
        
        //禁用获取验证码按钮60秒
        checkBtn.enabled = false
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "repeat", userInfo: nil, repeats: true)
        
        //获取验证码
        var url = Constant.getServerHost() + "/App-Register-sendphone"
        var params = ["cellphone":phone]
        var manager = AFHTTPRequestOperationManager()
        loading.startLoading(self.view)
        manager.POST(url, parameters: params,
            success: { (op:AFHTTPRequestOperation!, data:AnyObject!) -> Void in
                loading.stopLoading()
                
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
                }
                AlertView.showMsg(msg, parentView: self.view)
            },
            failure:{ (op:AFHTTPRequestOperation!, error:NSError!) -> Void in
                loading.stopLoading()
                AlertView.alert("提示", message: "服务器错误", buttonTitle: "确定", viewController: self)
            }
        )
    }
    
    var i = 60
    func repeat(){
        checkBtn.setTitle("\(i)", forState: UIControlState.Disabled)
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
        
        surePwdTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        phoneTextField.resignFirstResponder()
        codeTextField.resignFirstResponder()
        var surePwd = surePwdTextField.text
        var password = passwordTextField.text
        var phone = phoneTextField.text
        var code = codeTextField.text
        if phone.isEmpty {
            AlertView.showMsg("手机号码不能为空", parentView: self.view)
        }else if password.isEmpty {
            AlertView.showMsg("密码不能为空", parentView: self.view)
        }else if password != surePwd{
            AlertView.showMsg("两次输入的密码不一致", parentView: self.view)
        }else if code.isEmpty{
            AlertView.showMsg("验证码不能为空", parentView: self.view)
        }else{
            //此处执行注册操作
            loading.startLoading(self.view)
            var url = Constant.getServerHost() + "/App-Register-regaction"
            var params = ["user_name":phone,"pass_word":password,"code":code]
            var manager = AFHTTPRequestOperationManager()
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
                        user.setObject(result["data"]?["userName"], forKey: "username")
                        user.setObject(result["data"]?["token"], forKey: "token")
                        user.setObject(result["data"]?["userPic"], forKey: "userpic")
                        user.setObject(proInfo.objectForKey("total_all"),forKey: "usermoney")
                        self.performSegueWithIdentifier("registerToMain", sender: nil)
                    }
                },
                failure: { (op:AFHTTPRequestOperation!, error:NSError!) -> Void in
                    NSLog("注册请求失败：%@", error)
                    loading.stopLoading()
                    AlertView.showMsg("注册失败", parentView: self.view)
                }
            )
        }
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

        surePwdTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        phoneTextField.resignFirstResponder()
        codeTextField.resignFirstResponder()
        return true
    }
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        surePwdTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        phoneTextField.resignFirstResponder()
        codeTextField.resignFirstResponder()
    }
}