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
    class func startLoading(view:UIView){
        
        //设置效果视图大小
        blurView.frame.size = CGSize(width: view.frame.width, height: view.frame.height)
        //添加模糊效果进view
        view.addSubview(blurView)
        //创建读取效果
        circle.frame = CGRect(x: view.frame.midX, y: view.frame.midY, width: 20, height: 20)
        
        view.addSubview(circle)
        circle.startAnimating()
    }
    class func stopLoading(){
        circle.stopAnimating()
        blurView.removeFromSuperview()
    }
}