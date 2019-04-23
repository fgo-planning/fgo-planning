//
//  FGCountViewController.m
//  FGO
//
//  Created by 孔志林 on 2019/1/8.
//  Copyright © 2019年 KMingMing. All rights reserved.
//

#import "FGCountViewController.h"
#import "JQFMDB.h"
@interface FGCountViewController ()<UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate>
/**  tableView    */
@property (nonatomic, strong) UITableView *tableView;
/**  数据源    */
@property (nonatomic, strong) NSMutableArray *dataArray;
/**      */
@property (nonatomic, strong)   UIAlertAction *sure;
/**  <##>    */
@property (nonatomic, strong) JQFMDB *db;
/**  <##>    */
@property (nonatomic, copy) NSString *countTitle;
@end

#define kDeTableName(tableName,cuttentName) [NSString stringWithFormat:@"%@_%@",tableName,cuttentName]


@implementation FGCountViewController
#pragma mark - Life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self p_config];
    [self p_createUI];
}

#pragma mark - Private methods
- (void)p_config
{
    self.navigationItem.title = @"当前账号";
    self.view.backgroundColor = [UIColor whiteColor];
    
//    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(rightBarButtonItemClick)];
//    self.navigationItem.rightBarButtonItem = item;
    
    //读取数据源
    NSArray *counts = [self.db jq_lookupTable:@"FGCountModel" dicOrModel:[FGCountModel class] whereFormat:nil];
    self.dataArray = [counts mutableCopy];
    
}
- (void)p_createUI
{
    [self.view addSubview:self.tableView];
}
- (void)rightBarButtonItemClick
{
    UIAlertController *alvc = [UIAlertController alertControllerWithTitle:nil message:@"输入名称" preferredStyle:UIAlertControllerStyleAlert];
    [alvc addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入账号名称";
        textField.delegate = self;
    }];
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            //需要遍历当前账号，如果是一样的名字就设置不能点击
        if (self.countTitle.length == 0) {
            [self p_toast:@"账号名称不能为空"];
            return ;
        }
            //读取数据源
            NSArray *counts = [self.db jq_lookupTable:@"FGCountModel" dicOrModel:[FGCountModel class] whereFormat:nil];
        __block BOOL isReturn = NO;
            [counts enumerateObjectsUsingBlock:^(FGCountModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([model.name isEqualToString:self.countTitle]) {
                    *stop = YES;
                    [self p_toast:@"添加失败,账号名称不能重复"];
                    isReturn = YES;
                }
            }];
        if (isReturn) {
            return ;
        }
        FGCountModel *model = [FGCountModel new];
        model.isSelected = @"YES";
        model.name = self.countTitle;
        
        [self.dataArray enumerateObjectsUsingBlock:^(FGCountModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.isSelected = @"NO";
        }];
        [self.dataArray addObject:model];
        [self.db jq_deleteAllDataFromTable:@"FGCountModel"];
        [self.db jq_insertTable:@"FGCountModel" dicOrModelArray:self.dataArray];
        [self.tableView reloadData];
    }];
    
    [alvc addAction:cancle];
    [alvc addAction:sure];
    self.sure = sure;
    [self presentViewController:alvc animated:YES completion:nil];
}
#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"%@",textField.text);
    self.countTitle = textField.text;
}
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    //需要遍历当前账号，如果是一样的名字就设置不能点击
//    //读取数据源
//    NSArray *counts = [self.db jq_lookupTable:@"FGCountModel" dicOrModel:[FGCountModel class] whereFormat:nil];
//    [counts enumerateObjectsUsingBlock:^(FGCountModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
//        if ([model.name isEqualToString:textField.text]) {
//            self.sure.enabled = NO;
//            *stop = YES;
//        }else{
//            self.sure.enabled = YES;
//        }
//    }];
//    return YES;
//}
#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FGCountModel *model = self.dataArray[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UITableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = model.name;
    cell.detailTextLabel.text = model.userID;
    cell.detailTextLabel.textColor = [UIColor grayColor];
    if ([model.isSelected isEqualToString:@"YES"]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FGCountModel *selectedModel = self.dataArray[indexPath.row];
    [self.dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        FGCountModel *model = obj;
        if ([model isEqual:selectedModel]) {
            model.isSelected = @"YES";
        }else
        {
            model.isSelected = @"NO";
        }
    }];
    [self.db jq_deleteAllDataFromTable:@"FGCountModel"];
    [self.db jq_insertTable:@"FGCountModel" dicOrModelArray:self.dataArray];
    [self.tableView reloadData];
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row > 0) {
        return YES;
    }
    return NO;
}
// 定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
// 修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}
// 进入编辑模式，按下出现的编辑按钮后,进行删除操作
- (void)tableView:(UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath*)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        FGCountModel *model = self.dataArray[indexPath.row];
        if ([model.isSelected isEqualToString:@"YES"]) {
            FGCountModel *nextModel = self.dataArray[indexPath.row - 1];
            nextModel.isSelected = @"YES";
            [self.dataArray removeObjectAtIndex:indexPath.row];
        }else{
            [self.dataArray removeObjectAtIndex:indexPath.row];
        }
        [self.db jq_deleteAllDataFromTable:@"FGCountModel"];
        [self.db jq_insertTable:@"FGCountModel" dicOrModelArray:self.dataArray];
        
        NSString *tableName = [NSString stringWithFormat:@"kHeroLevel_%@",model.name];
        [[JQFMDB shareDatabase] jq_deleteTable:tableName];
        
        [[JQFMDB shareDatabase] jq_deleteTable:kDeTableName(@"sourceInfo", model.name)];//保存的素材信息
        [[JQFMDB shareDatabase] jq_deleteTable:kDeTableName(@"likeHero", model.name)];//喜欢的英雄列表
        [[JQFMDB shareDatabase] jq_deleteTable:kDeTableName(@"haveHero", model.name)];//拥有的英雄列表
        [[JQFMDB shareDatabase] jq_deleteTable:kDeTableName(@"FGActivityModel", model.name)];//打开的活动列表

        
        [UIView performWithoutAnimation:^{
            [self.tableView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:indexPath]
                                  withRowAnimation:UITableViewRowAnimationNone];
        }];
        [self.tableView reloadData];
    }
}

#pragma mark - Lazy load
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MainWidth, MainHeight - HeightOfStaAndNav - HeightOfFromBottom) style:UITableViewStylePlain]; //UITableViewStylePlain,section头部固定在顶部。UITableViewStyleGrouped,头部向上
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];//去掉底部多余线条
        _tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);//分割线两边距离为10
//        _tableView.separatorColor = [UIColor lightGrayColor];//分割线颜色
        _tableView.rowHeight = 50; //行高
    }
    return _tableView;
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (JQFMDB *)db//保存账号
{
    if (!_db) {
        _db = [JQFMDB shareDatabase];
        BOOL isExist = [_db jq_isExistTable:@"FGCountModel"];
        if (!isExist) {
            [_db jq_createTable:@"FGCountModel" dicOrModel:[FGCountModel class]];
            
            FGCountModel *model = [FGCountModel new];
            model.isSelected = @"YES";
            model.name = @"默认";
            model.userID = @"o";
            [_db jq_insertTable:@"FGCountModel" dicOrModel:model];
        }
    }
    return _db;
}
@end

@implementation FGCountModel
@end
