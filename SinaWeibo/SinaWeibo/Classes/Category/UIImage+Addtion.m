//
//  UIImage+Addtion.m
//  SinaWeibo
//
//  Created by orange on 15/6/15.
//  Copyright (c) 2015年 orange. All rights reserved.
//
/**
 *  prefix header文件是被那些大量使用 以及 几乎所有系统中的文件都需要被使用（例如 Foundation.h）。
 如果 你有一些东西大量存在，你应该重新思考你的架构问题你。
 因为 当你修改你prefix header的一些代码的时候，
 prefix header导致整个项目重新编译，这让你的代码重用变得困难，
 并且导致一些琐碎build的问题。所以 不要去使用prefix header
 这样可以避免你大量的重新编译整个项目的时间
 */


#import "UIImage+Addtion.h"
#import "NSString+Addition.h"

@implementation UIImage (Addtion)
//new_feature_%d.png
#pragma mark - 加载全屏的图片 属于分类  新建文件夹实现功能
+ (UIImage *)fullscreenImage:(NSString *)imgName
{
    //if iPhone5 宏定义
    //if ([UIScreen mainScreen].bounds .size.height == 568) {
    if(iPhone5){
        //1.1 获得文件拓展名
        imgName = [imgName fileAppend:@"-568h@2x"];
        
    }
    
    NSLog(@"imgName:%@",imgName);
    //2 加载图片
    return [self imageNamed:imgName];
}


#pragma mark 可以自由拉伸的图片
+ (UIImage *)resizeImage:(NSString *)imgName{
    UIImage *img = [UIImage imageNamed:imgName];
    return [img stretchableImageWithLeftCapWidth:img.size.width*0.6 topCapHeight:img.size.height*0.5];
//    img
}
@end
