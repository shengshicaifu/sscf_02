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
    var keyboardShown:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        surePwdTextField.delegate = self
        passwordTextField.delegate = self
        phoneTextField.delegate = self
        regist.layer.cornerRadius = 5
        self.navigationItem.title = "用户注册"
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
//    func showAlert(message:String){
//        var alert = UIAlertController(title: "提示", message: message, preferredStyle:UIAlertControllerStyle.Alert)
//        alert.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.Default, handler: nil))
//        self.presentViewController(alert, animated: true, completion: nil)
//    }
    
//    func textFieldDidBeginEditing(textField: UITextField) {
//        if textField.tag == 1 {
//            moveView(-100)
//        }else if textField.tag == 2 {
//            moveView(-50)
//        }
//    }
//    
//    func textFieldDidEndEditing(textField: UITextField) {
//        if textField.tag == 1 {
//            moveView(100)
//        }else if textField.tag == 2 {
//            moveView(50)
//        }
//    }
//    
//    //控制视图上下移动
//    func moveView(move:CGFloat){
//        var animationDuration:NSTimeInterval = 0.30;
//        var frame:CGRect  = self.view.frame;
//        frame.origin.y += move;//view的y轴上移
//        self.view.frame = frame;
//        UIView.beginAnimations("ResizeView", context: nil)
//        UIView.setAnimationDuration(animationDuration)
//        self.view.frame = frame;
//        UIView.commitAnimations()
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
//    func keyboardWasShown(aNSNotification:NSNotification){
//        println("keyboardWasShown")
//        if keyboardShown {
//            return
//        }
//        
//        var info:NSDictionary = aNSNotification.userInfo!
//        var value:NSValue = info.objectForKey(UIKeyboardAnimationCurveUserInfoKey) as! NSValue
//        var keyboardSize:CGSize = value.CGRectValue().size
//        
//        
//        
//        keyboardShown = true
//    }
//    
//    func keyboardWasHidden(aNSNotification:NSNotification){
//        println("keyboardWasHidden")
//        var info:NSDictionary = aNSNotification.userInfo!
//        var value:NSValue = info.objectForKey(UIKeyboardAnimationCurveUserInfoKey) as! NSValue
//        var keyboardSize:CGSize = value.CGRectValue().size
//        
//        
//    }
    
    
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