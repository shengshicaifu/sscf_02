//
//  BandBankControllerExtension.swift
//  盛世财富
//
//  Created by 云笺 on 15/6/13.
//  Copyright (c) 2015年 sscf88. All rights reserved.
//

import UIKit
extension BandBankController:UIPickerViewDataSource{
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        return 2
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        if component == 0{
            return province.count
        }
        return city.count
    }
}
extension BandBankController:UIPickerViewDelegate{
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        if component == 0{
         
        }
      
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String!{
        if component == 0{
            return province[row]
        }
        return city[row]
    }
}
