//
//  Dock.m
//  SinaWeibo
//
//  Created by orange on 15/6/16.
//  Copyright (c) 2015年 orange. All rights reserved.
//

#import "Dock.h"
#import "DockItem.h"
@interface Dock()
{
    DockItem *_selectedItem;
}
@end

@implementation Dock
//
//- (id)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tabbar_background.png"]];
//    }
//    
//    return self;
//}

#pragma mark - 添加一个选项卡
-(void)addItemWithIcon:(NSString *)icon selectedIcon:(NSString *)selected title:(NSString *)title
{
    DockItem *item = [[DockItem alloc]init];
    [item setTitle:title forState:UIControlStateNormal];
    [item setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];

    [item setImage:[UIImage imageNamed:selected] forState:UIControlStateSelected];
    //监听item的点击
    [item addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchDown];
    
    //2. 调整item的frame
    //每次添加一次Item的时候重新调整所有Item的位置
    
//    item.frame = CGRectMake(;, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)
    
    //3. Add Item
    [self addSubview:item];

    //添加动画
//    [UIView beginAnimations:nil context:nil];
    
    //4. 调整所有Item的frame
    int count = self.subviews.count;
    if (count==1) {
        [self itemClick:item];
    }
    CGFloat height = self.frame.size.height;//Dock高度即为每个选项卡高度
    CGFloat width = self.frame.size.width/count;
    
    for (int i=0; i<count; i++) {
        DockItem *dockItem = self.subviews[i];
        dockItem.tag = i;//绑定标记
        dockItem.frame = CGRectMake(width*i, 0, width, height);
//        if(i==0){
//            //模拟首页点中
////            dockItem.selected = YES;
////            _selectedItem = dockItem;
////            NSLog(@"_selectedItem%@",_selectedItem);
//            [self itemClick:dockItem];
//        }
        //自定义item选中
        if (i==self.selectedIndex) {
            [self itemClick:dockItem];
        }
    }
//    提交动画
//    [UIView commitAnimations];
    
}


#pragma mark 监听item点击
-(void)itemClick:(DockItem *)item
{
    //4.通知代理——赋值之前通知代理
    if([_delegate respondsToSelector:@selector(dock:itemSelectedFrom:to:)]){
        [_delegate dock:self itemSelectedFrom:_selectedItem.tag to:item.tag];
    }
    //1.取消选中当前选中的item
    _selectedItem.selected = NO;
    //2.选中点击的item
    item.selected=YES;
    //3.赋值
    _selectedItem = item;
    //使用代理通知主控制器切换界面
    
}

@end
