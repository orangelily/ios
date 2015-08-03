//
//  MyNavigationController.m
//  SinaWeibo
//
//  Created by orange on 15/7/22.
//  Copyright (c) 2015年 orange. All rights reserved.
//

#define COLOR(R,G,B,A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]
#define ARGB 34/255
#import "MyNavigationController.h"

@interface MyNavigationController ()

@end

@implementation MyNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    //    self.view.frame = CGRectMake(0, -20, self.view.frame.size.width, 40);
    //    导航条外观
    UINavigationBar *bar = [UINavigationBar appearance];
//        self.navigationController.navigationBar.translucent = NO;
    //1.设置导航栏背景颜色
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f) {
        bar.clipsToBounds = YES;
        UIImage *img = [UIImage imageNamed:@"navigationbar_background2.png"];
        [img stretchableImageWithLeftCapWidth:img.size.width*0.5 topCapHeight:img.size.height*0.5];
//        UIImageView *imgView = [[UIImageView alloc]initWithImage:img];
//        [bar setTintColor:COLOR(111, 211, 211, 1)];
//        [bar setTintColor:[UIColor colorWithRed:ARGB green:ARGB blue:ARGB alpha:1]];
//        bar.backgroundColor= [UIColor colorWithPatternImage:img];
//        [self.navigationController.navigationBar setBackgroundImage:img forBarMetrics:UITableViewStylePlain];
    }else{
        bar = self.navigationController.navigationBar;
        //if iOS 5.0 - 6.0
        [bar setBackgroundImage:[UIImage imageNamed:@"navigationbar_background2.png"] forBarMetrics:UIBarMetricsDefault];
    }
    //
    
    
    //    [bar setTitleTextAttributes:@{UITextAttributeTextColor:[UIColor blackColor],UITextAttributeTextShadowOffset:[NSValue valueWithUIOffset:UIOffsetZero]}];
    //
    //    导航条UIbuttonItem的外观
    UIBarButtonItem *barItem = [UIBarButtonItem appearance];
    //    修改item背景图片
    [barItem setBackgroundImage:[UIImage imageNamed:@"navigationbar_button_background.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [barItem setBackgroundImage:[UIImage imageNamed:@"navigationbar_button_background_pushed.png"]forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    
    // 3.设置导航文字格式
    //    修改item上面的文字样式
    NSDictionary *dict = @{UITextAttributeTextColor:[UIColor blackColor],UITextAttributeTextShadowOffset:[NSValue valueWithUIOffset:UIOffsetZero]};
    [barItem setTitleTextAttributes:dict forState:UIControlStateNormal];
    [barItem setTitleTextAttributes:dict forState:UIControlStateHighlighted];
    //        [bar setTitleTextAttributes:@{UITextAttributeFont:[UIColor blackColor],}];
    
    //4. 设置状态栏样式
    //    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    // 5.设置状态栏样式
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleBlackOpaque;
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
