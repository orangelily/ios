//
//  Common.h
//  SinaWeibo
//
//  Created by orange on 15/6/15.
//  Copyright (c) 2015年 orange. All rights reserved.
//

//#ifndef SinaWeibo_Common_h
//#define SinaWeibo_Common_h
//1. 判断是否是iPhone5的宏
#define iPhone5 ([UIScreen mainScreen].bounds.size.height == 568)


//2.日志输出宏定义
#ifndef DEBUG
// 调试状态-
#define MyLog(...) NSLog(__VA_ARGS__)

#else
//发布状态--删除打印
#define MyLog(...) //可不写 可加注释
#endif
