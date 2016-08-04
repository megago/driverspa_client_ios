//
//  SearchViewController.m
//  WashMe
//
//  Created by Almas Adilbek on 12/28/14.
//  Copyright (c) 2014 Almas Adilbek. All rights reserved.
//

#import "SearchViewController.h"
#import "UIViewController+Ext.h"
#import "Carwash.h"
#import "CarwashCell.h"
#import "InputTextField.h"
#import "NSString+Ext.h"
#import "CarwashApi.h"
#import "CarwashesHelper.h"
#import "AppDelegate.h"
#import "UIViewController+NoContent.h"

#define kSearchKeywordKey @"searchNavigationKeyword"

@interface SearchViewController ()
@end

@implementation SearchViewController {
    UITableView *list;
    NSArray *carwashes;
    InputTextField *searchField;
    BOOL viewDidLoaded;
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

    // Set keyword if saved before.
//    NSString *savedKeyword = [[NSUserDefaults standardUserDefaults] valueForKey:kSearchKeywordKey];
//    if(savedKeyword) {
//        searchField.textField.text = savedKeyword;
//    }

    [self showNoContentMessage:@"Введите текст для поиска по названию автомоек"];
}

- (void)viewDidAppear:(BOOL)animated {
    if(!viewDidLoaded) {
        viewDidLoaded = YES;
        [searchField focus];
    }
}

#pragma mark -
#pragma mark Actions

- (void)backButtonTapped {
    [searchField blur];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)search:(NSString *)keyword
{
    [searchField blur];

    [Toast showHudWithTitle:@"Поиск"];
    [CarwashApi searchCarwashes:keyword success:^(id response) {

        [self removeNoContentMessageIfExists];
        carwashes = [CarwashesHelper sortCarwashesByDistance:response];
        [list reloadData];

        if(carwashes.count == 0) {
            [self showNoContentMessage:[NSString stringWithFormat:@"Нет моек по названию\n\"%@\"", keyword]];
        }

    } failure:^(NSInteger code, NSString *message) {

    }];
}

#pragma mark -
#pragma mark UITableView

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return carwashes.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    Carwash *carwash = carwashes[(NSUInteger) indexPath.row];
    return [CarwashCell cellHeightWithCarwashName:carwash.name andAddress:carwash.address];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"cell";
    CarwashCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[CarwashCell alloc] initWithReuseIdentifier:CellIdentifier];
    }
    [cell setCarwash:carwashes[(NSUInteger) indexPath.row]];

    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [searchField blur];

    CarwashViewController *v = [[CarwashViewController alloc] init];
    v.carwash = carwashes[(NSUInteger) indexPath.row];
    [self.navigationController pushViewController:v animated:YES];
}

#pragma mark -
#pragma mark TextField

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSString *keyword = [textField.text trim];
    if(keyword.length > 0)
    {
        [self saveKeyword];
        [self search:keyword];
    }

    return YES;
}

#pragma mark -
#pragma mark ScrollView

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [searchField blur];
}

#pragma mark -
#pragma mark Helper

- (void)saveKeyword {
    // Save keyword
    [[NSUserDefaults standardUserDefaults] setValue:[searchField.textField.text trim] forKey:kSearchKeywordKey];
}

#pragma mark -

-(void)configUI
{
    [self setBlueBackground];
//    [self setBackButton];
    [self setNavigationTitle:@"Поиск"];

    CGFloat barHeight = 55;
    UIView *searchNavigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [ASize screenWidth], barHeight + 20)];
    searchNavigationView.backgroundColor = [UIColor fromRGB:0x26558D];
    [self.view addSubview:searchNavigationView];

    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton addTarget:self action:@selector(backButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    UIImage *backButtonImage = [UIImage imageNamed:@"icon-arrow-back.png"];
    [backButton setImage:backButtonImage forState:UIControlStateNormal];
    backButton.showsTouchWhenHighlighted = YES;
    backButton.width = backButtonImage.size.width;
    backButton.height = backButtonImage.size.height;
    backButton.x = 10;
    backButton.y = (CGFloat) (searchNavigationView.height - backButton.height - (barHeight - backButton.height) * 0.5);
    [searchNavigationView addSubview:backButton];

    CGFloat paddingLeft = 15;
    searchField = [[InputTextField alloc] initWithWidth:(searchNavigationView.width - backButton.right - 2 * paddingLeft) height:30];
    [searchField.textField setFont:[UIFont robotoRegular:16]];
    searchField.textField.delegate = self;
    searchField.x = backButton.right + paddingLeft;
    searchField.y = (CGFloat) (searchNavigationView.height - searchField.height - (barHeight - searchField.height) * 0.5);
    [searchField.textField setKeyboardAppearance:UIKeyboardAppearanceAlert];
    [searchField.textField setReturnKeyType:UIReturnKeySearch];
    [searchField setPlaceholder:@"Поиск автомоек"];
    [searchNavigationView addSubview:searchField];

    // List
    list = [[UITableView alloc] initWithFrame:CGRectMake(0, searchNavigationView.bottom, [ASize screenWidth], [ASize screenHeight] - searchNavigationView.height-44) style:UITableViewStylePlain];
    list.delegate = self;
    list.dataSource = self;
    list.backgroundView = [[UIView alloc] init];
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