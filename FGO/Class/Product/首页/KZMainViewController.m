//
//  KZMainViewController.m
//  KZBaseProject
//
//  Created by 孔志林 on 2018/6/7.
//  Copyright © 2018年 KMingMing. All rights reserved.
//

#import "KZMainViewController.h"
#import "KZBaseUINavigationController.h"

#import <StreamSniffing/StreamSniffing.h>
#import <NetworkExtension/NEVPNConnection.h>
#import <NetworkExtension/NETunnelProviderManager.h>
#import <NetworkExtension/NETunnelProviderProtocol.h>
#import <NetworkExtension/NETunnelProviderSession.h>

#import "SessionsViewController.h"
#import <GCDWebServer.h>
#import <GCDWebServerDataResponse.h>

@interface KZMainViewController ()<UITableViewDelegate, UITableViewDataSource>
/**  tableView    */
@property (nonatomic, strong) UITableView *tableView;
/**  数据源    */
@property (nonatomic, strong) NSArray *dataArray;
/**  vpnMA    */
@property (nonatomic, strong) NETunnelProviderManager *vpnManager;
@property (nonatomic, assign) BOOL running;
/**  <##>    */
@property (nonatomic, strong) GCDWebServer *webServer;
@end

@implementation KZMainViewController
#pragma mark - Life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self p_config];
    [self p_createUI];
    
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
#pragma mark - Private methods
- (void)p_config
{
    self.navigationItem.title = @"首页";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem =  [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemClick)];
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
//    self.edgesForExtendedLayout = UIRectEdgeNone;  //设置了这个，frame从导航栏下方开始
    /**
     当导航栏不透明时，(0,0)从导航栏下方开始为起点
     当导航栏透明时，(0,0)从屏幕顶端为起点。
     */
    
    self.dataArray = @[@"开始抓包",@"安装ca",@"显示抓包数据"];
    [self.tableView reloadData];
    
    //检测vpn是否开启了，来改变开关的状态
    [NETunnelProviderManager loadAllFromPreferencesWithCompletionHandler:^(NSArray<NETunnelProviderManager *> * _Nullable managers, NSError * _Nullable error) {
        NETunnelProviderManager *manager = nil;
        
        if (managers.count > 0) {
            manager = [managers firstObject];
            
            if( manager.enabled && (manager.connection.status == NEVPNStatusConnected) ) {
                self.running = YES;
            } else {
                self.running = NO;
            }
        } else {
            self.running = NO;
        }
    }];
    
    //添加一个通知来检测vpn的状态。
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(vpnStatusChange:) name:NEVPNStatusDidChangeNotification object:nil];
}

- (void)vpnStatusChange: (NSNotification *)notification
{
    NETunnelProviderSession *session = notification.object;
    
    if (session.status == NEVPNStatusConnected) {
        self.running = YES;
    } else {
        self.running = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [self p_setNavigationBarColor:[UIColor redColor] translucent:YES];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    UIColor *color = [[UIColor orangeColor] colorWithAlphaComponent:1];
//    [self p_setNavigationBarColor:color translucent:YES];
    

}

- (void)p_createUI
{
    [self.view addSubview:self.tableView];
}
- (void)rightBarButtonItemClick
{
}

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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",self.dataArray[indexPath.row]];
//    cell.backgroundColor = [UIColor p_randomColor];
    
    if (indexPath.row == 0) {
        if (self.running) {
            cell.textLabel.text = @"停止抓包";
        } else {
            cell.textLabel.text = @"开始抓包";
        }
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            //开启关闭vpn
            [NETunnelProviderManager loadAllFromPreferencesWithCompletionHandler:^(NSArray<NETunnelProviderManager *> * _Nullable managers, NSError * _Nullable error) {
                if (error != nil) {
                    return;
                }
                
                NETunnelProviderManager *manager = nil;
                
                if (!self.running) {
                    if (managers.count == 0) {
                        manager = [[NETunnelProviderManager alloc] init];
                        
                        NETunnelProviderProtocol *protocol = [[NETunnelProviderProtocol alloc] init];
                        protocol.providerBundleIdentifier = @"com.fgopy.www.FGO.PacketTunnel";
                        protocol.serverAddress = @"StreamSDK";
                        
                        manager.protocolConfiguration = protocol;
                        manager.enabled = YES;
                        
                        [manager saveToPreferencesWithCompletionHandler:^(NSError * _Nullable error) {
                            if (error) {
                                NSLog(@"");
                            }else
                            {
                                [manager loadFromPreferencesWithCompletionHandler:^(NSError * _Nullable error) {
                                    if (error) {
                                        
                                    }else
                                    {
                                        NSError *startError;
                                        [manager.connection startVPNTunnelWithOptions:@{} andReturnError:&startError];
                                        
                                        if (startError == nil) {
                                            self.running = YES;
                                        }
                                    }
                                }];
                            }
                        }];
                    } else
                    {
                        manager = [managers firstObject];
                        [manager loadFromPreferencesWithCompletionHandler:^(NSError * _Nullable error) {
                            if (error) {
                                
                            }else
                            {
                                manager.enabled = YES;
                                [manager saveToPreferencesWithCompletionHandler:^(NSError * _Nullable error) {
                                    if (error) {
                                        NSLog(@"");
                                    }else
                                    {
                                        NSError *startError;
                                        [manager.connection startVPNTunnelWithOptions:@{} andReturnError:&startError];
                                        
                                        if (startError == nil) {
                                            self.running = YES;
                                        }
                                    }
                                }];
                                
                            }
                        }];
                    }
                } else {
                    manager = [managers firstObject];
                    self.running = NO;
                    
                    [manager.connection stopVPNTunnel];
                }
            }];
                
        }
            break;
        case 1://安装ca
        {
            GCDWebServer* webServer = [[GCDWebServer alloc] init];
            
            [webServer addDefaultHandlerForMethod:@"GET"
                                     requestClass:[GCDWebServerRequest class]
                                     processBlock:^GCDWebServerResponse *(GCDWebServerRequest* request) {
                                         NSString *path = [[STSniffingSDK sharedInstance] CAPath];
                                         NSData *data = [NSData dataWithContentsOfFile:path];
                                         return [GCDWebServerDataResponse responseWithData:data contentType:@"application/pkix-cert"];
                                     }];
            
            [webServer startWithOptions:@{ GCDWebServerOption_AutomaticallySuspendInBackground: @(NO), GCDWebServerOption_Port: @(8080) } error:nil];
            
            _webServer = webServer;
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://127.0.0.1:8080/ca.cer"]];
        }
            break;
        case 2://显示抓包数据
        {
            SessionsViewController *controller = [[SessionsViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;

        default:
            break;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0f;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [NSString stringWithFormat:@"第%ld个模块",section];
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    CGFloat alpha = 0;
//    alpha = scrollView.contentOffset.y / 164.0;
//    UIColor *color = [[UIColor orangeColor] colorWithAlphaComponent:alpha];
//    [self p_setNavigationBarColor:color translucent:YES];
//}
#pragma mark - Lazy load
//      <UITableViewDelegate, UITableViewDataSource>
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,64, WithOfMainScreen, HeightOfMainScreen - 64 - 49) style:UITableViewStylePlain]; //UITableViewStylePlain,section头部固定在顶部。UITableViewStyleGrouped,头部向上
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];//去掉底部多余线条
        _tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);//分割线两边距离为10
//        _tableView.separatorColor = [UIColor redColor];//分割线颜色
        _tableView.rowHeight = 40; //行高
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
        _tableView.backgroundColor = [UIColor whiteColor];
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
- (void)setRunning:(BOOL)running
{
    _running = running;
    
    [_tableView reloadData];
}
@end
