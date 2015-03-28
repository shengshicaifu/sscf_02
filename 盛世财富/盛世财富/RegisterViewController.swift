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
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var surePwdTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    var keyboardShown:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextField.delegate = self
        surePwdTextField.delegate = self
        passwordTextField.delegate = self
        phoneTextField.delegate = self
    }
    
    @IBAction func registerTapped(sender: AnyObject) {
        var username = usernameTextField.text
        var surePwd = surePwdTextField.text
        var password = passwordTextField.text
        var phone = phoneTextField.text
        if phone.isEmpty {
            showAlert("手机号码不能为空")
        }else if password.isEmpty {
            showAlert("密码不能为空")
        }else if password != surePwd{
            showAlert("两次输入的密码不一致")
        }else if username.isEmpty{
            showAlert("用户名不能为空")
        }else{
            //此处执行注册操作
            showAlert("执行注册操作")
        }
    }
    
    func showAlert(message:String){
        var alert = UIAlertController(title: "提示", message: message, preferredStyle:UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        var frame:CGRect = textField.frame;
        var offset:CGFloat  = frame.origin.y + frame.size.height - (self.view.frame.size.height - 216.0);//键盘高度216
        
        UIView.beginAnimations("ResizeForKeyboard", context: nil)
        UIView.setAnimationDuration(0.3)
        
        //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
        if(offset > 0){
            //-offset
            self.view.frame = CGRectMake( 0,  -offset-280,  self.view.frame.size.width,  self.view.frame.size.height)
        }
        
        UIView.commitAnimations()
        
//        var defaultCenter:NSNotificationCenter = NSNotificationCenter()
//        
//        defaultCenter.addObserver(self, selector: Selector("keyboardWasHidden:"), name: UIKeyboardDidShowNotification, object: nil)
//        
//        defaultCenter.addObserver(self, selector: Selector("keyboardWasShown"), name: UIKeyboardDidShowNotification, object: nil)
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        self.view.frame = CGRectMake( 0,  0,  self.view.frame.size.width,  self.view.frame.size.height)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func keyboardWasShown(aNSNotification:NSNotification){
        println("keyboardWasShown")
        if keyboardShown {
            return
        }
        
        var info:NSDictionary = aNSNotification.userInfo!
        var value:NSValue = info.objectForKey(UIKeyboardAnimationCurveUserInfoKey!) as NSValue
        var keyboardSize:CGSize = value.CGRectValue().size
        
        var viewFrame:CGRect = scrollView.frame
        viewFrame.size.height -= keyboardSize.height
        scrollView.frame = viewFrame
        
        var textFieldRect:CGRect = usernameTextField.frame
        scrollView.scrollRectToVisible(textFieldRect, animated: true)
        
        keyboardShown = true
    }
    
    func keyboardWasHidden(aNSNotification:NSNotification){
        println("keyboardWasHidden")
        var info:NSDictionary = aNSNotification.userInfo!
        var value:NSValue = info.objectForKey(UIKeyboardAnimationCurveUserInfoKey!) as NSValue
        var keyboardSize:CGSize = value.CGRectValue().size
        
        var viewFrame:CGRect = scrollView.frame
        viewFrame.size.height += keyboardSize.height
        scrollView.frame = viewFrame
        
        var textFieldRect:CGRect = usernameTextField.frame
        scrollView.scrollRectToVisible(textFieldRect, animated: true)
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
//        usernameTextField.resignFirstResponder()
        UIView.beginAnimations("ResizeForKeyboard", context: nil)
        UIView.setAnimationDuration(0.3)
        var rect:CGRect = CGRectMake( 0,  0,  self.view.frame.size.width,  self.view.frame.size.height)
        self.view.frame = rect;
        UIView.commitAnimations()
        usernameTextField.resignFirstResponder()
        surePwdTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        phoneTextField.resignFirstResponder()
        return true
    }
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        usernameTextField.resignFirstResponder()
        surePwdTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        phoneTextField.resignFirstResponder()
    }

}