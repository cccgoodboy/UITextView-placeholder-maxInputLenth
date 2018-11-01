//
//  HXDatePhotoToolsManager.m
//  微博照片选择
//
//  Created by 洪欣 on 2017/11/2.
//  Copyright © 2017年 洪欣. All rights reserved.
//

#import "HXDatePhotoToolManager.h"
#import "UIImage+HXExtension.h"

@interface HXDatePhotoToolManager ()
@property (copy, nonatomic) HXDatePhotoToolManagerSuccessHandler successHandler;
@property (copy, nonatomic) HXDatePhotoToolManagerFailedHandler failedHandler;
@property (strong, nonatomic) NSMutableArray *allURL;
@property (strong, nonatomic) NSMutableArray *photoURL;
@property (strong, nonatomic) NSMutableArray *videoURL;
@property (strong, nonatomic) NSMutableArray *writeArray;
@property (strong, nonatomic) NSMutableArray *waitArray;
@property (strong, nonatomic) NSMutableArray *allArray;
@end

@implementation HXDatePhotoToolManager


- (void)writeSelectModelListToTempPathWithList:(NSArray<HXPhotoModel *> *)modelList success:(HXDatePhotoToolManagerSuccessHandler)success failed:(HXDatePhotoToolManagerFailedHandler)failed {
    self.successHandler = success;
    self.failedHandler = failed;
    
    [self.allURL removeAllObjects];
    [self.photoURL removeAllObjects];
    [self.videoURL removeAllObjects];
    
    self.allArray = [NSMutableArray array];
    for (HXPhotoModel *model in modelList) {
        [self.allArray insertObject:model atIndex:0];
    }
    self.waitArray = [NSMutableArray arrayWithArray:self.allArray];
    [self writeModelToTempPath];
}

- (void)writeModelToTempPath {
    if (self.waitArray.count == 0) {
        NSSLog(@"全部压缩成功");
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.successHandler) {
                self.successHandler(self.allURL, self.photoURL, self.videoURL);
            }
        });
        return;
    }
    self.writeArray = [NSMutableArray arrayWithObjects:self.waitArray.lastObject, nil];
    [self.waitArray removeLastObject];
    HXPhotoModel *model = self.writeArray.firstObject;
    __weak typeof(self) weakSelf = self;
    if (model.type == HXPhotoModelMediaTypeVideo) {
        [HXPhotoTools getAVAssetWithPHAsset:model.asset startRequestIcloud:^(PHImageRequestID cloudRequestId) {
            
        } progressHandler:^(double progress) {
            
        } completion:^(AVAsset *asset) {
            [weakSelf compressedVideoWithMediumQualityWriteToTemp:asset progress:^(float progress) {
                
            } success:^(NSURL *url) {
                [weakSelf.allArray removeObject:weakSelf.writeArray.firstObject];
                [weakSelf.allURL addObject:url];
                [weakSelf.videoURL addObject:url];
                [weakSelf writeModelToTempPath];
            } failure:^{
                if (weakSelf.failedHandler) {
                    weakSelf.failedHandler();
                }
            }];
        } failed:^(NSDictionary *info) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (weakSelf.failedHandler) {
                    weakSelf.failedHandler();
                }
            });
        }];
    }else if (model.type == HXPhotoModelMediaTypeCameraVideo) {
        [self compressedVideoWithMediumQualityWriteToTemp:model.videoURL progress:^(float progress) {
            
        } success:^(NSURL *url) {
            [weakSelf.allArray removeObject:weakSelf.writeArray.firstObject];
            [weakSelf.allURL addObject:url];
            [weakSelf.videoURL addObject:url];
            [weakSelf writeModelToTempPath];
        } failure:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                if (weakSelf.failedHandler) {
                    weakSelf.failedHandler();
                }
            });
        }];
    }else if (model.type == HXPhotoModelMediaTypeCameraPhoto) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData *imageData = UIImageJPEGRepresentation(model.thumbPhoto, 0.8);
            NSString *fileName = [[self uploadFileName] stringByAppendingString:[NSString stringWithFormat:@".jpeg"]];
            
            NSString *fullPathToFile = [NSTemporaryDirectory() stringByAppendingPathComponent:fileName];
            
            if ([imageData writeToFile:fullPathToFile atomically:YES]) {
                [self.allArray removeObject:weakSelf.writeArray.firstObject];
                [self.allURL addObject:[NSURL fileURLWithPath:fullPathToFile]];
                [self.photoURL addObject:[NSURL fileURLWithPath:fullPathToFile]];
                [self writeModelToTempPath];
            }else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (self.failedHandler) {
                        self.failedHandler();
                    }
                });
            }
        });
    }else if (model.type == HXPhotoModelMediaTypePhotoGif) {
        [HXPhotoTools getImageData:model.asset startRequestIcloud:^(PHImageRequestID cloudRequestId) {
            
        } progressHandler:^(double progress) {
            
        } completion:^(NSData *imageData, UIImageOrientation orientation) {
            NSString *fileName = [[self uploadFileName] stringByAppendingString:[NSString stringWithFormat:@".gif"]];
            
            NSString *fullPathToFile = [NSTemporaryDirectory() stringByAppendingPathComponent:fileName];
            
            if ([imageData writeToFile:fullPathToFile atomically:YES]) {
                [weakSelf.allArray removeObject:weakSelf.writeArray.firstObject];
                [weakSelf.allURL addObject:[NSURL fileURLWithPath:fullPathToFile]];
                [weakSelf.photoURL addObject:[NSURL fileURLWithPath:fullPathToFile]];
                [weakSelf writeModelToTempPath];
            }else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (weakSelf.failedHandler) {
                        weakSelf.failedHandler();
                    }
                });
            }
        } failed:^(NSDictionary *info) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (weakSelf.failedHandler) {
                    weakSelf.failedHandler();
                }
            });
        }];
    }else {
        CGSize size = CGSizeZero;
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        CGFloat height = [UIScreen mainScreen].bounds.size.height;
        CGFloat imgWidth = model.imageSize.width;
        CGFloat imgHeight = model.imageSize.height; 
        if (imgHeight > imgWidth / 9 * 17) {
            size = CGSizeMake(width, height);
        }else {
            size = CGSizeMake(model.endImageSize.width * 1.5, model.endImageSize.height * 1.5);
        }
        [HXPhotoTools getHighQualityFormatPhoto:model.asset size:size startRequestIcloud:^(PHImageRequestID cloudRequestId) {
            
        } progressHandler:^(double progress) {
            
        } completion:^(UIImage *image) {
            if (image.imageOrientation != UIImageOrientationUp) {
                image = [image normalizedImage];
            }
            NSData *imageData;
            NSString *suffix;
            if (UIImagePNGRepresentation(image)) {
                //返回为png图像。
                imageData = UIImagePNGRepresentation(image);
                suffix = @"png";
            }else {
            //返回为JPEG图像。
                imageData = UIImageJPEGRepresentation(image, 0.8);
                suffix = @"jpeg";
            }
         
            NSString *fileName = [[self uploadFileName] stringByAppendingString:[NSString stringWithFormat:@".%@",suffix]];
            
            NSString *fullPathToFile = [NSTemporaryDirectory() stringByAppendingPathComponent:fileName];
            
            if ([imageData writeToFile:fullPathToFile atomically:YES]) {
                [weakSelf.allArray removeObject:weakSelf.writeArray.firstObject];
                [weakSelf.allURL addObject:[NSURL fileURLWithPath:fullPathToFile]];
                [weakSelf.photoURL addObject:[NSURL fileURLWithPath:fullPathToFile]];
                [weakSelf writeModelToTempPath];
            }else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (weakSelf.failedHandler) {
                        weakSelf.failedHandler();
                    }
                });
            }
        } failed:^(NSDictionary *info) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (weakSelf.failedHandler) {
                    weakSelf.failedHandler();
                }
            });
        }];
    }
}

- (AVAssetExportSession *)compressedVideoWithMediumQualityWriteToTemp:(id)obj progress:(void (^)(float progress))progress success:(void (^)(NSURL *url))success failure:(void (^)())failure {
    AVAsset *avAsset;
    if ([obj isKindOfClass:[AVAsset class]]) {
        avAsset = obj;
    }else {
        avAsset = [AVURLAsset URLAssetWithURL:obj options:nil];
    }
    
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    if ([compatiblePresets containsObject:AVAssetExportPresetHighestQuality]) {
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPresetHighestQuality];
        
        NSString *fileName = [[self uploadFileName] stringByAppendingString:@".mp4"];
        NSString *fullPathToFile = [NSTemporaryDirectory() stringByAppendingPathComponent:fileName];
        NSURL *videoURL = [NSURL fileURLWithPath:fullPathToFile];
        exportSession.outputURL = videoURL;
        exportSession.outputFileType = AVFileTypeMPEG4;
        exportSession.shouldOptimizeForNetworkUse = YES;
        
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            if ([exportSession status] == AVAssetExportSessionStatusCompleted) {
                if (success) {
                    success(videoURL);
                }
            }else if ([exportSession status] == AVAssetExportSessionStatusFailed){
                if (failure) {
                    failure();
                }
            }else if ([exportSession status] == AVAssetExportSessionStatusCancelled) {
                if (failure) {
                    failure();
                }
            }
        }];
        return exportSession;
    }else {
        if (failure) {
            failure();
        }
        return nil;
    }
}
- (NSString *)uploadFileName {
    NSString *fileName = @"";
    NSDate *nowDate = [NSDate date];
    NSString *dateStr = [NSString stringWithFormat:@"%ld", (long)[nowDate timeIntervalSince1970]];
    
    NSString *numStr = [NSString stringWithFormat:@"%d",arc4random()%10000];
    
    fileName = [fileName stringByAppendingString:@"hx"];
    fileName = [fileName stringByAppendingString:dateStr];
    fileName = [fileName stringByAppendingString:numStr];
    return fileName;
}
- (NSMutableArray *)allURL {
    if (!_allURL) {
        _allURL = [NSMutableArray array];
    }
    return _allURL;
}
- (NSMutableArray *)photoURL {
    if (!_photoURL) {
        _photoURL = [NSMutableArray array];
    }
    return _photoURL;
}
- (NSMutableArray *)videoURL {
    if (!_videoURL) {
        _videoURL = [NSMutableArray array];
    }
    return _videoURL;
}
- (NSMutableArray *)writeArray {
    if (!_writeArray) {
        _writeArray = [NSMutableArray array];
    }
    return _writeArray;
}
- (NSMutableArray *)waitArray {
    if (!_waitArray) {
        _waitArray = [NSMutableArray array];
    }
    return _waitArray;
}
@end
