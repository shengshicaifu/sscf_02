//
//  ModifyLoginPasswordViewController.swift
//  盛世财富
//  修改登录密码
//  Created by 云笺 on 15/5/16.
//  Copyright (c) 2015年 sscf88. All rights reserved.
//

import UIKit

class ModifyLoginPasswordViewController: UIViewController {

    
    @IBOutlet weak var oldPassTextField: UITextField!
    
    @IBOutlet weak var newPassTextField: UITextField!
    
    @IBOutlet weak var confirmPassTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func modifyTapped(sender: UIButton) {
        var oldpass = oldPassTextField.text
        var newpass = newPassTextField.text
        var confirmpass = confirmPassTextField.text
        if oldpass.isEmpty {
            AlertView.showMsg("请输入原密码", parentView: self.view)
            return
        }
        if newpass.isEmpty {
            AlertView.showMsg("请输入新密码", parentView: self.view)
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
        var manager = AFHTTPRequestOperationManager()
        var url = Constant.getServerHost() + "/App-Ucenter-setPassWord"
        var token = NSUserDefaults.standardUserDefaults().objectForKey("token") as? String
        var params = ["oldpass":oldpass,"newpass":newpass,"to":token]
        manager.POST(url, parameters: params,
            success: { (op:AFHTTPRequestOperation!, data:AnyObject!) -> Void in
                var result = data as! NSDictionary
                var code = result["code"] as! Int
                if code == -1 {
                   AlertView.showMsg("请登录后再试", parentView: self.view)
                }else if code == 0 {
                   AlertView.showMsg("修改密码失败，请稍候再试", parentView: self.view)
                }else if code == 200 {
                    NSLog("修改登录密码成功")
                    self.navigationController?.popViewControllerAnimated(true)
                }
                
            },failure: { (op:AFHTTPRequestOperation!, error:NSError!) -> Void in
                AlertView.alert("提示", message: "网络连接有问题，请检查手机网络", buttonTitle: "确定", viewController: self)
            }
        )
        
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
        
        oldPassTextField.resignFirstResponder()
        newPassTextField.resignFirstResponder()
        confirmPassTextField.resignFirstResponder()

        return true
    }
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        oldPassTextField.resignFirstResponder()
        newPassTextField.resignFirstResponder()
        confirmPassTextField.resignFirstResponder()
       
    }
}
