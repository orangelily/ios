//
//  MoreController.m
//  SinaWeibo
//
//  Created by orange on 15/7/7.
//  Copyright (c) 2015年 orange. All rights reserved.
//
@interface LogoutBtn:UIButton
@end

@implementation LogoutBtn

-(CGRect)imageRectForContentRect:(CGRect)contentRect{
//    CGFloat x=10;
//    CGFloat y =0;
//    CGFloat width = contentRect.size.width-2*x;
//    CGFloat height = contentRect.size.height;
//    return (CGRect){x,y,width,height};
    return (CGRect){CGPointZero,contentRect.size};
    
}

@end
#import "MoreController.h"
#import "UIImage+Addtion.h"
#define ARGB 230/255.0


@interface MoreController ()
{
    NSArray *_data;
}
@end

@implementation MoreController

- (void)viewDidLoad {
    [super viewDidLoad];
    int height =self.tableView.frame.size.height;
    NSLog(@"height%d",height);
    //1.搭建UI界面
    [self buildUI];
    //    2.读取plist文件的内容
    [self loadPlist];
    //    3.设置tableview属性
    [self buildTableView];
}

#pragma mark tableView属性
-(void)buildTableView{
    //backgroundView优先级大于backgroundColor
    //1.设置背景
    self.tableView.backgroundView =nil;
    //255/255
    self.tableView.backgroundColor = [UIColor colorWithRed:ARGB green:ARGB blue:ARGB alpha:1];
    //2.设置tableView的高度
    self.tableView.sectionHeaderHeight = 5;
    self.tableView.sectionFooterHeight = 0;
    
    //3.要在tableView底部添加一个按钮
//    self.tableView.tableFooterView = [UIButton buttonWithType:UIButtonTypeContactAdd];
    LogoutBtn *logout = [LogoutBtn buttonWithType:UIButtonTypeCustom];
//    UIButton *logout = [UIButton buttonWithType:UIButtonTypeCustom];
    //设置背景图片
    [logout setImage:[UIImage resizeImage:@"common_button_big_red.png"] forState:UIControlStateNormal];
    
//    [logout setBackgroundImage:[UIImage resizeImage:@"common_button_big_red.png"] forState:UIControlStateNormal];
    [logout setImage:[UIImage resizeImage:@"common_button_big_red_highlighted.png"] forState:UIControlStateHighlighted];
    //设置宽度表示左边间距，0表示填充整个tableview的宽度
//    logout.bounds = CGRectMake(0, 0, 0, 44);
//    logout.imageView.bounds = CGRectMake(0, 0, 320, 44);
//    修改内部内容的边界
    
    logout.bounds = CGRectMake(-10, 0, 0, 44);
    logout.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
    
    [logout setTitle:@"退出当前账号" forState:UIControlStateNormal];

    self.tableView.tableFooterView = logout;
    self.tableView.bounds = CGRectMake(0, 64, 320, 396);
    int height =self.tableView.frame.size.height;
    NSLog(@"height%d",height);

}

#pragma mark 搭建UI界面
- (void)buildUI{
    self.title = @"更多";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"设置" style:UIBarButtonItemStyleBordered target:nil action:nil];
    
}

#pragma mark 读取plist文件的内容
- (void)loadPlist{
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"More" withExtension:@"plist"];
    _data = [NSArray arrayWithContentsOfURL:url];
    //    NSArray *array = [NSDictionary dictionaryWithContentsOfURL:url][@"zh_CN"];
    //    [array  writeToFile:@"/Users/orange/Desktop/more.plist" atomically:YES];
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return _data.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    //    NSArray *array = _data[section];
    //    return array.count;
    return [_data[section] count];
}

#pragma mark 每当有一个新的cell进入屏幕视野范围就会调用
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier =@"Cell";
    // forIndexPath 跟storyboard配套使用
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];// forIndexPath:indexPath];
    if (cell ==nil) {
        cell = [[UITableViewCell alloc]  initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//        只需在初次生成cell的时候调用
//        设置cell的背景view
        //    3.设置cell的背景
        UIImageView *bg = [[UIImageView alloc] init];
        cell.backgroundView = bg;
        
        UIImageView *bg2 = [[UIImageView alloc] init];
        cell.selectedBackgroundView = bg2;
        
        
    }
    //    cell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"navigationbar_button_background.png"]];
    
    // Configure the cell...
    //    1.取出这行对应的字典数据
    NSDictionary *dict = _data[indexPath.section][indexPath.row];
    //    2.设置cell的文字
    cell.textLabel.text = dict[@"name"];
    //    3.label的颜色清除
    cell.textLabel.backgroundColor = [UIColor clearColor];
    //    cell.contentView.backgroundColor
    
    //    3.设置cell的背景
    UIImageView *bg = (UIImageView *)cell.backgroundView;
    UIImageView *bg2 = (UIImageView *)cell.selectedBackgroundView;
    
    
    //当前组的总行数
    int count = [_data[indexPath.section] count];
    if (count ==1) {
        //        UIImage *img = [UIImage resizeImage:@"common_card_background.png"];
        //        UIImage *img2 = [UIImage resizeImage:@"common_card_background_highlighted.png"];
        
        bg.image = [UIImage resizeImage:@"common_card_background.png"];
        
        bg2.image = [UIImage resizeImage:@"common_card_background_highlighted.png"];
        //    stretchableImageWithLeftCapWidth:img2.size.width*0.5 topCapHeight:img2.size.height*0.5];
        
    }else if(indexPath.row==0){
        bg.image= [UIImage resizeImage:@"common_card_top_background.png"];
        bg2.image = [UIImage resizeImage:@"common_card_top_background_highlighted.png"];
        //        bg.image = [img stretchableImageWithLeftCapWidth:img.size.width*0.5 topCapHeight:img.size.height*0.5];
        //        bg2.image = [img2 stretchableImageWithLeftCapWidth:img2.size.width*0.5 topCapHeight:img2.size.height*0.5];
        
    }else if(indexPath.row==count-1){
        bg.image= [UIImage resizeImage:@"common_card_bottom_background.png"];
        bg2.image = [UIImage resizeImage:@"common_card_bottom_background_highlighted.png"];
        
    }else{
        bg.image= [UIImage resizeImage:@"common_card_middle_background.png"];
        bg2.image = [UIImage resizeImage:@"common_card_middle_background_highlighted.png"];
        //        UIImage *img = [UIImage imageNamed:@"common_card_middle_background.png"];
        //        UIImage *img2 = [UIImage imageNamed:@"common_card_middle_background_highlighted.png"];
        //        bg.image = [img stretchableImageWithLeftCapWidth:img.size.width*0.5 topCapHeight:img.size.height*0.5];
        //        bg2.image = [img2 stretchableImageWithLeftCapWidth:img2.size.width*0.5 topCapHeight:img2.size.height*0.5];
    }
    return cell;
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
