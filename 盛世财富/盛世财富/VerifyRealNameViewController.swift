//
//  VerifyRealNameViewController.swift
//  盛世财富
//
//  Created by 云笺 on 15/5/27.
//  Copyright (c) 2015年 sscf88. All rights reserved.
//

import UIKit
/**
*  实名认证控制器
*/
class VerifyRealNameViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var realNameTextField: UITextField!
    @IBOutlet weak var idcardTextField: UITextField!
    @IBOutlet weak var cardFrontImageView: UIImageView!
    @IBOutlet weak var cardBackImageView: UIImageView!
    @IBOutlet weak var cardHandImageView: UIImageView!
    
    var cardFrontImage:UIImage?
    var cardBackImage:UIImage?
    var cardHandImage:UIImage?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //为图像添加点击事件
        cardFrontImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "cardFrontImagePick"))
        cardBackImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "cardBackImagePick"))
        cardHandImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "cardHandImagePick"))
        
        
    }
    
    //前身照
    func cardFrontImagePick(){
        imagePick("cardFront")
    }
    
    //背面照
    func cardBackImagePick(){
        imagePick("cardBack")
    }
    
    //手持照
    func cardHandImagePick(){
        imagePick("cardHand")
    }
    
    //访问相册或相机
    func imagePick(flag:String){
        
        //var source = UIImagePickerControllerSourceType.Camera
        let controller = UIAlertController(title: "请选择相册或照相机", message: "", preferredStyle: UIAlertControllerStyle.ActionSheet)
        let actionPhoto = UIAlertAction(title: "相册", style: UIAlertActionStyle.Default, handler: { (paramAction:UIAlertAction!) -> Void in
            var source = UIImagePickerControllerSourceType.PhotoLibrary
            var picker = UIImagePickerController()
            
            if flag == "cardFront" {
                picker.restorationIdentifier = "cardFront"
            } else if flag == "cardBack" {
                picker.restorationIdentifier = "cardBack"
            } else if flag == "cardHand" {
                picker.restorationIdentifier = "cardHand"
            }
            
            
            picker.allowsEditing = true//设置可编辑
            picker.delegate = self
            picker.sourceType = source
            self.presentViewController(picker, animated: true, completion: nil)
        })
        controller.addAction(actionPhoto)
        
        //判断设备是否支持相机功能
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            let actionCamera = UIAlertAction(title: "拍照", style: UIAlertActionStyle.Destructive, handler: { (paramAction:UIAlertAction!) -> Void in
                var source:UIImagePickerControllerSourceType = UIImagePickerControllerSourceType.Camera
                var picker = UIImagePickerController()
                if flag == "cardFront" {
                    picker.restorationIdentifier = "cardFront"
                } else if flag == "cardBack" {
                    picker.restorationIdentifier = "cardBack"
                } else if flag == "cardHand" {
                    picker.restorationIdentifier = "cardHand"
                }
                picker.allowsEditing = true//设置可编辑
                picker.delegate = self
                picker.sourceType = source
                self.presentViewController(picker, animated: true, completion: nil)
                
            })
            controller.addAction(actionCamera)
            
        }

        let actionCancel = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: { (paramAction:UIAlertAction!) -> Void in
            self.dismissViewControllerAnimated(true, completion:nil)
        })
        
        controller.addAction(actionCancel)
        
        self.presentViewController(controller, animated: true, completion: nil)
            
        
    }
    
    //选择了图像
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        //编辑后的图像
        let selectedImage:UIImage? = info[UIImagePickerControllerEditedImage] as? UIImage
        //原始图像
        let originalImage:UIImage? = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        if picker.restorationIdentifier! == "cardFront" {
            cardFrontImage = selectedImage
            cardFrontImageView.image = selectedImage
        } else if picker.restorationIdentifier! == "cardBack" {
            cardBackImage = selectedImage
            cardBackImageView.image = selectedImage
        } else if picker.restorationIdentifier! == "cardHand" {
            cardHandImage = selectedImage
            cardHandImageView.image = selectedImage
        }
        
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //取消选择图像
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }

    //提交
    @IBAction func okTapped(sender: UIButton) {
        resignAll()
        
        //输入验证
        var realName = realNameTextField.text
        if realName.isEmpty {
            AlertView.showMsg("请输入姓名", parentView: self.view)
            return
        }
        if !Common.stringLengthIn(realName, start: 1, end: 20){
            AlertView.showMsg("姓名长度不能超过20个字符", parentView: self.view)
            return
        }
        var idcard = idcardTextField.text
        if idcard.isEmpty {
            AlertView.showMsg("请输入身份证号码", parentView: self.view)
            return
        }
        if cardFrontImage == nil {
            AlertView.showMsg("请选择前身照", parentView: self.view)
            return
        }
        if cardBackImage == nil {
            AlertView.showMsg("请选择背面照", parentView: self.view)
            return
        }
        if cardHandImage == nil {
            AlertView.showMsg("请选择手持照", parentView: self.view)
            return
        }
        
        //提交数据
        //检查手机网络
        var reach = Reachability(hostName: Common.domain)
        reach.unreachableBlock = {(r:Reachability!) -> Void in
            //NSLog("网络不可用")
            dispatch_async(dispatch_get_main_queue(), {

                AlertView.alert("提示", message: "网络连接有问题，请检查手机网络", buttonTitle: "确定", viewController: self)
            })
        }
        
        reach.reachableBlock = {(r:Reachability!) -> Void in
           //NSLog("网络可用")
            dispatch_async(dispatch_get_main_queue(), {
                loading.startLoading(self.view)
                var manager = AFHTTPRequestOperationManager()
                var url = Common.serverHost + "/App-Ucenter-verifyRealName"
                var token = NSUserDefaults.standardUserDefaults().objectForKey("token") as? String
                var params = ["to":token!,"real_name":realName,"idcard":idcard]
                NSLog("实名认证参数%@", params)
                manager.responseSerializer.acceptableContentTypes = NSSet(array: ["text/html"]) as Set<NSObject>
                manager.POST(url, parameters: params, constructingBodyWithBlock: { (formData:AFMultipartFormData!) -> Void in
                    //加入图像参数
                    formData.appendPartWithFileData(UIImageJPEGRepresentation(self.cardFrontImage, 1.0), name: "card_front", fileName: "card_front.jpg", mimeType: "image/jpeg")
                    formData.appendPartWithFileData(UIImageJPEGRepresentation(self.cardBackImage, 1.0), name: "card_back", fileName: "card_back.jpg", mimeType: "image/jpeg")
                    formData.appendPartWithFileData(UIImageJPEGRepresentation(self.cardFrontImage, 1.0), name: "card_hand", fileName: "card_hand.jpg", mimeType: "image/jpeg")
                    
                    }, success: { (operation:AFHTTPRequestOperation!, data:AnyObject!) -> Void in
                        loading.stopLoading()
                        var result = data as! NSDictionary
                        NSLog("实名认证提交返回信息%@", result)
                        var code = result["code"] as! Int
                        if code == 0 {
                            AlertView.alert("提示", message: result["message"] as! String, buttonTitle: "确定", viewController: self)
                        }else if code == -1 {
                            AlertView.alert("提示", message: result["message"] as! String, buttonTitle: "确定", viewController: self)
                        }else if code == 200 {
                            
                            //将用户的idcard和isVerify放入userdefault中
                            
                            var userdefault = NSUserDefaults.standardUserDefaults()
                            userdefault.setObject(idcard, forKey: "isUpload")
                            userdefault.setObject("0", forKey: "isVerify")
                            
//                            AlertView.alert("提示", message: "实名认证信息已经提交，请等待审核！", buttonTitle: "确定", viewController: self, callback: {
//                                self.navigationController?.popViewControllerAnimated(true)
//                            })
                            AlertView.alert("提示", message: "实名认证信息已经提交，请等待审核！", buttonTitle: "确定", viewController: self, callback: { (alertAction:UIAlertAction!) -> Void in
                                self.navigationController?.popViewControllerAnimated(true)
                            })
                        }
                    
                    }, failure: { (operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
                        loading.stopLoading()
                        AlertView.alert("提示", message: "服务器异常", buttonTitle: "确定", viewController: self)
                        
                })

            })
        }
      
        reach.startNotifier()
        
    }
    
    //MARK:- 隐藏键盘
    override func viewWillAppear(animated: Bool) {
        DaiDodgeKeyboard.addRegisterTheViewNeedDodgeKeyboard(self.view)
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        DaiDodgeKeyboard.removeRegisterTheViewNeedDodgeKeyboard()
        super.viewWillDisappear(animated)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        resignAll()
        return true
    }
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        resignAll()
        
    }
    
    func resignAll(){
        realNameTextField.resignFirstResponder()
        idcardTextField.resignFirstResponder()
    }

}
