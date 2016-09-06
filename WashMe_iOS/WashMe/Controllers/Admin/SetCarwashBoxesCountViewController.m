//
//  SetCarwashBoxesCountViewController.m
//  WashMe
//
//  Created by Almas Adilbek on 10/25/14.
//  Copyright (c) 2014 Almas Adilbek. All rights reserved.
//

#import "SetCarwashBoxesCountViewController.h"
#import "UIViewController+Ext.h"

#import "SimpleCheckboxCell.h"
#import "CreateCarwashDraft.h"

@interface SetCarwashBoxesCountViewController ()
@end

@implementation SetCarwashBoxesCountViewController {
    UITableView *list;
    NSInteger selectedRow;
}

-(id)init {
    self = [super init];
    if(self) {
        [self initVars];
    }
    return self;
}

-(void)initVars {
    selectedRow = [[CreateCarwashDraft sharedInstance] boxesCount] - 1;
    if(selectedRow < 0) selectedRow = 2;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configUI];
    [self configAction];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[CreateCarwashDraft sharedInstance] setBoxesCount:(selectedRow + 1)];
}

- (void)configAction
{

}

#pragma mark -
#pragma mark UITableView

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"cell";
    SimpleCheckboxCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[SimpleCheckboxCell alloc] initWithReuseIdentifier:CellIdentifier];
    }

    [cell setTitle:[NSString stringWithFormat:@"  %li", (indexPath.row + 1)]];
    cell.isChecked = indexPath.row == selectedRow;

    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if(indexPath.row == selectedRow) return;

    SimpleCheckboxCell *cell = (SimpleCheckboxCell *) [tableView cellForRowAtIndexPath:indexPath];
    cell.isChecked = !cell.isChecked;

    if(selectedRow >= 0) {
        SimpleCheckboxCell *previousCheckedCell = (SimpleCheckboxCell *) [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selectedRow inSection:0]];
        previousCheckedCell.isChecked = NO;
    }

    selectedRow = indexPath.row;
}

#pragma mark -

-(void)configUI
{
    [self setBlueBackground];
    [self setBackButtonInNavigation];
    [self setNavigationTitle:@"Количество боксов"];

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