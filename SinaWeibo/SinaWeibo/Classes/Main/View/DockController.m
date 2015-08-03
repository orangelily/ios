//
//  DockController.m
//  测试QQ
//
//  Created by orange on 15/7/29.
//  Copyright (c) 2015年 orange. All rights reserved.
//

#import "DockController.h"
//#import "Dock.h"
#define kDockHeight 44

@interface DockController() <DockDelegate>

@end

@implementation DockController
-(void)viewDidLoad{
    [self addDock];
}

#pragma mark 添加dock
-(void)addDock{
    Dock *dock = [[Dock alloc]init];
    
    dock.frame = CGRectMake(0, self.view.frame.size.height-kDockHeight, self.view.frame.size.width, kDockHeight);
    dock.delegate=self;
    [self.view addSubview:dock];
    _dock = dock;
    
}

#pragma mark dock的代理方法
- (void)dock:(Dock *)dock itemSelectedFrom:(int)from to:(int)to
{
    NSLog(@"-----%d  %d",from,to);
    if(to<0||to>=self.childViewControllers.count) return;
    
    //3.移除旧控制器的view
    UIViewController *oldVc = self.childViewControllers[from];
    [oldVc.view removeFromSuperview];
    
    //1.取出即将显示的控制器
    UIViewController *newVc=self.childViewControllers[to];
    //设置显示位置
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height-kDockHeight;
    newVc.view.frame = CGRectMake(0, 0, width, height);
    //    NSLog(@"newVc.view%@",newVc.view);
    //2.添加新控制器的view到MainController上面
    [self.view addSubview:newVc.view];
    
}
@end
