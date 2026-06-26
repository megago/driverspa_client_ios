//
//  CarwashPricesViewController.m
//  WashMe
//
//  Created by Almas Adilbek on 11/21/14.
//  Copyright (c) 2014 Almas Adilbek. All rights reserved.
//

#import "CarwashPricesViewController.h"
#import "UIViewController+Ext.h"

#import "CarwashMenuItem.h"
#import "Cache.h"
#import "CompanyCarwashRefs.h"
#import "CarwashRefs.h"
#import "IdTitleObject.h"
#import "NSString+Ext.h"

@interface CarwashPricesViewController ()
@end

@implementation CarwashPricesViewController {
    UITableView *list;
    NSArray *carTypeIds;
    NSMutableArray *carTypeMenus;
    NSArray *carTypes;
    NSArray *allCarTypes;
    NSArray *services;
    NSDictionary *servicesMap;
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

    carTypeIds = [self.menu allKeys];
    carTypeMenus = [[NSMutableArray alloc] init];

    allCarTypes = [[Cache carwashRefs] carType];
    services = [[Cache carwashRefs] services];

    for(id carTypeId in carTypeIds)
    {
        NSMutableArray *array = [NSMutableArray array];
        NSDictionary *menus = _menu[carTypeId];
        NSArray *menuTypeIds = [menus allKeys];
        for(id menuType in menuTypeIds) {
            [array addObject:menus[menuType]];
        }
        [carTypeMenus addObject:array];
    }

    servicesMap = [[Cache carwashRefs] servicesDictionary];
}

- (void)configAction
{
    
}

#pragma mark -
#pragma mark UITableView

-(int)numberOfSectionsInTableView:(UITableView *)tableView {
    return carTypeIds.count;
}
-(int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *menus = carTypeMenus[section];
    return menus.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 35;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *carTypeTitle = @"";
    for(IdTitleObject *carType in allCarTypes) {
        if([carType isIntObjectIdEqual:carTypeIds[section]]) {
            carTypeTitle = carType.title;
            break;
        }
    }
        
    UIView * header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [ASize screenWidth], 35)];
    header.backgroundColor = [UIColor fromRGB:0x0058A6];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, (CGFloat) (header.width * 0.8), 1)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont robotoRegular:14];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = carTypeTitle;
    [titleLabel sizeToFit];
    titleLabel.center = header.center;
    [header addSubview:titleLabel];
    return header;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.font = [UIFont robotoRegular:15];
        cell.detailTextLabel.textColor = [UIColor whiteColor];
        cell.detailTextLabel.font = [UIFont robotoThin:18];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

//    id carType = carTypeIds[indexPath.section];
    NSArray *menus = carTypeMenus[indexPath.section];
    CarwashMenuItem *carwashMenuItem = menus[indexPath.row];
    IdTitleObject *service = servicesMap[carwashMenuItem.type];

    cell.textLabel.text = service.title;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ тг.", [NSString numberFormattedNumberText:carwashMenuItem.price]];

    return cell;
}

#pragma mark -

-(void)configUI
{
    [self setBlueBackground];
    [self setBackButtonInNavigation];
    [self setNavigationTitle:@"Цены"];

    list = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, [ASize screenWidth], [ASize screenHeightWithoutStatusBarAndNavigationBar]) style:UITableViewStylePlain];
    list.delegate = self;
    list.dataSource = self;
    list.backgroundColor = [UIColor clearColor];
    list.separatorColor = [UIColor colorWithWhite:0xffffff alpha:0.3];
    list.rowHeight = 54;
    [self.view addSubview:list];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc {

}

@end