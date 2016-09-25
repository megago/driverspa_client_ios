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
#import "UIViewController+NoContent.h"

#import "CarwashComplex.h"
#import "BoxSetting.h"
#import "BoxAdminCell.h"
#import "CreateCarwashDraft.h"
#import "SetBoxSettingViewController.h"
#import "AdminApi.h"

@interface SetCarwashBoxesCountViewController () <SetBoxSettingViewControllerDelegate>
@end

@implementation SetCarwashBoxesCountViewController {
    CarwashComplex *carwash;
    
    NSArray *boxes;
    UITableView *list;
    NSInteger selectedRow;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    carwash = [CarwashComplex cashedCarwash];
    [self configUI];
    [self loadBoxes];
}

- (void)viewWillDisappear:(BOOL)animated {
    //[[CreateCarwashDraft sharedInstance] setBoxesCount:(selectedRow + 1)];
}

#pragma mark - 
#pragma mark - Actions

- (void)loadBoxes {
    [Toast showHudLoading];
    [AdminApi getCarwashBoxes:carwash.carwashId success:^(id response) {
        [self removeNoContentMessageIfExists];
        boxes = (NSArray *)response;
        [self buildUI];
    } failure:^(NSInteger code, NSString *message) {
        
    }];
}

- (void)tapAddBox {
    SetBoxSettingViewController *v = [[SetBoxSettingViewController alloc] init];
    v.delegate = self;
    v.carwash = carwash;
    [self.navigationController pushViewController:v animated:YES];
}

- (void)refreshList {
    
}

#pragma mark -
#pragma mark SetBoxSettingViewControllerDelegate

- (void)boxSettingUpdated {
    [list removeFromSuperview];
    [self loadBoxes];
}

#pragma mark -
#pragma mark UITableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return boxes.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    BoxSetting *box = boxes[(NSUInteger) indexPath.row];
    return [BoxAdminCell cellHeight:box];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"cell";
    BoxAdminCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[BoxAdminCell alloc] initWithReuseIdentifier:CellIdentifier];
    }

    BoxSetting *box = boxes[indexPath.row];
    [cell setBoxSetting:box];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BoxSetting *box = boxes[indexPath.row];
    SetBoxSettingViewController *v = [[SetBoxSettingViewController alloc] init];
    v.editMode = YES;
    v.box = box;
    v.delegate = self;
    v.carwash = carwash;
    [self.navigationController pushViewController:v animated:YES];
}

#pragma mark -

-(void)configUI
{
    [self setBlueBackground];
    [self setBackButtonInNavigation];
    [self setNavigationTitle:@"Количество боксов"];
    [self setNavigationButtonWithIcon:@"iconCirclePlus" atLeft:NO selector:@selector(tapAddBox)];
    [self showNoContentMessage:@"Нет боксов" withButton:@"Обновить" selector:@selector(loadBoxes)];
}

- (void)buildUI {
    if (boxes.count == 0){
        [self showNoContentMessage:@"Нет боксов" withButton:@"Обновить" selector:@selector(loadBoxes)];
    } else {
        list = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, [ASize screenWidth], [ASize screenHeightWithoutStatusBarAndNavigationBar]) style:UITableViewStylePlain];
        list.delegate = self;
        list.dataSource = self;
        list.backgroundColor = [UIColor clearColor];
        list.separatorColor = [UIColor clearColor];
        [self.view addSubview:list];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc {

}

@end
