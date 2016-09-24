//
//  SetCarwashBoxesCountViewController.m
//  WashMe
//
//  Created by Almas Adilbek on 10/25/14.
//  Copyright (c) 2014 Almas Adilbek. All rights reserved.
//

#import "SetCarwashBoxesCountViewController.h"
#import "UIViewController+Ext.h"
#import "UIViewController+NavigationBar.h"

#import "CarwashComplex.h"
#import "BoxSetting.h"
#import "BoxAdminCell.h"
#import "CreateCarwashDraft.h"
#import "AddBoxViewController.h"

@interface SetCarwashBoxesCountViewController () {
    CarwashComplex *carwash;
}
@end

@implementation SetCarwashBoxesCountViewController {
    UITableView *list;
    NSInteger selectedRow;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    carwash = [CarwashComplex cashedCarwash];
    
    [self configUI];
}

- (void)tapAddBox {
    AddBoxViewController *v = [[AddBoxViewController alloc] init];
    [self.navigationController pushViewController:v animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[CreateCarwashDraft sharedInstance] setBoxesCount:(selectedRow + 1)];
}

#pragma mark -
#pragma mark UITableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return carwash.boxSettings.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    BoxSetting *box = carwash.boxSettings[(NSUInteger) indexPath.row];
    return [BoxAdminCell cellHeight:box];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"cell";
    BoxAdminCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[BoxAdminCell alloc] initWithReuseIdentifier:CellIdentifier];
    }

    BoxSetting *box = carwash.boxSettings[indexPath.row];
    [cell setBoxSetting:box];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -

-(void)configUI
{
    [self setBlueBackground];
    [self setBackButtonInNavigation];
    [self setNavigationTitle:@"Количество боксов"];
    [self setNavigationButtonWithIcon:@"iconCirclePlus" atLeft:NO selector:@selector(tapAddBox)];

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
