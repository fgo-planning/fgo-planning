//
//  FGLiZhuangViewController.m
//  FGO
//
//  Created by 孔志林 on 2018/12/3.
//  Copyright © 2018年 KMingMing. All rights reserved.
//

#import "FGLiZhuangViewController.h"
#import "FGLiZhuangTableViewCell.h"
#import <MWPhotoBrowser.h>
@interface FGLiZhuangViewController ()<UITableViewDelegate, UITableViewDataSource,MWPhotoBrowserDelegate,FGLiZhuangTableViewCellDelegate>
/**  tableView    */
@property (nonatomic, strong) UITableView *tableView;
/**  数据源    */
@property (nonatomic, strong) NSArray *dataArray;
/**  images    */
@property (nonatomic, strong) NSMutableArray *images;
@end

@implementation FGLiZhuangViewController
#pragma mark - Life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self p_config];
    [self p_createUI];
}
- (void)setCardInfoModel:(FGHeroDetailCardInfoModel *)cardInfoModel;
{
    _cardInfoModel = cardInfoModel;
    [self.tableView reloadData];
}
#pragma mark - Private methods
- (void)p_config
{
    self.view.backgroundColor = [UIColor whiteColor];
}
- (void)p_createUI
{
    [self.view addSubview:self.tableView];
}
- (void)p_showImage
{
    self.images = [NSMutableArray array];
    
    MWPhoto *photo = [MWPhoto photoWithURL:[NSURL URLWithString:self.cardInfoModel.pic1]];
    [self.images addObject:photo];
    //初始化
    MWPhotoBrowser *photoBrowser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    
    [photoBrowser setCurrentPhotoIndex:0];
    photoBrowser.displayActionButton = NO;//显示分享按钮(左右划动按钮显示才有效)
    photoBrowser.displayNavArrows = NO; //显示左右划动
    photoBrowser.displaySelectionButtons = NO; //是否显示选择图片按钮
    photoBrowser.alwaysShowControls = NO; //控制条始终显示
    photoBrowser.zoomPhotosToFill = YES; //是否自适应大小
    photoBrowser.enableGrid = NO;//是否允许网格查看图片
    photoBrowser.startOnGrid = NO; //是否以网格开始;
    photoBrowser.enableSwipeToDismiss = YES;
    photoBrowser.autoPlayOnAppear = NO;//是否自动播放视频
    
    //这样处理的目的是让整个页面跳转更加自然
    UINavigationController *navC = [[UINavigationController alloc] initWithRootViewController:photoBrowser];
    navC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:navC animated:YES completion:nil];
}

#pragma mark - MWPhotosBrowserDelegate
//必须实现的方法
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser{
    return  self.images.count;
}
- (id<MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index{
    
    if (index < self.images.count) {
        return [self.images objectAtIndex:index];
    }
    return nil;
}
//可选方法
- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser didDisplayPhotoAtIndex:(NSUInteger)index{
    NSLog(@"当前显示图片编号----%ld",index);
}
- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser actionButtonPressedForPhotoAtIndex:(NSUInteger)index{
    NSLog(@"分享按钮的点击方法----%ld",index);
}

- (BOOL)photoBrowser:(MWPhotoBrowser *)photoBrowser isPhotoSelectedAtIndex:(NSUInteger)index{
    //浏览图片时是图片是否选中状态
    return NO;
}
-(void)photoBrowserDidFinishModalPresentation:(MWPhotoBrowser *)photoBrowser{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - FGLiZhuangTableViewCellDelegate
- (void)tapFGLiZhuangTableViewCellLookBtn:(FGLiZhuangTableViewCell *)cell
{
    [self p_showImage];
}
#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FGLiZhuangTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FGLiZhuangTableViewCell"];
    cell.delegate = self;
    cell.cardInfoModel = self.cardInfoModel;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0f;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"";
}
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UITableViewCell *cell = [UITableViewCell new];
//    cell.accessoryType = UITableViewCellAccessoryCheckmark;
//    return cell;
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 0.1f;
//}
//- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
//{
//    return @" ";
//}
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    return [UIView new];
//}


//
#pragma mark - Lazy load
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MainWidth, MainHeight - HeightOfStaAndNav - HeightOfFromBottom - 160) style:UITableViewStylePlain]; //UITableViewStylePlain,section头部固定在顶部。UITableViewStyleGrouped,头部向上
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];//去掉底部多余线条
        _tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);//分割线两边距离为10
        //        _tableView.separatorColor = [UIColor redColor];//分割线颜色
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        _tableView.estimatedRowHeight = 700; //行高
        [_tableView registerClass:[FGLiZhuangTableViewCell class] forCellReuseIdentifier:@"FGLiZhuangTableViewCell"];
        _tableView.backgroundColor = kGrayColor;
    }
    return _tableView;
}
- (NSArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSArray array];
    }
    return _dataArray;
}


@end
