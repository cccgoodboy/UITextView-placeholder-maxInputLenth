//
//  SwiftTableViewCell.swift
//  tableView动态行高
//
//  Created by 戴维保 on 2017/4/19.
//  Copyright © 2017年 daiweibao. All rights reserved.
//

import UIKit

class CommentTabCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, UIAlertViewDelegate {

    let CollectViewCellheight = (kScreenWidth - 3*5 - 56)/4
    //用户头像
    private lazy var imageHead:UIImageView = UIImageView()
    //用户昵称
    private lazy var labelTitle:UILabel = UILabel()
    
    //星级
    private lazy var startImg:UIView = UIView()
    private lazy var start:[UIImageView] = [UIImageView(),UIImageView(),UIImageView(),UIImageView(),UIImageView()]
    //图片
//    let layout =
    private lazy var imagePhone : UICollectionView = UICollectionView.init(frame: CGRect.init(), collectionViewLayout: UICollectionViewFlowLayout())
    //内容
    private lazy var labelContronter : UILabel = UILabel()
    
    //封面数据
    var images:[String] = []
    //时间
    private lazy var labelTime:UILabel = UILabel()

    fileprivate var browser: LLPhotoBrowserViewController?

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        //创建UI
        self.InitUI()
    }
    
    
    fileprivate func InitUI(){
        
        imageHead.layer.cornerRadius = 13
        imageHead.layer.masksToBounds = true
        contentView.addSubview(imageHead)
        imageHead.snp.makeConstraints { (make) in
            make.top.equalTo(contentView).offset(8)
            make.left.equalTo(10)
            make.width.height.equalTo(26)
        }
        
        //标题 【重点】必须在创建第一块控件的时候约束：contentView
        labelTitle.numberOfLines = 0
        labelTitle.backgroundColor = UIColor.white
        labelTitle.font = UIFont.systemFont(ofSize: 14)
        contentView.addSubview(labelTitle)
        labelTitle.snp.makeConstraints({ (make) in
            
            make.top.equalTo(contentView).offset(13)
            make.left.equalTo(imageHead.snp.right).offset(10)
            make.right.equalTo(-10)
        })
      
        for item in start.indices {
            start[item].image = #imageLiteral(resourceName: "fabupingjia_xing_hui")
            start[item].frame = CGRect.init(x: item*25, y: 0, width: 20, height: 20)
            startImg.addSubview(start[item])
        }
        contentView.addSubview(startImg)
        startImg.snp.makeConstraints { (make) in
            make.top.equalTo(labelTitle.snp.bottom).offset(3)
            make.left.equalTo(labelTitle.snp.left)
            make.height.equalTo(20)
            make.width.equalTo(200)
        }
        
        //内容 【重点】必须在创建最后一块控件的时候约束：contentView
        contentView.addSubview(labelContronter)
        labelContronter.isUserInteractionEnabled = true
        labelContronter.font = UIFont.systemFont(ofSize: 12)
        //添加点击手势
        let tapGesture = UITapGestureRecognizer(target: self, action:#selector(Actionbuton))
        labelContronter.addGestureRecognizer(tapGesture)
        labelContronter.numberOfLines = 0
        labelContronter.textColor = UIColor.init(hexString: "666666")
        labelContronter.snp.makeConstraints { (make) in
            make.top.equalTo(startImg.snp.bottom).offset(15)
            make.left.equalTo(labelTitle.snp.left)
            make.right.equalTo(-10)
        }
        
        imagePhone.translatesAutoresizingMaskIntoConstraints = false
        imagePhone.backgroundColor = UIColor.white
        imagePhone.delegate = self
        imagePhone.dataSource = self
        imagePhone.register(UINib.init(nibName: "CommentCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CommentCollectionViewCell")
        contentView.addSubview(imagePhone)
        imagePhone.snp.makeConstraints { (make) in
            make.top.equalTo(labelContronter.snp.bottom).offset(10)
            make.left.equalTo(labelTitle.snp.left)
            make.right.equalTo(-10)
            make.height.equalTo(CollectViewCellheight)
//            make.bottom.equalTo(labelTime).offset(-10)
        }
        
        labelTime.font = UIFont.systemFont(ofSize: 14)
        contentView.addSubview(labelTime)
        labelTime.snp.makeConstraints { (make) in
            make.top.equalTo(imagePhone.snp.bottom).offset(15)
            make.bottom.equalTo(contentView).offset(-10)
            make.left.equalTo(labelTitle.snp.left)
            make.width.equalTo(280)
        }
    }
    
    func Actionbuton() {
        print("点击了label")
    }
    
    //控制器传过来的值赋值
    internal func getTitle(model:CommentDescModel){
        // getTitle(contain:String,index:Int,image:[String]){
        
        labelTitle.text = model.username//昵称
        imageHead.sd_setImage(with: URL.init(string: model.header_img ?? ""), placeholderImage: #imageLiteral(resourceName: "moren-2"))//头像
        labelTime.text = model.create_time
    
       /******************评价星星展示数**********************/

        let a = max(0, Int(model.mark ?? "0")!)
            startImg.isHidden = a == 0 ? true: false
        for i in 0..<5{
            if i < max(0, Int(model.mark ?? "0")!){
                start[i].image = #imageLiteral(resourceName: "quanbupingjiajia_xing_cheng")
            }else{
                start[i].image = #imageLiteral(resourceName: "fabupingjia_xing_hui")
            }
        }
        var num = 0
        if model.img.count%4 > 0{
           num = model.img.count/4 + 1
        }else{
          num = model.img.count/4
        }
        
         //更新collectionView的高度约束
        let imagesHeight:CGFloat = CGFloat(num) * (CollectViewCellheight + 5);
        
        imagePhone.snp.updateConstraints { (make) in
            make.height.equalTo(imagesHeight)
        }
        labelContronter.text = model.comment_desc//评论内容
        self.images =  model.img
        //collectionView重新加载数据
        self.imagePhone.reloadData()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("images ==\(images.count)")
        return  images.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CommentCollectionViewCell", for: indexPath) as! CommentCollectionViewCell
        cell.comimage.sd_setImage(with: URL.init(string: images[indexPath.row]), placeholderImage: #imageLiteral(resourceName: "moren-2"))
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: CollectViewCellheight, height: CollectViewCellheight)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var data: [LLBrowserModel] = []
        for index in 0..<images.count {
            let cell: CommentCollectionViewCell? = collectionView.cellForItem(at: IndexPath.init(row: index, section: 0)) as? CommentCollectionViewCell
            let model = LLBrowserModel.init()
            model.data = images[index]
            if let c = cell {
                model.sourceImageView = c.comimage
            }
            
            data.append(model)
        }
        
        browser = LLPhotoBrowserViewController.init(photoArray: data, currentIndex: indexPath.row, sheetTitileArray: ["保存到相册"], isOpenQRCodeCheck: true) { (index, imageView, qrcodeString) in
            print("ActionSheet点击-->下标=\(index); ImageView:\(imageView); qrcodeString:\(String(describing: qrcodeString))")
            
//            if let qrcode = qrcodeString {
//                UIAlertView.init(title: "二维码地址", message: qrcode, delegate: self, cancelButtonTitle: "跳转").show()
//            }
            
        }
        
        // ActionSheet Custom
        // browser?.actionSheetCellBackgroundColor = UIColor.brown
        // browser?.actionSheetBackgroundColor = UIColor.red
        // browser?.actionSheetCellHeight = 50
        // browser?.actionSheetCancelTextColor = UIColor.yellow
        // browser?.actionSheetCancelTitle = "Cancel"
     responderViewController()?.present(browser!, animated: true, completion: nil)

//        browser?.presentBrowserViewController()
    }
    // MARK: UIAlertViewDelegate
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        browser?.dismiss(animated: false, completion: {
//            self.navigationController?.pushViewController(LLSecondViewController(), animated: true)
        })
    }
    
}
