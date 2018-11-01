//
//  ProvinceCityDistrictChoice.swift
//  Yesho
//
//  Created by Luiz on 2016/12/4.
//  Copyright © 2016年 luiz. All rights reserved.
//

import UIKit

class ProvinceCityDistrictChoice: UIView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var provinceArray: Array<String> = []
    var cityDictionary: Dictionary<String, Array<String>> = [:]
    var districtDictionary: Dictionary<String, Array<String>> = [:]
    var cityArray: Array<String>!
    var districtArray:  Array<String>!
    
    let pickerView = UIPickerView()
    
    var choiceComplete: ((_: String, _: String, _: String) -> ())?
    private func setupData() {
        let areaDic = NSDictionary(contentsOfFile: Bundle.main.path(forResource: "area", ofType: "plist")!)
        for index in 0...33 {
            let dic = areaDic?.object(forKey: "\(index)") as! Dictionary<String, Dictionary<String, Dictionary<String, Array<String>>>>
            let provinceName = dic.allKeys().first
            provinceArray.append(provinceName!)
            let proDic = dic[provinceName!]
            var cArr: Array<String> = []
            for i in 0..<(proDic?.allKeys().count)! {
                let ctyDic = proDic?["\(i)"]
                let cityName = ctyDic?.allKeys().first
                cArr.append(cityName!)
                districtDictionary[provinceName! + cityName!] = ctyDic?[cityName!]
            }
            cityDictionary[provinceName!] = cArr
        }
        cityArray = cityDictionary[provinceArray.first!]
        districtArray = districtDictionary[provinceArray.first! + cityArray.first!]
    }
    func show(choiced:@escaping (_: String, _: String, _: String) -> ()) {
        self.choiceComplete = choiced
        setupData()
        
        self.backgroundColor = UIColor(white: 0.6, alpha: 0.4)
        pickerView.frame = CGRect(x: 0, y: kScreenHeight - 264, width: kScreenWidth, height: 200)
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.backgroundColor = UIColor.white
            
        pickerView.selectRow(0, inComponent: 0, animated: true)
        pickerView.selectRow(0, inComponent: 1, animated: true)
        pickerView.selectRow(0, inComponent: 2, animated: true)
        self.addSubview(pickerView)
        
        

        let okBtn = UIButton(frame: CGRect(x: 0, y: kScreenHeight - 304 , width: kScreenWidth / 2, height: 40))
//        okBtn.setBackgroundImage(UIImage(named: "supermarket-btn"), for: .normal)
        okBtn.backgroundColor = themeColor
        okBtn.setTitle("确定", for: .normal)
        okBtn.addTarget(self, action: #selector(okAction), for: .touchUpInside)
        self.addSubview(okBtn)
        
        let cancelBtn = UIButton(frame: CGRect(x: kScreenWidth / 2, y: kScreenHeight - 304 , width: kScreenWidth / 2, height: 40))
        
        cancelBtn.backgroundColor = UIColor.gray
        cancelBtn.setTitle("取消", for: .normal)
        cancelBtn.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        self.addSubview(cancelBtn)
        
        self.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(hidensView)))

    }
    func hidensView(){
        self.removeFromSuperview()
        
    }
    func okAction() {
        self.removeFromSuperview()
        let pIndex = self.pickerView.selectedRow(inComponent: 0)
        let cIndex = self.pickerView.selectedRow(inComponent: 1)
        let dIndex = self.pickerView.selectedRow(inComponent: 2)
        self.choiceComplete?(provinceArray[pIndex], cityArray[cIndex], districtArray[dIndex])
    }
    func cancelAction() {
        self.removeFromSuperview()
    }
    // MARK: picker view 数据源 和 代理
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return kScreenWidth / 3
    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 36
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return provinceArray.count
        } else if component == 1 {
            return self.cityArray.count
        } else if component == 2 {
            return self.districtArray.count
        }
        return 0
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let title = UILabel(frame: CGRect(x: 0, y: 0, width: kScreenWidth / 3, height: 30))
        title.textAlignment = .center
        title.font = UIFont.systemFont(ofSize: 14)
        if component == 0 {
            title.text = provinceArray[row]
        } else if component == 1 {
            title.text = cityArray[row]
        } else {
            title.text = districtArray[row]
        }
        return title
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       
        
        
        
        if component == 0 {

            
            cityArray = cityDictionary[provinceArray[row]]
            districtArray = districtDictionary[provinceArray[row] + cityArray.first!]
            
                        if cityDictionary[provinceArray[row]] != nil || districtDictionary[provinceArray[row] + cityArray.first!] != nil{
                            pickerView.selectRow(0, inComponent: 1, animated: true)
                            pickerView.selectRow(0, inComponent: 2, animated: true)
                            pickerView.reloadComponent(1)
                            pickerView.reloadComponent(2)
                        } else {
                            
            }
            
        } else if component == 1 {
            let index = pickerView.selectedRow(inComponent: 0)


            districtArray = districtDictionary[provinceArray[index] + cityArray[row]]
                        if districtDictionary[provinceArray[index] + cityArray[row]] != nil {
                            pickerView.selectRow(0, inComponent: 2, animated: true)
                            pickerView.reloadComponent(2)

                        } else {
                            
                            
            }
        }
    }
}
