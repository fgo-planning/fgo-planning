//
//  FGBaoJuViewController.m
//  FGO
//
//  Created by 孔志林 on 2018/12/3.
//  Copyright © 2018年 KMingMing. All rights reserved.
//

#import "FGBaoJuViewController.h"
#import "FGBaoJuTableViewCell.h"
#import <KRVideoPlayerController.h>
#import "AppDelegate+KZConfig.h"
//#import <ZFPlayer/ZFPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
@interface FGBaoJuViewController ()<UITableViewDelegate, UITableViewDataSource,FGBaoJuTableViewCellDelegate, AVPlayerViewControllerDelegate>
/**  tableView    */
@property (nonatomic, strong) UITableView *tableView;
/**  数据源    */
@property (nonatomic, strong) NSArray *dataArray;
/**  宝具模型    */
@property (nonatomic, strong) FGHeroDetailTreasureModel *treasureModel;
/**  技能个数    */
@property (nonatomic, strong) NSMutableArray *bjSkills;
/**  视频播放    */
//@property (nonatomic, strong) KRVideoPlayerController *playVC;
@end

@implementation FGBaoJuViewController
#pragma mark - Life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self p_config];
    [self p_createUI];
}
- (void)setModel:(FGHeroDetailModel *)model
{
    _model = model;
    self.treasureModel = model.treasure;
    
    NSArray *rows = [self.treasureModel.tDesc componentsSeparatedByString:@"-"];
    NSArray *tlvs = [self.treasureModel.tLv componentsSeparatedByString:@"-"];
    [rows enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        FGBaoJuModel *model = [FGBaoJuModel new];
        model.bjDetail = obj;
        NSString *tlv = tlvs[idx];
        NSArray *skillNumbers = [tlv componentsSeparatedByString:@"|"];
        model.skillNumbers = skillNumbers;
        [self.bjSkills addObject:model];
    }];
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
#pragma mark - FGBaoJuTableViewCellDelegate
- (void)baoJuCellTapDHBtn:(FGBaoJuTopTableViewCell *)cell
{
    //播放宝具动画
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (delegate.isWifi) {
        [self p_playVideo];
    }else
    {
        [self p_alertTitle:@"将使用移动网络播放视频" message:@"您当前的网络不是wifi,要继续播放吗" sureBlock:^(UIAlertAction *action) {
            [self p_playVideo];
        }];
    }
}
#pragma mark - 播放视频
- (void)p_playVideo
{
//    [self.playVC showInWindow];

    //步骤1：获取视频路径
    NSString *webVideoPath = @"http://api.junqingguanchashi.net/yunpan/bd/c.php?vid=/junqing/1213.mp4";
    NSURL *webVideoUrl = [NSURL URLWithString:self.treasureModel.animeAddr];
    //步骤2：创建AVPlayer
    AVPlayer *avPlayer = [[AVPlayer alloc] initWithURL:webVideoUrl];
    //步骤3：使用AVPlayer创建AVPlayerViewController，并跳转播放界面
    AVPlayerViewController *avPlayerVC =[[AVPlayerViewController alloc] init];
    avPlayerVC.delegate = self;
    avPlayerVC.player = avPlayer;
    [avPlayer play];
    [self presentViewController:avPlayerVC animated:YES completion:nil];
    
}
#pragma mark - AVPlayerViewControllerDelegate
- (void)playerViewControllerWillStartPictureInPicture:(AVPlayerViewController *)playerViewController
{
    
}
- (void)playerViewControllerDidStartPictureInPicture:(AVPlayerViewController *)playerViewController
{
    
}
- (void)playerViewController:(AVPlayerViewController *)playerViewController failedToStartPictureInPictureWithError:(NSError *)error
{
    
}


- (void)playerViewControllerWillStopPictureInPicture:(AVPlayerViewController *)playerViewController
{
    
}
- (void)playerViewControllerDidStopPictureInPicture:(AVPlayerViewController *)playerViewController
{
    
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else if (section == 1)
    {
        return self.bjSkills.count;
    }else
    {
        return 1;
    }

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        FGBaoJuTopTableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"FGBaoJuTopTableViewCell"];
        cell.model = self.treasureModel;
        cell.delegate = self;
        return cell;
    }else if (indexPath.section == 1)
    {
        FGBaoJuCenterTableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"FGBaoJuCenterTableViewCell"];
        cell.model = self.bjSkills[indexPath.row];
        return cell;
    }else
    {
        FGBaoJuBottomTableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"FGBaoJuBottomTableViewCell"];
        cell.model = self.treasureModel;
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        return [FGBaoJuTopTableViewCell p_getCellHeight];
    }else if (indexPath.section == 1)
    {
        return [FGBaoJuCenterTableViewCell p_getCellHeight];

    }else
    {
        return [FGBaoJuBottomTableViewCell p_getCellHeight];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0f;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"";
}

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
//        _tableView.rowHeight = 40; //行高
        [_tableView registerClass:[FGBaoJuTopTableViewCell class] forCellReuseIdentifier:@"FGBaoJuTopTableViewCell"];
        [_tableView registerClass:[FGBaoJuCenterTableViewCell class] forCellReuseIdentifier:@"FGBaoJuCenterTableViewCell"];
        [_tableView registerClass:[FGBaoJuBottomTableViewCell class] forCellReuseIdentifier:@"FGBaoJuBottomTableViewCell"];
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
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
- (NSMutableArray *)bjSkills {
    if (!_bjSkills) {
        _bjSkills = [NSMutableArray array];
    }
    return _bjSkills;
}
//- (KRVideoPlayerController *)playVC {
//    if (!_playVC) {
//        _playVC = [[KRVideoPlayerController alloc] initWithFrame:CGRectMake(0, 0, MainWidth, MainWidth*(9.0/16.0))];
//        _playVC.contentURL = [NSURL URLWithString:self.treasureModel.animeAddr];
//    }
//    return _playVC;
//}
@end
