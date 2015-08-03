//
//  UIBarButtonItem+My.h
//  SinaWeibo
//
//  Created by orange on 15/7/28.
//  Copyright (c) 2015年 orange. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (My)
- (id)initWithIcon:(NSString *)icon highlightedIcon:(NSString *)highlighted target:(id)target action:(SEL)action;

+(id)itemWithIcon:(NSString *)icon highlightedIcon:(NSString *)highlighted target:(id)target action:(SEL)action;

@end
