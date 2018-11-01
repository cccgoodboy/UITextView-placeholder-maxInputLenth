//
//  WaterFlowViewLayout.swift
//  LearnDemo
//
//  Created by innouni on 16/10/31.
//  Copyright © 2016年 innouni. All rights reserved.
//

import UIKit

class WaterFlowViewLayout: UICollectionViewLayout {

    let rowMargin:CGFloat = 5
    let colMargin:CGFloat = 5
    let colNum = 2
    let sectionInset = UIEdgeInsets(top: 0, left: 9, bottom: 0, right: 9)
    
    private lazy var maxYDict = [Int : CGFloat]()
    private lazy var attributesArr = [UICollectionViewLayoutAttributes]()
    
    typealias FetchItemHeight = (_ width: CGFloat, _ indexPath: IndexPath) -> (CGFloat)
    var itemHeight:FetchItemHeight?
    
    override var collectionViewContentSize: CGSize {
        get {
            var maxColumn = 0
            for (key, object) in maxYDict {
                if object > maxYDict[maxColumn]! {
                    maxColumn = key
                }
            }
            return CGSize(width: 0, height: maxYDict[maxColumn]! + sectionInset.bottom)
        }
    }

    override func prepare() {
        super.prepare()
        
        for col in 0..<colNum {
            maxYDict[col] = sectionInset.top
        }
        attributesArr.removeAll()
        for index in 0..<(collectionView?.numberOfItems(inSection: 0))! {
            let indexPath = IndexPath(item: index, section: 0)
            let attribute = layoutAttributesForItem(at: indexPath)
            attributesArr.append(attribute!)
        }
    }
  
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        super.layoutAttributesForItem(at: indexPath)
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        let width = (UIScreen.main.bounds.width - sectionInset.left - sectionInset.right - CGFloat(colNum - 1) * colMargin) / CGFloat(colNum)
        let height = itemHeight!(width, indexPath)
        var minColumn = 0
        for (key, object) in maxYDict {
            if object < maxYDict[minColumn]! {
                minColumn = key
            }
        }
        let x = sectionInset.left + (width + colMargin) * CGFloat(minColumn)
        let y = maxYDict[minColumn]
        attributes.frame = CGRect(x: x, y: y!, width: width, height: height)
        maxYDict[minColumn] = y! + height + rowMargin
        return attributes
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        super.layoutAttributesForElements(in: rect)
        return attributesArr
    }
}
