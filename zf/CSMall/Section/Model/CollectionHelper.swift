//
//  CollectionHelper.swift
//  CSMall
//
//  Created by YI on 18/10/2017.
//  Copyright © 2017 taoh. All rights reserved.
//

import UIKit

class CollectionHelper: NSObject {
    static let instance = CollectionHelper()
    
    func ergodic(_ collections: [UserCollection]?, _ collection: UserCollection?) -> [UserCollection] {
        var cols = [UserCollection]()
        if collections == nil || collection == nil {
            print("collection=",collections!,"collection=",collection!)
        }else {
            if collections?.count == 0 {
                cols = collections!
                cols.append(collection!)
                return cols
            }else {
                for (n, c) in collections!.enumerated() {
                    if collection?.goods_id == c.goods_id {
                        cols = collections!
                        cols.remove(at: n)
                        return cols
                    }
                    if n == (collections?.count)! - 1 {
                        cols = collections!
                        cols.append(collection!)
                        return cols
                    }
                }
            }
        }
        return cols
    }
    
    func ids(_ collections: [UserCollection]?) -> String {
        var ids = ""
        if collections?.count == 0 {
            return ""
        }else {
            for (n, c) in collections!.enumerated() {
                if n == (collections?.count)! - 1 {
                    ids = ids + c.collection_id!
                    return ids
                }else {
                    ids = ids + c.collection_id!
                }
            }
        }
        return ids
    }
}
