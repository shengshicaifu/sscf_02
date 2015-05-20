//
//  loading.swift
//  study
//
//  Created by 肖典 on 15/5/13.
//  Copyright (c) 2015年 xiao. All rights reserved.
//

import Foundation
import UIKit
class loading{
    //创建模糊效果实例
    static let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
    //创建效果视图实例
    static let blurView = UIVisualEffectView(effect: blurEffect)
    static let circle = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
    //static let imageView = UIImageView(image: UIImage(named: "logo-gray.png"))
    static let myView = UIView()
    class func startLoading(view:UIView){
        //网络等待指示器
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        myView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        myView.layer.backgroundColor = UIColor(red: 135/255.0, green: 135/255.0, blue: 135/255.0, alpha: 1).CGColor
        myView.alpha = 1
        //设置效果视图大小
//        blurView.frame.size = CGSize(width: view.frame.width, height: view.frame.height)
//        //添加模糊效果进view
//        myView.addSubview(blurView)
        //创建读取效果
        circle.frame = CGRect(x: myView.frame.midX, y: myView.frame.midY-128, width: 20, height: 20)
        circle.center = myView.center
        
        
        //imageView.frame = CGRect(x: 0, y: myView.frame.midY - 100, width: myView.frame.width, height: 150)
        //myView.addSubview(imageView)
        myView.addSubview(circle)
        view.addSubview(myView)
        circle.startAnimating()
        
        
    }
    class func stopLoading(){
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        circle.stopAnimating()
        myView.removeFromSuperview()
    }
}