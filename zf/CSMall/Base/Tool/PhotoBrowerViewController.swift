//
//  PhotoBrowerViewController.swift
//  Yesho
//
//  Created by innouni on 16/12/16.
//  Copyright © 2016年 luiz. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class PhotoBrowerViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var indexLabel: UILabel!
    var userID: String!
    var currentIndex = 0
    
    var dataArr: Array<Any> = [] // 只能是image或者图片地址
    // 兼容 iOS 8.0
    init() {
        super.init(nibName: "PhotoBrowerViewController", bundle: Bundle.main)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "图片浏览"
        
        self.flowLayout.itemSize = CGSize(width: kScreenWidth, height: kScreenHeight)
        self.collectionView.register(PhotoBrowerCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        self.pageControl.currentPage = currentIndex
        self.indexLabel.text = "\(currentIndex + 1)/\(dataArr.count)"
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(PhotoBrowerViewController.dismissSelf))
        self.view.addGestureRecognizer(tap)
    }
    override func viewDidLayoutSubviews() {
        self.collectionView.scrollToItem(at: IndexPath.init(row: currentIndex, section: 0), at: .centeredHorizontally, animated: false)
    }
    func dismissSelf() {
        self.dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - colllection view 数据源
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.pageControl.numberOfPages = self.dataArr.count
        return self.dataArr.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PhotoBrowerCell
        cell.model = self.dataArr[indexPath.row]
        return cell
    }
    // MARK: - colllection view 代理
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.pageControl.currentPage = Int(scrollView.contentOffset.x / kScreenWidth)
        self.currentIndex = self.pageControl.currentPage
        self.indexLabel.text = "\(currentIndex + 1)/\(dataArr.count)"
    }
    @IBAction func reportButtonAction(_ sender: UIButton) {
        let param = ["user_id":self.userID!,"why":"图片违规"]
        NetworkingHandle.fetchNetworkData(url: "User/report", at: self, params: param,  success: { (response) in
            ProgressHUD.showSuccess(message: "举报成功")
        }, failure: {
            
        })

    }
}
// cell
class PhotoBrowerCell: UICollectionViewCell, UIScrollViewDelegate {
    
    var imgView: UIImageView!
    var scrollView: UIScrollView!
    var reportBtn: UIButton!
    var model: Any? {
        willSet(m) {
            if m is String {
                self.imgView.kf.setImage(with: URL(string: m as! String))
            } else if m is UIImage {
                self.imgView.image = m as! UIImage?
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.scrollView = UIScrollView(frame: self.bounds)
        self.scrollView.contentSize = self.bounds.size
        self.contentView.addSubview(self.scrollView)
        self.imgView = UIImageView(frame: self.bounds)
        self.imgView.contentMode = .scaleAspectFit
        self.scrollView.addSubview(self.imgView)
        
        self.scrollView.delegate = self
        self.scrollView.maximumZoomScale = 3
        self.scrollView.minimumZoomScale = 0.5
        self.scrollView.isMultipleTouchEnabled = true
        
        let longTap = UILongPressGestureRecognizer(target: self, action: #selector(PhotoBrowerCell.savePictrue))
        
        self.addGestureRecognizer(longTap)
    }
    // 保存图片
    func savePictrue() {
        if let img = imgView.image {
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let action = UIAlertAction(title: "保存到相册", style: .default) { (a) in
                let state = PHPhotoLibrary.authorizationStatus()
                if state == .authorized {
                    UIImageWriteToSavedPhotosAlbum(img, self, #selector(self.image(image:didFinishSavingWithError:contextInfo:)), nil)
                } else {
                    self.deviceDisable(dis: "相册")
                }
            }
            let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            alert.addAction(action)
            alert.addAction(cancel)
            self.responderViewController()?.present(alert, animated: true, completion: nil)
        }
    }
    func deviceDisable(dis: String) {
        let alertVC = UIAlertController(title: nil, message: "请在iPhone的\"设置\"中，允许APP访问您的\(dis)。", preferredStyle: .alert)
        let ok = UIAlertAction(title: "去设置", style: .default, handler: { [unowned self] (alertAction) in
            self.openSettings()
        })
        let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alertVC.addAction(cancel)
        alertVC.addAction(ok)
        self.responderViewController()?.present(alertVC, animated: true, completion: nil)
    }
    func openSettings() {
        let settingsURL: URL = URL(string: UIApplicationOpenSettingsURLString)!
        UIApplication.shared.openURL(settingsURL)
    }
    func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: AnyObject) {
        if error != nil {
            ProgressHUD.showNoticeOnStatusBar(message: "保存失败")
        } else {
            ProgressHUD.showSuccess(message: "保存成功")
        }
    }
    // MARK: - scroll view 代理
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imgView
    }
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let offsetX = scrollView.bounds.width > scrollView.contentSize.width ? (scrollView.bounds.width - scrollView.contentSize.width) * 0.5 : 0
        let offsetY = scrollView.bounds.height > scrollView.contentSize.height ? (scrollView.bounds.height - scrollView.contentSize.height) * 0.5 : 0
        self.imgView.center = CGPoint(x: scrollView.contentSize.width * 0.5 + offsetX, y: scrollView.contentSize.height * 0.5 + offsetY)
    }
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        scrollView.setZoomScale(scale, animated: false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}




