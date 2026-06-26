//
//  BookingCarwashServicesViewController.m
//  WashMe
//
//  Created by Almas Adilbek on 10/5/14.
//  Copyright (c) 2014 Almas Adilbek. All rights reserved.
//

#import "BookingCarwashServicesViewController.h"
#import "UIViewController+Ext.h"
#import "SimpleCheckboxCell.h"
#import "CarwashRefs.h"
#import "Cache.h"
#import "IdTitleObject.h"
#import "AAButton+Styles.h"
#import "UIViewController+NoContent.h"

@interface BookingCarwashServicesViewController ()
@end

@implementation BookingCarwashServicesViewController {
    NSArray *services;
    UITableView *list;
    NSMutableDictionary *checkedServicesDictionary;
    AAButton *applyButton;
}

-(id)init {
    self = [super init];
    if(self) {
        [self initVars];
    }
    return self;
}

-(void)initVars {
    self.checkedServices = [[NSMutableArray alloc] init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configUI];

    [Cache carwashRefs:^(id obj) {
        NSMutableArray *array = [NSMutableArray array];
        NSDictionary *servicesDictionary = [(CarwashRefs *)obj servicesDictionary];

        for(id serviceId in self.carwashServices) {
            if(servicesDictionary[serviceId] != nil) {
                [array addObject:servicesDictionary[serviceId]];
            }
        }

        services = array;

        if(services.count > 0) {
            [list reloadData];
        } else {
            [self showNoContentMessage:@"Для выбранного типа машин\nнет услуги" withButton:@"Назад" selector:@selector(goBack)];
        }
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [self updateApplyButtonState];
}

- (void)setCheckedServices:(NSMutableArray *)checkedServices {
    _checkedServices = checkedServices;
    checkedServicesDictionary = [[NSMutableDictionary alloc] init];
    for(IdTitleObject *obj in _checkedServices) {
        checkedServicesDictionary[obj.objectId] = obj;
    }
}

#pragma mark -
#pragma mark Actions

- (void)applyTap {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark UITableView

-(int)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return services.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    IdTitleObject *service = services[(NSUInteger) indexPath.row];
    return [SimpleCheckboxCell cellHeight:service.title];
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 65;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [ASize screenWidth], 65)];

    // Button
    if(!applyButton) {
        __weak BookingCarwashServicesViewController *wSelf = self;
        applyButton = [[AAButton alloc] initWithWidth:150 onTap:^(UIView *_self) {
            [wSelf applyTap];
        }];
        [applyButton commonStyleButtonWithTitle:@"Применить"];
        [applyButton setTitleFont:[UIFont robotoRegular:20]];
        applyButton.centerX = footerView.centerX;
        applyButton.y = footerView.height - applyButton.height;
        applyButton.button.enabled = NO;
    }
    [footerView addSubview:applyButton];

    return footerView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"cell";
    SimpleCheckboxCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[SimpleCheckboxCell alloc] initWithReuseIdentifier:CellIdentifier];
    }

    IdTitleObject *service = services[(NSUInteger) indexPath.row];
    [cell setTitle:service.title];

    cell.isChecked = (checkedServicesDictionary[service.objectId] != nil && checkedServicesDictionary[service.objectId] != [NSNull null]);

    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    SimpleCheckboxCell *cell = (SimpleCheckboxCell *) [tableView cellForRowAtIndexPath:indexPath];
    cell.isChecked = !cell.isChecked;

    IdTitleObject *service = services[(NSUInteger) indexPath.row];
    if(cell.isChecked) {
        [_checkedServices addObject:service];
        checkedServicesDictionary[service.objectId] = service;
    } else {
        [_checkedServices removeObject:service];
        for(IdTitleObject *obj in _checkedServices) {
            if([obj isIntObjectIdEqual:service.objectId]) {
                [_checkedServices removeObject:obj];
                break;
            }
        }
        checkedServicesDictionary[service.objectId] = [NSNull null];
    }

    // Update apply button
    [self updateApplyButtonState];

    [self.delegate carwashServicesViewControllerSelectedServices:_checkedServices];
}

#pragma mark -

- (void)updateApplyButtonState {
    applyButton.button.enabled = _checkedServices.count > 0;
}

-(void)configUI
{
    [self setBlueBackground];
    [self setBackButtonInNavigation];
    [self setNavigationTitle:@"Выберите услуги"];
    
    list = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, [ASize screenWidth], [ASize screenHeightWithoutStatusBarAndNavigationBar]) style:UITableViewStylePlain];
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