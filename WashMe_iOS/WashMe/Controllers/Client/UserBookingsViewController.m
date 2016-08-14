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
#import "UIViewController+NavigationBar.h"
#import "LGRefreshView.h"
#import "BookCell.h"

@interface UserBookingsViewController ()
@property(nonatomic, strong) LGRefreshView *refreshView;
@end

@implementation UserBookingsViewController {
    NSMutableArray  *bookings;
    UITableView *list;
    int badgeCount;
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
    //[self loadBookings];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userBookUpdated) name:kUserBookEditedNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setTabBarVisible:YES animated:YES completion:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [self loadBookings];
}

#pragma mark - 
#pragma mark - Config Action

- (void)loadBookings
{
    [Toast showHudLoading];
    [UserApi bookingsWithStatus:nil success:^(id response) {
        bookings = [NSMutableArray arrayWithArray:response];
        [self reloadList];
        [self updateBadge];
        [self.refreshView endRefreshing];
    } failure:^(NSInteger code, NSString *message) {

    }];
}

- (void)reloadList {
    if(bookings.count > 0) {
        list.hidden = NO;
        [list reloadData];
        [self removeNoContentMessageIfExists];
    } else {
        //__weak UserBookingsViewController *wSelf = self;
        [self showNoContentMessage:@"У Вас нет автивных броней" withButton:@"Обновить" selector:@selector(loadBookings)];
        list.hidden = YES;
    }
}

- (void)updateBadge {
    badgeCount = 0;
    for (CarwashBook *book in bookings) {
        if (book.isPending || book.isApproved) {
            badgeCount++;
        }
    }
    if (badgeCount > 0) {
        [[[[[self tabBarController] tabBar] items]
          objectAtIndex:3] setBadgeValue:[NSString stringWithFormat:@"%i", badgeCount]];
    } else {
        [[[[[self tabBarController] tabBar] items]
          objectAtIndex:3] setBadgeValue:nil];
    }
}

- (void)setTabBarVisible:(BOOL)visible animated:(BOOL)animated completion:(void (^)(BOOL))completion {
    
    if ([self tabBarIsVisible] == visible) return (completion)? completion(YES) : nil;
    
    CGRect frame = self.tabBarController.tabBar.frame;
    CGFloat height = frame.size.height;
    CGFloat offsetY = (visible)? -height : height;
    
    CGFloat duration = (animated)? 0.3 : 0.0;
    
    [UIView animateWithDuration:duration animations:^{
        self.tabBarController.tabBar.frame = CGRectOffset(frame, 0, offsetY);
    } completion:completion];
}

- (BOOL)tabBarIsVisible {
    return self.tabBarController.tabBar.frame.origin.y < CGRectGetMaxY(self.view.frame);
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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return bookings.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CarwashBook *book = bookings[(NSUInteger) indexPath.row];
    return [BookCell cellHeight:book];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"cell";
    //SimpleDetailsDisclosureCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    BookCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[BookCell alloc] initWithReuseIdentifier:CellIdentifier];
    }

    CarwashBook *book = bookings[(NSUInteger) indexPath.row];
    //[cell setTitle:book.carwashName details:[book localizedPrettyDate]];
    [cell setCarwashBook:book];

    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    __weak UserBookingsViewController * weakSelf = self;
    __weak NSMutableArray * weakBookings = bookings;
    [self setTabBarVisible:NO animated:YES completion:^(BOOL finished) {
        UserBookViewController *v = [[UserBookViewController alloc] init];
        v.delegate = weakSelf;
        v.book = weakBookings[(NSUInteger) indexPath.row];
        v.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:v animated:YES];
    }];
}

#pragma mark -

-(void)configUI
{
    [super configUI];
    [self showMenuButton];
    [self setBlueBackground];
    [self setNavigationBarTransparent];
    [self setNavigationTitle:@"Мои брони"];

    list = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, [ASize screenWidth], [ASize screenHeightWithoutStatusBarAndNavigationBar] - 44) style:UITableViewStylePlain];
    list.delegate = self;
    list.dataSource = self;
    list.backgroundColor = [UIColor clearColor];
    list.separatorColor = [UIColor clearColor];
    [self.view addSubview:list];
    
    __weak typeof(self) wself = self;
    _refreshView = [LGRefreshView refreshViewWithScrollView:list
                                             refreshHandler:^(LGRefreshView *refreshView)
                    {
                        [wself loadBookings];
                    }];
    _refreshView.tintColor = [UIColor whiteColor];
    _refreshView.backgroundColor = [UIColor clearColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kUserBookEditedNotification object:nil];
}

@end