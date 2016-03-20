//
//  BLHelper.h
//  Smart
//
//  Created by orange on 16/3/19.
//  Copyright © 2016年 orange. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppCommon.h"
#import "AFNetworking.h"
#import "GlobalVariables.h"
#import "NSString+Extension.h"
#import "KGStatusBar.h"

#define GUIDE_ID [[GlobalVariables sharedGlobalVariables] guideId]

@interface BLHelper : NSObject

//从缓存中加载数据
-(id)loadCacheDataWithCustomId:(NSString *)customId andCacheName:(NSString *)cacheName;
- (NSString *)pathForPersistedDataWithCustomId:(NSString *)customId andCacheName:(NSString *)cacheName;

@end
