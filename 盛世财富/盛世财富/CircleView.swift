//
//  CircleView.swift
//  customerViewDemo
//
//  Created by 莫文琼 on 15/6/8.
//  Copyright (c) 2015年 莫文琼. All rights reserved.
//

import UIKit
/**
*  自定义的圆环
*/
class CircleView: UIView {

    var percent = 0.0//进度
    var incompleteColor = UIColor(red: 216/255.0, green: 216/255.0, blue: 216/255.0, alpha: 1.0).CGColor
    var completeColor = UIColor(red: 253/255.0, green: 134/255.0, blue: 143/255.0, alpha: 1.0).CGColor
    var incompleteFontColor = UIColor(red: 216/255.0, green: 216/255.0, blue: 216/255.0, alpha: 1.0)
    var completeFontColor = UIColor(red: 253/255.0, green: 134/255.0, blue: 143/255.0, alpha: 1.0)
    var tip:NSString = "立即投资"
    var type:NSString = "1" //1:百分比和文字  2:文字
    //0  0   -pi/2
    
    //1  pi*2   pi + pi/2
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        //视图的边框
        var bounds = self.bounds
        
        //圆环的中心
        var center:CGPoint = CGPoint()
        center.x = bounds.origin.x + bounds.size.width / 2.0
        center.y = bounds.origin.y + bounds.size.height / 2.0
        
        //背景圆
        var context1 = UIGraphicsGetCurrentContext()
        CGContextSetLineWidth(context1, 3)//线条宽度
        var radious = bounds.size.width / 2.0 - 2
        var startAngle = CGFloat(0 - M_PI_2)
        var endAngle = CGFloat(M_PI * 2)
        CGContextSetStrokeColorWithColor(context1, incompleteColor)
        CGContextAddArc(context1, center.x, center.y,radious, startAngle,endAngle, 0)
        CGContextStrokePath(context1)//绘制
       
        
        //进度曲线
        var context2 = UIGraphicsGetCurrentContext()
        endAngle = CGFloat(percent * M_PI * 2 - M_PI_2)
        CGContextSetStrokeColorWithColor(context2, completeColor)
        CGContextAddArc(context2, center.x, center.y, radious, startAngle, endAngle, 0)
        CGContextStrokePath(context2)//绘制
        
        
        //绘制文字
        if type == "1" {
            var proress:NSString = "\(percent * 100)%"
            var textRect:CGRect = CGRect()
            var font = UIFont(name: "HelveticaNeue", size: 10.0)
            var fontColor = completeFontColor
            let att = NSDictionary(objects: [font!,fontColor], forKeys: [NSFontAttributeName,NSForegroundColorAttributeName]) as [NSObject : AnyObject]
            textRect.size = proress.sizeWithAttributes(att)
            textRect.origin.x = center.x - textRect.size.width / 2.0
            textRect.origin.y = center.y - textRect.size.height / 2.0 - 10
            proress.drawInRect(textRect, withAttributes: att)
            
            textRect.size = tip.sizeWithAttributes(att)
            textRect.origin.x = center.x - textRect.size.width / 2.0
            textRect.origin.y = center.y - textRect.size.height / 2.0 + 5
            tip.drawInRect(textRect, withAttributes: att)
        }else if type == "2" {
            var textRect:CGRect = CGRect()
            var font = UIFont(name: "HelveticaNeue", size: 10.0)
            var fontColor = incompleteFontColor
            let att = NSDictionary(objects: [font!,fontColor], forKeys: [NSFontAttributeName,NSForegroundColorAttributeName]) as [NSObject : AnyObject]
            textRect.size = tip.sizeWithAttributes(att)
            textRect.origin.x = center.x - textRect.size.width / 2.0
            textRect.origin.y = center.y - textRect.size.height / 2.0
            tip.drawInRect(textRect, withAttributes: att)
        }
        
        
    }
    
}
