//
//  UIScrollView+KZMJRefresh.h
//  KZBaseProject
//
//  Created by 孔志林 on 2018/6/7.
//  Copyright © 2018年 KMingMing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MJRefresh.h>

@interface UIScrollView (KZMJRefresh)
/** 添加头部刷新 */
- (void)p_addHeaderRefresh:(MJRefreshComponentRefreshingBlock)block;
/**
 gif动画刷新
 
 @param idle 设置普通状态的动画图片数组
 @param pulling 设置即将刷新状态的动画图片
 @param refreshing 设置正在刷新状态图片
 @param block 刷新时的Block
 */
- (void)p_addGifHeaderRefreshWitIdle:(NSArray *)idle pulling:(NSArray *)pulling refreshing:(NSArray *)refreshing block:(MJRefreshComponentRefreshingBlock)block;
/** 开始头部刷新 */
- (void)p_beginHeaderRefresh;
/** 结束头部刷新 */
- (void)p_endHeaderRefresh;

/** 添加脚部自动刷新 */
- (void)p_addAutoFooterRefresh:(MJRefreshComponentRefreshingBlock)block;
/** 添加脚步上拉刷新 */
- (void)p_addBackFooterRefresh:(MJRefreshComponentRefreshingBlock)block;
/** 开始脚部刷新 */
- (void)p_beginFooterRefresh;
/** 结束脚部刷新 */
- (void)p_endFooterRefresh;

@end
