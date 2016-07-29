//
//  BookChooseBoxViewController.m
//  WashMe
//
//  Created by Almas Adilbek on 10/6/14.
//  Copyright (c) 2014 Almas Adilbek. All rights reserved.
//

#import "BookChooseBoxViewController.h"
#import "UIViewController+Ext.h"
#import "UIScrollView+Ext.h"
#import "BoxesGridView.h"
#import "BookObject.h"
#import "CarwashComplex.h"
#import "AAButton+Styles.h"
#import "BookResultViewController.h"
#import "CarwashApi.h"
#import "BoxTimeTable.h"
#import "NSDate+Utilities.h"
#import "UserApi.h"

@interface BookChooseBoxViewController ()
@end

@implementation BookChooseBoxViewController {
    CarwashBoxesTimeDay currentTableDay;
    BoxesGridView *boxesGridView;
    AAButton *bookButton;
    AAButton *todayButton;
    AAButton *tomorrowButton;
}

-(id)init {
    self = [super init];
    if(self) {
        [self initVars];
    }
    return self;
}

-(void)initVars {
    currentTableDay = CarwashBoxesTimeDayToday;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configUI];

    if(self.editMode) {
        if([_bookObject.bookDate isTomorrow]) {
            [self selectTomorrowTab];
            currentTableDay = CarwashBoxesTimeDayTomorrow;
        }
    } else {
        _bookObject.bookDate = [NSDate date];
    }

    [self loadTable];
}

- (void)viewWillAppear:(BOOL)animated
{
    if(self.preview) {
        [self setNavigationTitle:@"Расписание"];
    } else {
        [self setNavigationTitle:@"Выберите время"];
    }
}

- (void)loadTable
{
    [Toast showHudWithTitle:@"Поиск свободных мест"];
    [CarwashApi timeTableWithCarwashId:_bookObject.carwash.carwashId day:currentTableDay success:^(id response) {
        [self onTimeTableLoaded:response];
    } failure:^(NSInteger code, NSString *message) {

    }];
}

- (void)onTimeTableLoaded:(id)response
{
    NSArray *responseArray = (NSArray *)response;
    NSMutableArray *timeStatuses = [NSMutableArray array];

    if(responseArray.count > 0)
    {
        BoxTimeTable *boxTimeTable = responseArray[0];
        for(NSInteger i=0; i<boxTimeTable.slots.count; i += 2) {
            [timeStatuses addObject:@NO];
        }

        for(BoxTimeTable *timeTable in responseArray)
        {
            NSArray *slots = timeTable.slots;
            NSUInteger index = 0;
            for(NSInteger i=0; i<slots.count; i += 2) {
                NSString *status1 = slots[i];
                NSString *status2 = slots[i + 1];
                if([status1 isEqual:kBoxTimeTableAvailableSign] && [status2 isEqual:kBoxTimeTableAvailableSign]) timeStatuses[index] = @YES;
                ++index;
            }
        }

        [self buildTableWithTimeStatuses:timeStatuses];
    }
    else {
        NSLog(@"No time table");
    }
}

- (void)buildTableWithTimeStatuses:(NSArray *)timeStatuses
{
    if(boxesGridView) {
        [boxesGridView removeFromSuperview];
        boxesGridView = nil;
    }

    if(bookButton) {
        [bookButton removeFromSuperview];
        bookButton = nil;
    }

    boxesGridView = [[BoxesGridView alloc] initWithTimeStatuses:timeStatuses];
    boxesGridView.delegate = self;
    boxesGridView.centerX = sv.centerX;
    boxesGridView.y = todayButton.bottom + 10;
    [sv addSubview:boxesGridView];

//    if(self.editMode) {
//
//        if(currentTableDay == CarwashBoxesTimeDayToday) {
//            if([_bookObject.bookDate isToday]) {
//                boxesGridView.bookDate = [NSDate date];
//                [boxesGridView setBookTime:_bookObject.bookTime];
//            }
//        } else {
//            if([_bookObject.bookDate isTomorrow]) {
//                boxesGridView.bookDate = [NSDate dateTomorrow];
//                [boxesGridView setBookTime:_bookObject.bookTime];
//            }
//        }
//    } else {
//        boxesGridView.bookDate = (currentTableDay == CarwashBoxesTimeDayToday ? [NSDate date] : [NSDate dateTomorrow]);
//    }
    if(currentTableDay == CarwashBoxesTimeDayToday)
    {
        boxesGridView.bookDate = [NSDate date];
        if([_bookObject.bookDate isToday]) {

            // If booktime isset
            if(_bookObject.bookTime) [boxesGridView setBookTime:_bookObject.bookTime];
        }
    }
    else
    {
        boxesGridView.bookDate = [NSDate dateTomorrow];
        if([_bookObject.bookDate isTomorrow]) {

            // If booktime isset
            if(_bookObject.bookTime) [boxesGridView setBookTime:_bookObject.bookTime];
        }
    }

    // Bron
    if(!self.preview)
    {
        __weak BookChooseBoxViewController *wSelf = self;
        bookButton = nil;
        if(!self.editMode) {
            bookButton = [[AAButton alloc] initWithWidth:200 onTap:^(UIView *_self) {
                [wSelf bookButtonTapped];
            }];
            [bookButton commonStyleButtonWithTitle:@"Бронировать"];
        } else {
            bookButton = [[AAButton alloc] initWithWidth:260 onTap:^(UIView *_self) {
                [wSelf editBookButtonTapped];
            }];
            [bookButton commonStyleButtonWithTitle:@"Обновить бронирование"];
        }

        [bookButton setTitleFont:[UIFont robotoRegular:18]];
        bookButton.centerX = self.view.centerX;
        bookButton.y = boxesGridView.bottom + 30;
        bookButton.height = 40;
        [sv addSubview:bookButton];

        [sv setContentSizeHeight:bookButton.bottom + 20];
    }
    else {
        [sv setContentSizeHeight:boxesGridView.bottom + 20];
        boxesGridView.userInteractionEnabled = NO;
    }
}

#pragma mark -
#pragma mark Actions

-(void)bookButtonTapped
{
    if([self validatePrepareBookAction])
    {
        [Toast showHudWithTitle:@"Бронирование"];
        [UserApi bookWithBookObject:_bookObject success:^(id response) {

            [self gotoResults:response];

        } failure:^(NSInteger code, NSString *message) {

        }];
    }
}

- (void)editBookButtonTapped
{
    if([self validatePrepareBookAction])
    {
        [Toast showHudWithTitle:@"Обновление"];
        [UserApi cancelBooking:_bookObject.bookId success:^(id response) {

            [Toast showHudWithTitle:@"Бронирования"];
            [UserApi bookWithBookObject:_bookObject success:^(id response) {
                [self gotoResults:response];
            } failure:^(NSInteger code, NSString *message) {
                [UIHelper showAlertTryAgain];
            }];

        } failure:^(NSInteger code, NSString *message) {
            [UIHelper showAlertTryAgain];
        }];
    }
}

- (void)todayTapped {
    if(currentTableDay != CarwashBoxesTimeDayToday) {
        currentTableDay = CarwashBoxesTimeDayToday;
        [self selectTodayTab];
        [self loadTable];
    }
}

- (void)tomorrowTapped {
    if(currentTableDay != CarwashBoxesTimeDayTomorrow) {
        currentTableDay = CarwashBoxesTimeDayTomorrow;
        [self selectTomorrowTab];
        [self loadTable];
    }
}

#pragma mark -
#pragma mark Actions Helper

- (BOOL)validatePrepareBookAction
{
    if(!boxesGridView.isTimeSelected) {
        [UIHelper showAlertWithMessage:@"Выберите время посещения мойки"];
        return NO;
    }

    // Set book date and time
    _bookObject.time = [boxesGridView bookDateString];
    return YES;
}

- (void)gotoResults:(id)response
{
    BookResultViewController *v = [[BookResultViewController alloc] init];
    v.carwashBook = response;
    v.bookObject = self.bookObject;
    [self.navigationController pushViewController:v animated:YES];
}

#pragma mark -
#pragma mark BoxesGridView

- (void)boxesGridViewTimeSelected:(BoxesGridView *)gridView {
    _bookObject.bookDate = gridView.bookDate;
    _bookObject.bookTime = [gridView bookTime];
}

#pragma mark -

- (void)selectTodayTab {
    todayButton.alpha = 1;
    tomorrowButton.alpha = 0.5;
}

- (void)selectTomorrowTab {
    tomorrowButton.alpha = 1;
    todayButton.alpha = 0.5;
}

-(void)configUI
{
    [super configUI];
    [self setBlueBackground];
    [self setBackButtonInNavigation];

    UILabel *subtitle = [sv setNavigationSubtitle:_bookObject.carwash.name];
    subtitle.y = 10;

    CGFloat buttonWidth = (CGFloat) ([ASize screenWidth] * 0.5);
    __weak BookChooseBoxViewController *wSelf = self;
    UIFont *font = [UIFont robotoCondensedLight:16];

    todayButton = [[AAButton alloc] initWithWidth:buttonWidth onTap:^(UIView *_self) {
        [wSelf todayTapped];
    }];
    todayButton.height = 30;
    [todayButton noBorderStyleButtonWithTitle:@"Сегодня"];
    [todayButton setTitleFont:font];
    [todayButton.button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    todayButton.y = subtitle.bottom + 7;
    [sv addSubview:todayButton];

    tomorrowButton = [[AAButton alloc] initWithWidth:buttonWidth onTap:^(UIView *_self) {
        [wSelf tomorrowTapped];
    }];
    tomorrowButton.height = todayButton.height;
    [tomorrowButton noBorderStyleButtonWithTitle:@"Завтра"];
    [tomorrowButton setTitleFont:font];
    [tomorrowButton.button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    tomorrowButton.x = todayButton.right;
    tomorrowButton.y = todayButton.y;
    tomorrowButton.alpha = 0.5;
    [sv addSubview:tomorrowButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc {

}

@end