//
//  viewController.swift
//  盛世财富
//
//  Created by 云笺 on 15/5/30.
//  Copyright (c) 2015年 sscf88. All rights reserved.
//

import UIKit
extension BandBankController:UIPickerViewDataSource{
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
       return 5
    }

}
extension BandBankController:UIPickerViewDelegate{
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String!{
        return ""
    }
}
