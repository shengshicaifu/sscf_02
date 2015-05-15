//
//  TransRecordViewController.swift
//  盛世财富
//
//  Created by zengchang on 15-3-17.
//  Copyright (c) 2015年 sscf88. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: UIViewController,UITextFieldDelegate,HttpProtocol {
    @IBOutlet weak var login: UIButton!
    @IBOutlet weak var regist: UIButton!
    var timeLineUrl = "http://www.sscf88.com/App-Login"//链接地址
    var tmpListData: NSMutableArray = NSMutableArray()//临时数据  下拉添加
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
    
    @IBOutlet weak var usernameLabel: UITextField!
    @IBOutlet weak var passwordLabel: UITextField!
    @IBAction func loginTapped(sender: AnyObject) {
//        self.count++
        usernameLabel.resignFirstResponder()
        passwordLabel.resignFirstResponder()
        //http://www.sscf88.com/App-Login
        loading.startLoading(self.view)
        if let name:NSString = usernameLabel.text{
            
            if let pwd:NSString = passwordLabel.text{
                
                eHttp.post(timeLineUrl, params: ["userName":usernameLabel.text,"userPass":passwordLabel.text,"userFlag":0] ,view: self.view ) { (result:NSDictionary)->Void in
                    if let code = result["code"] as? Int{
                        
//                        println(result)
                        if(code == 200){
                            print(result)
                            let user = NSUserDefaults.standardUserDefaults()
                            let proInfo:NSDictionary = result["data"]?["proInfo"] as! NSDictionary
                            user.setObject(self.usernameLabel.text, forKey: "username")
                            user.setObject(result["data"]?["token"], forKey: "token")
                            user.setObject(result["data"]?["userPic"], forKey: "userpic")
                            user.setObject(proInfo.objectForKey("total_all"),forKey: "usermoney")
                            
                            
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
            }else{
                AlertView.showMsg("请填写密码！", parentView: self.view)
                
            }
        }else{
            AlertView.showMsg("请填写用户名！", parentView: self.view)
        }
        loading.stopLoading()
    }
    //读取json并解析
    func didRecieveResult(result: NSDictionary){
//        if(result["data"]?.valueForKey("list") != nil){
//            self.tmpListData = result["data"]?.valueForKey("list") as NSMutableArray //list数据
//            //            self.page = result["data"]?["page"] as Int
////            self.mainTable.reloadData()
//        }

       
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