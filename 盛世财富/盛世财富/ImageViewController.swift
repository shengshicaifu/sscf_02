//
//  PicViewController.swift
//  盛世财富
//
//  Created by xiao on 15-3-19.
//  Copyright (c) 2015年 sscf88. All rights reserved.
//



import UIKit

class ImageViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
   
    @IBOutlet weak var image: UIImageView!
    
    var count = 1
    @IBAction func left(sender: AnyObject) {
        
        image.image = UIImage(named: "\(count).jpg")
        count++
        if count > 4 {
            count = 1
        }
        
    }
    
    @IBAction func right(sender: AnyObject) {
        image.image = UIImage(named: "\(count).jpg")
        count--
        if count < 1 {
            count = 4
        }
        
    }
    
}

