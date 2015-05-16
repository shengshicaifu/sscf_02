//
//  IdeaViewController.swift
//  盛世财富
//
//  Created by xiao on 15-3-24.
//  Copyright (c) 2015年 sscf88. All rights reserved.
//



import UIKit

class IdeaViewController: UIViewController ,UITextViewDelegate,UITextFieldDelegate{

    @IBOutlet weak var content: UITextView!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var submit: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        content.delegate = self
        phone.delegate = self
        content.layer.borderWidth = 1
        content.layer.borderColor = UIColor.blackColor().CGColor
        submit.layer.cornerRadius = 5
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func submitIdea(sender: UIButton) {
        AlertView.alert("提示", message: "感谢您的反馈！", buttonTitle: "确定", viewController: self)
    }
    func textViewShouldBeginEditing(textView: UITextView) -> Bool{
        if content.text == "请输入您的意见" {
            content.text = ""
            content.textColor = UIColor.blackColor()
        }
        return true
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if phone.text == "请输入您的联系方式"{
            phone.text = ""
            phone.textColor = UIColor.blackColor()
        }
        return true
    }
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        content.resignFirstResponder()
        phone.resignFirstResponder()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        content.resignFirstResponder()
        phone.resignFirstResponder()
        return true
    }
}

