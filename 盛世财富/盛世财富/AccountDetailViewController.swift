//
//  TransRecordViewController.swift
//  盛世财富
//
//  Created by zengchang on 15-3-17.
//  Copyright (c) 2015年 sscf88. All rights reserved.
//

import Foundation
import UIKit

//账户信息
class AccountDetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    var imageView:UIImageView!
    var nickLabel:UILabel!
    var genderLabel:UILabel!
    var birthdayLabel:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.navigationItem.title = "账户信息"
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func returnTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if section == 0 {
            return 1
        }else if section == 1 {
            return 3
        }else {
            return 1
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = self.tableView.dequeueReusableCellWithIdentifier("firstCell") as UITableViewCell
        
        if indexPath.section == 0 {
            if indexPath.row == 0{
                //init(x: Int, y: Int, width: Int, height: Int)
                var moneyLabel = UILabel(frame: CGRect(x: 10, y: 10, width: 100, height: 20))
                moneyLabel.text = "头像"
                imageView = UIImageView(frame: CGRect(x: 130, y: 10, width: 50, height: 50))
                imageView.image = UIImage(named: "aaa.jpg")
                
                cell.addSubview(moneyLabel)
                cell.addSubview(imageView)
            }
        }else if indexPath.section == 1{
            if indexPath.row == 0{
                var moneyLabel = UILabel(frame: CGRect(x: 10, y: 10, width: 100, height: 20))
                moneyLabel.text = "昵称"
                nickLabel = UILabel(frame: CGRect(x: 130, y: 10, width: 150, height: 20))
                nickLabel.text = "那一抹轻"
                cell.addSubview(moneyLabel)
                cell.addSubview(nickLabel)
            }else if indexPath.row == 1{
                var moneyLabel = UILabel(frame: CGRect(x: 10, y: 10, width: 100, height: 20))
                moneyLabel.text = "性别"
                genderLabel = UILabel(frame: CGRect(x: 130, y: 10, width: 50, height: 20))
                genderLabel.text = "男"
                cell.addSubview(moneyLabel)
                cell.addSubview(genderLabel)
            }else if indexPath.row == 2 {
                var moneyLabel = UILabel(frame: CGRect(x: 10, y: 10, width: 100, height: 20))
                moneyLabel.text = "出生日期"
                birthdayLabel = UILabel(frame: CGRect(x: 130, y: 10, width: 150, height: 20))
                birthdayLabel.text = "1993年09月23日"
                cell.addSubview(moneyLabel)
                cell.addSubview(birthdayLabel)
            }
        }else {
            var existButton:UIButton = UIButton(frame: CGRect(x: 50, y: 20, width: 300, height: 50))
            existButton.setTitle("退出登录", forState: UIControlState.Normal)
            existButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            cell.addSubview(existButton)
            existButton.addTarget(self, action: "existAppTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        }
        
        return cell
    }
    
    func existAppTapped(sender:AnyObject){
        var message:String = "退出后将无法投资，若担心账户安全，建议手动设置手势，是否确定退出"
        var alert:UIAlertController = UIAlertController(title: "提示", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.Default, handler: cancelClick))
        //handler:类型为(action:UIAlertAction!) -> Void
//        UIAlertAction(title: <#String#>, style: UIAlertActionStyle, handler: <#((UIAlertAction!) -> Void)!##(UIAlertAction!) -> Void#>)
        alert.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.Default, handler: sureClick))
        
        self.presentViewController(alert, animated: true, completion: nil)
//        var alert:UIAlertView = UIAlertView(title: "提示", message: message, delegate: nil, cancelButtonTitle: "取消")
//        alert.addButtonWithTitle("确定")
//        alert.show()
    }
    
    func cancelClick(action:UIAlertAction!) -> Void {
        println("您点击了取消")
    }
    func sureClick(action:UIAlertAction!) -> Void {
        //用户退出登录，注销用户信息
        
        
        //跳转页面
        var mainView:LoginViewController = self.storyboard?.instantiateViewControllerWithIdentifier("loginViewController") as LoginViewController
        //???此处跳转到主页面会出现nav和bar没有的情况
//        self.presentViewController(mainView, animated: true,completion: nil)
        //该方法是在右navigation的情况下使用的
        self.navigationController?.pushViewController(mainView, animated: true)
//        self.navigationController?.popToViewController(mainView, animated: true)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                return 70
            }
        }else if indexPath.section == 2{
            if indexPath.row == 0 {
                return 170
            }
        }
        
        return 50
    }
    
    //设置点击cell的事件
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        if indexPath.section == 0{
            var upc = UIImagePickerController()
            //访问图片库
            upc.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            upc.delegate = self
            
            self.presentViewController(upc, animated: true, completion: nil)
        }
    }
    
    //重写方法，使之能访问图库
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        imageView.image = image
        println(image.size.height)
        //此处可以将图片资源保存到数据库中
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
}