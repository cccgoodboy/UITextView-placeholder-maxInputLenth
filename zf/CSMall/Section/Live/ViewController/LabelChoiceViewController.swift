//
//  LabelChoiceViewController.swift
//  DragonVein
//
//  Created by sh-lx on 2017/3/28.
//  Copyright © 2017年 tts. All rights reserved.
//

import UIKit

class LabelChoiceViewController: UIViewController {
    
    var labelChoiceSuccess: (([String]) ->())?
    
    var dataArr: [LabelModel] = []
    
    var selectedBtns: [UIButton] = []
    
    var scrollView: UIScrollView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "选择标签"
        
        scrollView = UIScrollView(frame: self.view.bounds)
        self.view.addSubview(scrollView)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "确定", target: self, action: #selector(rightBarButtonItemAction))
        fetchData()
    }
    func rightBarButtonItemAction() {
        if selectedBtns.count == 0 {
            ProgressHUD.showNoticeOnStatusBar(message: "你还没有选择标签呢！")
            return
        }
        var labs: [String] = []
        for btn in selectedBtns {
            let model = dataArr[btn.tag - 100]
            labs.append(model.name!)
        }
        labelChoiceSuccess?(labs)
        _ = self.navigationController?.popViewController(animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func fetchData() {
        NetworkingHandle.fetchNetworkData(url: "Index/lebel_list", at: self, success: { (result) in
            let data = result["data"] as! [[String: AnyObject]]
            self.dataArr = LabelModel.modelsWithArray(modelArray: data) as! [LabelModel]
            self.refreshUI()
        })
    }
    func refreshUI() {
        var maxX: CGFloat = 15
        var maxY: CGFloat = 15
        for i in 0..<dataArr.count {
            setupLabelButton(index: i, title: "# " + dataArr[i].name! + " #", xX: &maxX, yY: &maxY)
        }
        scrollView.contentSize = CGSize(width: kScreenWidth, height: maxY + 31 + 15)
    }
    func setupLabelButton(index: Int, title: String, xX: inout CGFloat, yY: inout CGFloat) {
        let width = CGFloat(title.characters.count) * 14 + 10
        if width + xX > kScreenWidth - 15 {
            xX = 15
            yY += 31 + 15
        }
        let btn = UIButton(frame: CGRect(x: xX, y: yY, width: width, height: 31))
        btn.tag = 100 + index
        xX += btn.frame.width + 15
        btn.setTitle(title, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.setTitleColor(UIColor(hexString: "#666666"), for: .normal)
        btn.setTitle(title, for: .selected)
        btn.setTitleColor(themeColor, for: .selected)
        btn.addTarget(self, action: #selector(LabelChoiceViewController.labelButtonAction(btn:)), for: .touchUpInside)
        btn.backgroundColor = UIColor.white
        btn.layer.cornerRadius = 15
        btn.layer.masksToBounds = true
        btn.layer.borderColor = UIColor(hexString: "#666666").cgColor
        btn.layer.borderWidth = 1
        scrollView.addSubview(btn)
    }
    func labelButtonAction(btn: UIButton) {
        
        if selectedBtns.contains(btn) {
            selectedBtns.remove(at: selectedBtns.index(of: btn)!)
        }
        if selectedBtns.count == 2 {
            ProgressHUD.showNoticeOnStatusBar(message: "只能选择两个标签哦！")
            return
        }
        
        btn.isSelected = !btn.isSelected
        
        if btn.isSelected {
            btn.isSelected = true
            btn.layer.borderColor = themeColor.cgColor
            selectedBtns.append(btn)
        } else {
            btn.isSelected = false
            btn.layer.borderColor = UIColor(hexString: "#666666").cgColor
        }
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
class LabelModel: KeyValueModel {
    var lebel_id: String?
    var name: String?
    var remark: String?
}
