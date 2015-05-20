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
    var timeLineUrl = Constant.getServerHost() + "/App-Login"//链接地址
//    var tmpListData: NSMutableArray = NSMutableArray()//临时数据  下拉添加
    var eHttp: HttpController = HttpController()//新建一个httpController
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
        
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    @IBAction func loginTapped(sender: AnyObject) {
//        self.count++
        usernameLabel.resignFirstResponder()
        passwordLabel.resignFirstResponder()
        var name = usernameLabel.text
        var pwd = passwordLabel.text
        if name.isEmpty {
            AlertView.showMsg("请填写用户名！", parentView: self.view)
            return
        }
        if pwd.isEmpty {
            AlertView.showMsg("请填写密码！", parentView: self.view)
            return
        }
        
        loading.startLoading(self.view)
                
        eHttp.post(timeLineUrl, params: ["userName":usernameLabel.text,"userPass":passwordLabel.text,"userFlag":0] ,view: self.view ) { (result:NSDictionary)->Void in
            loading.stopLoading()
            NSLog("%@登录返回结果%@", self.usernameLabel.text,result)
            
                if let code = result["code"] as? Int{
                    
                    
                    if(code == 200){
                        let user = NSUserDefaults.standardUserDefaults()
                        let proInfo:NSDictionary = result["data"]?["proInfo"] as! NSDictionary
                        user.setObject(self.usernameLabel.text, forKey: "username")
                        user.setObject(result["data"]?["token"], forKey: "token")
                        
                        user.setObject(proInfo.objectForKey("total_all"),forKey: "usermoney")
                        
                        var userInfo = result["data"]?["userInfo"] as! NSDictionary
                        user.setObject(userInfo["pinPass"], forKey: "pinpass")
                        user.setObject(userInfo["birthday"], forKey: "birthday")
                        user.setObject(userInfo["gender"], forKey: "gender")
                        user.setObject(userInfo["headpic"], forKey: "userpic")
                        
                        self.dismissViewControllerAnimated(true, completion: nil)
                    }
                    if(code == 0){
                        //报错弹窗
                        AlertView.showMsg(result["message"] as! String, parentView: self.view)
                    }
                }else{
                    AlertView.showMsg("服务器异常!", parentView: self.view)
                }
            }
        
    
        
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
        usernameLabel.resignFirstResponder()
        passwordLabel.resignFirstResponder()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        usernameLabel.resignFirstResponder()
        passwordLabel.resignFirstResponder()
        return true
    }
}