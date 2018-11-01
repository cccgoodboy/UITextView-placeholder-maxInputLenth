//
//  CacheTool.swift
//  Kongfu
//
//  Created by 邵杰 on 17/3/18.
//  Copyright © 2017年 邵杰. All rights reserved.
//

import UIKit

class CacheTool: NSObject {
    // 计算缓存大小
    static var cacheSize: String{
        get{
            let basePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
            let fileManager = FileManager.default
            
            func caculateCache() -> Float{
                var total: Float = 0
                if fileManager.fileExists(atPath: basePath!){
                    let childrenPath = fileManager.subpaths(atPath: basePath!)
                    if childrenPath != nil{
                        for path in childrenPath!{
                            let childPath = basePath?.appending("/").appending(path)
                            do{
                                let attr = try fileManager.attributesOfItem(atPath: childPath!)
                                let fileSize = attr[FileAttributeKey.size] as! Float
                                total += fileSize
                                
                            }catch _{
                                
                            }
                        }
                    }
                }
                
                return total
            }
            
            
            let totalCache = caculateCache()
            return NSString(format: "%.2f MB", totalCache / 1024.0 / 1024.0 ) as String
        }
    }
    
    // 清除缓存
    class func clearCache() -> Bool{
        var result = true
        let basePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: basePath!){
            let childrenPath = fileManager.subpaths(atPath: basePath!)
            for childPath in childrenPath!{
                let cachePath = basePath?.appending("/").appending(childPath)
                do{
                    try fileManager.removeItem(atPath: cachePath!)
                    ProgressHUD.showNoticeOnStatusBar(message: "清除成功")
                }catch _{
                    result = false
                    ProgressHUD.showNoticeOnStatusBar(message: "小主，您的应用已经很干净了！")

                }
            }
        }
        
        return result
    }
}
