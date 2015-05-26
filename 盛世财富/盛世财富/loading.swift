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
    static let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
    //创建效果视图实例
    static let blurView = UIVisualEffectView(effect: blurEffect)
    static let circle = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
    static let darkView = UIView()
    static let msg = UILabel()
    class func startLoading(view:UIView){
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        darkView.frame = CGRect(x: (view.frame.width-100)/2, y: (view.frame.height-100)/2, width: 100, height: 100)
        darkView.backgroundColor = UIColor.blackColor()
        darkView.alpha = 0.5
        darkView.layer.cornerRadius = 10
        //设置效果视图大小
        blurView.frame.size = CGSize(width: view.frame.width, height: view.frame.height)
        //添加模糊效果进view
        
        view.addSubview(blurView)
        //创建读取效果
        circle.frame = CGRect(x:(darkView.frame.width )/2 , y:(darkView.frame.height )/2-15, width: 0, height: 0)
        msg.text = "加载中..."
        msg.frame = CGRect(x: 0, y: circle.frame.maxY+10, width: 100, height: 50)
        msg.textAlignment = NSTextAlignment.Center
        msg.textColor = UIColor.whiteColor()
        msg.numberOfLines = 2
        msg.adjustsFontSizeToFitWidth = true
        darkView.addSubview(msg)
        darkView.addSubview(circle)
        view.addSubview(darkView)
        circle.startAnimating()
        
    }
    class func startLoading(view:UIView,message:String){
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        darkView.frame = CGRect(x: (view.frame.width-100)/2, y: (view.frame.height-100)/2, width: 100, height: 100)
        darkView.backgroundColor = UIColor.blackColor()
        darkView.alpha = 0.5
        darkView.layer.cornerRadius = 10
        //设置效果视图大小
        blurView.frame.size = CGSize(width: view.frame.width, height: view.frame.height)
        //添加模糊效果进view
        view.addSubview(blurView)
        //创建读取效果
        circle.frame = CGRect(x:(darkView.frame.width )/2 , y:(darkView.frame.height )/2-15, width: 0, height: 0)
        msg.text = message
        msg.frame = CGRect(x: 0, y: circle.frame.maxY+10, width: 100, height: 50)
        msg.textAlignment = NSTextAlignment.Center
        msg.textColor = UIColor.whiteColor()
        msg.numberOfLines = 2
        msg.adjustsFontSizeToFitWidth = true
        darkView.addSubview(msg)
        darkView.addSubview(circle)
        view.addSubview(darkView)
        circle.startAnimating()
        
    }
    class func stopLoading(){
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        circle.stopAnimating()
        darkView.removeFromSuperview()
        blurView.removeFromSuperview()
    }
}