//
//  AccountInfoTableViewController.swift
//  盛世财富
//  账户信息
//  Created by 云笺 on 15/5/15.
//  Copyright (c) 2015年 sscf88. All rights reserved.
//

import UIKit

class AccountInfoTableViewController: UITableViewController,UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    
    @IBOutlet weak var headImage: UIImageView!
    
    @IBOutlet weak var PhoneLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var birthdayLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headImage.layer.cornerRadius = 35
        headImage.layer.masksToBounds = true
        
        var userDefaults = NSUserDefaults.standardUserDefaults()
        
        if let i:NSData = userDefaults.objectForKey("headImage") as? NSData {
            headImage.image = UIImage(data: i)
        }
        
        if let phone = userDefaults.objectForKey("username") as? String {
            PhoneLabel.text = phone
        }
        if let gender = userDefaults.objectForKey("gender") as? String {
            genderLabel.text = gender
        }
        println(userDefaults.objectForKey("birthday") as? String)
        if let birth = userDefaults.objectForKey("birthday") as? String {
            
            var formatter = NSDateFormatter()
            formatter.dateFormat = "yyyyMMdd"
            if let birthDate = formatter.dateFromString(birth) {
                formatter.dateFormat = "yyyy年MM月dd日"
                birthdayLabel.text = formatter.stringFromDate(birthDate)
            }
            
        } else {
            birthdayLabel.text = ""
        }
        
    }
    
    
    //退出登录
    @IBAction func loginOutAction(sender: UIButton) {
        //提示是否退出
        var alertController = UIAlertController(title: "提示", message: "退出后将无法投资，是否确定退出", preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.Default, handler: { (action:UIAlertAction!) -> Void in
            //删除用户信息
            var userDefaults = NSUserDefaults.standardUserDefaults()
            userDefaults.removeObjectForKey("username")
            userDefaults.removeObjectForKey("token")
            userDefaults.removeObjectForKey("userpic")
            userDefaults.removeObjectForKey("usermoney")
            userDefaults.removeObjectForKey("gender")
            userDefaults.removeObjectForKey("birthday")
            AlertView.showMsg("注销成功", parentView: self.view)
            self.presentViewController(self.storyboard?.instantiateViewControllerWithIdentifier("tabBarViewController") as! TabBarViewController, animated: true, completion: nil)
            
        }))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if UIDevice.currentDevice().model == "iPad" {
            AlertView.alert("提示", message: "iPad无法更换头像", buttonTitle: "确定", viewController: self)
            return
        }
        if indexPath.section == 0{
            var source = UIImagePickerControllerSourceType.Camera
            let controller = UIAlertController(title: "请选择相册或照相机", message: "", preferredStyle: UIAlertControllerStyle.ActionSheet)
            let actionPhoto = UIAlertAction(title: "相册", style: UIAlertActionStyle.Default, handler: { (paramAction:UIAlertAction!) -> Void in
                source = UIImagePickerControllerSourceType.PhotoLibrary
                var picker = UIImagePickerController()
                picker.allowsEditing = true//设置可编辑
                picker.delegate = self
                picker.sourceType = source
                self.presentViewController(picker, animated: true, completion: nil)
            })
            let actionCamera = UIAlertAction(title: "拍照", style: UIAlertActionStyle.Destructive, handler: { (paramAction:UIAlertAction!) -> Void in
                if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera){
                    source = UIImagePickerControllerSourceType.PhotoLibrary
                    
                }
                var picker = UIImagePickerController()
                picker.allowsEditing = true//设置可编辑
                picker.delegate = self
                picker.sourceType = source
                self.presentViewController(picker, animated: true, completion: nil)
                
            })
            let actionCancel = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: { (paramAction:UIAlertAction!) -> Void in
                self.dismissViewControllerAnimated(true, completion:nil)
            })
            controller.addAction(actionPhoto)
            controller.addAction(actionCamera)
            controller.addAction(actionCancel)
            
            self.presentViewController(controller, animated: true, completion: nil)
        }
        
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
//        var imageview:UIImageView = UIImageView(frame: CGRectMake(0, 100, 320, 300))
        
        var user = NSUserDefaults.standardUserDefaults()
        user.setObject(UIImageJPEGRepresentation(image, 1.0), forKey: "headImage")
//        imageview.image = image
        headImage.image = image
        
        var token:String = user.objectForKey("token") as! String
        var afnet = AFHTTPRequestOperationManager()
        var url = Constant.getServerHost()+"/App-Ucenter-setUserInfo"
        var param = ["to":user.objectForKey("token") as! String,"gender":"","birthday":""]
        afnet.POST(url, parameters: param, constructingBodyWithBlock: { (formData:AFMultipartFormData!) -> Void in
            var fileName = "headpic.jpg"
            formData.appendPartWithFileData(UIImageJPEGRepresentation(image, 1.0), name: "headpic", fileName: fileName, mimeType: "image/jpeg")
            }, success: { (opration:AFHTTPRequestOperation!, data:AnyObject!) -> Void in
                AlertView.alert("提示", message: data["message"] as! String, buttonTitle: "确定", viewController: self)
            }) { (opration:AFHTTPRequestOperation!, error:NSError!) -> Void in
                AlertView.alert("错误", message: error.localizedDescription, buttonTitle: "确定", viewController: self)
        }
        
        
        
//        println(editingInfo);
        
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil);
    }
}
