//
//  AdminCarwashBoxesSchedulesViewController.m
//  WashMe
//
//  Created by Almas Adilbek on 3/28/15.
//  Copyright (c) 2015 Almas Adilbek. All rights reserved.
//

#import "AdminCarwashBoxesSchedulesViewController.h"
#import "UIViewController+Ext.h"
#import "AdminApi.h"
#import "SimpleCell.h"
#import "Carwash.h"
#import "CarwashApi.h"
#import "CarwashComplex.h"
#import "BoxSetting.h"
#import "SimpleDisclosureCell.h"
#import "AdminCarwashBoxScheduleViewController.h"
#import "BoxTimeTable.h"
#import "UIViewController+NoContent.h"

@interface AdminCarwashBoxesSchedulesViewController ()
@end

@implementation AdminCarwashBoxesSchedulesViewController {
    UITableView *list;
    NSString *carwashId;
    NSMutableArray *boxSettings;
    NSMutableArray *timeStatuses;
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
    [self loadCarwashes];
}

- (void)loadCarwashes
{
    [Toast showHudLoading];
    [AdminApi myCarwashes:^(id response) {
        [self onCarwashesLoaded:response];
    } failure:^(NSInteger code, NSString *message) {

    }];
}

- (void)onCarwashesLoaded:(id)response
{
    NSArray *carwashes = response;
    if(carwashes.count == 0)
    {
        [self showNoContentMessage:@"У Вас нет автомоек"];
    }
    else
    {
        [self removeNoContentMessageIfExists];
        Carwash *carwash = [carwashes firstObject];
        carwashId = carwash.carwashId;

        [Toast showHudWait];
        [CarwashApi getCarwashDetails:carwashId success:^(id response) {
            boxSettings = [[(CarwashComplex *)response boxSettings] mutableCopy];

            list.hidden = NO;
            [list reloadData];
        } failure:^(NSInteger code, NSString *message) {

        }];
    }
}

#pragma mark -
#pragma mark UITableView

-(int)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return boxSettings.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"cell";
    SimpleDisclosureCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[SimpleDisclosureCell alloc] initWithReuseIdentifier:CellIdentifier];
    }

    [cell setTitle:[NSString stringWithFormat:@"Бокс #%i", indexPath.row + 1]];

    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    BoxSetting *boxSetting = boxSettings[indexPath.row];

    AdminCarwashBoxScheduleViewController *v = [[AdminCarwashBoxScheduleViewController alloc] init];
    v.boxIndex = indexPath.row + 1;
    v.boxSetting = boxSetting;
    v.carwashId = carwashId;
    [self.navigationController pushViewController:v animated:YES];

}

#pragma mark -

-(void)configUI
{
    [self setBlueBackground];
    [self setNavigationTitle:@"Таблица броней"];
    [self setBackButton];

    CGFloat listY = 64;
    list = [[UITableView alloc] initWithFrame:CGRectMake(0, listY, [ASize screenWidth], [ASize screenHeight] - listY - 44) style:UITableViewStylePlain];
    list.delegate = self;
    list.dataSource = self;
    list.backgroundView = [[UIView alloc] init];
    list.backgroundColor = [UIColor clearColor];
    list.separatorColor = [UIColor clearColor];
    list.hidden = YES;
    [self.view addSubview:list];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc {

}

@end