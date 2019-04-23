//
//  NSObject+KZAFNetWorking.m
//  KZBaseProject
//
//  Created by 孔志林 on 2018/6/7.
//  Copyright © 2018年 KMingMing. All rights reserved.
//


/**
 NSJSONReadingMutableContainers：返回可变容器，NSMutableDictionary或NSMutableArray。
 NSJSONReadingMutableLeaves：返回的JSON对象中字符串的值为NSMutableString
 NSJSONReadingAllowFragments：允许JSON字符串最外层既不是NSArray也不是NSDictionary，但必须是有效的JSON Fragment。例如使用这个选项可以解析 @“123” 这样的字符串
 一般都用NSJSONReadingMutableContainers
 */

#import "NSObject+KZAFNetWorking.h"
#import <AFNetworking.h>
#import <SVProgressHUD.h>

#define kDocumentPath NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject

@implementation NSObject (KZAFNetWorking)
+ (instancetype)sharedAFManager
{
    static AFHTTPSessionManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseUrl]];
        manager.requestSerializer.timeoutInterval = 30; //响应超时时间
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", @"text/json", @"text/javascript", @"application/json",nil];
        
        /**
         fix Bug: Request failed: unsupported media type (415) 添上下面两句
         because：AFNetwoking的默认Content-Type是application/x-www-form-urlencodem。若服务器要求Content-Type为applicaiton/json，为了和服务器对应，就必须修改AFNetworking的Content-Type
         */
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        /**
         responseSerializer:默认是AFJSONResponseSerializer
         AFJSONResponseSerializer：返回解析好的JSON
         AFHTTPResponseSerializer：返回原始JSON数据
         AFImageResponseSerializer：返回图片
         */
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
    });
    return manager;
}

- (void)GET:(NSString *)url paramaters:(id)paramaters success:(CompletionSuccess)successBlock failure:(CompletionFailure)failureBlock
{
    [(AFHTTPSessionManager *)[NSObject sharedAFManager] GET:url parameters:paramaters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        successBlock(task, responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failureBlock(error);
    }];
}

- (void)POST:(NSString *)url paramaters:(id)paramaters success:(CompletionSuccess)successBlock failure:(CompletionFailure)failureBlock
{
    [(AFHTTPSessionManager *)[NSObject sharedAFManager] POST:url parameters:paramaters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        successBlock(task, responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failureBlock(error);
    }];
}

#pragma mark - 上传图片
+ (void)uploadImageWithUrl:(NSString *)url images:(NSArray *)images params:(NSDictionary *)params success:(CompletionSuccess)successBlock failure:(CompletionFailure)failureBlock
{
    [SVProgressHUD showProgress:-1 status:@"正在上传,请稍等"];
    AFHTTPSessionManager *manager = [self sharedAFManager];
    [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (int i = 0; i < images.count; i++) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *dateStr = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString stringWithFormat:@"%@.jpg",dateStr];
            UIImage *image = images[i];
            NSData *imageData = UIImageJPEGRepresentation(image, 0.28);//压缩图片质量，不能无限压缩。
            NSString *name = [NSString stringWithFormat:@"uplpad%d",i+1];
            [formData appendPartWithFileData:imageData name:name fileName:fileName mimeType:@"image/jpeg"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"");
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [SVProgressHUD showSuccessWithStatus:@"上传成功"];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"上传失败"];
    }];
}

#pragma mark - 下载
+ (void)DownLoad:(NSString *)url savePath:(NSString *)path saveName:(NSString *)name success:(CompletionSuccess)successBlock failure:(CompletionFailure)failureBlock
{
    [self p_SVProgressHUDBegin:@"正在下载"];
    __block NSString *savePath = kDocumentPath;
    if (path) {
        savePath = path;
    }
    
    NSFileManager *filemanager = [NSFileManager defaultManager];
    BOOL isExist = [filemanager fileExistsAtPath:savePath];
    if (!isExist) {
        [filemanager createDirectoryAtPath:savePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSURL *downLoadurl = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:downLoadurl];
    
    NSURLSessionDownloadTask *task = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        if (name) {
            savePath = [savePath stringByAppendingPathComponent:name];
        }else
        {
            savePath = [savePath stringByAppendingPathComponent:response.suggestedFilename];
        }
        return [NSURL fileURLWithPath:savePath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        [self p_SVProgressHUDDismiss];
        if (!error) {
            [self p_SVProgressHUDSuccess:@"下载完成"];
        }else {
            [self p_SVProgressHUDError:@"下载错误"];
        }
    }];
    [task resume];
    
}
@end
