//
//  MenuViewController.m
//  WashMe
//
//  Created by Almas Adilbek on 4/2/16.
//  Copyright (c) 2016 Almas Adilbek. All rights reserved.
//

#import "MenuViewController.h"
#import "UIViewController+Ext.h"
#import "ALView+PureLayout.h"
#import "UIView+ConcisePureLayout.h"
#import "IdTitleObject.h"
#import "UIView+Gestures.h"
#import "ProfileViewController.h"
#import "UIViewController+FrostedMenu.h"
#import "User.h"
#import "UserApi.h"
#import "NotificationsHelper.h"
#import "UIHelper.h"
#import "AppDelegate.h"
#import "APIClient.h"
#import "UserSettings.h"
#import "City.h"

@interface MenuViewController ()
@property(nonatomic, strong) UITableView *list;
@property(nonatomic, strong) NSArray *items;
@end

@implementation MenuViewController {
    UIView *headerView;
    UIView *footerView;
    UIImageView *_avatarView;
    UILabel *_nameLabel;
    UILabel *_telLabel;
}

- (id)init
{
    self = [super init];
    if(self) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Menu" bundle:nil];
        self = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([MenuViewController class])];

        [self initVars];
    }
    return self;
}

-(void)initVars {
    self.items = @[
            //[IdTitleObject instanceWithId:@"city" title:@"Алматы" value:@"iconPin2"],
            //[IdTitleObject instanceWithId:@"mybook" title:@"Моя бронь" value:@"iconTimetable"],
            //[IdTitleObject instanceWithId:@"history" title:@"История посещений" value:@"iconHistory"],
            //[IdTitleObject instanceWithId:@"bonuses" title:@"Бонусы" value:@"iconPresent"],
            //[IdTitleObject instanceWithId:@"settings" title:@"Настройки" value:@"iconSettings"],
            //[IdTitleObject instanceWithId:@"share" title:@"Поделиться" value:@"iconShare"]
                   
           [IdTitleObject instanceWithId:@"carwashes" title:[NSString stringWithFormat:@"Мойки (%@)", [UserSettings currentCity].title] value:@"ic_business_white"],
           [IdTitleObject instanceWithId:@"aboutus" title:@"О нас" value:@"ic_about_us"]
    ];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self subscribeForNotifications];
    [self configUI];
}

+ (CGFloat)menuWidth {
    return 260;
}

#pragma mark -
#pragma mark Actions

- (void)openProfile {
    //[self pushViewControllerInCurrentContentController:[ProfileViewController new]];
    [self showControllerInStoryboard:@"UserMain" tabBar:@"profile"];
}

- (void)userProfileUpdated {
    [self setUserInfo];
}

- (void)setUserInfo {
    _nameLabel.text = [User currentUser].firstName;
    _telLabel.text = [User currentUser].mobile;
    
    [self initVars];
    [_list reloadData];
}

- (void)tapLogout {
    [[User currentUser] logoutQuestion:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
        if(actionSheet.cancelButtonIndex != buttonIndex) {
            
            NSString *udid = [UserSettings currentUDID];
            NSString *path = [NSString stringWithFormat:@"devices/%@", udid];
            [APIClient DELETE:path success:^(id response) {
                [[UIApplication sharedApplication] unregisterForRemoteNotifications];
                [UserSettings setIsRegisteredPushToken:NO];
                [UserSettings removePushToken];
                [UserSettings removeUDID];
                
                [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithInt:0] forKey:@"badgeCountApplication"];
                [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
                [[User currentUser] logout];
                [[UIHelper appDelegate] gotoWelcomeViewController];
            } failure:nil];
        }
    }];
}

#pragma mark -
#pragma mark UITableView

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 180;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if(!headerView) {
        headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[self class] menuWidth], [self tableView:tableView heightForHeaderInSection:section])];
        [headerView tapGesture:self selector:@selector(openProfile)];

        UIView *containerView = [UIView newAutoLayoutView];
        [headerView addSubview:containerView];
        [containerView aa_sameWidthWith:headerView];
        [containerView aa_centerVertical];

        _avatarView = [UIImageView newAutoLayoutView];
        [_avatarView aa_setHeight:65];
        [_avatarView aa_setWidth:65];
        _avatarView.contentMode = UIViewContentModeScaleAspectFill;
        _avatarView.image = [UIImage imageNamed:@"carwash-image-placeholder.png"];
        [containerView addSubview:_avatarView];
        [_avatarView aa_superviewTop:0];
        [_avatarView aa_centerHorizontal];

        _nameLabel = [UILabel newAutoLayoutView];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.font = [UIFont robotoBold:15];
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        [containerView addSubview:_nameLabel];
        [_nameLabel aa_pinUnderView:_avatarView offset:7];
        [_nameLabel aa_superviewFitWidthWithInset:20];

        _telLabel = [UILabel newAutoLayoutView];
        _telLabel.backgroundColor = [UIColor clearColor];
        _telLabel.font = [UIFont robotoThin:14];
        _telLabel.textColor = [UIColor whiteColor];
        _telLabel.textAlignment = NSTextAlignmentCenter;
        [containerView addSubview:_telLabel];
        [_telLabel aa_pinUnderView:_nameLabel offset:3];
        [_telLabel aa_leadingAndTrailing:_nameLabel];
        [_telLabel aa_superviewBottom:0];

        UIView *line = [UIView newAutoLayoutView];
        [line setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.1]];
        [line aa_setHeight:1];
        [headerView addSubview:line];
        [line aa_superviewBottom:0];
        [line aa_superviewFitWidth];

        [self setUserInfo];
    }

    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 200;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if(!footerView) {
        footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[self class] menuWidth], [self tableView:tableView heightForFooterInSection:section])];
        
        UIButton *logout = [UIButton newAutoLayoutView];
        [logout setBackgroundColor:[UIColor clearColor]];
        [logout setTitle:@"Выход" forState:UIControlStateNormal];
        [logout setImage:[UIImage imageNamed:@"ic_logout"] forState:UIControlStateNormal];
        [logout addTarget:self action:@selector(tapLogout) forControlEvents:UIControlEventTouchUpInside];
        [logout setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
        [logout setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        [footerView addSubview:logout];
        [logout aa_sameWidthWith:footerView];
        [logout aa_setHeight:40.f];
        [logout aa_superviewBottom:0.f];
    }
    return footerView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.font = [UIFont robotoRegular:16];
    }

    IdTitleObject *object = self.items[indexPath.row];
    cell.textLabel.text = object.title;

    UIView *imageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    imageView.opaque = NO;
    UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:object.value]];
    [imageView addSubview:iconView];
    iconView.center = imageView.middlePoint;
    iconView.y += 2;
    [iconView autoCenterInSuperview];
    cell.imageView.image = [UIImage imageWithView:imageView];

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    IdTitleObject *object = self.items[indexPath.row];

    if([object.objectId isEqual:@"carwashes"])
    {
        [self showControllerInStoryboard:@"UserMain" tabBar:@"tabBarcontroller"];
    }
    else if([object.objectId isEqual:@"aboutus"])
    {
        [self showControllerInStoryboard:@"UserMain" navigation:@"about_us" andTitle:nil];
    }
}

#pragma mark - Notifications

- (void) subscribeForNotifications
{
    [self unsubscribeFromNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userProfileUpdated)
                                                 name:kNotificationUserProfileUpdated
                                               object:nil];
}

- (void) unsubscribeFromNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name: kNotificationUserProfileUpdated
                                                  object:nil];
}

#pragma mark -

-(void)configUI
{
    [self setBlueBackground];

    self.list = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _list.delegate = self;
    _list.dataSource = self;
    _list.rowHeight = 40;
    _list.backgroundColor = [UIColor clearColor];
    _list.backgroundView = [UIView new];
    _list.separatorColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2];
    [self.view addSubview:_list];
    [_list autoPinEdgesToSuperviewEdges];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc {
    [self unsubscribeFromNotifications];
}

@end
