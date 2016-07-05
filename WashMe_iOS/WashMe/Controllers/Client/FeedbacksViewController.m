//
// Created by Almas Adilbek on 9/27/14.
// Copyright (c) 2014 Almas Adilbek. All rights reserved.
//

#import "FeedbacksViewController.h"
#import "UIViewController+Ext.h"
#import "FeedbackCell.h"
#import "Carwash.h"
#import "CarwashComplex.h"
#import "CarwashApi.h"
#import "UIViewController+NoContent.h"


@interface FeedbacksViewController ()
@end

@implementation FeedbacksViewController {
    UITableView *list;
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

    if(_carwash.reviews.count == 0) {
        list.hidden = YES;
        [self showNoContentMessage:@"Пока нет отзывов"];
    }
}

- (void)configAction
{

}

#pragma mark -
#pragma mark Actions

- (void)addTapped
{
    AddFeedbackViewController *v = [[AddFeedbackViewController alloc] init];
    v.delegate = self;
    v.carwash = self.carwash;
    [self.navigationController pushViewController:v animated:YES];
}

#pragma mark -
#pragma mark AddFeedbackViewController

-(void)addFeedbackViewControllerFeedbackSent
{
    [Toast showHudLoading];
    [CarwashApi getCarwashDetails:_carwash.carwashId success:^(id response) {

        [self removeNoContentMessageIfExists];

        _carwash = response;
        [list reloadData];
        list.hidden = NO;

        [self.delegate feedbacksViewControllerCarwashFeedbacksUpdated:_carwash];
    } failure:^(NSInteger code, NSString *message) {

    }];
}

#pragma mark -
#pragma mark UITableView

-(int)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _carwash.reviews.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [FeedbackCell cellHeight:_carwash.reviews[(NSUInteger) indexPath.row]];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 35;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView * header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [ASize screenWidth], 35)];
    header.backgroundColor = [UIColor fromRGB:0x0058A6];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, (CGFloat) (header.width * 0.8), 1)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont robotoRegular:14];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = self.carwash.name;
    [titleLabel sizeToFit];
    titleLabel.center = header.center;
    [header addSubview:titleLabel];
    return header;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"cell";
    FeedbackCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[FeedbackCell alloc] initWithReuseIdentifier:CellIdentifier];
    }
    [cell setFeedback:_carwash.reviews[(NSUInteger) indexPath.row]];

    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

#pragma mark -

-(void)configUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    [self setBlueBackground];
    [self setBackButton];
    [self setNavigationTitle:@"Отзывы"];

    [self createBarButtonAtLeft:NO buttonImage:@"icon-add-outline" target:self selector:@selector(addTapped)];

    list = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, [ASize screenWidth], [ASize screenHeightWithoutStatusBarAndNavigationBar]-44) style:UITableViewStylePlain];
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