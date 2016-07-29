//
//  BooksHistoryViewController.m
//  WashMe
//
//  Created by Almas Adilbek on 10/3/14.
//  Copyright (c) 2014 Almas Adilbek. All rights reserved.
//

#import "BooksHistoryViewController.h"
#import "UIViewController+Ext.h"
#import "UserApi.h"
#import "CarwashBook.h"
#import "SimpleDisclosureCell.h"
#import "UIViewController+NoContent.h"

@interface BooksHistoryViewController ()
@end

@implementation BooksHistoryViewController {
    UITableView *list;
    NSMutableArray  *bookings;
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
    [self configAction];

    [Toast showHudLoading];
    [UserApi bookingsWithStatus:kBookStatusFinished success:^(id response) {
        bookings = [NSMutableArray arrayWithArray:response];
        if (bookings.count > 0) {
            [list reloadData];
        } else {
            [self showNoContentMessage:@"Вы еще не посетили ни одну мойку"];
        }

    } failure:^(NSInteger code, NSString *message) {

    }];
}

- (void)configAction
{

}

#pragma mark -
#pragma mark UITableView

-(int)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return bookings.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CarwashBook *book = bookings[(NSUInteger) indexPath.row];
    return [SimpleDisclosureCell cellHeight:[book localizedPrettyDate]];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"cell";
    SimpleDisclosureCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[SimpleDisclosureCell alloc] initWithReuseIdentifier:CellIdentifier];
    }

    CarwashBook *book = bookings[(NSUInteger) indexPath.row];
    [cell setTitle:[book localizedPrettyDate]];

    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    UserBookViewController *v = [[UserBookViewController alloc] init];
    v.delegate = self;
    v.book = bookings[(NSUInteger) indexPath.row];
    [self.navigationController pushViewController:v animated:YES];
}

#pragma mark -

-(void)configUI
{
    [super configUI];
    [self setBlueBackground];
    [self setBackButtonInNavigation];
    [self setNavigationTitle:@"История посещении"];

    list = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, [ASize screenWidth], [ASize screenHeightWithoutStatusBarAndNavigationBar] - 44) style:UITableViewStylePlain];
    list.delegate = self;
    list.dataSource = self;
    list.backgroundColor = [UIColor clearColor];
    list.separatorColor = [UIColor clearColor];
    [self.view addSubview:list];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc {

}

@end