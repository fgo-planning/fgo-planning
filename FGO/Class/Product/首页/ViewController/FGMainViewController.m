//
//  FGMainViewController.m
//  FGO
//
//  Created by 孔志林 on 2018/10/24.
//  Copyright © 2018年 KMingMing. All rights reserved.
//

#import "FGMainViewController.h"
#import <StoreKit/StoreKit.h>
#import <SVProgressHUD.h>
#import "FGHeroViewController.h"
#import "FGMainVIiewModel.h"
#import "JQFMDB.h"
#import "FGHeroModel.h"
#import <NetworkExtension/NEVPNConnection.h>
#import <NetworkExtension/NETunnelProviderManager.h>
#import <NetworkExtension/NETunnelProviderProtocol.h>
#import <NetworkExtension/NETunnelProviderSession.h>
@interface FGMainViewController ()<SKPaymentTransactionObserver,SKProductsRequestDelegate,UIScrollViewDelegate>
@property (nonatomic,copy) NSString *currentProId;
/**  <##>    */
@property (nonatomic, strong) UIScrollView *scroView;
/**  <##>    */
@property (nonatomic, strong) UIImageView *imgView;
/**  <##>    */
@property (nonatomic, strong) JQFMDB *db;
@end

@implementation FGMainViewController
#pragma mark - Life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self p_config];
    [self p_createUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(p_readVPN) name:UIApplicationWillEnterForegroundNotification object:nil];
    [self p_readVPN];
    [self p_frorceUpdate];

}

- (void)p_readVPN
{
    //检测vpn是否开启了，来改变开关的状态
    [NETunnelProviderManager loadAllFromPreferencesWithCompletionHandler:^(NSArray<NETunnelProviderManager *> * _Nullable managers, NSError * _Nullable error) {
        NETunnelProviderManager *manager = nil;
        if (managers.count > 0) {
            manager = [managers firstObject];
            if( manager.enabled && (manager.connection.status == NEVPNStatusConnected) ) {
//                self.running = YES;
                //读取vpn数据
                [[FGMainVIiewModel sharedInstance] getVPNData:^(id obj, NSURLSessionDataTask *dataTask) {
                } failure:^(id err) {
                }];
            } else {
//                self.running = NO;
            }
        } else {
//            self.running = NO;
        }
    }];
    [self p_frorceUpdate];
}
- (void)loadView
{
    self.view = self.scroView;
}
- (UIScrollView *)scroView
{
    if (!_scroView) {
        _scroView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _scroView.contentSize = CGSizeMake(MainWidth, MainWidth >= 768 ? MainHeight : (MainHeight -HeightOfStaAndNav - HeightOfTabBar + 1));
        _scroView.delegate = self;
    }
    return _scroView;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGRect frame = self.imgView.frame;
    CGFloat height = MainWidth * 469 / 750;
    CGFloat offset = height - scrollView.contentOffset.y;
    frame.size.height = offset;
    frame.origin.y = scrollView.contentOffset.y;
    if (offset < height) {
        frame.size.height = height;
        frame.origin.y = 0;
    }
    self.imgView.frame = frame;
}
#pragma mark - Private methods
- (void)p_config
{
    self.navigationItem.title = @"首页";
    [self p_setStatusBarBlackTextColorBlack:NO];
    
}
//强制升级
- (void)p_frorceUpdate
{
    [self GET:@"http://llllengda.net/abc.php" paramaters:nil success:^(NSURLSessionDataTask *dataTask, id response) {
        if (!response) {
            return ;
        }
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        NSString *serverVersion = dic[@"datavar"];
        NSString *jumpUrl = dic[@"url"];
        NSString *localVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        if (![localVersion isEqualToString:serverVersion]) {
            UIAlertController *alVC = [UIAlertController alertControllerWithTitle:@"有可用的更新" message:@"请更新后继续使用" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *sureAc = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:jumpUrl]];
            }];
            [alVC addAction:sureAc];
            [self presentViewController:alVC animated:YES completion:nil];
        }
        NSLog(@"");
    } failure:^(id error) {
        
    }];
}
- (void)p_createUI
{
    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MainWidth, MainWidth * 469 / 750)];
    iv.image = [UIImage imageNamed:@"fgo"];
    iv.contentMode = UIViewContentModeScaleAspectFill;
    self.imgView = iv;
    [self.view addSubview:iv];
    
    NSArray *titleArr = @[@"英灵列表",@"素材信息",@"活动详情",@"素材规划"];
    NSArray *imageArr = @[@"01",@"02",@"03",@"04"];
    
    [titleArr enumerateObjectsUsingBlock:^(NSString *title, NSUInteger i, BOOL * _Nonnull stop) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:imageArr[i]] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightLight];
        btn.tag = i + 100;
        [btn addTarget:self action:@selector(tapBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(iv.bottom);
            make.width.equalTo(MainWidth/4.0);
            make.height.equalTo(180);
            make.left.equalTo(i * (MainWidth/4.0));
        }];
        [btn p_changeImageLocation:KZImageAtTop space:15];
    }];
        
}

#pragma mark - 点击事件
- (void)tapBtn:(UIButton *)sender
{
    NSArray *vcs = @[@"FGHeroViewController",@"FGSourceViewController",@"FGMainActivityViewController",@"FGSourcePlanViewController"];
    NSInteger i = sender.tag - 100;
    Class class = NSClassFromString(vcs[i]);
    if (class)
    {
        if (i == 3) {
            NSArray *likes = [self.db jq_lookupTable:kTableName(@"likeHero") dicOrModel:[FGHeroModel class] whereFormat:nil];
            if ([NSArray isNullOrEmptyArray:likes])
            {
                [self p_alertTitle:@"您好!" message:@"请先去英灵列表中关注英雄,再进行素材规划" sureBlock:^(UIAlertAction *action) {
                    FGHeroViewController *vc = [FGHeroViewController new];
                    [self.navigationController pushViewController:vc animated:YES];
                }];
                return;
            }
    }
        [self.navigationController pushViewController:[class new] animated:YES];
    }
}

- (void)rightBarButtonItemClick
{
//    [self p_applePay];//支付6元哦；
    [[FGMainVIiewModel sharedInstance] getVPNData:^(id obj, NSURLSessionDataTask *dataTask) {
        
    } failure:^(id err) {
        
    }];
}
#pragma mark - 读取抓包数据
- (void)p_readData
{
    STSession *session = [[[STSniffingSDK sharedInstance] sessions] objectAtIndex:0];
    NSArray<STConnection *>  *connection = [[STSniffingSDK sharedInstance] connectionsForSession:session];
    [connection enumerateObjectsUsingBlock:^(STConnection * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.uri containsString:@"_key=toplogin"]) {//_key=toplogin
            NSData *data = [[STSniffingSDK sharedInstance] responseBodyForConnection:obj inSession:session];
            NSString *urlencodeStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSString *urlDencodeStr = [NSString p_URLDencode:urlencodeStr];
            NSString *base64Dencode = [NSString p_base64Dencode:urlDencodeStr];
            NSData *jsonData = [base64Dencode dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
            NSLog(@"");
        }
    }];
}



#pragma mark - 苹果支付
- (void)p_applePay
{
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    _currentProId = @"getGameInfo";
    if([SKPaymentQueue canMakePayments]){
        [self requestProductData:_currentProId];
    }else{
        NSLog(@"不允许程序内付费");
    }
}
//去苹果服务器请求商品
- (void)requestProductData:(NSString *)type{
    NSLog(@"-------------请求对应的产品信息----------------");
    
    [SVProgressHUD showWithStatus:nil maskType:SVProgressHUDMaskTypeBlack];
    
    NSArray *product = [[NSArray alloc] initWithObjects:type,nil];
    
    NSSet *nsset = [NSSet setWithArray:product];
    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:nsset];
    request.delegate = self;
    [request start];
    
}

//收到产品返回信息
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    
    NSLog(@"--------------收到产品反馈消息---------------------");
    NSArray *product = response.products;
    if([product count] == 0){
        [SVProgressHUD dismiss];
        NSLog(@"--------------没有商品------------------");
        return;
    }
    
    NSLog(@"productID:%@", response.invalidProductIdentifiers);
    NSLog(@"产品付费数量:%lu",(unsigned long)[product count]);
    
    SKProduct *p = nil;
    for (SKProduct *pro in product) {
        NSLog(@"%@", [pro description]);
        NSLog(@"%@", [pro localizedTitle]);
        NSLog(@"%@", [pro localizedDescription]);
        NSLog(@"%@", [pro price]);
        NSLog(@"%@", [pro productIdentifier]);
        
        if([pro.productIdentifier isEqualToString:_currentProId]){
            p = pro;
        }
    }
    
    SKPayment *payment = [SKPayment paymentWithProduct:p];
    
    NSLog(@"发送购买请求");
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

//请求失败
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error{
    [SVProgressHUD showErrorWithStatus:@"支付失败"];
    NSLog(@"------------------错误-----------------:%@", error);
}

- (void)requestDidFinish:(SKRequest *)request{
    [SVProgressHUD dismiss];
    NSLog(@"------------反馈信息结束-----------------");
}
//沙盒测试环境验证
#define SANDBOX @"https://sandbox.itunes.apple.com/verifyReceipt"
//正式环境验证
#define AppStore @"https://buy.itunes.apple.com/verifyReceipt"
/**
 *  验证购买，避免越狱软件模拟苹果请求达到非法购买问题
 *
 */
-(void)verifyPurchaseWithPaymentTransaction{
    //从沙盒中获取交易凭证并且拼接成请求体数据
    NSURL *receiptUrl=[[NSBundle mainBundle] appStoreReceiptURL];
    NSData *receiptData=[NSData dataWithContentsOfURL:receiptUrl];
    
    NSString *receiptString=[receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];//转化为base64字符串
    
    NSString *bodyString = [NSString stringWithFormat:@"{\"receipt-data\" : \"%@\"}", receiptString];//拼接请求数据
    NSData *bodyData = [bodyString dataUsingEncoding:NSUTF8StringEncoding];
    
    
    //创建请求到苹果官方进行购买验证
    NSURL *url=[NSURL URLWithString:SANDBOX];
    NSMutableURLRequest *requestM=[NSMutableURLRequest requestWithURL:url];
    requestM.HTTPBody=bodyData;
    requestM.HTTPMethod=@"POST";
    //创建连接并发送同步请求
    NSError *error=nil;
    NSData *responseData=[NSURLConnection sendSynchronousRequest:requestM returningResponse:nil error:&error];
    if (error) {
        NSLog(@"验证购买过程中发生错误，错误信息：%@",error.localizedDescription);
        return;
    }
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
    NSLog(@"%@",dic);
    if([dic[@"status"] intValue]==0){
        NSLog(@"购买成功！");
        NSDictionary *dicReceipt= dic[@"receipt"];
        NSDictionary *dicInApp=[dicReceipt[@"in_app"] firstObject];
        NSString *productIdentifier= dicInApp[@"product_id"];//读取产品标识
        //如果是消耗品则记录购买数量，非消耗品则记录是否购买过
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        if ([productIdentifier isEqualToString:@"123"]) {
            NSInteger purchasedCount=[defaults integerForKey:productIdentifier];//已购买数量
            [[NSUserDefaults standardUserDefaults] setInteger:(purchasedCount+1) forKey:productIdentifier];
        }else{
            [defaults setBool:YES forKey:productIdentifier];
        }
        //在此处对购买记录进行存储，可以存储到开发商的服务器端
    }else{
        NSLog(@"购买失败，未通过验证！");
    }
}
//监听购买结果
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transaction{
    for(SKPaymentTransaction *tran in transaction){
        switch (tran.transactionState) {
            case SKPaymentTransactionStatePurchased:{
                NSLog(@"交易完成");
                // 发送到苹果服务器验证凭证
                [self verifyPurchaseWithPaymentTransaction];
                [[SKPaymentQueue defaultQueue] finishTransaction:tran];
                
            }
                break;
            case SKPaymentTransactionStatePurchasing:
                NSLog(@"商品添加进列表");
                
                break;
            case SKPaymentTransactionStateRestored:{
                NSLog(@"已经购买过商品");
                
                [[SKPaymentQueue defaultQueue] finishTransaction:tran];
            }
                break;
            case SKPaymentTransactionStateFailed:{
                NSLog(@"交易失败");
                [[SKPaymentQueue defaultQueue] finishTransaction:tran];
                [SVProgressHUD showErrorWithStatus:@"购买失败"];
            }
                break;
            default:
                break;
        }
    }
}

//交易结束
- (void)completeTransaction:(SKPaymentTransaction *)transaction{
    NSLog(@"交易结束");
    
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}


- (void)dealloc{
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
}
- (JQFMDB *)db
{
    _db = [JQFMDB shareDatabase];
    
    return _db;
}



@end
