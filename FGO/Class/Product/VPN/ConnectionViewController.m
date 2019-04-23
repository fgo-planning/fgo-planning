//
//  ConnectionViewController.m
//  StreamSniffingExample
//
//  Created by xushaozhen on 2018/5/17.
//  Copyright © 2018 fish. All rights reserved.
//

#import "ConnectionViewController.h"
#import <Masonry.h>
#import <StreamSniffing/StreamSniffing.h>

@interface ConnectionViewController () <UITableViewDataSource, UITableViewDelegate> {
    UITableView *_tableView;
    
    NSData *_requestData;
    NSData *_responseData;
}

@end

@implementation ConnectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"Connection";
    
    [self initTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableView

- (void)initTableView
{
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.estimatedRowHeight = 40;
    [self.view addSubview:_tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.font = [UIFont systemFontOfSize:12];
    }
    
    if (indexPath.section == 0) {
        cell.textLabel.text = _connection.uri;
    } else if (indexPath.section == 1) {
        cell.textLabel.text = _connection.requestHeader;
    } else if (indexPath.section == 2) {
        NSData *data = [[STSniffingSDK sharedInstance] requestBodyForConnection:self.connection inSession:self.session];
        NSString *text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        cell.textLabel.text = text;
    } else if (indexPath.section == 3) {
        cell.textLabel.text = _connection.responseHeader;
    } else {
        NSData *data = [[STSniffingSDK sharedInstance] responseBodyForConnection:self.connection inSession:self.session];
        NSString *text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        cell.textLabel.text = text;
        
        if ([self.connection.uri containsString:@"_key=toplogin"]) {//_key=toplogin
            NSString *urlencodeStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSString *urlDencodeStr = [NSString p_URLDencode:urlencodeStr];
            NSString *base64Dencode = [NSString p_base64Dencode:urlDencodeStr];

            cell.textLabel.text = base64Dencode;
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



@end
