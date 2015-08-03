//
//  UIImage+Addtion.h
//  SinaWeibo
//
//  Created by orange on 15/6/15.
//  Copyright (c) 2015年 orange. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Addtion)
#pragma mark 加载全屏的图片
+ (UIImage *)fullscreenImage:(NSString *)imgName;

#pragma mark 可以自由拉伸的图片
+ (UIImage *)resizeImage:(NSString *)imgName;
@end
