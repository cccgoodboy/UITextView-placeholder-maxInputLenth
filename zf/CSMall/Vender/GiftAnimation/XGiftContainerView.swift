//
//  XGiftContainerView.swift
//  XGiftAnimation
//
//  Created by sajiner on 2016/12/19.
//  Copyright © 2016年 sajiner. All rights reserved.
//

import UIKit
private let kChannelCount = 2
private let kChannelViewH : CGFloat = 40
private let kChannelMargin : CGFloat = 10

class XGiftContainerView: UIView {

    fileprivate lazy var channelViews: [XGiftChannelView] = [XGiftChannelView]()
    fileprivate lazy var cacheGiftModels: [XGiftModel] = [XGiftModel]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

//MARK: - Open Methods
extension XGiftContainerView {
    func showGiftModel(_ giftModel: XGiftModel) {
        if let channelView = checkUsingChannelView(giftModel) {
            channelView.addOnceToCache()
            return
        }
        if let channelView = checkIdleChannelView() {
            channelView.giftModel = giftModel
            return
        }
        cacheGiftModels.append(giftModel)
    }
    
    private func checkUsingChannelView(_ giftModel: XGiftModel) -> XGiftChannelView? {
        for channelView in channelViews {
            if giftModel.isEqual(channelView.giftModel) && channelView.state != .endAnimating {
                return channelView
            }
        }
        return nil
    }
    
    private func checkIdleChannelView() -> XGiftChannelView? {
        for channelView in channelViews {
            if channelView.state == .idle {
                return channelView
            }
        }
        return nil
    }
}

//MARK: - 初始化子控件
extension XGiftContainerView {
    fileprivate func setupUI() {
        let w : CGFloat = frame.width
        let h : CGFloat = kChannelViewH
        let x : CGFloat = 0
        for i in 0..<kChannelCount {
            let y = (h + kChannelMargin) * CGFloat(i)
            let channelView = XGiftChannelView.loadFromNib()
            channelView.frame = CGRect(x: x, y: y, width: w, height: h)
            channelView.alpha = 0
            addSubview(channelView)
            channelViews.append(channelView)
            
            channelView.complectionCallback = { channelView in
                guard self.cacheGiftModels.count != 0 else { return }
                let firstGiftModel = self.cacheGiftModels.first!
                self.cacheGiftModels.removeFirst()
                
                channelView.giftModel = firstGiftModel
                
                for i in (0..<self.cacheGiftModels.count).reversed() {
                    let giftModel = self.cacheGiftModels[i]
                    if giftModel.isEqual(firstGiftModel) {
                        channelView.addOnceToCache()
                        self.cacheGiftModels.remove(at: i)
                    }
                }
            }
        }
    }
}
