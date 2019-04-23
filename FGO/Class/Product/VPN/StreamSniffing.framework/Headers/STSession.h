//
//  STSession.h
//  PackageTunnelProvider
//
//  Created by xushaozhen on 16/11/2017.
//  Copyright © 2017 fish. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STSession : NSObject

@property (strong, nonatomic) NSDate *startTime;
@property (strong, nonatomic) NSDate *endTime;
@property (strong, nonatomic) NSString *name;
@property (assign, nonatomic) NSInteger uploadSize;
@property (assign, nonatomic) NSInteger downloadSize;

@end
