//
//  SetCarwashServicesViewController.m
//  WashMe
//
//  Created by Almas Adilbek on 10/22/14.
//  Copyright (c) 2014 Almas Adilbek. All rights reserved.
//

#import "SetCarwashServicesViewController.h"
#import "UIViewController+Ext.h"

#import "IdTitleObject.h"
#import "SimpleCheckboxCell.h"
#import "Cache.h"
#import "CarwashRefs.h"
#import "CompanyCarwashRefs.h"
#import "CreateCarwashDraft.h"

@interface SetCarwashServicesViewController ()
@end

@implementation SetCarwashServicesViewController {
    UITableView *list;
    NSArray *services;
}

-(id)init {
    self = [super init];
    if(self) {
        [self initVars];
    }
    return self;
}

-(void)initVars {
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configUI];

    [Cache companyCarwashRefs:^(id obj) {
        services = [(CompanyCarwashRefs *)obj services];
        [list reloadData];
    }];
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
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"cell";
    SimpleCheckboxCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[SimpleCheckboxCell alloc] initWithReuseIdentifier:CellIdentifier];
    }

    IdTitleObject *service = services[(NSUInteger) indexPath.row];
    [cell setTitle:service.title];

    cell.isChecked = NO;
    for(IdTitleObject *obj in [[CreateCarwashDraft sharedInstance] services]) {
        if([obj.objectId intValue] == [service.objectId intValue]) {
            cell.isChecked = YES;
            break;
        }
    }

    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    SimpleCheckboxCell *cell = (SimpleCheckboxCell *) [tableView cellForRowAtIndexPath:indexPath];
    cell.isChecked = !cell.isChecked;

    IdTitleObject *service = services[(NSUInteger) indexPath.row];
    if(cell.isChecked) {
        [[CreateCarwashDraft sharedInstance] addService:service];
    } else {
        [[CreateCarwashDraft sharedInstance] removeServiceWithId:service.objectId];
    }
}

#pragma mark -

-(void)configUI
{
    [self setBlueBackground];
    [self setBackButtonInNavigation];
    [self setNavigationTitle:@"Услуги"];

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