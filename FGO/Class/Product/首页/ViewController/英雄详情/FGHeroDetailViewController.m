//
//  FGHeroDetailViewController.m
//  FGO
//
//  Created by 孔志林 on 2018/11/15.
//  Copyright © 2018年 KMingMing. All rights reserved.
//

#import "FGHeroDetailViewController.h"
#import <MWPhotoBrowser.h>
#import <HCSStarRatingView.h>
#import "FGMainVIiewModel.h"
#import "FGHeroJiNengViewController.h"
#import "FGHeroDetailModel.h"
#import "JQFMDB.h"
#import "FGBaoJuViewController.h"
#import "FGLiZhuangViewController.h"

@interface FGHeroDetailViewController ()<MWPhotoBrowserDelegate>
@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, strong) UIImageView *heroIV;
/**  攻击、血量    */
@property (nonatomic, strong) UILabel *gjLabel, *xlLabel, *ljLabel;
/**  关注按钮、小火箭、归零    */
@property (nonatomic, strong) UIButton *likeBtn, *xhjBtn, *glBtn;
/**  星星view    */
@property (nonatomic, strong) HCSStarRatingView *starView;
/**  <##>    */
@property (nonatomic, strong) FGHeroDetailModel *model;
/**  <##>    */
@property (nonatomic, strong) FGHeroJiNengViewController *jiNengVC;
/**  jqFMDB    */
@property (nonatomic, strong) JQFMDB *db;

@end

@implementation FGHeroDetailViewController

#pragma mark - Life circle
- (void)viewDidLoad {
    [super viewDidLoad];

    [self p_showMBProgressHUD];
    [[FGMainVIiewModel sharedInstance] getHeroDetaiWithID:self.ID success:^(id obj, NSURLSessionDataTask *dataTask) {
        [self p_hideMBProgressHUD];
        [self p_config];
        [self p_createUI];
        FGHeroDetailModel *model = obj;
        self.model = model;
        
        //读取喜欢按钮的状态
        NSArray *array  = [self.db jq_lookupTable:kTableName(@"likeHero") dicOrModel:[FGHeroModel class] whereFormat:[NSString stringWithFormat:@"where ID = '%@'",self.ID]];
        self.likeBtn.selected = array.count > 0 ?: NO;

    } failure:^(id err) {
        [self p_hideMBProgressHUD];
    }];

}
- (void)setModel:(FGHeroDetailModel *)model
{
    _model = model;
    self.gjLabel.text = [NSString stringWithFormat:@"攻击:%@", [model.maxAtk stringValue]];
    self.xlLabel.text = [NSString stringWithFormat:@"血量:%@", [model.maxHp stringValue]];
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:model.imgPath ofType:nil];
    if (imagePath) {
        self.heroIV.image = [UIImage imageWithContentsOfFile:imagePath];
    }else
    {
        [self.heroIV sd_setImageWithURL:[NSURL URLWithString:model.imgPath]];
    }
    
    //读取保存的技能
    NSArray *data= [[JQFMDB shareDatabase] jq_lookupTable:kHeroLevel dicOrModel:[FGHeroSkillModel class] whereFormat:[NSString stringWithFormat:@"where servantId = '%@'",model.servantId]];
    if (![NSArray isNullOrEmptyArray:data]) {
        FGHeroSkillModel *skillModel = data[0];
        NSArray *skillArr = [NSKeyedUnarchiver unarchiveObjectWithData:skillModel.skillLevel];
        model.setSkill = skillArr;
        self.starView.value = [skillModel.lingjiValue floatValue];
        [self didChangeValue:self.starView];
    }
//    [self reloadData];
    self.jiNengVC.detailModel = self.model;
}
#pragma mark - Private methods
- (void)p_config
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLingJI) name:@"updateLingJiNotification" object:nil];
    
    self.navigationItem.title = self.heroName;
    self.view.backgroundColor = [UIColor whiteColor];
//    self.navigationItem.rightBarButtonItem =  [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"like"] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemClick)];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 30, 30);
    [button setImage:[UIImage imageNamed:@"FG_back"] forState:UIControlStateNormal];
    button.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 10);
    [button addTarget:self action:@selector(p_popViewController) forControlEvents:UIControlEventTouchUpInside];
    UIView *btView = [[UIView alloc] initWithFrame:button.frame];
    [btView addSubview:button];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btView];
    self.navigationItem.leftBarButtonItem = item;
    
    [self p_defaultSetting];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updateLingJiNotification" object:nil];
}
- (void)p_defaultSetting
{
    self.titles = @[@"技能",@"宝具",@"礼装"];//@"特攻",@"卡池"
    self.menuItemWidth = (MainWidth - 20)/self.titles.count;
    self.progressWidth = (MainWidth - 20)/ (self.titles.count + 2);
    self.menuViewStyle = WMMenuViewStyleSegmented;
    self.scrollEnable = NO;
    self.titleColorSelected = kJHSColor;
    self.progressColor = [UIColor p_rgbColorR:222 G:255 B:222];//底下线条颜色
    self.view.backgroundColor = kGrayColor;
    self.pageAnimatable = NO;
    
    [self reloadData];
}
- (void)updateLingJI
{
    self.starView.value = 4;
    [self didChangeValue:self.starView];
    self.xhjBtn.selected = YES;
}

- (void)p_createUI
{
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainWidth, 120)];
    topView.backgroundColor = kGrayColor;
    [self.view addSubview:topView];
    [topView addSubview:self.heroIV];
    [topView addSubview:self.gjLabel];
    [topView addSubview:self.xlLabel];
    [topView addSubview:self.ljLabel];
    [topView addSubview:self.likeBtn];
    [topView addSubview:self.xhjBtn];
    [topView addSubview:self.glBtn];
    [self.heroIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(10);
        make.size.equalTo(CGSizeMake(100, 100));
    }];
    [self.gjLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.heroIV.mas_right).offset(10);
        make.top.equalTo(self.heroIV).offset(0);
        make.size.equalTo(CGSizeMake(MainWidth - 180, 30));
    }];
    [self.xlLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.heroIV.mas_right).offset(10);
        make.top.equalTo(self.gjLabel.mas_bottom).offset(0);
        make.size.equalTo(CGSizeMake(MainWidth - 180, 30));
    }];
    [self.ljLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.heroIV.mas_right).offset(10);
        make.top.equalTo(self.xlLabel.mas_bottom).offset(10);
        make.size.equalTo(CGSizeMake(30, 30));
    }];
    [self.likeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-10);
        make.size.equalTo(CGSizeMake(40, 40));
        make.top.equalTo(self.heroIV).offset(0);
    }];
    [self.xhjBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-10);
        make.size.equalTo(CGSizeMake(40, 40));
        make.top.equalTo(self.likeBtn.mas_bottom).offset(5);
    }];
    [self.glBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.ljLabel).offset(0);
        make.left.equalTo(self.ljLabel.mas_right).offset(120);
        make.size.equalTo(CGSizeMake(30, 30));
    }];
//    for (UIView *v in topView.subviews) {
//        v.backgroundColor = [UIColor p_randomColor];
//    }
    [self.view layoutIfNeeded];//立即更新约束
    HCSStarRatingView *starRatingView = [[HCSStarRatingView alloc] initWithFrame:CGRectMake(self.ljLabel.right + 10, self.xlLabel.bottom + 10, 100, 30)];
    starRatingView.backgroundColor = [UIColor clearColor];
    starRatingView.maximumValue = 4;
    starRatingView.minimumValue = 0;
    starRatingView.value = 0;
    starRatingView.tintColor = kJHSColor;
    starRatingView.allowsHalfStars = NO;
    starRatingView.emptyStarImage = [[UIImage imageNamed:@"heart-empty"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    starRatingView.filledStarImage = [[UIImage imageNamed:@"heart-full"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [starRatingView addTarget:self action:@selector(didChangeValue:) forControlEvents:UIControlEventValueChanged];
    [topView addSubview:starRatingView];
    self.starView = starRatingView;
 
}
#pragma mark - 传入灵基等级
- (void)didChangeValue:(HCSStarRatingView *)sender {
    NSLog(@"Changed rating to %.1f", sender.value);
    self.glBtn.selected = (sender.value > 0) ? YES : NO;
    self.model.lingJIValue = sender.value;
    
    FGHeroJiNengViewController *vc = self.jiNengVC;
    vc.lingJIValue = sender.value;
    vc.isSetLevel = YES;
    
}

- (void)p_popViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController
{
    return self.titles.count;
}

- (__kindof UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index
{
    if (index == 0) {
        FGHeroJiNengViewController *vc = [FGHeroJiNengViewController new];
        vc.detailModel = self.model;
        self.jiNengVC = vc;
        return vc;
    }else if (index == 1)
    {
        FGBaoJuViewController *vc = [FGBaoJuViewController new];
        vc.model = self.model;
        return vc;
    }
    else
    {
        FGLiZhuangViewController *vc = [FGLiZhuangViewController new];
        vc.cardInfoModel = self.model.cardInfo;
        return vc;
    }
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index
{
    return self.titles[index];
}
- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView
{
    return CGRectMake(10, 120, MainWidth - 20, 30);
}
- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView
{
    CGFloat distance = pageController.menuView.bottom + 10;
    return CGRectMake(0, distance, MainWidth, MainHeight - HeightOfStaAndNav - HeightOfFromBottom - distance);
}

- (void)rightBarButtonItemClick
{
    [self p_showImage];
}
- (void)p_showImage
{
    self.images = [NSMutableArray array];
    NSArray *array = @[@"A",@"B",@"C",@"D",@"E",@"F"];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *heroID = [[self.model.imgPath componentsSeparatedByString:@"/"].lastObject stringByReplacingOccurrencesOfString:@".jpg" withString:@""];
        heroID = [heroID stringByAppendingString:[NSString stringWithFormat:@"%@.jpg",obj]];
        NSString *imagePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"images/servant/info/%@",heroID] ofType:nil];
        UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
        if (image) {
            MWPhoto *photo = [MWPhoto photoWithImage:image];
            [self.images addObject:photo];
        }
    }];
    
//    for (int i = 0; i<7; i++) {
//        MWPhoto *photo = [MWPhoto photoWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"c%d",i+1]]];
//        //        photo.caption = [NSString stringWithFormat:@"%d/%d",i+1,7];
//        [self.images addObject:photo];
//    }
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
//- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index selectedChanged:(BOOL)selected{
//
//    //selected表示是否选中
//    if (selected) {
//
//        [self.selectedArray addObject:@(index)];
//        NSLog(@"第%ld张图片在被选中",index);
//    }else{
//
//        [self.selectedArray removeObject:@(index)];
//        NSLog(@"第%ld张图片在被选中",index);
//    }
//
//
//}
//有navigationBar时title才会显示
//- (NSString *)photoBrowser:(MWPhotoBrowser *)photoBrowser titleForPhotoAtIndex:(NSUInteger)index{
//
//
//    NSString *str = nil;
//    switch (index) {
//        case 0 :
//            str = @"这是第111张图片";
//            break;
//        case 1 :
//            str = @"这是第222张图片";
//            break;
//        case 2 :
//            str = @"这是第333张图片";
//            break;
//        default:
//            break;
//    }
//    return str
//    ;
//}
//如果要看缩略图必须实现这个方法
//- (id<MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index{
//    return [self.images objectAtIndex:index];
//}


#pragma mark - Lazy load
- (UIImageView *)heroIV {
    if (!_heroIV) {
        _heroIV = [[UIImageView alloc] initWithFrame:CGRectZero];
        _heroIV.contentMode = UIViewContentModeScaleAspectFit;
//        _heroIV.image = [UIImage imageNamed:@"001"];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(p_showImage)];
        _heroIV.userInteractionEnabled = YES;
        [_heroIV addGestureRecognizer:tap];
    }
    return _heroIV;
}
- (UILabel *)gjLabel {
    if (!_gjLabel) {
        _gjLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _gjLabel.textColor = [UIColor blueColor];
    }
    return _gjLabel;
}
- (UILabel *)xlLabel {
    if (!_xlLabel) {
        _xlLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _xlLabel.textColor = [UIColor blueColor];
    }
    return _xlLabel;
}
- (UILabel *)ljLabel {
    if (!_ljLabel) {
        _ljLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _ljLabel.adjustsFontSizeToFitWidth = YES;
        _ljLabel.textColor = kJHSColor;
        _ljLabel.text = @"灵基:";
    }
    return _ljLabel;
}
- (UIButton *)likeBtn {
    if (!_likeBtn) {
        _likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _likeBtn.tag = 100;
        [_likeBtn setImage:[UIImage imageNamed:@"like_dark"] forState:UIControlStateNormal];
        [_likeBtn setImage:[UIImage imageNamed:@"like"] forState:UIControlStateSelected];
        _likeBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_likeBtn addTarget:self action:@selector(tapAction:) forControlEvents:UIControlEventTouchUpInside];
        _likeBtn.imageEdgeInsets = UIEdgeInsetsMake(3, 3, 3, 3);
    }
    return _likeBtn;
}
- (UIButton *)xhjBtn {
    if (!_xhjBtn) {
        _xhjBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _xhjBtn.tag = 101;
        [_xhjBtn setImage:[UIImage imageNamed:@"xiaohuojian_dark"] forState:UIControlStateNormal];
        [_xhjBtn setImage:[UIImage imageNamed:@"xiaohuojian"] forState:UIControlStateSelected];
        _xhjBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_xhjBtn addTarget:self action:@selector(tapAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _xhjBtn;
}
- (UIButton *)glBtn {
    if (!_glBtn) {
        _glBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _glBtn.tag = 102;
        [_glBtn setImage:[UIImage imageNamed:@"reset_off"] forState:UIControlStateNormal];
        [_glBtn setImage:[UIImage imageNamed:@"reset"] forState:UIControlStateSelected];
        _xhjBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_glBtn addTarget:self action:@selector(tapAction:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _glBtn;
}
- (JQFMDB *)db
{
        _db = [JQFMDB shareDatabase];
        BOOL isAlready = [_db jq_isExistTable:kTableName(@"likeHero")];
        if (!isAlready) {
            [_db jq_createTable:kTableName(@"likeHero") dicOrModel:[FGHeroModel class]];
        }        
    return _db;
}

- (void)tapAction:(UIButton *)sender
{
    switch (sender.tag) {
        case 100://喜欢
            {
                sender.selected  = !sender.selected;
                
                if (sender.selected) {//保存当前英雄为喜欢
                    [self.db jq_deleteTable:kTableName(@"likeHero") whereFormat:[NSString stringWithFormat:@"where ID = '%@'",self.ID]];
                    BOOL isSuccess = [self.db jq_insertTable:kTableName(@"likeHero") dicOrModel:self.heroModel];
                    if (isSuccess) {
                        [self p_SVProgressHUDSuccess:@"已设置为关注"];
                    }
                    NSLog(@"添加喜欢:%d",isSuccess);
                }else//删除当前英雄为喜欢
                {
                    BOOL isCancle = [self.db jq_deleteTable:kTableName(@"likeHero") whereFormat:[NSString stringWithFormat:@"where ID = '%@'",self.ID]];
                    if (isCancle) {
                        [self p_SVProgressHUDError:@"已取消关注"];
                    }
                }
            }
            break;
        case 101://小火箭
        {
            sender.selected = !sender.selected;
            [self updateLijing:sender.selected];//更新灵基

            FGHeroJiNengViewController *vc = self.jiNengVC;
            [vc p_updateSkillLevel:sender.selected];

        }
            break;
        case 102://归零
        {
            if (sender.selected) {
                self.starView.value = 0;
                [self didChangeValue:self.starView];
                sender.selected = NO;
            }
        }
            break;

        default:
            break;
    }
}
- (void)updateLijing:(BOOL)isMax
{
    self.starView.value = isMax ? 4 : 0;
    [self didChangeValue:self.starView];
}



@end
