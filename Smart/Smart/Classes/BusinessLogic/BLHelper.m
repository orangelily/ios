//
//  BLHelper.m
//  Smart
//
//  Created by orange on 16/3/19.
//  Copyright © 2016年 orange. All rights reserved.
//

#import "BLHelper.h"

@implementation BLHelper


#pragma mark - 从缓存中加载数据
/**
 * 从缓存中加载数据
 * @param customId
 * @param cacheName 缓存名称
 * @return 缓存数据
 */
- (id)loadCacheDataWithCustomId:(NSString *)customId andCacheName:(NSString *)cacheName
{
    NSString *path = [self pathForPersistedDataWithCustomId:customId andCacheName:cacheName];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        return nil;
    }
    id results = [NSKeyedUnarchiver unarchiveObjectWithFile:[self pathForPersistedDataWithCustomId:customId andCacheName:cacheName]];
    return results;
}

- (NSString *)pathForPersistedDataWithCustomId:(NSString *)customId andCacheName:(NSString *)cacheName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    return [NSString stringWithFormat:@"%@/%@_%@",[paths objectAtIndex:0],customId,cacheName];
}
@end
