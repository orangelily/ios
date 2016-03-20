//
//  User.m
//  Smart
//
//  Created by orange on 16/3/19.
//  Copyright © 2016年 orange. All rights reserved.
//

#import "User.h"
//#import "NSString+Extension.h"
//#import "AFNetworking.h"

#define LOGIN_URL [BASE_IP_ADDRESS stringByAppendingString:@"/login/%@/%@.do"]
#define LOGOUT_URL [BASE_IP_ADDRESS stringByAppendingString:@"/logout/%@.do"]


#define kUserNameKey  @"username"
#define kPasswordKey  @"userpsw"

@implementation User
single_implementation(User)

#pragma mark - 用户登录
-(void)userLogin:(NSDictionary *)dict
{
    NSString *username = [dict objectForKey:kUserNameKey];
    NSData *data = [[dict objectForKey:kPasswordKey]MD5CharData];
    NSString *userpsw = [data base64EncodedStringWithOptions:0];
    NSString *urlStr = [NSString stringWithFormat:LOGIN_URL,username,userpsw];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:[NSString URLDecodedString:urlStr] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSInteger result = [[[NSString alloc]initWithData:(NSData *)responseObject encoding:NSUTF8StringEncoding]integerValue];
        
        if ([self.delegate respondsToSelector:@selector(loginSucceedWithResult:)]) {
            [self.delegate loginSucceedWithResult:result];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if ([self.delegate respondsToSelector:@selector(loginFailedWithError:)]) {
            [self.delegate loginFailedWithError:error];
        }
    }];
}

-(void)userLogout
{
    NSString *urlStr = [NSString stringWithFormat:LOGOUT_URL,GUIDE_ID];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:[NSString URLEncodedString:urlStr] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        BOOL result = [[[NSString alloc] initWithData:(NSData *)responseObject encoding:NSUTF8StringEncoding] boolValue];
        if ([self.delegate respondsToSelector:@selector(logoutSucceededWithResult:)]) {
            [self.delegate logoutSucceededWithResult:result];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if ([self.delegate respondsToSelector:@selector(logoutFailedWithError:)]) {
            [self.delegate logoutFailedWithError:error];
        }
    }];
}
@end
