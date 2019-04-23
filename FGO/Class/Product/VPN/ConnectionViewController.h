//
//  ConnectionViewController.h
//  StreamSniffingExample
//
//  Created by xushaozhen on 2018/5/17.
//  Copyright © 2018 fish. All rights reserved.
//

#import <UIKit/UIKit.h>

@class STSession;
@class STConnection;

@interface ConnectionViewController : UIViewController

@property (nonatomic, strong) STConnection *connection;
@property (nonatomic, strong) STSession *session;

@end
