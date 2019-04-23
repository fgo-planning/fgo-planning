//
//  STConnection.h
//  PackageTunnelProvider
//
//  Created by xushaozhen on 14/11/2017.
//  Copyright © 2017 fish. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STConnection : NSObject<NSCopying>

#pragma mark - 请求相关

// 请求 URL
@property (strong, nonatomic) NSString *uri;

// 请求端口
@property (assign, nonatomic) NSUInteger port;

// 请求 HTTP 协议版本号
@property (strong, nonatomic) NSString *version;

// 远程 IP
@property (strong, nonatomic) NSString *remoteAddress;

// 请求 URL 域
@property (strong, nonatomic) NSString *host;

// 请求 UserAgent
@property (strong, nonatomic) NSString *userAgent;

// 请求 Method
@property (strong, nonatomic) NSString *method;

// 请求 Content-Type
@property (strong, nonatomic) NSString *requestContentType;

// 请求 Content-Length
@property (assign, nonatomic) NSUInteger requestContentLength;

// 请求主体
@property (strong, nonatomic) NSData *requestBodyData;

// 请求头部
@property (strong, nonatomic) NSString *requestHeader;

// 请求头部 Data
@property (strong, nonatomic) NSData *requestHeaderData;


#pragma mark - 响应相关

// 响应 Code 值
@property (strong, nonatomic) NSString *responseCode;

// 响应 HTTP 协议版本号
@property (strong, nonatomic) NSString *responseVersion;

// 响应 statusText
@property (strong, nonatomic) NSString *responseStatusText;

// 响应 Content-Type
@property (strong, nonatomic) NSString *responseContentType;

// 响应 Content-Encoding
@property (strong, nonatomic) NSString *responseContentEncoding;

// 响应 Content-Length
@property (assign, nonatomic) NSUInteger responseContentLength;

// 是否存在 Content-Length 字段
@property (assign, nonatomic) BOOL hasResponseContentLength;

// 响应主体
@property (strong, nonatomic) NSData *responseBodyData;

// 响应编码
@property (strong, nonatomic) NSString *responseCharset;

// 响应头部
@property (strong, nonatomic) NSString *responseHeader;

#pragma mark - 其他

// 连接错误原因
@property (strong, nonatomic) NSString *disconnectError;

// 归属于哪次抓包 Session
@property (strong, nonatomic) NSDate *sessionStartTime;

// 某次请求的唯一标识符
@property (strong, nonatomic) NSString *identifier;

// 请求开始时间
@property (strong, nonatomic) NSDate *startTime;

// 服务器开始响应的时间
@property (strong, nonatomic) NSDate *startResponseTime;

// 请求关闭的时间
@property (strong, nonatomic) NSDate *closeTime;

// 请求是否仍然处于活跃状态
@property (assign, nonatomic) BOOL active;


@end
