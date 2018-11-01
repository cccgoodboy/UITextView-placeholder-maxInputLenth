//
//  HXPhotoPreviewViewCell.h
//  微博照片选择
//
//  Created by 洪欣 on 17/2/9.
//  Copyright © 2017年 洪欣. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXPhotoModel.h"
#import <PhotosUI/PhotosUI.h>
@interface HXPhotoPreviewViewCell : UICollectionViewCell
@property (strong, nonatomic) HXPhotoModel *model;
@property (strong, nonatomic, readonly) UIImageView *imageView;
@property (strong, nonatomic, readonly) PHLivePhotoView *livePhotoView;
@property (assign, nonatomic) BOOL isAnimating;
@property (assign, nonatomic, readonly) PHImageRequestID requestID;
@property (assign, nonatomic, readonly) PHImageRequestID longRequestId;
@property (assign, nonatomic, readonly) PHImageRequestID liveRequestID;
@property (strong, nonatomic) UIImage *firstImage;
- (void)startLivePhoto;
- (void)stopLivePhoto;
- (void)startGifImage;
- (void)stopGifImage;
- (void)fetchLongPhoto;
@end
