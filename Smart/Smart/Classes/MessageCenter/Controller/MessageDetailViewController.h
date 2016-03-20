//
//  MessageDetailViewController.h
//  SmartTravelApp2
//
//  Created by whutlab5 on 15/1/18.
//  Copyright (c) 2015年 lgy. All rights reserved.
//

#import "JSQMessages.h"

@interface MessageDetailViewController : JSQMessagesViewController<UIActionSheetDelegate>
@property (strong, nonatomic) NSString *messageType;
@end
