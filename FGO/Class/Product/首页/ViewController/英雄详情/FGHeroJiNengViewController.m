//
//  FGHeroJiNengViewController.m
//  FGO
//
//  Created by 孔志林 on 2018/11/21.
//  Copyright © 2018年 KMingMing. All rights reserved.
//

#import "FGHeroJiNengViewController.h"
#import "FGJiNengTableViewCell.h"
#import "JQFMDB.h"
#import "FGSaveJNModel.h"
#import "FGCalcuteViewController.h"


@interface FGHeroJiNengViewController ()<UITableViewDelegate, UITableViewDataSource, FGJiNengTableViewCellDelegate>
/**  tableView    */
@property (nonatomic, strong) UITableView *tableView;
/**  数据源    */
@property (nonatomic, strong) NSMutableArray *dataArray;
/**  jqFMDB    */
@property (nonatomic, strong) JQFMDB *db;
/**  带滑块的技能    */
@property (nonatomic, strong) NSArray *skillArray;
/**  最后一个section技能    */
@property (nonatomic, strong) NSArray *skillAddArray;
/**  存放要保存到数据库的模型数组    */
@property (nonatomic, strong) NSMutableArray *skillDBArray;
/**  自己创建一个数据源，用来更新滑块cell的数据    */
@property (nonatomic, strong) NSMutableArray *sliderCellDataArray;
@property (nonatomic, assign) NSInteger rankValue;//灵基

@end

@implementation FGHeroJiNengViewController
#pragma mark - Life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self p_config];
    [self p_createUI];
}
- (void)setDetailModel:(FGHeroDetailModel *)detailModel
{
    self.isSetLevel = NO;
    if (detailModel.skill.count || detailModel.skillAdd.count) {
        _detailModel = detailModel;
        //设置数据源
        [self.dataArray addObjectsFromArray:detailModel.skill];
        [self.dataArray addObject:detailModel.skillAdd];
        
        self.skillArray = detailModel.skill;
        self.skillAddArray = detailModel.skillAdd;
        
        /**  为了当没有移动滑块时点击设置可以成功。  */
        if (detailModel.setSkill.count == detailModel.skill.count) {//数据库中保存了技能状态
            self.rankValue = detailModel.lingJIValue;//读取上一次保存的值，如果没有保存
            self.lingJIValue = self.rankValue;//给灵基赋默认值
            self.skillDBArray = [detailModel.setSkill mutableCopy];
            
        }else
        {
            //当没有点设置，我们自己用初始值保存一个，这样逻辑应该就是一样的
            [self.skillDBArray removeAllObjects];
            [detailModel.skill enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                FGSaveJNModel *saveJNModel = [FGSaveJNModel new];
                saveJNModel.level = 1;
                saveJNModel.labelTag = 100;
                saveJNModel.levelDetail = @"等级:1";
            
                [self.skillDBArray addObject:saveJNModel];
            }];
            
            FGHeroSkillModel *saveModel = [FGHeroSkillModel new];
            saveModel.servantId = self.detailModel.servantId;
            saveModel.lingjiValue = @(0);//默认的灵基初始值是0
            NSData *skillDBArrayData = [NSKeyedArchiver archivedDataWithRootObject:self.skillDBArray];
            saveModel.skillLevel = skillDBArrayData;
            
            BOOL s = [self.db jq_deleteTable:kHeroLevel whereFormat:[NSString stringWithFormat:@"where servantId = '%@'",self.detailModel.servantId]];
            BOOL b =[self.db jq_insertTable:kHeroLevel dicOrModel:saveModel];
                NSLog(@"");
        }
        
        //给滑块数据源附初始值,如果已经保存过了那么需要读取保存过后的值
        [self.sliderCellDataArray removeAllObjects];
        [detailModel.skill enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            FGSaveJNModel *saveJNModel = [FGSaveJNModel new];
            saveJNModel.level = 1;
            saveJNModel.labelTag = 100;
            saveJNModel.levelDetail = @"等级:1";
            //读取保存过后的值
            if (![NSArray isNullOrEmptyArray:detailModel.setSkill]) {
                FGSaveJNModel *savedModel = (FGSaveJNModel *)detailModel.setSkill[idx];
                saveJNModel.level = savedModel.level;
                saveJNModel.labelTag = savedModel.labelTag;
                saveJNModel.levelDetail = savedModel.levelDetail;
            }
            [self.sliderCellDataArray addObject:saveJNModel];
        }];
        [self.tableView reloadData];
    }
    
}
//MARK:读取保存的状态
- (void)p_refresh
{
    //读取保存的技能
    NSArray *data= [self.db jq_lookupTable:kHeroLevel dicOrModel:[FGHeroSkillModel class] whereFormat:[NSString stringWithFormat:@"where servantId = '%@'",self.detailModel.servantId]];
    if (![NSArray isNullOrEmptyArray:data]) {
        FGHeroSkillModel *skillModel = data[0];
        NSArray *skillArr = [NSKeyedUnarchiver unarchiveObjectWithData:skillModel.skillLevel];
        [self.sliderCellDataArray removeAllObjects];
        [skillArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            FGSaveJNModel *savedModel = (FGSaveJNModel *)obj;
            [self.sliderCellDataArray addObject:savedModel];
        }];
        [self.tableView reloadData];
    }
}

- (void)p_refreshLevel
{
    FGHeroSkillModel *saveModel = [FGHeroSkillModel new];
    saveModel.servantId = self.detailModel.servantId;
    saveModel.lingjiValue = @(self.lingJIValue);//正向传值得到
    NSData *skillDBArrayData = [NSKeyedArchiver archivedDataWithRootObject:self.skillDBArray];
    saveModel.skillLevel = skillDBArrayData;
    [self.db jq_deleteTable:kHeroLevel whereFormat:[NSString stringWithFormat:@"where servantId = '%@'",self.detailModel.servantId]];
    BOOL isSuccess = [self.db jq_insertTable:kHeroLevel dicOrModel:saveModel];
    if (isSuccess) {
        self.isSetLevel = NO;
        [self p_refresh];
    }
}

#pragma mark - Private methods
- (void)p_config
{
    self.lingJIValue = 0;
    self.rankValue = 0;
    self.view.backgroundColor = [UIColor whiteColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(p_refreshLevel) name:@"refreshSkillLevelNotification" object:nil];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshSkillLevelNotification" object:nil];
}
- (void)p_createUI
{
    [self.view addSubview:self.tableView];
    CGFloat viewHeight = 60;
    UIView *bottomVeiw = [[UIView alloc] initWithFrame:CGRectMake(0, self.tableView.bottom, MainWidth, viewHeight)];
    bottomVeiw.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.1];
    [self.view addSubview:bottomVeiw];
    
    UIButton *setBtn = [self createButton:@"设置"];
    setBtn.tag = 100;
    [bottomVeiw addSubview:setBtn];
    [setBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.width.equalTo(60);
        make.height.equalTo(40);
        make.centerY.equalTo(0);
    }];
    UIButton *allBtn = [self createButton:@"310"];
    allBtn.tag = 101;
    [bottomVeiw addSubview:allBtn];
    [allBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(setBtn.mas_right).offset(10);
        make.width.equalTo(80);
        make.height.equalTo(40);
        make.centerY.equalTo(0);
    }];
    
    UIButton *jsBtn = [self createButton:@"计算素材"];
    [jsBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    jsBtn.backgroundColor = [UIColor p_rgbColorR:2 G:175 B:0];
    jsBtn.tag = 102;
    [bottomVeiw addSubview:jsBtn];
    [jsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(allBtn.mas_right).offset(10);
        make.right.equalTo(-10);
        make.height.equalTo(40);
        make.centerY.equalTo(0);
    }];
}
- (UIButton *)createButton:(NSString *)title
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.layer.cornerRadius = 3;
    btn.layer.borderColor = [UIColor grayColor].CGColor;
    btn.layer.borderWidth = .5;
    btn.layer.masksToBounds = YES;
    [btn addTarget:self action:@selector(tapAction:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    return btn;
}

- (void)tapAction:(UIButton *)sender
{
    switch (sender.tag) {
        case 100://设置
        {
            FGHeroSkillModel *saveModel = [FGHeroSkillModel new];
            saveModel.servantId = self.detailModel.servantId;
            saveModel.lingjiValue = @(self.lingJIValue);//正向传值得到
            NSData *skillDBArrayData = [NSKeyedArchiver archivedDataWithRootObject:self.skillDBArray];
            saveModel.skillLevel = skillDBArrayData;
            [self.db jq_deleteTable:kHeroLevel whereFormat:[NSString stringWithFormat:@"where servantId = '%@'",self.detailModel.servantId]];
            BOOL isSuccess = [self.db jq_insertTable:kHeroLevel dicOrModel:saveModel];
            if (isSuccess) {
                [self p_SVProgressHUDSuccess:@"技能设置成功"];
                self.isSetLevel = NO; //点了设置之后需要把设置状态重置
            }
            //读取
            NSArray *data= [self.db jq_lookupTable:kHeroLevel dicOrModel:[FGHeroSkillModel class] whereFormat:[NSString stringWithFormat:@"where servantId = '%@'",self.detailModel.servantId]];
            FGHeroSkillModel *mm = data[0];
            NSArray *skillArr = [NSKeyedUnarchiver unarchiveObjectWithData:mm.skillLevel];
            mm.skillArr = skillArr;
//            NSLog(@"");
            
            [self p_refresh];
        }
            break;
        case 101://310
        {
            //更新重载数据源
            [self.sliderCellDataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                FGSaveJNModel *model = obj;
                NSInteger level = 10;
                model.level = level;
                model.labelTag = level + 99;
                //读取保存的技能来确定等级详情如何展示
                NSString *levelDetail = [NSString stringWithFormat:@"等级:%ld",level];;
                NSArray *saveedSkillAray= [self.db jq_lookupTable:kHeroLevel dicOrModel:[FGHeroSkillModel class] whereFormat:[NSString stringWithFormat:@"where servantId = '%@'",self.detailModel.servantId]];
                if (![NSArray isNullOrEmptyArray:saveedSkillAray]) {
                    FGHeroSkillModel *skillModel = saveedSkillAray[0];
                    NSArray *skillArr = [NSKeyedUnarchiver unarchiveObjectWithData:skillModel.skillLevel];
                    FGSaveJNModel *saveLevel = (FGSaveJNModel *)skillArr[idx];
                    NSInteger setDJ = saveLevel.level;//
                    if (setDJ < level)  {
                        levelDetail = [NSString stringWithFormat:@"等级:%ld->%ld",setDJ,(long)level];
                    }
                }
                model.levelDetail = levelDetail;
            }];
            //更新需要保存的数据源
            self.lingJIValue = 4;//手动更新一下灵基
            [[NSNotificationCenter defaultCenter] postNotificationName:@"updateLingJiNotification" object:nil];//发通知更洗一下父vc中的灵基
            [self.skillDBArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                FGSaveJNModel *model = obj;
                model.level = 10;
                model.labelTag = 10 + 99;
                model.levelDetail = @"等级:10";
            }];
            [self.tableView reloadData];
            
        }
            break;
        case 102://计算素材
        {
            if (!self.isSetLevel) {
                [self p_alertTitle:@"未设置技能等级" message:@"请先设置技能等级再计算" sureBlock:nil];
                return;
            }
            //读取数据库来判断rank最后一次保存的值
            
            NSArray *saveSkill = [NSArray array];
            NSArray *saveedSkillAray= [self.db jq_lookupTable:kHeroLevel dicOrModel:[FGHeroSkillModel class] whereFormat:[NSString stringWithFormat:@"where servantId = '%@'",self.detailModel.servantId]];
            if (![NSArray isNullOrEmptyArray:saveedSkillAray]) {
                FGHeroSkillModel *skillModel = saveedSkillAray[0];
                self.rankValue = [skillModel.lingjiValue integerValue];
                saveSkill = [NSKeyedUnarchiver unarchiveObjectWithData:skillModel.skillLevel];
            }
            
            if (self.rankValue > [@(self.lingJIValue) integerValue]) {
                [self p_alertTitle:@"╮(╯﹏╰)╭" message:@"您设置的灵基等级小于当前默认值,请重新设置一下吧" sureBlock:nil];
                return;
            }
            NSString *rank = [NSString stringWithFormat:@"%ld_%ld",self.rankValue,[@(self.lingJIValue) integerValue]];

            __block NSString *skill = @"";
            [self.sliderCellDataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                FGSaveJNModel *model = obj;
                FGSaveJNModel *saveModel = saveSkill[idx];
                NSString *skillChange = [NSString stringWithFormat:@"%ld_%ld",saveModel.level, model.level];
                skill = [skill stringByAppendingString:skillChange];
                skill = [skill stringByAppendingString:@","];
                
                if (saveModel.level > model.level) {
                    [self p_alertTitle:@"╮(╯﹏╰)╭" message:@"您设置的技能等级小于当前默认值,请重新设置一下吧" sureBlock:nil];
                    *stop = YES;
                    return;
                }
            }];
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            [params setObject:[self.detailModel.servantId stringValue]forKey:@"servantId"];
            [params setObject:rank forKey:@"rank"];
            [params setObject:skill forKey:@"skill"];
            [params setObject:self.detailModel.clothFlag forKey:@"clothFlag"];
            
            if ([rank isEqualToString:@"4_4"] && [skill isEqualToString:@"10_10,10_10,10_10,"]) {
                [self p_alertTitle:@"O(∩_∩)O" message:@"已经升到满级啦！" sureBlock:nil];
                return;
            }
//
//            NSArray *ranks = [rank componentsSeparatedByString:@"_"];
//            NSArray *skills = [skill componentsSeparatedByString:@"_"];

            
            //图片路径
            NSMutableArray *imagePaths = [NSMutableArray array];
            [imagePaths addObject:self.detailModel.imgPath];//英雄头像
            [self.skillArray enumerateObjectsUsingBlock:^(FGHeroDetailSkillModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [imagePaths addObject:obj.imgPath];
            }];
            
            FGCalcuteViewController *vc = [FGCalcuteViewController new];
            vc.imagePaths = imagePaths;
            vc.params = params;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        default:
            break;
    }
}
//小火箭用来更新状态的
- (void)p_updateSkillLevel:(BOOL)isMax
{
    NSInteger level = isMax ? 10 : 1;
    //更新重载数据源
    [self.sliderCellDataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        FGSaveJNModel *model = obj;
        model.level = level;
        model.labelTag = level + 99;
        //读取保存的技能来确定等级详情如何展示
        NSString *levelDetail = [NSString stringWithFormat:@"等级:%ld",level];;
        NSArray *saveedSkillAray= [self.db jq_lookupTable:kHeroLevel dicOrModel:[FGHeroSkillModel class] whereFormat:[NSString stringWithFormat:@"where servantId = '%@'",self.detailModel.servantId]];
        if (![NSArray isNullOrEmptyArray:saveedSkillAray]) {
            FGHeroSkillModel *skillModel = saveedSkillAray[0];
            NSArray *skillArr = [NSKeyedUnarchiver unarchiveObjectWithData:skillModel.skillLevel];
            FGSaveJNModel *saveLevel = (FGSaveJNModel *)skillArr[idx];
            NSInteger setDJ = saveLevel.level;//
            if (setDJ < level)  {
                levelDetail = [NSString stringWithFormat:@"等级:%ld->%ld",setDJ,(long)level];
            }
        }
        model.levelDetail = levelDetail;
    }];
    //更新需要保存的数据源
//    self.lingJIValue = isMax ? 4 : 0;//手动更新一下灵基
    [self.skillDBArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        FGSaveJNModel *model = obj;
        model.level = level;
        model.labelTag = level + 99;
        model.levelDetail = [NSString stringWithFormat:@"等级:%ld",level];
    }];
    [self.tableView reloadData];

}
#pragma mark - FGJiNengTableViewCellDelegate
- (void)sliderTableViewCell:(FGJiNengTableViewCell *)cell didSelected:(FGJiNengLabelTableViewCellModel *)model
{
    self.isSetLevel = YES;//只有走了这个方法才证明她改动过滑块，才可以计算素材。记得当点击灵基的时候也把这个设为yes
    NSInteger level = model.sliderValue; //滑块等级
    
    /**  更新需要保存到数据库的数据   new*/
    FGSaveJNModel *saveJNModel = self.skillDBArray[model.section];
    saveJNModel.level = level;
    saveJNModel.labelTag = level + 99;
    saveJNModel.levelDetail = [NSString stringWithFormat:@"等级:%ld",level];
    
    
    /**  更新数据源，防止重载时bug new  */
    FGSaveJNModel *updateJNModel = self.sliderCellDataArray[model.section];
    updateJNModel.level = level;
    updateJNModel.labelTag = level + 99;
    NSString *levelDetail = [NSString stringWithFormat:@"等级:%ld",level];;
    //读取保存的技能来确定等级详情如何展示
    NSArray *saveedSkillAray= [self.db jq_lookupTable:kHeroLevel dicOrModel:[FGHeroSkillModel class] whereFormat:[NSString stringWithFormat:@"where servantId = '%@'",self.detailModel.servantId]];
    if (![NSArray isNullOrEmptyArray:saveedSkillAray]) {
        FGHeroSkillModel *skillModel = saveedSkillAray[0];
        NSArray *skillArr = [NSKeyedUnarchiver unarchiveObjectWithData:skillModel.skillLevel];
        FGSaveJNModel *saveLevel = (FGSaveJNModel *)skillArr[model.section];
        NSInteger setDJ = saveLevel.level;//
        if (setDJ < level)  {
            levelDetail = [NSString stringWithFormat:@"等级:%ld->%ld",setDJ,(long)level];
        }
    }
    updateJNModel.levelDetail = levelDetail;
    
    if (model.section <= self.dataArray.count - 2) {

        NSIndexPath *indexPath0 = [NSIndexPath indexPathForRow:0 inSection:model.section];
        //    [self.tableView reloadRowsAtIndexPaths:@[indexPath0,indexPath1] withRowAnimation:UITableViewRowAnimationNone];
        FGJiNengTopTableViewCell *topCell = [self.tableView cellForRowAtIndexPath:indexPath0];
        if (topCell) {
            topCell.updateModel = updateJNModel;
        }
        
        FGHeroDetailSkillModel *skillModel = self.dataArray[model.section];
        [skillModel.levels enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:idx + 1 inSection:model.section];
            FGJiNengLabelTableViewCell *labelCell = [self.tableView cellForRowAtIndexPath:indexPath];
            if (labelCell) {
                labelCell.updateModel = updateJNModel;
            }
        }];
    }
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section <= self.dataArray.count - 2)
    {
        FGHeroDetailSkillModel *skillModel = self.dataArray[section];
        return skillModel.levels.count + 2;
    }else {
        return self.detailModel.skillAdd.count;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section <= self.dataArray.count - 2) {
        FGHeroDetailSkillModel *skillModel = self.dataArray[indexPath.section];
        FGSaveJNModel *updateModel = self.sliderCellDataArray[indexPath.section];
        if (indexPath.row == 0) {
            FGJiNengTopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FGJiNengTopTableViewCell"];
            cell.skillModel = skillModel;//传入技能(cd)的
            cell.updateModel = updateModel;
            return cell;
        }else if(indexPath.row == skillModel.levels.count+1){
            FGJiNengSliderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FGJiNengSliderTableViewCell"];
            cell.delegate = self;
            cell.section = indexPath.section;//传入section，代理中回传回来。
            cell.updateModel = updateModel;
            return cell;
        }
        else
        {
            FGJiNengLabelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FGJiNengLabelTableViewCell"];
            cell.levelsModel = skillModel.levels[indexPath.row-1]; //传入技能描述，label中的值
            cell.updateModel = updateModel;
            return cell;
        }
    }else
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UITableViewCell"];
            cell.contentView.backgroundColor = kGrayColor;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        FGHeroDetailBottomSkillModel *model = self.detailModel.skillAdd[indexPath.row];
        cell.textLabel.text = model.skillName;
        cell.detailTextLabel.text = model.skillDesc;
        cell.detailTextLabel.textColor = [UIColor lightGrayColor];
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
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section <= self.dataArray.count - 2) {
        FGHeroDetailSkillModel *skillModel = self.dataArray[indexPath.section];
        NSArray *rows = [skillModel.skillDesc componentsSeparatedByString:@"&"];
        rows = [skillModel.lv[0] componentsSeparatedByString:@"/"];
        if (indexPath.row == 0) {
            return [FGJiNengTopTableViewCell p_getCellHeight];
        }else if(indexPath.row == skillModel.levels.count+1){
            return [FGJiNengSliderTableViewCell p_getCellHeight];
        }else
        {
            return [FGJiNengLabelTableViewCell p_getCellHeight];
        }
    }else
    {
        return 70;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 3.1f;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [NSString stringWithFormat:@" "];
}
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UITableViewCell *cell = [UITableViewCell new];
//    cell.backgroundColor = [UIColor whiteColor];
//    return cell;
//}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1.1f;
}
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return @" ";
}
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    return [UIView new];
//}


#pragma mark - Lazy load
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MainWidth, MainHeight - HeightOfStaAndNav - HeightOfFromBottom - 160 - 60) style:UITableViewStyleGrouped]; //UITableViewStylePlain,section头部固定在顶部。UITableViewStyleGrouped,头部向上
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];//去掉底部多余线条
        _tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);//分割线两边距离为10
        //        _tableView.separatorColor = [UIColor redColor];//分割线颜色
        //        _tableView.rowHeight = 40; //行高
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        [_tableView registerClass:[FGJiNengTopTableViewCell class] forCellReuseIdentifier:@"FGJiNengTopTableViewCell"];
        [_tableView registerClass:[FGJiNengLabelTableViewCell class] forCellReuseIdentifier:@"FGJiNengLabelTableViewCell"];
        [_tableView registerClass:[FGJiNengSliderTableViewCell class] forCellReuseIdentifier:@"FGJiNengSliderTableViewCell"];

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
- (NSMutableArray *)skillDBArray
{
    if (!_skillDBArray) {
        _skillDBArray = [NSMutableArray array];
    }
    return _skillDBArray;
}
- (NSMutableArray *)sliderCellDataArray
{
    if (!_sliderCellDataArray) {
        _sliderCellDataArray = [NSMutableArray array];
    }
    return _sliderCellDataArray;
}
- (JQFMDB *)db
{
        _db = [JQFMDB shareDatabase];
        BOOL isAlready = [_db jq_isExistTable:kHeroLevel];
        if (!isAlready) {
            BOOL success = [_db jq_createTable:kHeroLevel dicOrModel:[FGHeroSkillModel class]];
            NSLog(@"");
    }
    return _db;
}
@end
