//
//  NSObject+KZAFNetWorking.h
//  KZBaseProject
//
//  Created by 孔志林 on 2018/6/7.
//  Copyright © 2018年 KMingMing. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^CompletionSuccess)(NSURLSessionDataTask *dataTask, id response);
typedef void(^CompletionFailure)(id error);
@interface NSObject (KZAFNetWorking)
/**
 GET请求
 
 @param url 请求url
 @param paramaters 请求参数
 @param successBlock 成功回调
 @param failureBlock 失败回调
 */
- (void)GET:(NSString *)url
 paramaters:(id)paramaters
    success:(CompletionSuccess)successBlock
    failure:(CompletionFailure)failureBlock;

/**
 POST请求
 
 @param url 请求url
 @param paramaters 请求参数
 @param successBlock 成功回调
 @param failureBlock 失败回调
 */
- (void)POST:(NSString *)url
  paramaters:(id)paramaters
     success:(CompletionSuccess)successBlock
     failure:(CompletionFailure)failureBlock;

/**
 上传图片

 @param url 地址
 @param images 保存图片的数组
 @param params 上传参数
 @param successBlock 成功回调
 @param failureBlock 失败回调
 */
+ (void)uploadImageWithUrl:(NSString *)url
                    images:(NSArray *)images
                    params:(NSDictionary *)params
                   success:(CompletionSuccess)successBlock
                   failure:(CompletionFailure)failureBlock;

/**
 下载

 @param url 下载地址
 @param path 保存路径
 @param name 保存名字
 @param successBlock 成功
 @param failureBlock 失败
 */
+ (void)DownLoad:(NSString *)url
        savePath:(NSString *)path
        saveName:(NSString *)name
         success:(CompletionSuccess)successBlock
         failure:(CompletionFailure)failureBlock;

@end
