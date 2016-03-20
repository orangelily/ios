//
//  HomeViewController.m
//  Smart
//
//  Created by orange on 16/3/19.
//  Copyright © 2016年 orange. All rights reserved.
//

#import "HomeViewController.h"
#import "UIImage+Extension.h"
#import "AppCommon.h"
#import "MessageBL.h"
#import "LatestMessage+Extension.h"
#import "MessageList+Extension.h"
//#import "BMapKit.h"

@interface HomeViewController () <MessageBLDelegate,BMKLocationServiceDelegate>
{
    BMKLocationService *_locService;
}
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    for (UITabBarItem *item in self.tabBar.items) {
        item.image = [item.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
    [[UITabBar appearance] setBackgroundImage:[UIImage imageWithColor:UIColorFromRGB(0x54bdae) andSize:self.tabBar.frame.size]];
    [[UITabBar appearance] setSelectionIndicatorImage:[UIImage imageWithColor:UIColorFromRGB(0x4aad9b) andSize:CGSizeMake(self.tabBar.frame.size.width/self.viewControllers.count, self.tabBar.frame.size.height)]];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    
    // 监听新的消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startPullNewMessage) name:HeartbeatPacketNewMessage object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadLocation) name:HeartbeatPacketUploadUserLocation object:nil];
    
    // 设置BL代理
    [MessageBL sharedMessageBL].delegate = self;
    
    // 开启心跳包
    [[MessageBL sharedMessageBL] startHeartBeatPacket];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)startPullNewMessage
{
    [[MessageBL sharedMessageBL] getNewMessages];
}

- (void)uploadLocation
{
    if (!_locService) {
        // 设置定位精确度，默认：kCLLocationAccuracyBest
        [BMKLocationService setLocationDesiredAccuracy:kCLLocationAccuracyBest];
        // 指定最小距离更新(米)，默认：kCLDistanceFilterNone
        [BMKLocationService setLocationDistanceFilter:kCLDistanceFilterNone];
        
        // 初始化BMKLocationService
        _locService = [[BMKLocationService alloc] init];
        _locService.delegate = self;
    } else
    {
        // 启动LocationService
        [_locService startUserLocationService];
    }
}

#pragma mark - MessageBLDelegate
- (void)getNewMessagesFinished:(NSArray *)messageList
{
    if (messageList.count > 0) {
        for (NSDictionary *dic in messageList) {
            [MessageList createAndSaveEntityWithDictionary:dic inManagedObjectContext:[CoreDataHelper privateQueueContext]];
            [LatestMessage record_A_NewMessage:dic inManagedObjectContext:[CoreDataHelper privateQueueContext]];
        }
    }
}

- (void)getNewMessagesFailed:(NSError *)error
{
    
}

- (void)uploadUserLocationFinished:(BOOL)result
{
    if (result) {
        NSLog(@"上传用户位置成功");
    } else
    {
        NSLog(@"上传用户位置失败");
    }
}

- (void)uploadUserLocationFailed:(NSError *)error
{
    NSLog(@"上传用户位置失败");
}

#pragma mark - BMKLocationServiceDelegate

#pragma mark 处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    // 定位成功一次便停止定位
    [_locService stopUserLocationService];
    NSNumber *longitude = [NSNumber numberWithDouble:userLocation.location.coordinate.longitude];
    NSNumber *latitude = [NSNumber numberWithDouble:userLocation.location.coordinate.latitude];
    [[MessageBL sharedMessageBL] uploadUserLocation:@{@"longitude":longitude,@"latitude":latitude}];
}

#pragma mark 定位失败
- (void)didFailToLocateUserWithError:(NSError *)error
{
    [_locService stopUserLocationService];
    NSLog(@"定位失败");
}

#pragma mark -
- (void)dealloc
{
    _locService = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
