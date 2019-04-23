//
//  FGVPNViewController.m
//  FGO
//
//  Created by 孔志林 on 2019/1/9.
//  Copyright © 2019年 KMingMing. All rights reserved.
//

#import "FGVPNViewController.h"
#import "KZBaseUINavigationController.h"

#import <StreamSniffing/StreamSniffing.h>
#import <NetworkExtension/NEVPNConnection.h>
#import <NetworkExtension/NETunnelProviderManager.h>
#import <NetworkExtension/NETunnelProviderProtocol.h>
#import <NetworkExtension/NETunnelProviderSession.h>

#import "SessionsViewController.h"
#import <GCDWebServer.h>
#import <GCDWebServerDataResponse.h>
#import <YYLabel.h>
#import <MWPhotoBrowser.h>

@interface FGVPNViewController ()<UITableViewDelegate, UITableViewDataSource,MWPhotoBrowserDelegate>
/**  tableView    */
@property (nonatomic, strong) UITableView *tableView;
/**  数据源    */
@property (nonatomic, strong) NSArray *dataArray;
/**  vpnMA    */
@property (nonatomic, strong) NETunnelProviderManager *vpnManager;
@property (nonatomic, assign) BOOL running;
/**  <##>    */
@property (nonatomic, strong) GCDWebServer *webServer;
@property (nonatomic, strong) NSMutableArray *images;

@end

@implementation FGVPNViewController

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
    self.navigationItem.title = @"开启数据同步";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem =  [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemClick)];
    
    self.dataArray = @[@"开启数据同步",@"安装ca",@"图片教程"];
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
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectZero];
    lb.textColor = [UIColor lightGrayColor];
    lb.numberOfLines = 0;
    lb.font = [UIFont systemFontOfSize:14];
    lb.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:lb];
    [lb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.right.equalTo(-15);
        make.centerY.equalTo(0);
    }];
   
    NSString *text = @"使用说明: 第一次使用需要安装ca,首先点击'安装ca'按钮安装证书,安装完成后点击 设置-->通用-->关于本机-->证书信任设置,打开刚才安装的证书开关。然后点击'开启数据同步'按钮安装描述文件即可进行抓包操作,ca安装成功后,下次使用直接点击'开启数据同步'按钮,不需要再安装ca";
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:text];
    // 2.添加属性
//    [attributeStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, 9)];
    [attributeStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica" size:15] range:NSMakeRange(5, text.length - 5)];
    
    [attributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 5)];
    [attributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(5, text.length - 5)];

    
    
    // 创建NSMutableParagraphStyle实例
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5;       //字间距5
    paragraphStyle.paragraphSpacing = 20;       //行间距是20
    paragraphStyle.alignment = NSTextAlignmentLeft;   //对齐方式为居中对齐
    [attributeStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, text.length)];
    lb.attributedText = attributeStr;
    
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
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@",self.dataArray[indexPath.row]];
    if (indexPath.row == 0) {
        if (self.running) {
            cell.textLabel.text = @"停止数据同步";
        } else {
            cell.textLabel.text = @"开启数据同步";
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
//                                            self.running = YES;
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
//                                            self.running = YES;
                                        }
                                    }
                                }];
                                
                            }
                        }];
                    }
                } else {
                    manager = [managers firstObject];
//                    self.running = NO;
                    
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
//                                         return [GCDWebServerDataResponse responseWithHTML:@"<html><body><p>Hello World</p></body></html>"];

                                     }];
            
            [webServer startWithOptions:@{ GCDWebServerOption_AutomaticallySuspendInBackground: @(NO), GCDWebServerOption_Port: @(8080) } error:nil];


            _webServer = webServer;
            
            NSURL *url = [NSURL URLWithString:@"http://127.0.0.1:8080/ca.cer"];

            UIApplication *app = [UIApplication sharedApplication];
            if ([app canOpenURL:url]) {
                [app openURL:url];
            }
        }
            break;
        case 2://图片教程
        {
            [self p_showImage];
        }
            break;

        default:
            break;
    }
}

- (void)p_showImage
{
    self.images = [NSMutableArray array];
    for (int i = 0; i<10; i++) {
        MWPhoto *photo = [MWPhoto photoWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"ͼƬ%d",i+1]]];
//        photo.caption = [NSString stringWithFormat:@"%d/%d",i+1,7];
        [self.images addObject:photo];
    }
    //初始化
    MWPhotoBrowser *photoBrowser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    
    [photoBrowser setCurrentPhotoIndex:0];
    photoBrowser.displayActionButton = NO;//显示分享按钮(左右划动按钮显示才有效)
    photoBrowser.displayNavArrows = NO; //显示左右划动
    photoBrowser.displaySelectionButtons = NO; //是否显示选择图片按钮
    photoBrowser.alwaysShowControls = NO; //控制条始终显示
    photoBrowser.zoomPhotosToFill = NO; //是否自适应大小
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
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, WithOfMainScreen, HeightOfMainScreen - HeightOfStaAndNav - HeightOfFromBottom) style:UITableViewStylePlain]; //UITableViewStylePlain,section头部固定在顶部。UITableViewStyleGrouped,头部向上
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];//去掉底部多余线条
        _tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);//分割线两边距离为10
        //        _tableView.separatorColor = [UIColor redColor];//分割线颜色
        _tableView.rowHeight = 40; //行高
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.bounces = NO;
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
