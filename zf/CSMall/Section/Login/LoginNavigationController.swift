//
//  LoginNavigationController.swift
//  Duluo
//
//  Created by sh-lx on 2017/3/20.
//  Copyright © 2017年 tts. All rights reserved.
//

import UIKit

class LoginNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.tintColor = UIColor.gray
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: themeColor, NSFontAttributeName: defaultFont(size: 16)]
            self.navigationBar.isTranslucent = false

    }
    
//    class func setup() -> LoginNavigationController {
//
//        let n = LoginNavigationController(rootViewController: LoginViewController())
//        return n
//    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if self.childViewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
        }
        let backItem = UIBarButtonItem()
        backItem.title = ""
        viewController.navigationItem.backBarButtonItem = backItem
        super.pushViewController(viewController, animated: animated)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
