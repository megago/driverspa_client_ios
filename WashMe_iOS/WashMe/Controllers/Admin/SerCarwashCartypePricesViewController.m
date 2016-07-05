//
//  SerCarwashCartypePricesViewController.m
//  WashMe
//
//  Created by Almas Adilbek on 10/25/14.
//  Copyright (c) 2014 Almas Adilbek. All rights reserved.
//

#import "SerCarwashCartypePricesViewController.h"
#import "UIViewController+Ext.h"

#import "SimpleCheckboxCell.h"
#import "CreateCarwashDraft.h"
#import "CompanyCarwashRefs.h"
#import "Cache.h"
#import "IdTitleObject.h"
#import "SimpleDisclosureCell.h"
#import "SerCarwashCartypeServicePricesViewController.h"
#import "UIViewController+NoContent.h"

@interface SerCarwashCartypePricesViewController ()
@end

@implementation SerCarwashCartypePricesViewController {
    UITableView *list;
    NSArray *carTypes;
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

    if(![[CreateCarwashDraft sharedInstance] issetCarTypes]) {
        [self showNoContentMessage:@"Для начало выберите типы машин для Вашей мойки в разделе \"Типы машин\""];
        return;
    }

    if(![[CreateCarwashDraft sharedInstance] issetServices]) {
        [self showNoContentMessage:@"Для начало выберите список услуг Вашей мойки в разделе \"Услуги\""];
        return;
    }

    carTypes = [[CreateCarwashDraft sharedInstance] carTypes];
    [list reloadData];
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
    return carTypes.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    IdTitleObject *carType = carTypes[(NSUInteger) indexPath.row];
    return [SimpleDisclosureCell cellHeight:carType.title];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"cell";
    SimpleDisclosureCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[SimpleDisclosureCell alloc] initWithReuseIdentifier:CellIdentifier];
    }

    IdTitleObject *carType = carTypes[(NSUInteger) indexPath.row];
    [cell setTitle:carType.title];

    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    SerCarwashCartypeServicePricesViewController *v = [[SerCarwashCartypeServicePricesViewController alloc] init];
    v.carType = carTypes[(NSUInteger) indexPath.row];
    [self.navigationController pushViewController:v animated:YES];
}

#pragma mark -

-(void)configUI
{
    [self setBlueBackground];
    [self setBackButton];
    [self setNavigationTitle:@"Цены"];

    list = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, [ASize screenWidth], [ASize screenHeightWithoutStatusBarAndNavigationBar]-44) style:UITableViewStylePlain];
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