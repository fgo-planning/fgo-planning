//
//  SessionViewController.m
//  StreamSniffingExample
//
//  Created by xushaozhen on 2018/5/17.
//  Copyright © 2018 fish. All rights reserved.
//

#import "SessionViewController.h"
#import <Masonry.h>
#import <StreamSniffing/StreamSniffing.h>
#import "ConnectionViewController.h"

@interface SessionViewController () <UITableViewDataSource, UITableViewDelegate> {
    UITableView *_tableView;
    
    NSArray<STConnection *> *_connections;
}


@end

@implementation SessionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"Connections";
    
    _connections = [[STSniffingSDK sharedInstance] connectionsForSession:self.session];
    
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
    [self.view addSubview:_tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _connections.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    STConnection *connection = [_connections objectAtIndex:indexPath.row];
    cell.textLabel.text = connection.uri;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ConnectionViewController *controller = [[ConnectionViewController alloc] init];
    
    STConnection *connection = [_connections objectAtIndex:indexPath.row];
    controller.connection = connection;
    controller.session = self.session;
    
    [self.navigationController pushViewController:controller animated:YES];
}


@end
