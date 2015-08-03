//
//  MainController.m
//  SinaWeibo
//
//  Created by orange on 15/6/15.
//  Copyright (c) 2015年 orange. All rights reserved.
//
#import "HomeController.h"
#import "MoreController.h"
#import "MeController.h"
#import "MessageController.h"
#import "SquareController.h"
#import "MyNavigationController.h"
#import "MainController.h"

@implementation MainController

- (void)viewDidLoad {
    [super viewDidLoad];
//self.view.
    
       //3.添加其他控制器
    //tabbar
    //    UITabBarController *tab=nil;
    //    tab.childViewControllers//readonly
    //    tab.viewControllers = @[vc1,vc2,vc3];
    //    [tab addChildViewController:vc1];
    //    [tab addChildViewController:vc2];
    //3.初始化所有子控制器 self在 子控件就存在
    [self addAllChildControllers];
    
    //1. Add Dock————————先写controller再写dock 实现默认dock选中
    [self addMyDock];
    
    }

#pragma mark 初始化所有的子控制器
-(void)addAllChildControllers{
    //3.1home
    HomeController *home = [[HomeController alloc]init];
    //    home.view.backgroundColor = [UIColor blueColor];
    //    导航控制器
    MyNavigationController *navHome = [[MyNavigationController alloc]initWithRootViewController:home];
    //    [self addChildViewController:home];
    [self addChildViewController:navHome];
    
    //3.2消息
    //    UIViewController *msg = [[UIViewController alloc]init];
    MessageController *msg = [[MessageController alloc]init];
    //    msg.title=@"消息";
    //    msg.view.backgroundColor = [UIColor clearColor];
    //    导航控制器
    MyNavigationController *navMsg = [[MyNavigationController alloc]initWithRootViewController:msg];
    [self addChildViewController:navMsg];
    //    [self addChildViewController:msg];
    
    //3.3我
    //    UIViewController *me = [[UIViewController alloc]init];
    MeController *me = [[MeController alloc]init];
    //    me.title=@"我";
    //    me.view.backgroundColor = [UIColor whiteColor];
    //    导航控制器
    MyNavigationController *navMe = [[MyNavigationController alloc]initWithRootViewController:me];
    [self addChildViewController:navMe];
    // [self addChildViewController:me];
    
    //3.4广场
    //    UIViewController *square = [[UIViewController alloc]init];
    SquareController *square = [[SquareController alloc]init];
    //    square.title=@"广场";
    //    square.view.backgroundColor = [UIColor lightGrayColor];
    //    导航控制器
    MyNavigationController *navSquare = [[MyNavigationController alloc]initWithRootViewController:square];
    [self addChildViewController:navSquare];
    // [self addChildViewController:square];
    
    //3.5更多
//    MoreController *more = [[MoreController alloc]init];
    MoreController *more = [[MoreController alloc]initWithStyle:UITableViewStyleGrouped];
    //    more.view.backgroundColor = [UIColor magentaColor];
    //    导航控制器
    MyNavigationController *navMore = [[MyNavigationController alloc]initWithRootViewController:more];
    [self addChildViewController:navMore];
    // [self addChildViewController:more];
    
}

#pragma mark 添加dock
-(void)addMyDock{
    _dock.selectedIndex = 4;
    [_dock addItemWithIcon:@"tabbar_home.png" selectedIcon:@"tabbar_home_selected.png" title:@"首页"];
    [_dock addItemWithIcon:@"tabbar_message_center.png" selectedIcon:@"tabbar_message_center_selected.png" title:@"消息"];
    [_dock addItemWithIcon:@"tabbar_profile.png" selectedIcon:@"tabbar_profile_selected.png" title:@"我"];
    [_dock addItemWithIcon:@"tabbar_discover.png" selectedIcon:@"tabbar_discover_selected.png" title:@"广场"];
    [_dock addItemWithIcon:@"tabbar_more.png" selectedIcon:@"tabbar_more_selected.png" title:@"更多"];
//    _dock = dock;
    
}

#pragma mark - 动画添加按钮
//
//- (void)addItem
//{
//    [_dock addItemWithIcon:@"tabbar_home.png" title:@"home"];
//}

@end
