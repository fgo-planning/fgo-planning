
//
//  KZMacro.h
//  KZBaseProject
//
//  Created by 孔志林 on 2018/6/7.
//  Copyright © 2018年 KMingMing. All rights reserved.
//

#ifndef KZMacro_h
#define KZMacro_h


#ifdef DEBUG
# define NSLog(fmt, ...) NSLog((@"[函数名:%s][行号:%d]\n打印内容🐒:%@\n"),__FUNCTION__, __LINE__,[NSString stringWithFormat:(fmt), ##__VA_ARGS__]);
#else
# define NSLog(...);
#endif


/***********************  常用代码块    ***********************/
#define BoundsOfMainScreen [[UIScreen mainScreen] bounds]
#define WithOfMainScreen [[UIScreen mainScreen] bounds].size.width
#define HeightOfMainScreen [[UIScreen mainScreen] bounds].size.height
#define MainBounds [[UIScreen mainScreen] bounds]
#define MainWidth [[UIScreen mainScreen] bounds].size.width
#define MainHeight [[UIScreen mainScreen] bounds].size.height



/***********************  常用颜色    ***********************/
#define kSelectedColor [UIColor p_rgbColorR:132 G:218 B:68]
#define kGrayColor [UIColor p_rgbColorR:240 G:240 B:240]
#define kLikeColor [UIColor p_rgbColorR:239 G:54 B:71]
#define kHaveColor [UIColor p_rgbColorR:255 G:205 B:64]

#define kJHSColor  [UIColor p_rgbColorR:250 G:136 B:31] //橘黄色
#define kqlsColor [UIColor p_rgbColorR:223 G:255 B:221] //浅绿色
#define kDLSColor [UIColor p_rgbColorR:230 G:243 B:249] //淡蓝色


/***********************  系统常量    ***********************/
#define KImagePath(path) [[NSBundle mainBundle] pathForResource:path ofType:nil]


/***********************  适配iPhoneX    ***********************/
/**  适配iponex 高度812    */
#define IS_IPHONE_X ((HeightOfMainScreen >= 812.0f && (MainWidth < 768)) ? YES : NO)

#define HeightOfNavigationBar 44.0f

#define HeightOfStatusBar ((IS_IPHONE_X==YES) ? 44.0f : 20.0f)

#define HeightOfStaAndNav ((IS_IPHONE_X==YES) ? 88.0f : 64.0f)

#define HeightOfTabBar ((IS_IPHONE_X==YES) ? 83.0f : 49.0f)

#define HeightOfFromBottom ((IS_IPHONE_X==YES) ? 34.0f : 0.0f)




#endif /* KZMacro_h */
