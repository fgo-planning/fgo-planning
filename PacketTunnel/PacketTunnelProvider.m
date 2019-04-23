//
//  PacketTunnelProvider.m
//  PacketTunnel
//
//  Created by 孔志林 on 2018/10/10.
//  Copyright © 2018年 KMingMing. All rights reserved.
//

#import "PacketTunnelProvider.h"
#import <StreamSniffing/StreamSniffing.h>

@interface PacketTunnelProvider() {
    NEPacketTunnelNetworkSettings *_settings;
}
@end

@implementation PacketTunnelProvider

- (void)startTunnelWithOptions:(NSDictionary *)options completionHandler:(void (^)(NSError *))completionHandler
{
    // 必须：启动后设置 AppGroup
    [[STSniffingSDK sharedInstance] registerExtensionId:@"eacf42d4e0efa5545dc82f1fbc3b9fb5"];
    [[STSniffingSDK sharedInstance] setExtensionGroup:@"group.com.fgopy.www.FGO"];
    
    // 设置虚拟 IP 以及本地代理
    NEPacketTunnelNetworkSettings *settings = [[NEPacketTunnelNetworkSettings alloc] initWithTunnelRemoteAddress:@"10.242.116.116"];
    settings.DNSSettings = [[NEDNSSettings alloc] initWithServers:@[@"8.8.8.8"]];
    settings.IPv4Settings = [[NEIPv4Settings alloc] initWithAddresses:@[@"192.168.0.2"] subnetMasks:@[@"255.255.255.0"]];
    
    // 启动对应的本地代理
    NSUInteger port = 1380;
    
    // 设置要抓取的域名列表，域名列表指定的越少，性能越稳定，Apple 本身有内存限制，如果超出了内存限制，会自动退出
    settings.proxySettings = [[STSniffingSDK sharedInstance] proxySettingsWithProxyPort:port sniffingDomains:@[@"*.line3-s2-ios-fate.bilibiligame.net"] excludeSniffingDomains:@[]];//*.baidu.com
    
    [[STSniffingSDK sharedInstance] startProxyWithPort:port];
    
    _settings = settings;
    [self setTunnelNetworkSettings:settings completionHandler:^(NSError * _Nullable error) {
        if (error == nil) {
            // 注册本次抓包
            [[STSniffingSDK sharedInstance] registerSession];
        }
        
        if (completionHandler) {
            completionHandler(error);
        }
    }];
    
}

- (void)stopTunnelWithReason:(NEProviderStopReason)reason completionHandler:(void (^)(void))completionHandler
{
    // 停止前，结束本地抓包
    [[STSniffingSDK sharedInstance] stopSession];
    
    completionHandler();
}

- (void)handleAppMessage:(NSData *)messageData completionHandler:(void (^)(NSData *))completionHandler
{
    // Add code here to handle the message.
}

- (void)sleepWithCompletionHandler:(void (^)(void))completionHandler
{
    // Add code here to get ready to sleep.
    completionHandler();
}

- (void)wake
{
    // Add code here to wake up.
}

@end
