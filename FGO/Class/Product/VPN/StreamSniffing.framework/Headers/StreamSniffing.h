//
//  StreamSniffing.h
//  StreamSniffing
//
//  Created by xushaozhen on 2018/5/15.
//  Copyright © 2018 fish. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StreamSniffing/STSession.h>
#import <StreamSniffing/STConnection.h>

FOUNDATION_EXPORT double StreamSniffingVersionNumber;

FOUNDATION_EXPORT const unsigned char StreamSniffingVersionString[];

@class NEProxySettings;

@interface STSniffingSDK : NSObject

+ (STSniffingSDK *)sharedInstance;

@property (nonatomic, assign) BOOL debugMode;
@property (nonatomic, assign, getter=isRunning, readonly) BOOL running;

// 设置 AppGroup，用于共享存储，必须在启动后设置
- (void)setExtensionGroup: (NSString *)group;

// 设置 TeamId，用于共享存储，必须在启动后设置
- (void)setTeamId: (NSString *)teamId;

// 设置当前 SDK 授权，分别在主 Target 和 Extension Target 里调用
- (BOOL)registerAppId: (NSString *)appId;
- (BOOL)registerExtensionId: (NSString *)extensionId;

// 获取 Extension 里的 ProxySetting，必须指定抓包的域名列表，也可选指定不抓包的域名列表
- (NEProxySettings *)proxySettingsWithProxyPort: (NSUInteger)port sniffingDomains: (NSArray<NSString *> *)sniffingDomains excludeSniffingDomains: (NSArray<NSString *> *)excludeSniffingDomains;

// 启动抓包代理
- (BOOL)startProxy;
- (BOOL)startProxyWithPort: (NSUInteger)port;

// 停止抓包代理
- (void)stopProxy;

// 生成的 CA 路径，用于 HTTPS 抓包
- (NSString *)CAPath;

// 重新生成 CA 证书，调用后，重新调用 CAPath 即可获取到最新的证书路径，建议重新生成的时候，把抓包临时关掉
- (void)reGenerateCA;

// 注册新的抓包 Session
- (void)registerSession;

// 结束当前抓包 Session
- (void)stopSession;

// 所有的抓包 Session
- (NSArray<STSession *> *)sessions;

// 某个 Session 里的所有请求
- (NSArray<STConnection *> *)connectionsForSession: (STSession *)session;

// 获取某个请求的 Request Body
- (NSData *)requestBodyForConnection: (STConnection *)connection inSession: (STSession *)session;

// 获取某个请求的 Response Body
- (NSData *)responseBodyForConnection: (STConnection *)connection inSession: (STSession *)session;

// 删除某次 Session 以及对应的请求
- (void)removeSession: (STSession *)session;

// 删除某个不符合条件的请求
- (void)removeConnection: (STConnection *)connection inSession: (STSession *)session;

// 删除所有的抓包记录
- (void)removeAllSessions;

@end

