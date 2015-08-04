//
//  Define_Hong.h
//  FastView项目
//
//  Created by 许振宇 on 14-6-19.
//  Copyright (c) 2014年 许振宇. All rights reserved.
//

#ifndef FastView___Define_Hong_h
#define FastView___Define_Hong_h

#define IOS8_OR_LATER (([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)? (YES):(NO))

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

//屏幕宽
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)

//屏幕高
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

//选项卡按钮未被选中时的标题颜色
#define TAB_HaveNotBeenSelected_TitleCollor [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1]
#define SaveButton_Frame CGRectMake(10, 0, SCREEN_WIDTH-20, 40);
#define TextField_backgroundCollor [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1]

#define TimeoutInterval 20

#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]


//画边框---倒圆角
#define layer_cornerRadius 2

//画边框---边框线的颜色
#define layer_borderColor ([UIColor grayColor].CGColor)

//画边框---边框线的宽度
#define layer_borderWidth 0.5

/**
 *  NSLog Debug
 */
#ifndef __OPTIMIZE__
#define NSLog(...) NSLog(__VA_ARGS__)
#else
#define NSLog(...) {}
#endif



/**
 *  导航栏加上状态栏的高度
 */
#define  NAVIGATIONBARANDSTAREBAR_HEIGHT 64

/**
 *  列表头的高度
 */
#define TableViewHeaderHeight 40
#define HearderViewBackgroundColor [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1.0]

//不加粗字体
#define TextFont_name      @"Helvetica"

//加粗的字体
#define TextFont_name_Bold @"Helvetica-Bold"

//导航栏加上状态栏的高度
#define NavgationBarAndStareBar_height 64

//画边框---倒圆角
#define TextField_layer_cornerRadius 2

//画边框---边框线的颜色
#define TextField_layer_borderColor ([UIColor grayColor].CGColor)

//画边框---边框线的宽度
#define TextField_layer_borderWidth 0.5

//手机各版本高的比例
#define Proportion_height (SCREEN_HEIGHT==480?0.85:(SCREEN_HEIGHT==568?1:(SCREEN_HEIGHT==667?1.174:(SCREEN_HEIGHT==736?1.295:1.5))))

//手机各版本宽的比例
#define Proportion_width (SCREEN_HEIGHT==480?1:(SCREEN_HEIGHT==568?1:(SCREEN_HEIGHT==667?1.174:(SCREEN_HEIGHT==736?1.295:1.5))))

//手机各版本字体大小比例
#define Proportion_text  (SCREEN_HEIGHT==480?0.85:(SCREEN_HEIGHT==568?1:(SCREEN_HEIGHT==667?1.174:(SCREEN_HEIGHT==736?1.295:1.5))))

//输入框的高度
#define TextField_height 35
#define TextField_Font_SmallSize 15
#define TextField_Font_BigSize 17

//按钮的高度
#define Button_height 40
#define Button_Font_SmallSize 15
#define Button_Font_BigSize 17


#endif
