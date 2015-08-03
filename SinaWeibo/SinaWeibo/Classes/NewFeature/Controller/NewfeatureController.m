//
//  NewfeatureController.m
//  SinaWeibo
//
//  Created by orange on 15/6/14.
//  Copyright (c) 2015年 orange. All rights reserved.
//  版本新特性界面

#import "NewfeatureController.h"
#import "UIImage+Addtion.h"
#import "MainController.h"

#define kCount 4
@interface NewfeatureController () <UIScrollViewDelegate>
{
    UIPageControl *_page;
    UIScrollView *_scroll;
}
@end

@implementation NewfeatureController
//
//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [self initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        //
//    }
//    return self;
//}
- (void)loadView
{
    
    UIImageView *imageView = [[UIImageView alloc]init];
//    imageView.image = [UIImage imageNamed:@"new_feature_background.png"];
    
    imageView.image = [UIImage fullscreenImage:@"new_feature_background.png"];
//    [UIImage fullscreenImage:@"new_feature_background.png"];
//    imageView.frame = [UIScreen mainScreen].bounds;
    //自动判断有无状态栏
    imageView.frame = [UIScreen mainScreen].applicationFrame;
    imageView.userInteractionEnabled = YES;
    self.view = imageView;
}
/**
 *  一个控件无法显示
    1.没有设置宽高
    2.位置不对
    3.hidden＝YES
    4.没有添加到控制器的view
 
    一个UIScrollView无法滚动
    1.contentSize 没有值
    2.事件
 
 */

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //1. 添加UIScrollView
    [self addScrollView];
    
    //2. 添加图片 ————default －568h才会自动加载图片，实现屏幕适配需要手动修改
    [self addScrollImages];

    //3.添加UIPageControl
    [self addPageControl];
    //NSLog(@"scroll--:%d",_page.currentPage);
    
}

//#pragma mark - 加载全屏的图片 属于分类  新建文件夹实现功能
//- (UIImage *)fullscreenImage:(NSString *)imgName
//{
//    UIImage *img = [UIImage imageNamed:@"ads.png"];
//    return img;
//}

#pragma mark - UI界面初始化
#pragma mark 添加滚动视图
- (void)addScrollView
{
    UIScrollView *scroll = [[UIScrollView alloc]init];
    scroll.frame = self.view.bounds;
    //NSLog(@"scroll.frame:%d",scroll.frame.size.width);
    
    scroll.showsHorizontalScrollIndicator = NO;// 隐藏水平滚动条
    CGSize size = scroll.frame.size;
    //scroll.contentSize ——可以滚动的区域
    scroll.contentSize = CGSizeMake(size.width*kCount, 0);
    scroll.pagingEnabled = YES;
    
    scroll.delegate =self;
    
    [self.view addSubview:scroll];
    _scroll = scroll;
}

#pragma mark - 添加滚动显示的图片
- (void)addScrollImages
{
    CGSize size = _scroll.frame.size;
    for (int i=0; i<kCount; i++) {
        UIImageView *imageView = [[UIImageView alloc]init];
        //        NSString *name = [NSString stringWithFormat:@"new_features_%d.jpg",i];
        
        NSString *name = [NSString stringWithFormat:@"new_feature_%d.png",i+1];
//        imageView.image = [UIImage imageNamed:name];
        //全屏图片
        imageView.image = [UIImage fullscreenImage:name];
        
        imageView.frame = CGRectMake(i*size.width, 0, size.width, size.height);
        [_scroll addSubview:imageView];
        if (i == kCount-1) {
//            NSLog(@"adlkhalg");
            UIButton *start = [UIButton buttonWithType:UIButtonTypeCustom];
            UIImage *startNormal = [UIImage imageNamed:@"new_feature_finish_button.png"];
            [start setBackgroundImage:startNormal forState:UIControlStateNormal];
            [start setBackgroundImage:[UIImage imageNamed:@"new_feature_finish_button_highlighted.png"]forState:UIControlStateHighlighted];
            start.center = CGPointMake(size.width*0.5, size.height*0.85);
            //            start.bounds = CGRectMake(0, 0, startNormal.size.width, startNormal.size.height);
            start.bounds = (CGRect){CGPointZero,startNormal.size};
            [start addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchUpInside];
            [imageView addSubview:start];
            
            //share
            UIButton *share = [UIButton buttonWithType:UIButtonTypeCustom];
            UIImage *shareNormal = [UIImage imageNamed:@"new_feature_share_true.png"];
            
            //
            [share setBackgroundImage:shareNormal forState:UIControlStateNormal];
            [share setBackgroundImage:[UIImage imageNamed:@"new_feature_share_false.png"]forState:UIControlStateSelected];
            share.center = CGPointMake(start.center.x,start.center.y-50);
            //            start.bounds = CGRectMake(0, 0, startNormal.size.width, startNormal.size.height);
            share.bounds = (CGRect){CGPointZero,shareNormal.size};
            //传Button
            [share addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
            //selected选中
            //share.selected = YES;
            //高亮时不需要变灰色
            share.adjustsImageWhenHighlighted = NO;
            
            [imageView addSubview:share];
            
            imageView.userInteractionEnabled = YES;
        }
    }

}

#pragma mark - 添加UIPageControl
- (void)addPageControl
{
    CGSize size = _scroll.frame.size;
    UIPageControl *page = [[UIPageControl alloc]init];
    page.center =  CGPointMake(size.width*0.5, size.height*0.95);
    page.numberOfPages = kCount;
    //    page.currentPageIndicatorTintColor = [UIColor redColor];
    //    page.pageIndicatorTintColor = [UIColor blackColor];
    
    //小圆点用图片表示
    page.currentPageIndicatorTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"new_feature_pagecontrol_checked_point.png"]];
    page.pageIndicatorTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"new_feature_pagecontrol_point.png"]];
    
    page.bounds = CGRectMake(0,0, 150,33);
    NSLog(@"page.bounds.size.width:%@",page);
    [self.view addSubview:page];
    _page = page;

}

#pragma mark - 监听按钮点击
#pragma mark 开始
- (void)start
{
    MyLog(@"main page");
    
    
// [UIApplication sharedApplication].keyWindow
    /**
     *  在显示控制器view之前显示状态栏：460
     *  在显示控制器view之后显示状态栏：480
     */
    // {0,0,320,480}
//    [UIScreen mainScreen].applicationFrame
    
    [UIApplication sharedApplication].statusBarHidden = NO;
//    {0,0,320,460}
//    [UIScreen mainScreen].applicationFrame;
    
    self.view.window.rootViewController = [[MainController alloc]init];
    
    
}

- (void)dealloc
{
    MyLog(@"new --销毁");
}

#pragma mark - share
#pragma mark 分享
- (void)share:(UIButton *)btn
{
    btn.selected = !btn.selected;
    MyLog(@"share page");
}

#pragma mark - 滚动代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //NSLog(@"scroll:%d",_page.currentPage);
    _page.currentPage = scrollView.contentOffset.x / scrollView.frame.size.width;
//    NSLog(@"scroll:%d",_page.currentPage);
}

@end
