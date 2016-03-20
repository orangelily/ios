//
//  MessageDetailViewController.m
//  SmartTravelApp2
//
//  Created by whutlab5 on 15/1/18.
//  Copyright (c) 2015年 lgy. All rights reserved.
//

#import "MessageDetailViewController.h"
#import "MessageList+Extension.h"
#import "LatestMessage+Extension.h"
#import "MessageBL.h"

//static NSString *const kJSQAvatarDisplayNameWarningMsg = @"预警消息";
//static NSString *const kJSQAvatarDisplayNameShortMsg = @"短信消息";
//static NSString *const kJSQAvatarDisplayNameNoticeMsg = @"公告";
static NSString * const kJSQAvatarDisplayNameSender = @"我自己";
static NSString * const kJSQAvatarIdWarningMsg = @"053496-4509-289"; //预警消息ID
static NSString * const kJSQAvatarIdShortMsg = @"468-768355-23123";  //短信消息ID
static NSString * const kJSQAvatarIdNoticeMsg = @"707-8956784-57";   //通知公告ID
static NSString * const kJSQAvatarIdSender = @"309-41802-93823";     //发送人ID

@interface MessageDetailViewController ()<NSFetchedResultsControllerDelegate>
{
    NSMutableArray *_messages;
    NSDictionary *_avatars;
    JSQMessagesBubbleImage *_outgoingBubbleImageData;
    JSQMessagesBubbleImage *_incomingBubbleImageData;
    NSString *_messageSenderId;
    NSDateFormatter *_dateFormatter;
}
@property (strong, nonatomic) NSFetchedResultsController *frc;
@end

@implementation MessageDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化_dateFormatter
    _dateFormatter = [[NSDateFormatter alloc] init];
    [_dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm"];
    
    // 初始化NSFetchedResultsController
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"MessageList" inManagedObjectContext:[CoreDataHelper mainQueueContext]]];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"guideId = %@ and type = %@",GUIDE_ID, self.messageType];
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"inserttime" ascending:YES];
    fetchRequest.sortDescriptors = @[sort];
    
    self.frc = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[CoreDataHelper mainQueueContext] sectionNameKeyPath:nil cacheName:nil];
    self.frc.delegate = self;
    self.title = self.messageType;
    
    // 设置JSQMessagesViewController
    self.senderId = kJSQAvatarIdSender;
    self.senderDisplayName = kJSQAvatarDisplayNameSender;
    self.showLoadEarlierMessagesHeader = NO;
    self.inputToolbar.hidden = YES;
    _messageSenderId = @"unknown";
    if ([self.messageType isEqualToString:MessageTypeWarningMsg]) {
        _messageSenderId  = kJSQAvatarIdWarningMsg;
    } else if ([self.messageType isEqualToString:MessageTypeShortMsg])
    {
        _messageSenderId = kJSQAvatarIdShortMsg;
    } else if ([self.messageType isEqualToString:MessageTypeNotice])
    {
        _messageSenderId = kJSQAvatarIdNoticeMsg;
    }
    
    // 泡泡窗口背景色
    JSQMessagesBubbleImageFactory *bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] init];
    _outgoingBubbleImageData = [bubbleFactory outgoingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleLightGrayColor]];
    _incomingBubbleImageData = [bubbleFactory incomingMessagesBubbleImageWithColor:UIColorFromRGB(0x54bdae)];
    
    // 用户头像
    JSQMessagesAvatarImage *disasterImage = [JSQMessagesAvatarImageFactory avatarImageWithImage:[UIImage imageNamed:@"msg_type_disaster"] diameter:kJSQMessagesCollectionViewAvatarSizeDefault];
    JSQMessagesAvatarImage *messageImage = [JSQMessagesAvatarImageFactory avatarImageWithImage:[UIImage imageNamed:@"msg_type_message"] diameter:kJSQMessagesCollectionViewAvatarSizeDefault];
    JSQMessagesAvatarImage *noticeImage = [JSQMessagesAvatarImageFactory avatarImageWithImage:[UIImage imageNamed:@"msg_type_notice"] diameter:kJSQMessagesCollectionViewAvatarSizeDefault];
    JSQMessagesAvatarImage *myImage = [JSQMessagesAvatarImageFactory avatarImageWithUserInitials:@"Me" backgroundColor:[UIColor colorWithWhite:0.85f alpha:1.0f] textColor:[UIColor colorWithWhite:0.60f alpha:1.0f] font:[UIFont systemFontOfSize:14.0f] diameter:kJSQMessagesCollectionViewAvatarSizeDefault];
    _avatars = @{ kJSQAvatarIdWarningMsg : disasterImage,
                    kJSQAvatarIdShortMsg : messageImage,
                   kJSQAvatarIdNoticeMsg : noticeImage,
                    kJSQAvatarIdSender : myImage };
    
    [self fetchData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.collectionView.collectionViewLayout.springinessEnabled = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 获取数据
- (void)fetchData
{
    NSError *fetchingError = nil;
    if ([self.frc performFetch:&fetchingError]) {
        if (!_messages)
        {
            _messages = [[NSMutableArray alloc] init];
        } else
        {
            [_messages removeAllObjects];
        }
        id<NSFetchedResultsSectionInfo> sectionInfo = self.frc.sections[0];
        for (NSInteger i = 0; i < sectionInfo.numberOfObjects; i++) {
            MessageList *message = [self.frc objectAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            [_messages addObject:[[JSQMessage alloc] initWithSenderId:_messageSenderId senderDisplayName:self.messageType date:message.inserttime text:message.content]];
        }
    } else
    {
        NSLog(@"Failed to fetch.");
    }
}

#pragma mark - NSFetchedResultsControllerDelegate
- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    if (type == NSFetchedResultsChangeDelete) {
        //删除
    }
    else if (type == NSFetchedResultsChangeInsert)
    {
        // 插入 (新的消息)
        [self receiveNewMessage];
        // 将未读消息数置零
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            [LatestMessage SetAllUnreadNumToZeroWithGuideId:GUIDE_ID Type:self.messageType inManagedObjectContext:[CoreDataHelper privateQueueContext]];
        });
        
    } else if (type == NSFetchedResultsChangeUpdate)
    {
        //更新
    }
}

#pragma mark - 接收新的消息
- (void)receiveNewMessage
{
    self.showTypingIndicator = !self.showTypingIndicator;
    [self scrollToBottomAnimated:YES];
    
     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
         // 显示indicator
         id<NSFetchedResultsSectionInfo> sectionInfo = self.frc.sections[0];
         MessageList *message = [self.frc objectAtIndexPath:[NSIndexPath indexPathForRow:(sectionInfo.numberOfObjects - 1) inSection:0]];
         JSQMessage *newMessage = [[JSQMessage alloc] initWithSenderId:_messageSenderId senderDisplayName:self.messageType date:message.inserttime text:message.content];
         
         
         [JSQSystemSoundPlayer jsq_playMessageReceivedSound];
         [_messages addObject:newMessage];
         [self finishReceivingMessageAnimated:YES];
         
     });
}

#pragma mark - JSQMessages CollectionView DataSource

- (id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [_messages objectAtIndex:indexPath.item];
}

- (id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    JSQMessage *message = [_messages objectAtIndex:indexPath.item];
    
    if ([message.senderId isEqualToString:self.senderId]) {
        return _outgoingBubbleImageData;
    }
    
    return _incomingBubbleImageData;
}

- (id<JSQMessageAvatarImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JSQMessage *message = [_messages objectAtIndex:indexPath.item];
    return [_avatars objectForKey:message.senderId];
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    JSQMessage *message = [_messages objectAtIndex:indexPath.item];
    if (indexPath.item > 0) {
        JSQMessage *preMessage = [_messages objectAtIndex:(indexPath.item-1)];
        if ([[_dateFormatter stringFromDate:message.date] isEqualToString:[_dateFormatter stringFromDate:preMessage.date]]) {
            return nil;
        }
    }
    return [[JSQMessagesTimestampFormatter sharedFormatter] attributedTimestampForDate:message.date];
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

#pragma mark - UICollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    // 1个section
    id<NSFetchedResultsSectionInfo> sectionInfo = self.frc.sections[0];
    return sectionInfo.numberOfObjects;
}

- (UICollectionViewCell *)collectionView:(JSQMessagesCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JSQMessagesCollectionViewCell *cell = (JSQMessagesCollectionViewCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    
    JSQMessage *msg = [_messages objectAtIndex:indexPath.item];
    
    if (!msg.isMediaMessage) {
        
        if ([msg.senderId isEqualToString:self.senderId]) {
            cell.textView.textColor = [UIColor blackColor];
        }
        else {
            cell.textView.textColor = [UIColor whiteColor];
        }
        
        cell.textView.linkTextAttributes = @{ NSForegroundColorAttributeName : cell.textView.textColor,
                                              NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle | NSUnderlinePatternSolid) };
    }
    return cell;
}

#pragma mark - JSQMessages collection view flow layout delegate

#pragma mark - Adjusting cell label heights

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    JSQMessage *message = [_messages objectAtIndex:indexPath.item];
    if (indexPath.item > 0) {
        JSQMessage *preMessage = [_messages objectAtIndex:(indexPath.item-1)];
        if ([[_dateFormatter stringFromDate:message.date] isEqualToString:[_dateFormatter stringFromDate:preMessage.date]]) {
            return 0.0f;
        }
    }
    return kJSQMessagesCollectionViewCellLabelHeightDefault;
}

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    return 10.0f;
}

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
{
    return 0.0f;
}

#pragma mark - Responding to collection view tap events

- (void)collectionView:(JSQMessagesCollectionView *)collectionView
                header:(JSQMessagesLoadEarlierHeaderView *)headerView didTapLoadEarlierMessagesButton:(UIButton *)sender
{
    NSLog(@"Load earlier messages!");
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapAvatarImageView:(UIImageView *)avatarImageView atIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Tapped avatar!");
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapMessageBubbleAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Tapped message bubble!");
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapCellAtIndexPath:(NSIndexPath *)indexPath touchLocation:(CGPoint)touchLocation
{
    NSLog(@"Tapped cell at %@!", NSStringFromCGPoint(touchLocation));
}

#pragma mark -
- (void)dealloc
{
    _messages = nil;
    _avatars = nil;
    _outgoingBubbleImageData = nil;
    _incomingBubbleImageData = nil;
    _messageSenderId = nil;
    _dateFormatter = nil;
}
@end
