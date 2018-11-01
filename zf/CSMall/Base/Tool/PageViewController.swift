//
//  PageViewController.swift
//  Yesho
//
//  Created by innouni on 16/12/2.
//  Copyright © 2016年 luiz. All rights reserved.
//

import UIKit

class PageViewController: UIViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {

    // 子类需实现 viewControllerArray, buttonArray 两数组
    // 控制器的数量 需与 按钮数量相等
    // 如果不实现 buttonArray 则注掉 pageViewController.delegate = self
    var viewControllerArray: Array<UIViewController>!
    var buttonArray: Array<UIButton>!
    
    // 需要设置初始控制器 .setViewControllers
    let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    
    private var tempViewController:UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pageViewController.view.backgroundColor = UIColor.clear
        pageViewController.delegate = self
        pageViewController.dataSource = self
        pageViewController.view.frame = self.view.bounds
        self.addChildViewController(pageViewController)
        self.view.addSubview(pageViewController.view)
    }
    // MARK: - pageViewController 数据源
    internal func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let index = self.viewControllerArray.index(of: viewController), index + 1 < self.viewControllerArray.count {
            return self.viewControllerArray[index + 1]
        }
        return nil
    }
    internal func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let index = self.viewControllerArray.index(of: viewController), index - 1 >= 0 {
            return self.viewControllerArray[index - 1]
        }
        return nil
    }
    // MARK: - pageViewController 代理
    // 开始翻页调用
    internal func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        self.tempViewController = pendingViewControllers.last
    }
    // 翻页完成调用
    internal func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            self.viewControllerTransition(toIndex: self.viewControllerArray.index(of: self.tempViewController)!)
        }
    }
    // 滑动试图 -- 刷新按钮点击状态
    func viewControllerTransition(toIndex index: Int) {
        for btn in self.buttonArray {
            btn.isSelected = false
        }
        self.buttonArray[index].isSelected = true
    }
    // MARK: - 子类点击按钮时调用
    func selectedViewController(atButton btn: UIButton) {
        let index = self.buttonArray.index(of: btn)
        let currentIndex = getCurrentIndex()
        if currentIndex == index {
            return
        }
        self.viewControllerTransition(toIndex: index!)
        var direction: UIPageViewControllerNavigationDirection = .forward
        if currentIndex > index! {
            direction = .reverse
        }
        self.pageViewController.setViewControllers([self.viewControllerArray[index!]], direction: direction, animated: true, completion: nil)
    }
    private func getCurrentIndex() -> Int {
        for index in 0..<self.buttonArray.count where self.buttonArray[index].isSelected {
            return index
        }
        return 0
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension UIView {
    //查找vc
    func responderViewController() -> UIViewController? {
        var next = self.superview
        while next != nil {
            let responder = next?.next
            if responder!.isKind(of: UIViewController.self) {
                return responder as? UIViewController
            }
            next = next?.superview
        }
        return nil
    }
}
