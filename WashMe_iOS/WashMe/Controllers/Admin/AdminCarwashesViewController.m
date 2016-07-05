//
//  AdminCarwashesViewController.m
//  WashMe
//
//  Created by Almas Adilbek on 10/15/14.
//  Copyright (c) 2014 Almas Adilbek. All rights reserved.
//

#import "AdminCarwashesViewController.h"
#import "UIViewController+Ext.h"
#import "SimpleCell.h"
#import "AAButton.h"
#import "AAButton+Styles.h"
#import "AdminCarwashViewController.h"
#import "AdminApi.h"
#import "SimpleDisclosureCell.h"
#import "Carwash.h"
#import "CarwashComplex.h"
#import "UIViewController+NoContent.h"

@interface AdminCarwashesViewController ()
@end

@implementation AdminCarwashesViewController {
    UITableView *list;
    UIView *noContentMessageView;
    NSMutableArray *carwashes;
    UIView *footerView;
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

    [self loadCarwashes];
}

- (void)loadCarwashes
{
    [Toast showHudLoading];
    [AdminApi myCarwashes:^(id response) {
        [self onCarwashesLoaded:response];
    } failure:^(NSInteger code, NSString *message) {

    }];
}

- (void)onCarwashesLoaded:(id)response
{
    carwashes = response;
    if(carwashes.count == 0) {
        __weak AdminCarwashesViewController *wSelf = self;
        [self showNoContentMessage:@"У Вас нет автомоек" withButton:@"Добавить мойку" selector:@selector(addButtonTapped)];

    } else {
        [self removeNoContentMessageIfExists];
        list.hidden = NO;
        [list reloadData];
    }
}

#pragma mark -
#pragma mark Actions

- (void)addButtonTapped
{
    AdminCarwashViewController *v = [[AdminCarwashViewController alloc] init];
    v.delegate = self;
    [self.navigationController pushViewController:v animated:YES];
}

#pragma mark -
#pragma mark AdminCarwashViewController

- (void)adminCarwashViewControllerCarwashCreated:(CarwashComplex *)createdCarwash {
    [carwashes addObject:createdCarwash];
    [list reloadData];
}

- (void)adminCarwashViewControllerCarwashUpdated:(CarwashComplex *)updatedCarwash
{
    for(NSInteger i = 0; i<carwashes.count; ++i) {
        Carwash *carwash = carwashes[i];
        if([carwash.carwashId isEqual:updatedCarwash.carwashId]) {
            carwashes[i] = updatedCarwash;
            [list reloadData];
            break;
        }
    }
}

#pragma mark -
#pragma mark UITableView

-(int)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return carwashes.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    Carwash *carwash = carwashes[(NSUInteger) indexPath.row];
    return [SimpleDisclosureCell cellHeight:carwash.name];
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return [self footerButtonView].height;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [self footerButtonView];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"cell";
    SimpleDisclosureCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[SimpleDisclosureCell alloc] initWithReuseIdentifier:CellIdentifier];
    }

    Carwash *carwash = carwashes[(NSUInteger) indexPath.row];
    [cell setTitle:carwash.name];

    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    AdminCarwashViewController *v = [[AdminCarwashViewController alloc] init];
    v.delegate = self;
    Carwash *carwash = carwashes[(NSUInteger) indexPath.row];
    v.carwash = carwash;
    [self.navigationController pushViewController:v animated:YES];
}

#pragma mark -
#pragma mark Helper

-(UIView *)footerButtonView
{
    return nil;
//    if(!footerView) {
//        footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [ASize screenWidth], 70)];
//        footerView.hidden = YES;
//
//        __weak AdminCarwashesViewController *wSelf = self;
//        AAButton *addButton = [[AAButton alloc] initWithWidth:kButtonWidth onTap:^(UIView *_self) {
//            [wSelf addButtonTapped];
//        }];
//        [addButton commonStyleButtonWithTitle:@"Добавить мойку"];
//        [addButton setTitleFont:[UIFont robotoRegular:18]];
//        addButton.centerX = footerView.centerX;
//        addButton.y = footerView.bottom - addButton.height;
//        addButton.height = 40;
//        [footerView addSubview:addButton];
//    }
//
//    return footerView;
}

#pragma mark -

-(void)configUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    [self setBlueBackground];
    [self setNavigationTitle:@"Мои мойки"];

    CGFloat listY = 64;
    list = [[UITableView alloc] initWithFrame:CGRectMake(0, listY, [ASize screenWidth], [ASize screenHeight] - listY - 44) style:UITableViewStylePlain];
    list.delegate = self;
    list.dataSource = self;
    list.backgroundView = [[UIView alloc] init];
    list.backgroundColor = [UIColor clearColor];
    list.separatorColor = [UIColor clearColor];
    list.hidden = YES;
    [self.view addSubview:list];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc {
    
}

@end