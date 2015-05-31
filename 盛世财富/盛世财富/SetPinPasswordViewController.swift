//
//  SetPinPasswordViewController.swift
//  盛世财富
//  设置交易密码
//  Created by 云笺 on 15/5/18.
//  Copyright (c) 2015年 sscf88. All rights reserved.
//

import UIKit

class SetPinPasswordViewController: UIViewController {

    @IBOutlet weak var pinPasswordTextField: UITextField!
    
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func modifyTapped(sender: UIButton) {
        resignAll()
        var pinpass = pinPasswordTextField.text
        var confirmpass = confirmPasswordTextField.text

        if pinpass.isEmpty {
            AlertView.showMsg("请输入交易密码", parentView: self.view)
            return
        }
        if !Common.isPassword(pinpass) {
            AlertView.showMsg(Common.passwordErrorTip, parentView: self.view)
            return
        }
        
        if confirmpass.isEmpty {
            AlertView.showMsg("请输入确认密码", parentView: self.view)
            return
        }
        if pinpass != confirmpass {
            AlertView.showMsg("两次密码不一致", parentView: self.view)
            return
        }
        //其他输入限制再加
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
                var manager = AFHTTPRequestOperationManager()
                var url = Common.serverHost + "/App-Ucenter-setFirstPin"
                var token = NSUserDefaults.standardUserDefaults().objectForKey("token") as? String
                var params = ["pin_pass":pinpass,"to":token]
                loading.startLoading(self.view)
                manager.responseSerializer.acceptableContentTypes = NSSet(array: ["text/html"]) as Set<NSObject>
                manager.POST(url, parameters: params,
                    success: { (op:AFHTTPRequestOperation!, data:AnyObject!) -> Void in
                        loading.stopLoading()
                        var result = data as! NSDictionary
                        //NSLog("设置交易密码：%@", result)
                        var code = result["code"] as! Int
                        if code == 0 {
                            NSLog("设置交易密码失败:%@", result["message"] as! String)
                            AlertView.showMsg("设置交易密码失败，请稍候再试", parentView: self.view)
                        }else if code == 200 {
                            //NSLog("设置交易密码成功")
                            //AlertView.showMsg("设置交易密码成功", parentView: self.view)
                            NSUserDefaults.standardUserDefaults().setObject(self.pinPasswordTextField.text, forKey: "pinpass")
                            AlertView.alert("提示", message: "设置交易密码成功", buttonTitle: "确定", viewController: self, callback: {
                                self.navigationController?.popViewControllerAnimated(true)
                            })
                           
                        }
                        
                    },failure: { (op:AFHTTPRequestOperation!, error:NSError!) -> Void in
                        loading.stopLoading()
                        AlertView.alert("提示", message: "网络连接有问题，请检查手机网络", buttonTitle: "确定", viewController: self)
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
    
    func resignAll(){
        pinPasswordTextField.resignFirstResponder()
        confirmPasswordTextField.resignFirstResponder()
    }
}
