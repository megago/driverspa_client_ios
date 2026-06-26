//
//  AdminCarwashesFeedbacksViewController.m
//  WashMe
//
//  Created by Almas Adilbek on 10/21/14.
//  Copyright (c) 2014 Almas Adilbek. All rights reserved.
//

#import "AdminCarwashesFeedbacksViewController.h"
#import "UIViewController+Ext.h"
#import "UIViewController+NavigationBar.h"
#import "UIViewController+NoContent.h"
#import "AdminApi.h"
#import "CarwashReview.h"
#import "FeedbackCell.h"

@interface AdminCarwashesFeedbacksViewController () {
    UITableView *list;
    NSMutableArray *reviews;
}
@end

@implementation AdminCarwashesFeedbacksViewController

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
    [self loadReviews];
}

- (void)loadReviews
{
    [Toast showHudLoading];
    [AdminApi myReviews:^(id response) {
        [self onReviewsResponse:response];
    } failure:^(NSInteger code, NSString *message) {
        
    }];
}

- (void)onReviewsResponse:(id)response
{
    reviews = response;
    [self removeNoContentMessageIfExists];
    
    if(reviews && reviews.count > 0) {
        [list reloadData];
        list.hidden = NO;
    } else {
        list.hidden = YES;
        [self showNoContentMessage:@"Нет отзывов" withButton:@"Обновить" selector:@selector(loadReviews)];
    }
}

#pragma mark -
#pragma mark UITableView

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return reviews.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CarwashReview *review = reviews[(NSUInteger) indexPath.row];
    return [FeedbackCell cellHeight:review];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"cell";
    FeedbackCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[FeedbackCell alloc] initWithReuseIdentifier:CellIdentifier];
    }
    
    CarwashReview *review = reviews[indexPath.row];
    [cell setFeedback:review];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    CarwashBook *book = books[indexPath.row];
//    AdminBookViewController *v = [[AdminBookViewController alloc] init];
//    v.delegate = self;
//    v.book = book;
//    [self.navigationController pushViewController:v animated:YES];
}


#pragma mark -
#pragma mark ConfigUI

-(void)configUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    [self setBlueBackground];
    [self setNavigationTitle:@"Отзывы"];
    [self showMenuButton];
    [self setNavigationBarTransparent];
    
    // List
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