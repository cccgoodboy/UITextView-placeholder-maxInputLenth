//
//  UIImage+THAdditions.h
//  Onthecollar
//
//  Created by CuiFeng on 15/11/12.
//  Copyright © 2015年 Stoney. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (THAdditions)

/**
 *  保存图片到临时文件夹
 *
 *  @return 图片路径 compressionQuality默认0.5
 */
- (NSString *)saveToLocalTempFolder;

/**
 *  保存图片到临时文件夹
 *
 *  @param compressionQuality 压缩比例
 *
 *  @return  
 */
- (NSString *)saveToLocalTempFolderWithCompressionQuality:(CGFloat) compressionQuality;

/**
 *  清理本地图片文件夹
 */
+ (void)cleanLocalTmpFolder;

- (UIImage *)resizedImageWithWidth:(CGFloat)width;
- (UIImage *) imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size;
- (UIImage *) imageCompressForWidth:(CGFloat)defineWidth;
@end
