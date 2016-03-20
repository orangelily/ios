//
//  MessageListViewController.m
//  SmartTravelApp2
//
//  Created by whutlab5 on 15/1/16.
//  Copyright (c) 2015年 lgy. All rights reserved.
//

#import "MessageListViewController.h"
#import "MessageListCell.h"
#import "LatestMessage+Extension.h"
#import "MessageBL.h"
#import "MessageDetailViewController.h"
#import "ChineseInclude.h"
#import "PinYinForObjc.h"

@interface MessageListViewController () <NSFetchedResultsControllerDelegate,UISearchBarDelegate>
{
    NSMutableDictionary *_totalUnreadMessageCount;
    NSDateFormatter *_formatter;
    NSMutableArray *_searchResults;
}
@property (strong, nonatomic) NSFetchedResultsController *frc;
@end

@implementation MessageListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _totalUnreadMessageCount = [NSMutableDictionary dictionary];
    _formatter = [[NSDateFormatter alloc] init];
    [_formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [self.searchDisplayController.searchResultsTableView registerNib:[UINib nibWithNibName:@"MessageListCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"messageListCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"MessageListCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"messageListCell"];
    [self fetchData];
    [UIView animateWithDuration:0 animations:^{
        [self.tableView reloadData];
    } completion:^(BOOL finished) {
        [self getTotalUnreadMessageNum];
    }];
}

#pragma mark - 获取数据
- (void)fetchData
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"LatestMessage" inManagedObjectContext:[CoreDataHelper mainQueueContext]]];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"guideId = %@ and deleteflag = 0",GUIDE_ID];
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"time" ascending:NO];
    fetchRequest.sortDescriptors = @[sort];
    self.frc = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[CoreDataHelper mainQueueContext] sectionNameKeyPath:nil cacheName:nil];
    self.frc.delegate = self;
    NSError *fetchingError = nil;
    if ([self.frc performFetch:&fetchingError]) {
        
    } else
    {
        NSLog(@"Failed to fetch.");
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - NSFetchedResultsControllerDelegate
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    if (type == NSFetchedResultsChangeDelete) {
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    else if (type == NSFetchedResultsChangeInsert)
    {
        [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    } else if (type == NSFetchedResultsChangeUpdate)
    {
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
    [self getTotalUnreadMessageNum];
}

#pragma mark - 获取总的未读消息条数
- (void)getTotalUnreadMessageNum
{
    NSInteger totalUnreadMessageNum = 0;
    NSEnumerator *enumerator = [_totalUnreadMessageCount objectEnumerator];
    for (id obj in enumerator) {
        int unreadNum = [obj intValue];
        totalUnreadMessageNum += unreadNum;
    }
    if (totalUnreadMessageNum > 0) {
        if (totalUnreadMessageNum > 99) {
            
            [[self navigationController] tabBarItem].badgeValue = @"99+";
        } else
        {
            
            [[self navigationController] tabBarItem].badgeValue = [NSString stringWithFormat:@"%d",(int)totalUnreadMessageNum];
        }
        
    } else
    {
        
        [[self navigationController] tabBarItem].badgeValue = nil;
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 66.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.searchDisplayController.searchResultsTableView == tableView) {
        return [_searchResults count];
    }
    id<NSFetchedResultsSectionInfo> sectionInfo = self.frc.sections[section];
    return sectionInfo.numberOfObjects;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"messageListCell" forIndexPath:indexPath];
    LatestMessage *message = (self.searchDisplayController.searchResultsTableView == tableView)?[_searchResults objectAtIndex:indexPath.row]:[self.frc objectAtIndexPath:indexPath];
    cell.messageTitle.text = message.title;
    cell.messageContent.text = message.content;
    [_formatter setDateFormat:@"yyyy-MM-dd"];
    cell.messageTime.text = [self dealWithTime:message.time];
    int unreadnum = [message.unreadnum intValue];
    cell.messageType = message.type;
    //NSLog(@"消息类型:%@",message.type);
    if ([message.type isEqualToString:MessageTypeNotice]) {
        cell.messageTitle.text = MessageTypeNotice;
        cell.messageImage.image = [UIImage imageNamed:@"msg_type_notice"];
        [_totalUnreadMessageCount setObject:[NSString stringWithFormat:@"%d",unreadnum] forKey:message.type];
    } else if ([message.type isEqualToString:MessageTypeWarningMsg])
    {
        cell.messageTitle.text = MessageTypeWarningMsg;
        cell.messageImage.image = [UIImage imageNamed:@"msg_type_disaster"];
        [_totalUnreadMessageCount setObject:[NSString stringWithFormat:@"%d",unreadnum] forKey:message.type];
    } else if ([message.type isEqualToString:MessageTypeShortMsg])
    {
        cell.messageTitle.text = MessageTypeShortMsg;
        cell.messageImage.image = [UIImage imageNamed:@"msg_type_message"];
        [_totalUnreadMessageCount setObject:[NSString stringWithFormat:@"%d",unreadnum] forKey:message.type];
    }
    if (unreadnum > 0) {
        if (unreadnum > 99) {
            cell.badgeView.badgeText = @"99+";
        } else
        {
            cell.badgeView.badgeText = [NSString stringWithFormat:@"%d",unreadnum];
        }
    } else
    {
        cell.badgeView.badgeText = @"";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageListCell *cell = (MessageListCell *)[tableView cellForRowAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"showMessageDetailSegue" sender:cell];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ((self.searchDisplayController.searchResultsTableView == tableView)) {
        return NO;
    }
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:animated];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        MessageListCell *cell = (MessageListCell *)[tableView cellForRowAtIndexPath:indexPath];
        [_totalUnreadMessageCount setObject:[NSString stringWithFormat:@"%d",0] forKey:cell.messageType];
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            [LatestMessage Delete_A_MessageWithGuideId:GUIDE_ID Type:cell.messageType inManagedObjectContext:[CoreDataHelper privateQueueContext]];
        });
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SCREEN_WIDTH, 0.5f)];
    [view setBackgroundColor:[UIColor colorWithRed:200.0f/255.0f green:199.0f/255.0f blue:204.0f/255.0f alpha:1]];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5f;
}

#pragma mark - 日期处理
- (NSString *)dealWithTime:(NSDate *)time
{
    //计算两个日期相差的天数
    NSString *timeStr = [_formatter stringFromDate:time];
    NSString *todayStr = [_formatter stringFromDate:[NSDate date]];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:NSDayCalendarUnit fromDate:[_formatter dateFromString:timeStr] toDate:[_formatter dateFromString:todayStr] options:0];
    NSInteger dayUnit = [components day];
    if (dayUnit == 0) {
        //今天
        [_formatter setDateFormat:@"HH:mm"];
        return [_formatter stringFromDate:time];
    } else if (dayUnit == 1) {
        //昨天
        [_formatter setDateFormat:@"HH:mm"];
        return @"昨天";
        
    } else if (dayUnit < 7 && dayUnit > 1)
    {
        //以星期表示
        components = [calendar components:NSWeekdayCalendarUnit fromDate:time];
        switch ([components weekday]) {
            case 1:
                return @"星期天";
            case 2:
                return @"星期一";
            case 3:
                return @"星期二";
            case 4:
                return @"星期三";
            case 5:
                return @"星期四";
            case 6:
                return @"星期五";
            case 7:
                return @"星期六";
            default:
                return @"";
        }
    } else
    {
        [_formatter setDateFormat:@"yyyy-MM-dd"];
        return [_formatter stringFromDate:time];
    }
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    MessageListCell *cell = (MessageListCell *)sender;
    if ([[segue identifier] isEqualToString:@"showMessageDetailSegue"])
    {
        if (![cell.badgeView.badgeText isEqualToString:@""]) {
            cell.badgeView.badgeText = @"";
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_async(queue, ^{
                [LatestMessage SetAllUnreadNumToZeroWithGuideId:GUIDE_ID Type:cell.messageType inManagedObjectContext:[CoreDataHelper privateQueueContext]];
            });
        }
        [(MessageDetailViewController *)segue.destinationViewController setMessageType:cell.messageType];
    }
}

#pragma mark - UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if ([searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length > 0)
    {
        [_searchResults removeAllObjects];
        id<NSFetchedResultsSectionInfo> sectionInfo = self.frc.sections[0];
        NSInteger count = sectionInfo.numberOfObjects;
        if (![ChineseInclude isIncludeChineseInString:searchText]) {
            for (NSInteger i = 0; i < count ; i++) {
                LatestMessage *message = [self.frc objectAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                NSString *messageContent = message.content;
                NSString *messageTitle = message.type;
                if ([ChineseInclude isIncludeChineseInString:messageContent] || [ChineseInclude isIncludeChineseInString:messageTitle]) {
                    NSString *tempPinYinStr1 = [PinYinForObjc chineseConvertToPinYin:messageContent];
                    NSString *tempPinYinStr2 = [PinYinForObjc chineseConvertToPinYin:messageTitle];
                    NSRange titleResult1 = [tempPinYinStr1 rangeOfString:searchText options:NSCaseInsensitiveSearch];
                    NSRange titleResult2 = [tempPinYinStr2 rangeOfString:searchText options:NSCaseInsensitiveSearch];
                    if (titleResult1.length > 0 || titleResult2.length > 0) {
                        [_searchResults addObject:message];
                    }
                } else
                {
                    NSRange titleResult1 = [messageContent rangeOfString:searchText options:NSCaseInsensitiveSearch];
                    NSRange titleResult2 = [messageTitle rangeOfString:searchText options:NSCaseInsensitiveSearch];
                    if (titleResult1.length > 0 || titleResult2.length > 0) {
                        [_searchResults addObject:message];
                    }
                }
            }
        }else
        {
            for (NSInteger i = 0; i < count; i++) {
                LatestMessage *message = [self.frc objectAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                NSString *messageContent = message.content;
                NSString *messageTitle = message.type;
                NSRange titleResult1 = [messageContent rangeOfString:searchText options:NSCaseInsensitiveSearch];
                NSRange titleResult2 = [messageTitle rangeOfString:searchText options:NSCaseInsensitiveSearch];
                if (titleResult1.length > 0 || titleResult2.length > 0) {
                    [_searchResults addObject:message];
                }
            }
        }
    }
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    if (!_searchResults) {
        _searchResults = [[NSMutableArray alloc] init];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
}

#pragma mark -
- (void)dealloc
{
    _totalUnreadMessageCount = nil;
    _formatter = nil;
    _searchResults= nil;
}
@end
