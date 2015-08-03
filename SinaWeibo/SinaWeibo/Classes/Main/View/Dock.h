//
//  Dock.h
//  SinaWeibo
//
//  Created by orange on 15/6/16.
//  Copyright (c) 2015年 orange. All rights reserved.
//  底部工具条 选项卡

#import <UIKit/UIKit.h>

@class Dock;

@protocol DockDelegate <NSObject>
@optional
- (void)dock:(Dock *)dock itemSelectedFrom:(int)from to:(int)to;
@end

@interface Dock : UIView
//添加一个选项卡
-(void)addItemWithIcon:(NSString *)icon selectedIcon:(NSString *)selected title:(NSString *)title;

@property (nonatomic,weak) id<DockDelegate> delegate;
@property (nonatomic,assign) int selectedIndex;
@end
