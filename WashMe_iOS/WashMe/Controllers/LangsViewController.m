//
//  LangsViewController.m
//  WashMe
//
//  Created by Almas Adilbek on 11/4/14.
//  Copyright (c) 2014 Almas Adilbek. All rights reserved.
//

#import "LangsViewController.h"
#import "UIViewController+Ext.h"
#import "IdTitleObject.h"
#import "SimpleCheckboxCell.h"
#import "Localization.h"

#import "Language.h"

@interface LangsViewController ()
@end

@implementation LangsViewController {
    UITableView *list;
    NSArray *langs;
}

-(id)init {
    self = [super init];
    if(self) {
        [self initVars];
    }
    return self;
}

-(void)initVars {
    langs = [Localization languages];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configUI];
    [self configAction];
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
    return langs.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    Language *carType = langs[(NSUInteger) indexPath.row];
    return [SimpleCheckboxCell cellHeight:carType.name];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"cell";
    SimpleCheckboxCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[SimpleCheckboxCell alloc] initWithReuseIdentifier:CellIdentifier];
    }

    Language *lang = langs[(NSUInteger) indexPath.row];
    [cell setTitle:lang.name];

    cell.isChecked = NO;
    if([[Localization currentLocale] isEqual:lang.locale]) {
        cell.isChecked = YES;
    }

    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    SimpleCheckboxCell *cell = (SimpleCheckboxCell *) [tableView cellForRowAtIndexPath:indexPath];
    cell.isChecked = !cell.isChecked;

    Language *lang = langs[(NSUInteger) indexPath.row];
    [Localization setLocale:lang.locale];

    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -

-(void)configUI
{
    [self setBlueBackground];
    [self setNavigationTitle:@"Настройки"];
    [self setBackButton];

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