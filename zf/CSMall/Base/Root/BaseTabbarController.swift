
//
//  BaseTabbarController.swift
//  CSMall
//
//  Created by taoh on 2017/2/15.
//  Copyright © 2017年 taoh. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {
    
    override func viewDidLoad() {
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: defaultFont(size: 18)]
        self.navigationBar.tintColor = UIColor.white
        self.navigationBar.barTintColor = themeColor
        
//        self.navigationBar.setBackgroundImage(#imageLiteral(resourceName: "daohang"), for: .default)
        self.navigationBar.isTranslucent = false
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        if self.childViewControllers.count > 0 {
            
            viewController.hidesBottomBarWhenPushed = true
        }
        
        let backItem = UIBarButtonItem()
        
        backItem.title = ""
        
        viewController.navigationItem.backBarButtonItem = backItem
        
        super.pushViewController(viewController, animated: animated)
    }
}

class BaseTabbarController: UITabBarController, UITabBarControllerDelegate {
    private var adImageView: UIImageView?
    var lastViewController = UIViewController()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
       
        self.setupOfflineAllViewController()
        self.setupOfflineTabBarButton()
        
        NetworkingHandle.fetchNetworkData(url: "/api/tools/upgrade", at: self, params: ["version":"ios_version"],isShowHUD: false, isShowError: false ,success: { (result) in
            if let url = (result["data"] as? [String:Any] )?["url"] as? String {

                let localVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String

                if Double(localVersion)! <=  Double(((result["data"] as? [String:Any] )?["version"] as? String)!)! {

//                    self.setupAllViewController()
                    self.setupTabBarButton()

                }else{
                    self.setupOfflineAllViewController()
                    self.setupOfflineTabBarButton()
                }
            }
        }) {

        }
     
        
        self.delegate = self
        lastViewController = self.childViewControllers.first!
        
        self.tabBar.isTranslucent = false
        //去除tabbar顶部的黑线
        self.tabBar.shadowImage = UIImage()
        self.tabBar.backgroundImage = initWithImage(color:RGBA(r: 246, g: 246, b: 246, a: 0.8))
    }
//    func updatetabbar(){
//        if UserDefaults.standard.object(forKey: "version_zfg_user") as? Int  == 1{
//            self.setupAllViewController()
//            self.setupTabBarButton()
//        }else{
//            self.setupOfflineAllViewController()
//            self.setupOfflineTabBarButton()
//        }
//    }
    func initWithImage(color:UIColor)->UIImage{
        let rect = CGRect(x: 0,y: 0,width: 1,height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @objc func changeLanguage(nofi : Notification){
        
        
        self.setupOfflineAllViewController()
        self.reloadSetupOfflineTabBarButton()
        
        NetworkingHandle.fetchNetworkData(url: "/api/tools/upgrade", at: self, params: ["version":"ios_version"],isShowHUD: false, isShowError: false ,success: { (result) in
            if let url = (result["data"] as? [String:Any] )?["url"] as? String {
                
                let localVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
                
                if Double(localVersion)! <=  Double(((result["data"] as? [String:Any] )?["version"] as? String)!)! {
                    
//                    self.setupAllViewController()
                    self.reloadSetup()
                    
                }else{
                    self.setupOfflineAllViewController()
                    self.reloadSetupOfflineTabBarButton()
                }
            }
        }) {
            
        }
        
        
        self.delegate = self
        lastViewController = self.childViewControllers.first!
        
        self.tabBar.isTranslucent = false
        //去除tabbar顶部的黑线
        self.tabBar.shadowImage = UIImage()
        self.tabBar.backgroundImage = initWithImage(color:RGBA(r: 246, g: 246, b: 246, a: 0.8))
    }
    
}

extension BaseTabbarController {
    
    func setupAllViewController() {
        self.delegate = self
    
        let homevc = LAHomeViewController()
        let homeNav = NavigationController(rootViewController: homevc)
        self.addChildViewController(homeNav)
        
        let good = CoodStuffVC()
        let goodNav = NavigationController(rootViewController: good)
        self.addChildViewController(goodNav)
        
        
        let shop = ShoppingCartVC()
        let shopNav = NavigationController(rootViewController: shop)
        self.addChildViewController(shopNav)
        
        //我的中心
        let mineVC = MineViewController()
        let mineNav = NavigationController(rootViewController: mineVC)
        self.addChildViewController(mineNav)
    }
    func setupOfflineAllViewController() {//
        self.delegate = self
        
        let good = CoodStuffVC()
        let goodNav = NavigationController(rootViewController: good)
        self.addChildViewController(goodNav)

        let homevc = AllKindViewController()
        let homeNav = NavigationController(rootViewController: homevc)
        self.addChildViewController(homeNav)
        
        let shop = ShoppingCartVC()
        let shopNav = NavigationController(rootViewController: shop)
        self.addChildViewController(shopNav)
        
        //我的中心
        let mineVC = MineViewController()
        let mineNav = NavigationController(rootViewController: mineVC)
        self.addChildViewController(mineNav)
    }
    func setupTabBarButton() {
        //设置TabBar按钮的内容
        let homeVC = self.childViewControllers[0]
        homeVC.tabBarItem.image = UIImage(named: "zhibo1")?.withRenderingMode(.alwaysOriginal)
        homeVC.tabBarItem.selectedImage = UIImage(named: "zhibo")?.withRenderingMode(.alwaysOriginal)
        homeVC.tabBarItem.title = NSLocalizedString("Mall", comment: "商城")

        
        let aiVC = self.childViewControllers[1]
        aiVC.tabBarItem.image = UIImage(named: "shangcheng1")?.withRenderingMode(.alwaysOriginal)
        aiVC.tabBarItem.selectedImage = UIImage(named: "shangcheng")?.withRenderingMode(.alwaysOriginal)
        aiVC.tabBarItem.title = NSLocalizedString("Classification", comment: "分类")

        
        let livingVC = self.childViewControllers[2]
        livingVC.tabBarItem.image = UIImage(named: "gouwuche1")?.withRenderingMode(.alwaysOriginal)
        livingVC.tabBarItem.selectedImage = UIImage(named: "gouwuche")?.withRenderingMode(.alwaysOriginal)
        livingVC.tabBarItem.title = NSLocalizedString("Shoppingcart", comment: "购物车")

        let mineVC = self.childViewControllers[3]
        mineVC.tabBarItem.image = UIImage(named: "wode1")?.withRenderingMode(.alwaysOriginal)
        mineVC.tabBarItem.selectedImage = UIImage(named: "wode")?.withRenderingMode(.alwaysOriginal)
        mineVC.tabBarItem.title = NSLocalizedString("Me", comment: "我的")

        
        let insets = UIEdgeInsetsMake(-5, 0, 0, 0)
        homeVC.tabBarItem.imageInsets = insets
        aiVC.tabBarItem.imageInsets = insets
        livingVC.tabBarItem.imageInsets = insets
        mineVC.tabBarItem.imageInsets = insets
        
        self.tabBar.tintColor = themeColor// RGBA(r: 0,g: 197,b: 166,a: 1)
        if #available(iOS 10.0, *) {
            self.tabBar.unselectedItemTintColor = RGBA(r: 154, g: 154, b: 154, a: 1)
        } else {
            
        }
    }
    func setupOfflineTabBarButton() {
        //设置TabBar按钮的内容
//        let homeVC = self.childViewControllers[0]
//        homeVC.tabBarItem.image = UIImage(named: "zhibo1")?.withRenderingMode(.alwaysOriginal)
//        homeVC.tabBarItem.selectedImage = UIImage(named: "zhibo")?.withRenderingMode(.alwaysOriginal)
        
        let aiVC = self.childViewControllers[0]
        aiVC.tabBarItem.image = UIImage(named: "shangcheng1")?.withRenderingMode(.alwaysOriginal)
        aiVC.tabBarItem.selectedImage = UIImage(named: "shangcheng")?.withRenderingMode(.alwaysOriginal)
        aiVC.tabBarItem.title = NSLocalizedString("Mall", comment: "商城")
  
        
        let homeVC = self.childViewControllers[1]
        homeVC.tabBarItem.image = UIImage(named: "fenlei1")?.withRenderingMode(.alwaysOriginal)
        homeVC.tabBarItem.selectedImage = UIImage(named: "fenlei")?.withRenderingMode(.alwaysOriginal)
        homeVC.tabBarItem.title = NSLocalizedString("Classification", comment: "分类")

        let livingVC = self.childViewControllers[2]
        livingVC.tabBarItem.image = UIImage(named: "gouwuche1")?.withRenderingMode(.alwaysOriginal)
        livingVC.tabBarItem.selectedImage = UIImage(named: "gouwuche")?.withRenderingMode(.alwaysOriginal)
        livingVC.tabBarItem.title = NSLocalizedString("Shoppingcart", comment: "购物车")

        let mineVC = self.childViewControllers[3]
        mineVC.tabBarItem.image = UIImage(named: "wode1")?.withRenderingMode(.alwaysOriginal)
        mineVC.tabBarItem.selectedImage = UIImage(named: "wode")?.withRenderingMode(.alwaysOriginal)
        mineVC.tabBarItem.title = NSLocalizedString("Me", comment: "我的")

        
        let insets = UIEdgeInsetsMake(-5, 0, 0, 0)
        homeVC.tabBarItem.imageInsets = insets
        aiVC.tabBarItem.imageInsets = insets
        livingVC.tabBarItem.imageInsets = insets
        mineVC.tabBarItem.imageInsets = insets
        
        self.tabBar.tintColor =  themeColor//RGBA(r: 0,g: 197,b: 166,a: 1)
        if #available(iOS 10.0, *) {
            self.tabBar.unselectedItemTintColor = RGBA(r: 154, g: 154, b: 154, a: 1)
        } else {
            
        }
    }
    func reloadSetup(){
        let homeVC = self.childViewControllers[0]
        homeVC.tabBarItem.image = UIImage(named: "zhibo1")?.withRenderingMode(.alwaysOriginal)
        homeVC.tabBarItem.selectedImage = UIImage(named: "zhibo")?.withRenderingMode(.alwaysOriginal)
//        homeVC.tabBarItem.title = ""
        
        
        let aiVC = self.childViewControllers[1]
        aiVC.tabBarItem.image = UIImage(named: "shangcheng1")?.withRenderingMode(.alwaysOriginal)
        aiVC.tabBarItem.selectedImage = UIImage(named: "shangcheng")?.withRenderingMode(.alwaysOriginal)
//        aiVC.tabBarItem.title = NSLocalizedString("Classification", comment: "分类")
        
        
        let livingVC = self.childViewControllers[2]
        livingVC.tabBarItem.image = UIImage(named: "gouwuche1")?.withRenderingMode(.alwaysOriginal)
        livingVC.tabBarItem.selectedImage = UIImage(named: "gouwuche")?.withRenderingMode(.alwaysOriginal)
//        livingVC.tabBarItem.title = NSLocalizedString("Shoppingcart", comment: "购物车")
        
        let mineVC = self.childViewControllers[3]
        mineVC.tabBarItem.image = UIImage(named: "wode1")?.withRenderingMode(.alwaysOriginal)
        mineVC.tabBarItem.selectedImage = UIImage(named: "wode")?.withRenderingMode(.alwaysOriginal)
//        mineVC.tabBarItem.title = NSLocalizedString("Me", comment: "我的")
        let languages = Locale.preferredLanguages.first
        
        if (languages?.contains("en"))!{//英文环境
            
            homeVC.tabBarItem.title  = "Mall"
            aiVC.tabBarItem.title = "Classification"
            livingVC.tabBarItem.title = "Shoppingcart"
            mineVC.tabBarItem.title = "Me"
        }else if (languages?.contains("zh"))!{
            homeVC.tabBarItem.title  = "商城"
            aiVC.tabBarItem.title = "分类"
            livingVC.tabBarItem.title = "购物车"
            mineVC.tabBarItem.title = "我的"
        }else{
            homeVC.tabBarItem.title  = "Mall"
            aiVC.tabBarItem.title = "Classification"
            livingVC.tabBarItem.title = "Shoppingcart"
            mineVC.tabBarItem.title = "Me"
        }
        
        let insets = UIEdgeInsetsMake(-5, 0, 0, 0)
        homeVC.tabBarItem.imageInsets = insets
        aiVC.tabBarItem.imageInsets = insets
        livingVC.tabBarItem.imageInsets = insets
        mineVC.tabBarItem.imageInsets = insets
        
        self.tabBar.tintColor = themeColor// RGBA(r: 0,g: 197,b: 166,a: 1)
        if #available(iOS 10.0, *) {
            self.tabBar.unselectedItemTintColor = RGBA(r: 154, g: 154, b: 154, a: 1)
        } else {
            
        }
    }
    func reloadSetupOfflineTabBarButton(){
        let aiVC = self.childViewControllers[0]
        aiVC.tabBarItem.image = UIImage(named: "shangcheng1")?.withRenderingMode(.alwaysOriginal)
        aiVC.tabBarItem.selectedImage = UIImage(named: "shangcheng")?.withRenderingMode(.alwaysOriginal)
//        aiVC.tabBarItem.title = NSLocalizedString("Mall", comment: "商城")
        
        
        let homeVC = self.childViewControllers[1]
        homeVC.tabBarItem.image = UIImage(named: "fenlei1")?.withRenderingMode(.alwaysOriginal)
        homeVC.tabBarItem.selectedImage = UIImage(named: "fenlei")?.withRenderingMode(.alwaysOriginal)
//        homeVC.tabBarItem.title = NSLocalizedString("Classification", comment: "分类")
        
        let livingVC = self.childViewControllers[2]
        livingVC.tabBarItem.image = UIImage(named: "gouwuche1")?.withRenderingMode(.alwaysOriginal)
        livingVC.tabBarItem.selectedImage = UIImage(named: "gouwuche")?.withRenderingMode(.alwaysOriginal)
//        livingVC.tabBarItem.title = NSLocalizedString("Shoppingcart", comment: "购物车")
        
        let mineVC = self.childViewControllers[3]
        mineVC.tabBarItem.image = UIImage(named: "wode1")?.withRenderingMode(.alwaysOriginal)
        mineVC.tabBarItem.selectedImage = UIImage(named: "wode")?.withRenderingMode(.alwaysOriginal)
//        mineVC.tabBarItem.title = NSLocalizedString("Me", comment: "我的")
        
        let languages = Locale.preferredLanguages.first
        
        if (languages?.contains("en"))!{//英文环境
            
            homeVC.tabBarItem.title  = "Mall"
            aiVC.tabBarItem.title = "Classification"
            livingVC.tabBarItem.title = "Shoppingcart"
            mineVC.tabBarItem.title = "Me"
        }else if (languages?.contains("zh"))!{
            homeVC.tabBarItem.title  = "商城"
            aiVC.tabBarItem.title = "分类"
            livingVC.tabBarItem.title = "购物车"
            mineVC.tabBarItem.title = "我的"
        }else{
            homeVC.tabBarItem.title  = "Mall"
            aiVC.tabBarItem.title = "Classification"
            livingVC.tabBarItem.title = "Shoppingcart"
            mineVC.tabBarItem.title = "Me"
        }
        let insets = UIEdgeInsetsMake(-5, 0, 0, 0)
        homeVC.tabBarItem.imageInsets = insets
        aiVC.tabBarItem.imageInsets = insets
        livingVC.tabBarItem.imageInsets = insets
        mineVC.tabBarItem.imageInsets = insets
        
        self.tabBar.tintColor =  themeColor//RGBA(r: 0,g: 197,b: 166,a: 1)
        if #available(iOS 10.0, *) {
            self.tabBar.unselectedItemTintColor = RGBA(r: 154, g: 154, b: 154, a: 1)
        } else {
            
        }
    }
    
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
        
        if tabBarController.selectedIndex == 2 || tabBarController.selectedIndex == 3{
        }
        if lastViewController == viewController {
        }
        lastViewController = viewController
    }
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        if let arr = tabBarController.viewControllers{
            if viewController == arr[2] || viewController == arr[3] {
                
                if CSUserInfoHandler.getIdAndToken() != nil{
                    return true
                }else{
                    
                    let vc = UINavigationController.init(rootViewController: LoginViewController())
                    self.present(vc, animated: false, completion: nil)
                    return false
                }
            }
        }
        return true
    }
}


extension UINavigationBar {
    // MARK: - 接口
    /**
     *  隐藏导航栏下的横线，背景色置空 viewWillAppear调用
     */
    func star() {
        let shadowImg: UIImageView? = self.findNavLineImageViewOn(view: self)
        shadowImg?.isHidden = true
        self.backgroundColor = nil
        
    }
    
    /**
     在func scrollViewDidScroll(_ scrollView: UIScrollView)调用
     @param color 最终显示颜色
     @param scrollView 当前滑动视图
     @param value 滑动临界值，依据需求设置
     */
    func change(_ color: UIColor, with scrollView: UIScrollView, andValue value: CGFloat) {
        if scrollView.contentOffset.y < 0{
            // 下拉时导航栏隐藏，无所谓，可以忽略
            self.topItem?.titleView?.alpha = 0
            //            self.isHidden = true
        } else {
            self.isHidden = false
            self.topItem?.titleView?.alpha = 1
            // 计算透明度
            let alpha: CGFloat = scrollView.contentOffset.y / value > 1.0 ? 1 : scrollView.contentOffset.y / value
            //设置一个颜色并转化为图片
            let image: UIImage? = imageFromColor(color: color.withAlphaComponent(alpha))
            self.setBackgroundImage(image, for: .default)
        }
    }
    
    /**
     *  还原导航栏  viewWillDisAppear调用
     */
    func reset() {
        let shadowImg = findNavLineImageViewOn(view: self)
        shadowImg?.isHidden = false
        self.setBackgroundImage(nil,for: .default)
    }
    // MARK: - 其他内部方法
    //寻找导航栏下的横线  （递归查询导航栏下边那条分割线）
    fileprivate func findNavLineImageViewOn(view: UIView) -> UIImageView? {
        if (view.isKind(of: UIImageView.classForCoder())  && view.bounds.size.height <= 1.0) {
            return view as? UIImageView
        }
        for subView in view.subviews {
            let imageView = findNavLineImageViewOn(view: subView)
            if imageView != nil {
                return imageView
            }
        }
        return nil
    }
    
    // 通过"UIColor"返回一张“UIImage”
    fileprivate func imageFromColor(color: UIColor) -> UIImage {
        //创建1像素区域并开始图片绘图
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        
        //创建画板并填充颜色和区域
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        
        //从画板上获取图片并关闭图片绘图
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
}

