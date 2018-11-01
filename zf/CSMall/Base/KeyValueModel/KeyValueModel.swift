//
//  KeyValueModel.swift
//
//  Created by space on 15/12/29.
//  Copyright © 2015年 Space. All rights reserved.



/**  swift 版的赋值
 注意：已经实现了序列化  不要实现任何构造器    继承KeyValueModel即可
 1：对于Int Double  Float 不要使用可选值   如果使用为了使程序不崩溃   就不会赋值操作
 2：  func propertyNameInDictionary()->[String:String]?   返回 属性名和字典名不同的对应关系
 */
//

import Foundation

protocol modelPruotocol: NSObjectProtocol {
    /**之前的Key:之后的key  模型属性名和的字典key不匹配问题*/
    func propertyNameInDictionary()->[String:String]?
}
class KeyValueModel: NSObject, modelPruotocol, NSCoding {
    /**之前的Key:之后的key  模型属性名和的字典key不匹配问题*/
    internal func propertyNameInDictionary() -> [String : String]? {
        return ["":""]
    }

    /**得到反射*/
    lazy var mirror:Mirror =  Mirror(reflecting:self)
    required override init() {super.init()}
    required init?(coder aDecoder: NSCoder) {
        super.init()
        for child  in mirror.children {
            let name  = child.label!
            let value = aDecoder.decodeObject(forKey: name)
            self.setValue(value, forKeyPath: name)
        }
        
    }
    func encode(with aCoder: NSCoder) {
        for child  in mirror.children {
            let name  = child.label!
            let value = self.value(forKey: name)
            aCoder.encode(value, forKey: name)
        }
    }

}
extension KeyValueModel {
    /**返回一个新的对象*/
    
    private func modelWithDic(dic:[String:AnyObject])->KeyValueModel {
        return (type(of: self) as  KeyValueModel.Type).modelWithDictionary(diction: dic)
    }
    /**对象数组*/
    private func modelsWithArray(array:[[String:AnyObject]])->[KeyValueModel] {
        return (type(of: self) as  KeyValueModel.Type).modelsWithArray(modelArray: array)
    }
    /**字典数组得到 ------》模型*/
    class func modelsWithArray(modelArray:[[String:AnyObject]]) ->[KeyValueModel] {
        var models = [KeyValueModel]()
        for one in modelArray {
            let model = modelWithDictionary(diction: one)
            models.append(model)
        }
        return models
    }
    /**字典------》模型*/
    class func modelWithDictionary ( diction:[String:AnyObject]) ->Self {
        let model = self.init()
        /**得到[propertyName:key]*/
        let exchageDic = model.propertyNameInDictionary()
        func setValue(msg:messageInfo,dicProperName:String) {
            if var value = diction[dicProperName] {
                if msg.isArray {
                    var arr = [AnyObject]()
                    let  className =  msg.arrarModelName
                    if msg.isModelArray {/**模型数组*/
                        let oneModel = (objc_getClass(className?.getWholeClassName()) as! KeyValueModel.Type).init()
                        for one in (diction[dicProperName] as? [[String:AnyObject]]!)! {
                            arr.append(oneModel.modelWithDic(dic: one))
                        }
                        model.setValue(arr , forKeyPath:msg.name)
                    } else {  //不是模型数组
                        let clazz = objc_getClass(className)
                        if let _ = clazz {//[NSURl]  [NSNumber] 等等
                            if(className?.lowercased() == "nsurl") {
                                for one in (value as![String]) {
                                    let url = NSURL.init(string: one)
                                    if let _ = url {
                                        arr.append(url!)
                                    }
                                }
                            } else if(className?.lowercased() == "nsnumber") {
                                for one in (value as![String]) {
                                    let number = NSNumber.init(value:(one as NSString).doubleValue)
                                    arr.append(number)
                                }
                            } else {}
                            model.setValue(arr , forKeyPath:msg.name)
                        } else {
                            // [String]   NSClassFromString("String")不能创建
                            model.setValue(value , forKeyPath:msg.name)
                        }
                    }
                } else {
                    /**普通属性*/
                    
                    if(!msg.isFoundation) {
                        var className = msg.valueType
                        className = className.getWholeClassName()
                        if value is [String:AnyObject] {
                            let res:[String:AnyObject] = value as! [String:AnyObject]
                            value =  (NSClassFromString(className)?.modelWithDictionary(diction:res))! as! KeyValueModel
                        }
                    }
                    model.setValue(value, forKeyPath:msg.name)
                }
            }
        }
        
        /**便利所有属性*/
        model.properties { (msg:messageInfo) -> () in
            var dicPropertyName = msg.name
            if let name = exchageDic![msg.name] {dicPropertyName = name}
            if msg.isOptional {
                /**可选型*/
                if (msg.isBasicNumber) {/**Int Double float 类型直接跳过 还没有解决*/}
                else {
                    setValue(msg: msg, dicProperName: dicPropertyName)
                }
            } else {
                setValue(msg: msg, dicProperName: dicPropertyName)
            }
        }
        return model
    }
    /**
     模型转为字典
     - returns: 字典
     */
    func dictionary()->[String:AnyObject]{
        var dic:[String:AnyObject] = [String:AnyObject]()
        properties { (message) in
            let value = self.value(forKey: message.name)
            if let _ = value{
                if(message.isArray){
                    var  array:[AnyObject]=[AnyObject]()
                    if(message.isModelArray){
                        for one in value as! [KeyValueModel] {
                            array.append(one.dictionary() as AnyObject)
                        }
                    }else{
                        let one = (value as! [AnyObject]).exchange() as! [AnyObject]
                        array.append(contentsOf: one)
                    }
                    dic[message.name] = array as AnyObject?
                }else{
                    if(message.isFoundation){      //系统
                        //字典  NSURl  NSNUmber String
                        if(message.valueType=="NSURL"){
                            dic[message.name] = (value as! NSURL).absoluteString as AnyObject?
                        }else if(message.valueType.lowercased().contains("dictionary")){
                            dic[message.name] = (value as! [String:AnyObject]).exchange()
                        }else{
                            dic[message.name] = "\(value)" as AnyObject?
                        }
                    }else{//继承KeyValueModel
                        let obj = value as! KeyValueModel
                        let temp = obj.dictionary()
                        dic[message.name] = temp as AnyObject?
                    }
                }
            }
        }
        return dic;
    }
}
extension KeyValueModel{
    func properties(option:@escaping (messageInfo)->()){
        func enumerate(mir:Mirror){
            if  "\(mir.subjectType)" == "KeyValueModel"{return}
            let superMir = mir.superclassMirror
            if let _ = superMir{
                enumerate(mir: superMir!)
            }
            for one in  mir.children{
                let propertyName:String = one.label!
                let value = one.value
                let msg = messageInfo.init(name: propertyName, value: value)
                option(msg)
            }
        }
        enumerate(mir: mirror)
    }
}

var classPrefix = NSStringFromClass(KeyValueModel.self).components(separatedBy: ".").first!
