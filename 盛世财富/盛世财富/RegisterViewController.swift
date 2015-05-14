//
//  TransRecordViewController.swift
//  盛世财富
//
//  Created by zengchang on 15-3-17.
//  Copyright (c) 2015年 sscf88. All rights reserved.
//

import Foundation
import UIKit

class RegisterViewController: UIViewController,UITextFieldDelegate {
    
    
    @IBOutlet weak var surePwdTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var regist: UIButton!
    @IBOutlet weak var checkBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        surePwdTextField.delegate = self
        passwordTextField.delegate = self
        phoneTextField.delegate = self
        regist.layer.cornerRadius = 5
        checkBtn.layer.cornerRadius = 5
        self.navigationItem.title = "用户注册"
    }
    
    @IBAction func checkTapped(sender: UIButton) {
        //验证码
    }
    @IBAction func registerTapped(sender: AnyObject) {
        loading.startLoading(self.view)
        surePwdTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        phoneTextField.resignFirstResponder()
        
        var surePwd = surePwdTextField.text
        var password = passwordTextField.text
        var phone = phoneTextField.text
        if phone.isEmpty {
            AlertView.showMsg("手机号码不能为空", parentView: self.view)
        }else if password.isEmpty {
            AlertView.showMsg("密码不能为空", parentView: self.view)
        }else if password != surePwd{
            AlertView.showMsg("两次输入的密码不一致", parentView: self.view)
        }else{
            //此处执行注册操作
//            showAlert("执行注册操作")
//            self.navigationController?.pushViewController(LendViewController(), animated: true)
        }
        loading.stopLoading()
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
        UIView.beginAnimations("ResizeForKeyboard", context: nil)
        UIView.setAnimationDuration(0.3)
        var rect:CGRect = CGRectMake( 0,  0,  self.view.frame.size.width,  self.view.frame.size.height)
        self.view.frame = rect;
        UIView.commitAnimations()
        
        surePwdTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        phoneTextField.resignFirstResponder()
        return true
    }
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        surePwdTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        phoneTextField.resignFirstResponder()
    }
}