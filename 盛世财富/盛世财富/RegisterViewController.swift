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
    var keyboardShown:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextField.delegate = self
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
        return true
    }
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        usernameTextField.resignFirstResponder()
    }

}