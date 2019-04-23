//
//  UIScrollView+KZMJRefresh.m
//  KZBaseProject
//
//  Created by 孔志林 on 2018/6/7.
//  Copyright © 2018年 KMingMing. All rights reserved.
//

#import "UIScrollView+KZMJRefresh.h"

@implementation UIScrollView (KZMJRefresh)
#pragma mark - 头部刷新
/** 添加普通头部刷新 */
- (void)p_addHeaderRefresh:(MJRefreshComponentRefreshingBlock)block
{
    self.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:block];
}
/**  添加动画刷新    */
- (void)p_addGifHeaderRefreshWitIdle:(NSArray *)idle pulling:(NSArray *)pulling refreshing:(NSArray *)refreshing block:(MJRefreshComponentRefreshingBlock)block
{
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:block];
    [header setImages:idle forState:MJRefreshStateIdle];
    [header setImages:pulling forState:MJRefreshStatePulling];
    [header setImages:refreshing forState:MJRefreshStateRefreshing];
    
    //#pragma mark --- 自定义刷新状态和刷新时间文字【当然了，对应的Label不能隐藏】
    //    // Set title
    //    [header setTitle:@"Pull down to refresh" forState:MJRefreshStateIdle];
    //    [header setTitle:@"Release to refresh" forState:MJRefreshStatePulling];
    //    [header setTitle:@"Loading ..." forState:MJRefreshStateRefreshing];
    //
    //    // Set font
    //    header.stateLabel.font = [UIFont systemFontOfSize:15];
    //    header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:14];
    //
    //    // Set textColor
    //    header.stateLabel.textColor = [UIColor redColor];
    //    header.lastUpdatedTimeLabel.textColor = [UIColor blueColor];
    
    self.mj_header = header;
}
/** 开始头部刷新 */
- (void)p_beginHeaderRefresh
{
    [self.mj_header beginRefreshing];
}
/** 结束头部刷新 */
- (void)p_endHeaderRefresh
{
    [self.mj_header endRefreshing];
}

#pragma mark - 脚部刷新
/** 添加脚部自动刷新 */
- (void)p_addAutoFooterRefresh:(MJRefreshComponentRefreshingBlock)block
{
    self.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:block];
}
/** 添加脚步上拉刷新 */
- (void)p_addBackFooterRefresh:(MJRefreshComponentRefreshingBlock)block
{
    self.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:block];
}
/** 开始脚部刷新 */
- (void)p_beginFooterRefresh
{
    [self.mj_footer beginRefreshing];
}
/** 结束脚部刷新 */
- (void)p_endFooterRefresh
{
    [self.mj_footer endRefreshing];
}
@end
