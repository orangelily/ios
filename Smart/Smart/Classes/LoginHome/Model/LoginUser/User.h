//
//  User.h
//  Smart
//
//  Created by orange on 16/3/19.
//  Copyright © 2016年 orange. All rights reserved.
//

#import "BLHelper.h"
//#import "Singleton.h"

@protocol UserDelegate <NSObject>
@optional
-(void)loginSucceedWithResult:(NSInteger)result;
-(void)loginFailedWithError:(NSError *)error;
-(void)logoutSucceededWithResult:(BOOL)result;
-(void)logoutFailedWithError:(NSError *)error;

@end

@interface User :BLHelper

//单例模式
single_interface(User)

//代理
@property (weak,nonatomic) id<UserDelegate> delegate;

//用户登录
-(void)userLogin:(NSDictionary *)dict;

//用户登录
-(void)userLogout;

@end
