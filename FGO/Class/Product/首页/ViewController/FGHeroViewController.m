//
//  FGHeroViewController.m
//  FGO
//
//  Created by 孔志林 on 2018/11/6.
//  Copyright © 2018年 KMingMing. All rights reserved.
//

#import "FGHeroViewController.h"
#import "FGHeroListViewController.h"
#import "FGMainVIiewModel.h"
#import <PYSearch.h>
#import "KZBaseUINavigationController.h"
#import "FGHeroModel.h"
#import "FGHeroDetailViewController.h"
#import "JQFMDB.h"
#import "FGHaveHeroModel.h"
@interface FGHeroViewController ()<UITextFieldDelegate, PYSearchViewControllerDelegate, PYSearchViewControllerDataSource>
/**  ViewModel    */
@property (nonatomic, strong) FGMainVIiewModel *viewModel;
@property (nonatomic, strong) NSArray *models;
/**  搜索    */
@property (nonatomic, strong) UITextField *searchTF;
/**  搜索结果    */
@property (nonatomic, strong) NSArray *searchResults;
/**  全部、喜欢、拥有    */
@property (nonatomic, strong) UIButton *rightBtn;
/**  全部英雄    */
@property (nonatomic, strong) NSArray *allHeros;
/**  <##>    */
@property (nonatomic, strong) JQFMDB *db;
@end

@implementation FGHeroViewController
#pragma mark - Life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self p_config];
    [self p_createUI];
    [self p_loadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSString *title = self.rightBtn.titleLabel.text;
    if ([title isEqualToString:@"关注"])
    {
        [self.viewModel getLikeHeroList:^(id obj, NSURLSessionDataTask *dataTask) {
            self.models = obj;
            [self reloadData];
        } failure:nil];
    }
}
    
#pragma mark - Private methods
- (void)p_loadData
{
    [self.viewModel getHeroList:^(id obj,NSURLSessionDataTask *dataTask) {
        self.models = obj;
        self.allHeros = obj;
        [self reloadData];
    } failure:^(NSError *err) {
        NSLog(@"");
    }];
}
- (void)p_config
{
    [self p_defaultSetting];
    
    self.navigationItem.title = @"英雄列表";
    self.view.backgroundColor = kGrayColor;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 30, 30);
    [button setImage:[UIImage imageNamed:@"FG_back"] forState:UIControlStateNormal];
    button.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 10);
    [button addTarget:self action:@selector(p_popViewController) forControlEvents:UIControlEventTouchUpInside];
    UIView *btView = [[UIView alloc] initWithFrame:button.frame];
    [btView addSubview:button];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btView];
    self.navigationItem.leftBarButtonItem = item;
}

- (void)rightBarButtonItemClick:(UIButton *)sender
{
    NSString *title = sender.titleLabel.text;
    NSArray *titles = @[@"全部",@"拥有",@"关注"];
    
    if ([title isEqualToString:titles[0]])
    {
        title = titles[1];
        sender.backgroundColor = kHaveColor;
    }else if ([title isEqualToString:titles[1]])
    {
        title = titles[2];
        sender.backgroundColor = kLikeColor;
    }else
    {
        title = titles[0];
        sender.backgroundColor = kSelectedColor;
    }
    [sender setTitle:title forState:UIControlStateNormal];
    
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(p_refreshData:) object:sender];
    [self performSelector:@selector(p_refreshData:) withObject:sender afterDelay:0.2f];
}
- (void)p_refreshData:(UIButton *)sender
{
    NSString *title = sender.titleLabel.text;
    if ([title isEqualToString:@"关注"]) {
        [self.viewModel getLikeHeroList:^(id obj, NSURLSessionDataTask *dataTask) {
            self.models = obj;
            [self reloadData];
        } failure:nil];
    }else if ([title isEqualToString:@"全部"])
    {
        self.models = self.allHeros;
        [self reloadData];
    }else //拥有
    {
        FGHaveHeroModel *model = [self.db jq_lookupTable:kTableName(@"haveHero") dicOrModel:[FGHaveHeroModel class] whereFormat:nil].firstObject;
        NSArray *hreos = [NSKeyedUnarchiver unarchiveObjectWithData:model.data];
        self.models = hreos;
        [self reloadData];
    }
    NSLog(@"%@",title);
}
- (void)p_popViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)p_defaultSetting
{
    self.titles = @[@"ALL",@"剑",@"弓",@"枪",@"骑",@"术",@"杀",@"狂",@"其他"];
    self.menuItemWidth = MainWidth/self.titles.count;
    self.menuViewStyle = WMMenuViewStyleLine;
    self.titleColorSelected = kSelectedColor;
    //    self.progressColor = [UIColor redColor];//底下线条颜色
    [self reloadData];
}

- (void)p_createUI
{
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(15, 10, MainWidth - 30 - 75, 30)];
    textField.backgroundColor = [UIColor whiteColor];
    NSAttributedString *alert = [[NSAttributedString alloc] initWithString:@"请输入名称搜索" attributes:@{NSForegroundColorAttributeName : [UIColor lightGrayColor]}];
    textField.attributedPlaceholder = alert;
    textField.font = [UIFont systemFontOfSize:15];
    textField.layer.cornerRadius = 8;
    textField.layer.masksToBounds = YES;
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 20, 20)];
    imageView.image = [UIImage imageNamed:@"HF_search"];
    imageView.tag = 101;
    [leftView addSubview:imageView];
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(searchAction)];
    leftView.userInteractionEnabled = YES;
    [leftView addGestureRecognizer:recognizer];
    
    textField.leftView = leftView;
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.delegate = self;
    self.searchTF = textField;
    [self.view addSubview:textField];

    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(textField.right + 15, 10, 60, 30);
    rightBtn.backgroundColor = kSelectedColor;
    [rightBtn setTitle:@"全部" forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    rightBtn.layer.cornerRadius = 5;
    rightBtn.layer.masksToBounds = YES;
    [rightBtn addTarget:self action:@selector(rightBarButtonItemClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightBtn];
    self.rightBtn = rightBtn;

}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self searchAction];
    return NO;
}
- (void)searchAction
{
    NSArray *hotSeaches = @[@"环境气象", @"汽车客运", @"位置查询",  @"预约挂号",  @"生活缴费", @"用水服务",  @"公交查询"];
    // 2. Create searchViewController
    PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:hotSeaches searchBarPlaceholder:@"请输入名称搜索" didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        // Call this Block when completion search automatically
        // Such as: Push to a view controller
        //        [searchViewController.navigationController pushViewController:[[UIViewController alloc] init] animated:YES];
    }];
    searchViewController.delegate = self;
    searchViewController.dataSource = self;
    searchViewController.hotSearchStyle = PYHotSearchStyleColorfulTag;
    searchViewController.hotSearchTitle = @"猜你想搜";
    searchViewController.showHotSearch = NO;
    
    KZBaseUINavigationController *nav = [[KZBaseUINavigationController alloc] initWithRootViewController:searchViewController];
    searchViewController.searchTextField.tintColor = [[UIColor blueColor] colorWithAlphaComponent:.7];
    [self presentViewController:nav  animated:NO completion:nil];
}

#pragma mark - PYSearchViewControllerDelegate
- (void)searchViewController:(PYSearchViewController *)searchViewController
      didSearchWithSearchBar:(UISearchBar *)searchBar
                  searchText:(NSString *)searchText
{
    NSArray *results = [self.viewModel getSearchResultFrom:self.models[0] heroName:searchText];
    self.searchResults = results;
    [searchViewController.searchSuggestionView reloadData];
}
- (void)searchViewController:(PYSearchViewController *)searchViewController
didSelectSearchSuggestionAtIndex:(NSInteger)index
                  searchText:(NSString *)searchText
{
    FGHeroDetailViewController *vc = [FGHeroDetailViewController new];
    FGHeroModel *model = self.searchResults[index];
    vc.ID = model.ID;
    vc.heroModel = model;
    vc.heroName = model.name;
    [searchViewController.navigationController pushViewController:vc animated:YES];
}
- (void)didClickCancel:(PYSearchViewController *)searchViewController
{
    [self dismissViewControllerAnimated:NO completion:nil];
}
- (CGFloat)searchSuggestionView:(UITableView *)searchSuggestionView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (NSInteger)searchSuggestionView:(UITableView *)searchSuggestionView numberOfRowsInSection:(NSInteger)section
{
    return self.searchResults.count;
}
- (UITableViewCell *)searchSuggestionView:(UITableView *)searchSuggestionView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [searchSuggestionView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UITableViewCell"];
        UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(10, 59, MainWidth - 20, 1)];
        lb.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.1];
        [cell.contentView addSubview:lb];
    }
    FGHeroModel *model = self.searchResults[indexPath.row];
    cell.textLabel.text = model.name;
    cell.detailTextLabel.text = model.clazz;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@    ID: %@",model.clazz, model.heroID];
    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:model.imgPath ofType:nil];
    if (imagePath) {
        cell.imageView.image = [UIImage imageWithContentsOfFile:imagePath];
    }else
    {
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:model.imgPath]];
    }
    
    CGSize itemSize = CGSizeMake(45, 45);
    UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    [cell.imageView.image drawInRect:imageRect];
    cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return cell;
}

- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController
{
    return self.titles.count;
}

- (__kindof UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index
{
    FGHeroListViewController *vc = [FGHeroListViewController new];
    vc.headerTitle = self.titles[index];
    vc.models = self.models[index];
    return vc;
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index
{
    return self.titles[index];
}
- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView
{
    return CGRectMake(0, 50, MainWidth, 40);
}
- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView
{
    CGFloat distance = pageController.menuView.height + 10;
    return CGRectMake(0, pageController.menuView.bottom + 10, MainWidth, MainHeight - HeightOfStaAndNav - HeightOfTabBar - distance);
}

#pragma mark - Lazy load
- (FGMainVIiewModel *)viewModel
{
    if (!_viewModel) {
        _viewModel = [FGMainVIiewModel new];
    }
    return _viewModel;
}
- (JQFMDB *)db
{
        _db = [JQFMDB shareDatabase];
    return _db;
}

@end
