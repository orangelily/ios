//
//  DockItem.m
//  SinaWeibo
//
//  Created by orange on 15/6/16.
//  Copyright (c) 2015年 orange. All rights reserved.
//

#import "DockItem.h"

//文字高度比例
#define kTitleRatio 0.3

#define kDockItemSelectedBG @"tabbar_slider.png"


@implementation DockItem

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //1.文字居中、大小
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:12];
        
        //2.图片的内容模式
        self.imageView.contentMode = UIViewContentModeCenter;
        //3.设置选中背景图片
        [self setBackgroundImage:[UIImage imageNamed:kDockItemSelectedBG] forState:UIControlStateSelected];
    }
    return self;
}

#pragma mark 覆盖父类
-(void)setHighlighted:(BOOL)highlighted{
    //    [super setHighlighted:highlighted];
}

#pragma mark 调整内部ImageView的frame
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageX=0;
    CGFloat imageHeight = contentRect.size.height*(1-kTitleRatio);
    CGFloat imageY = 0;
    CGFloat imageWidth = contentRect.size.width;
    return CGRectMake(imageX, imageY, imageWidth, imageHeight);
    
}


#pragma mark 调整内部UILable的frame
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleX = 0;
    CGFloat titleHeight = contentRect.size.height*kTitleRatio;
    CGFloat titleY = contentRect.size.height-titleHeight;
    CGFloat titleWidth = contentRect.size.width;
    return CGRectMake(titleX, titleY, titleWidth, titleHeight);
}




@end
