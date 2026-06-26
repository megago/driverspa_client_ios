//
//  SetCarwashCarTypesViewController.m
//  WashMe
//
//  Created by Almas Adilbek on 10/22/14.
//  Copyright (c) 2014 Almas Adilbek. All rights reserved.
//

#import "SetCarwashCarTypesViewController.h"
#import "UIViewController+Ext.h"
#import "IdTitleObject.h"
#import "SimpleCheckboxCell.h"
#import "Cache.h"
#import "CarwashRefs.h"
#import "CompanyCarwashRefs.h"
#import "CreateCarwashDraft.h"

@interface SetCarwashCarTypesViewController ()
@end

@implementation SetCarwashCarTypesViewController {
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

-(void)initVars {
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configUI];

    [Cache companyCarwashRefs:^(id obj) {
        carTypes = [(CompanyCarwashRefs *)obj carType];
        [list reloadData];
    }];
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
    return [SimpleCheckboxCell cellHeight:carType.title];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"cell";
    SimpleCheckboxCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[SimpleCheckboxCell alloc] initWithReuseIdentifier:CellIdentifier];
    }

    IdTitleObject *carType = carTypes[(NSUInteger) indexPath.row];
    [cell setTitle:carType.title];

    cell.isChecked = NO;
    for(IdTitleObject *obj in [[CreateCarwashDraft sharedInstance] carTypes]) {
        if([obj.objectId intValue] == [carType.objectId intValue]) {
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

    IdTitleObject *carType = carTypes[(NSUInteger) indexPath.row];
    if(cell.isChecked) {
        [[CreateCarwashDraft sharedInstance] addCarType:carType];
    } else {
        [[CreateCarwashDraft sharedInstance] removeCarTypeWithId:carType];
    }
}

#pragma mark -

-(void)configUI
{
    [self setBlueBackground];
    [self setBackButtonInNavigation];
    [self setNavigationTitle:@"Типы машин"];

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
