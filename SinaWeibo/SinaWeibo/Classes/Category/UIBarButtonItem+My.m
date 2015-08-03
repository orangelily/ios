//
//  UIBarButtonItem+My.m
//  SinaWeibo
//
//  Created by orange on 15/7/28.
//  Copyright (c) 2015年 orange. All rights reserved.
//

#import "UIBarButtonItem+My.h"

@implementation UIBarButtonItem (My)
-(id)initWithIcon:(NSString *)icon highlightedIcon:(NSString *)highlighted target:(id)target action:(SEL)action{
    //    2.左边的item
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [UIImage imageNamed:icon];
    //    设置普通背景图片
    [btn setBackgroundImage:image forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:highlighted] forState:UIControlStateHighlighted];
    //设置宽高显示图片
    btn.bounds = (CGRect){CGPointZero,image.size};
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [self initWithCustomView:btn];
}

+(id)itemWithIcon:(NSString *)icon highlightedIcon:(NSString *)highlighted target:(id)target action:(SEL)action{
   
    return [[self alloc]initWithIcon:icon highlightedIcon:highlighted target:target action:action];

}
@end
