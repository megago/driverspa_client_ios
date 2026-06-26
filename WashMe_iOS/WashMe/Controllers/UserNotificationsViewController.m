//
//  UserNotificationsViewController.m
//  WashMe
//
//  Created by Almas Adilbek on 2/21/15.
//  Copyright (c) 2015 Almas Adilbek. All rights reserved.
//

#import "UserNotificationsViewController.h"
#import "UIViewController+Ext.h"
#import "UserApi.h"
#import "EventNotification.h"
#import "SimpleDetailsDisclosureCell.h"
#import "NSDate+DateTools.h"

@interface UserNotificationsViewController ()
@end

@implementation UserNotificationsViewController {
    NSMutableArray *notifications;
    UITableView *list;
}

-(id)init {
    self = [super init];
    if(self) {
        [self initVars];
    }
    return self;
}

-(void)initVars {}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configUI];

    [Toast showHudLoading];
    [UserApi notifications:^(id response) {
        NSLog(@"%@", response);
        notifications = response;
        [list reloadData];
    } failure:^(NSInteger code, NSString *message) {

    }];
}

#pragma mark -
#pragma mark UITableView

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return notifications.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    EventNotification *notification = notifications[(NSUInteger) indexPath.row];
    return [SimpleDetailsDisclosureCell cellHeight:notification.text details:[notification.date timeAgoSinceNow]];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"cell";
    SimpleDetailsDisclosureCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[SimpleDetailsDisclosureCell alloc] initWithReuseIdentifier:CellIdentifier];
        cell.accessoryView = nil;
    }

    EventNotification *notification = notifications[(NSUInteger) indexPath.row];
    [cell setTitle:notification.text details:[notification.date timeAgoSinceNow]];

    return cell;
}

#pragma mark -

-(void)configUI
{
    [super configUI];
    [self setBlueBackground];
    [self setNavigationTitle:@"Уведомления"];
    [self setBackButtonInNavigation];
    
    list = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, [ASize screenWidth], [ASize screenHeightWithoutStatusBarAndNavigationBarAndTabBar]) style:UITableViewStylePlain];
    list.delegate = self;
    list.dataSource = self;
    list.backgroundView = [[UIView alloc] init];
    list.backgroundColor = [UIColor clearColor];
    list.separatorColor = [UIColor clearColor];
    list.rowHeight = 55;
    list.allowsSelection = NO;
    [self.view addSubview:list];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc {

}

@end