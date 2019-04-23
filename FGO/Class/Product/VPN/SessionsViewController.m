//
//  SessionsViewController.m
//  StreamSniffingExample
//
//  Created by xushaozhen on 2018/5/17.
//  Copyright © 2018 fish. All rights reserved.
//

#import "SessionsViewController.h"
#import <Masonry.h>
#import <StreamSniffing/StreamSniffing.h>
#import "SessionViewController.h"

@interface SessionsViewController () <UITableViewDelegate, UITableViewDataSource> {
    UITableView *_tableView;
    
    NSArray<STSession *> *_sessions;
}

@end

@implementation SessionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"Sessions";
    
    _sessions = [[STSniffingSDK sharedInstance] sessions];
    
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
    return _sessions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    STSession *session = [_sessions objectAtIndex:indexPath.row];
    cell.textLabel.text = [session.startTime description];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SessionViewController *controller = [[SessionViewController alloc] init];
    STSession *session = [_sessions objectAtIndex:indexPath.row];
    controller.session = session;
    [self.navigationController pushViewController:controller animated:YES];
}

@end
