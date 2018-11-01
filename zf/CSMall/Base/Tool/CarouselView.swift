//
//  CarouselView.swift
//  Yesho
//
//  Created by innouni on 17/1/13.
//  Copyright © 2017年 luiz. All rights reserved.
//

import UIKit
import Kingfisher

class CarouselView: UIView, UIScrollViewDelegate {

    var totalPages: Int {
        set(n) {
            if n > 0 {
                tPages = n
                let size = pageControl.size(forNumberOfPages: n)
                pageControl.frame = CGRect(origin: CGPoint(x: (self.bounds.width - (18.0 * CGFloat(n)))/2, y: self.bounds.height - size.height), size: size)
                pageControl.numberOfPages = n
                if animationDuration > 0 {
                    timer.resumeAfter(timeInterval: animationDuration)
                }
                configContentViews()
            } else {
                tPages = 0
                if animationDuration > 0 {
                    timer.pause()
                }
            }
        }
        get {
            return tPages
        }
    }
    var fetchImageUrl: ((_: Int) -> Any)!
    
    private var currentPage = 0
    private var clickImg: ((_: Int) -> ())?
    private var tPages = 0
    private var animationDuration: TimeInterval!
    private var scrollView: UIScrollView!
    private var imgUrls: Array<Any> = []
    
    private lazy var timer: Timer = {
        Timer.scheduledTimer(timeInterval: self.animationDuration, target: self, selector: #selector(CarouselView.animationAction), userInfo: nil, repeats: true)
    }()
    private lazy var pageControl: UIPageControl = {
        let page = UIPageControl(frame: CGRect())
        page.currentPageIndicatorTintColor = RGBA(r: 0,g: 197,b: 166,a: 1)
        page.pageIndicatorTintColor = UIColor.white
        return page
    }()
    
    // 外部初始化调用
    convenience init(frame: CGRect, animationDuration: TimeInterval, didSelect: ((_: Int) -> ())?) {
        self.init(frame: frame)
        self.clickImg = didSelect
        self.animationDuration = animationDuration
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        self.autoresizesSubviews = true
        self.setupSubviews()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    private func setupSubviews() {
        scrollView = UIScrollView(frame: self.bounds)
        self.addSubview(scrollView)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.contentSize = CGSize(width: 3 * self.bounds.width, height: self.bounds.height)
        scrollView.delegate = self
        for i in 0..<3 {
            var frame = self.bounds
            frame.origin.x = CGFloat(i) * self.bounds.width
            let img = UIImageView(frame: frame)
            img.isUserInteractionEnabled = true
            let imgTap = UITapGestureRecognizer(target: self, action: #selector(CarouselView.clickImageView))
            img.addGestureRecognizer(imgTap)
            img.contentMode = .scaleAspectFill
            img.clipsToBounds = true
            scrollView.addSubview(img)
        }
        self.addSubview(pageControl)
    }
    @objc private func clickImageView() {
        self.clickImg?(currentPage)
    }
    // 定时
    @objc private func animationAction() {
        let newOffset = CGPoint(x: scrollView.contentOffset.x + scrollView.bounds.width, y: scrollView.contentOffset.y)
        scrollView.setContentOffset(newOffset, animated: true)
    }
    // scorllView 代理
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if animationDuration > 0 {
            timer.pause()
        }
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if animationDuration > 0 {
            timer.resumeAfter(timeInterval: animationDuration)
        }
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollView.setContentOffset(CGPoint(x: scrollView.bounds.width, y: 0), animated: true)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x
        if offsetX >= scrollView.bounds.width * 2 {
            currentPage = getValidNextIndex(index: currentPage + 1)
            configContentViews()
        } else if offsetX <= 0 {
            currentPage = getValidNextIndex(index: currentPage - 1)
            configContentViews()
        }
        pageControl.currentPage = currentPage
    }
    
    // 
    private func configContentViews() {
        setupScrollViewContentDataSource()
        for i in 0..<imgUrls.count {
            let imgView = scrollView.subviews[i] as! UIImageView
            let img = imgUrls[i]
            if img is String {
                imgView.sd_setImage(with: URL.init(string: img as! String), placeholderImage: #imageLiteral(resourceName: "moren-2"))
//                imgView.kf.setImage(with: URL(string: img as! String))
            } else if img is UIImage {
                imgView.image = img as? UIImage
            }
        }
        scrollView.setContentOffset(CGPoint(x: scrollView.bounds.width, y: 0), animated: false)
    }
    private func setupScrollViewContentDataSource() {
        let lastPage = getValidNextIndex(index: currentPage - 1)
        let nextPage = getValidNextIndex(index: currentPage + 1)
        if fetchImageUrl == nil {
            fatalError("fetchImageUrl not valid")
        }
        imgUrls.removeAll()
        imgUrls.append(fetchImageUrl(lastPage))
        imgUrls.append(fetchImageUrl(currentPage))
        imgUrls.append(fetchImageUrl(nextPage))
    }
    private func getValidNextIndex(index: Int) -> Int {
        if index == -1 {
            return tPages - 1
        } else if index == tPages {
            return 0
        }
        return index
    }
}
extension Timer {
    // 暂停
    func pause() {
        if self.isValid {
            self.fireDate = Date.distantFuture
        }
    }
    // 重新开始
    func resume() {
        if self.isValid {
            self.fireDate = Date()
        }
    }
    func resumeAfter(timeInterval: TimeInterval) {
        if self.isValid {
            self.fireDate = Date(timeIntervalSinceNow: timeInterval)
        }
    }
}
