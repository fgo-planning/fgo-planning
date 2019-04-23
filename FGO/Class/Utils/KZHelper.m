//
//  KZHelper.m
//  KZBaseProject
//
//  Created by 孔志林 on 2018/6/7.
//  Copyright © 2018年 KMingMing. All rights reserved.
//

#import "KZHelper.h"
#import <CoreLocation/CoreLocation.h>
@interface KZHelper ()<CLLocationManagerDelegate>
/**  locationBlock    */
@property (nonatomic, copy) LocationSuccessBlock locationBlock;
/**  定位管理器    */
@property (nonatomic, strong) CLLocationManager *locationManager;
@end

@implementation KZHelper
+ (instancetype)sharedInstance
{
    static KZHelper *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [self new];
    });
    return instance;
}

#pragma mark - 获取当前控制器
+ (UIViewController *)p_getCurrentVC
{
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *currentVC = [KZHelper getCurrentVCFrom:rootViewController];
    
    return currentVC;
}
+ (UIViewController *)getCurrentVCFrom:(UIViewController *)rootVC
{
    UIViewController *currentVC;
    
    if ([rootVC presentedViewController]) {
        // 视图是被presented出来的
        rootVC = [rootVC presentedViewController];
    }
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        // 根视图为UITabBarController
        currentVC = [self getCurrentVCFrom:[(UITabBarController *)rootVC selectedViewController]];
        
    } else if ([rootVC isKindOfClass:[UINavigationController class]]){
        // 根视图为UINavigationController
        currentVC = [self getCurrentVCFrom:[(UINavigationController *)rootVC visibleViewController]];
    } else {
        // 根视图为非导航类
        currentVC = rootVC;
    }
    return currentVC;
}
#pragma mark - 开始定位
- (void)p_startLocation:(LocationSuccessBlock)successBlock
{
    self.locationBlock = successBlock;
    if ([CLLocationManager locationServicesEnabled]) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        //申请授权
        [_locationManager requestWhenInUseAuthorization];//使用应用期间
//        [_locationManager requestWhenInUseAuthorization];//始终
        //设置寻址精度
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        //多少米更新一次位置信息
        _locationManager.distanceFilter = 10.0;
        [_locationManager startUpdatingLocation];
    }
}
//定位成功
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    [_locationManager stopUpdatingLocation];
    //获取定位信息
    CLLocation *currentLocation = [locations lastObject];
    
    //包含位置坐标的结构体经纬度2D
    CLLocationCoordinate2D coordinate = currentLocation.coordinate;
    //经度
    NSString *longitude = [NSString stringWithFormat:@"%f", coordinate.longitude];
    //纬度
    NSString *latitude = [NSString stringWithFormat:@"%f", coordinate.latitude];
    //地理反编码--根据经纬度确定城市地点
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count > 0) {
            CLPlacemark *placeMark = placemarks[0];
            NSString *locality = placeMark.locality;
            if (!locality) {
                //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                locality = placeMark.administrativeArea;
            }
            NSString *city = [NSString stringWithFormat:@"%@%@%@", locality,placeMark.subLocality,placeMark.name];
            NSDictionary *locationInfo = @{@"city" : city,
                                         @"longitude" : longitude,
                                         @"latitude": latitude
                                         };
            self.locationBlock(locationInfo);
        }else
        {
            NSLog(@"获取城市信息失败");
        }
    }];
}
//定位失败
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    //提醒用户打开定位服务
    UIAlertController* alertVC = [UIAlertController alertControllerWithTitle:@"允许\"定位\"提示"
                                                                     message:@"请在设置中打开定位"
                                                              preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * action)
                                   {
                                       
                                   }];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"打开定位"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action)
                                 {
                                     //打开定位设置
                                     NSURL *settingURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                                     [[UIApplication sharedApplication] openURL:settingURL];
                                 }];
    
    [alertVC addAction:cancleAction];
    [alertVC addAction:sureAction];
    UIViewController *currentVc = [KZHelper p_getCurrentVC];
    [currentVc presentViewController:alertVC animated:YES completion:nil];
}
@end
