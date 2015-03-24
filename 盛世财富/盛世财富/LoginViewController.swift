//
//  TransRecordViewController.swift
//  盛世财富
//
//  Created by zengchang on 15-3-17.
//  Copyright (c) 2015年 sscf88. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBOutlet weak var usernameLabel: UITextField!
    @IBOutlet weak var passwordLabel: UITextField!
    @IBAction func loginTapped(sender: AnyObject) {
        var manager = AFHTTPRequestOperationManager()
        var url = "http://192.168.1.25:8080/people/CheckLoginServlet"
        var params:NSDictionary! = ["username":usernameLabel.text,"password":passwordLabel.text]
        manager.POST(url, parameters: params,
            success:{
                (operation:
                AFHTTPRequestOperation!,
                responseObject: AnyObject!) in
                //打印json数据
                //println("responseObject: \(responseObject!) ")
                
                //解析json数据是List集合类型
                // var json:[AnyObject] = responseObject as [AnyObject]
                var json:NSDictionary = responseObject as NSDictionary
    
                var result:Bool = json["result"] as Bool
                if result {
                    self.performSegueWithIdentifier("loginIdentifier", sender: self)
                    println("enter...")
                }else{
                    //弹窗
                    var alert = UIAlertController(title: "提示", message: "您输入的密码或者账号有误！", preferredStyle:UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.Cancel, handler: nil))
                  self.presentViewController(alert, animated: true, completion: nil)
                }
            } ,
            failure:{
                (operation:AFHTTPRequestOperation!,error:NSError!) in
                //打印错误信息
                println("error:"+error.localizedDescription)
        } )
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //传递数据过去
        if segue.identifier == "loginIdentifier" {
            
        }
    }
}