//
//  UserBookingsViewController.m
//  WashMe
//
//  Created by Almas Adilbek on 10/12/14.
//  Copyright (c) 2014 Almas Adilbek. All rights reserved.
//

#import "UserBookingsViewController.h"
#import "UIViewController+Ext.h"
#import "UserApi.h"
#import "SimpleDisclosureCell.h"
#import "CarwashBook.h"
#import "SimpleDetailsCell.h"
#import "SimpleDetailsDisclosureCell.h"
#import "UIViewController+NoContent.h"

@interface UserBookingsViewController ()
@end

@implementation UserBookingsViewController {
    NSMutableArray  *bookings;
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

    [self loadBookings];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userBookUpdated) name:kUserBookEditedNotification object:nil];
}

- (void)loadBookings
{
    [Toast showHudLoading];
    [UserApi bookingsWithStatus:kBookStatusPending success:^(id response) {
        bookings = [NSMutableArray arrayWithArray:response];
        [self reloadList];
    } failure:^(NSInteger code, NSString *message) {

    }];
}

- (void)reloadList {
    if(bookings.count > 0) {
        list.hidden = NO;
        [list reloadData];
        [self removeNoContentMessageIfExists];
    } else {
        __weak UserBookingsViewController *wSelf = self;
        [self showNoContentMessage:@"У Вас нет автивных броней" withButton:@"Обновить" selector:@selector(loadBookings)];
        list.hidden = YES;
    }
}

#pragma mark -
#pragma mark Notifications

- (void)userBookUpdated {
    [self loadBookings];
}

#pragma mark -
#pragma mark ClientBookViewController

- (void)clientBookViewControllerBookCanceled:(NSString *)bookId {
    for(CarwashBook *book in bookings) {
        if([book.carwashBookId isEqual:bookId]) {
            [bookings removeObject:book];
            [self reloadList];
            break;
        }
    }
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
    return [SimpleDetailsDisclosureCell cellHeight:book.carwashName details:[book localizedPrettyDate]];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"cell";
    SimpleDetailsDisclosureCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[SimpleDetailsDisclosureCell alloc] initWithReuseIdentifier:CellIdentifier];
    }

    CarwashBook *book = bookings[(NSUInteger) indexPath.row];
    [cell setTitle:book.carwashName details:[book localizedPrettyDate]];

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
    [self setBackButton];
    [self setBlueBackground];
    [self setNavigationTitle:@"Мои брони"];

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
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kUserBookEditedNotification object:nil];
}

@end