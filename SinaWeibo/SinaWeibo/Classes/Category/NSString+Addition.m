//
//  NSString+NSString.m
//  SinaWeibo
//
//  Created by orange on 15/6/16.
//  Copyright (c) 2015年 orange. All rights reserved.
//

#import "NSString+Addition.h"

@implementation NSString (Addition)


- (NSString *)fileAppend:(NSString *)append
{
    NSString *ext = [self pathExtension];
    //1.2 删除后面的拓展名
    NSString *imgName = [self stringByDeletingPathExtension];
    //1.3 拼接－568h@2x
    //NSLog(@"imgName:%@",imgName);
    imgName = [imgName stringByAppendingString:append];
    //1.4 拼接拓展名
    
    return [imgName stringByAppendingPathExtension:ext];
}

@end
