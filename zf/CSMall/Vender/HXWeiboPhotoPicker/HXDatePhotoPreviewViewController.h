//
//  HXDatePhotoPreviewViewController.h
//  微博照片选择
//
//  Created by 洪欣 on 2017/10/14.
//  Copyright © 2017年 洪欣. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PhotosUI/PhotosUI.h>
#import "HXPhotoManager.h"

@class HXDatePhotoPreviewViewController,HXDatePhotoPreviewBottomView,HXDatePhotoPreviewViewCell,HXPhotoView;
@protocol HXDatePhotoPreviewViewControllerDelegate <NSObject>
@optional
- (void)datePhotoPreviewControllerDidSelect:(HXDatePhotoPreviewViewController *)previewController model:(HXPhotoModel *)model;
- (void)datePhotoPreviewControllerDidDone:(HXDatePhotoPreviewViewController *)previewController;
@end

@interface HXDatePhotoPreviewViewController : UIViewController<UINavigationControllerDelegate,UIViewControllerTransitioningDelegate>
@property (weak, nonatomic) id<HXDatePhotoPreviewViewControllerDelegate> delegate;
@property (strong, nonatomic) HXPhotoManager *manager;
@property (strong, nonatomic) NSMutableArray *modelArray;
@property (assign, nonatomic) NSInteger currentModelIndex;
@property (assign, nonatomic) BOOL outside;
@property (assign, nonatomic) BOOL selectPreview;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) HXDatePhotoPreviewBottomView *bottomView;
@property (strong, nonatomic) HXPhotoView *photoView;
- (HXDatePhotoPreviewViewCell *)currentPreviewCell:(HXPhotoModel *)model;
@end


@interface HXDatePhotoPreviewViewCell : UICollectionViewCell
@property (strong, nonatomic) HXPhotoModel *model;
@property (strong, nonatomic, readonly) UIImageView *imageView;
@property (strong, nonatomic, readonly) UIImage *gifImage;
@property (assign, nonatomic) BOOL dragging;
@property (nonatomic, copy) void (^cellTapClick)();

- (void)resetScale;
- (void)requestHDImage;
- (void)cancelRequest;
@end
