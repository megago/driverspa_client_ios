//
//  AdminCarwashBoxScheduleViewController.m
//  WashMe
//
//  Created by Almas Adilbek on 3/28/15.
//  Copyright (c) 2015 Almas Adilbek. All rights reserved.
//

#import "AdminCarwashBoxScheduleViewController.h"
#import "UIViewController+Ext.h"
#import "UIViewController+NavigationBar.h"
#import "CarwashApi.h"
#import "AAButton+Styles.h"
#import "BoxTimeTable.h"
#import "BoxSetting.h"
#import "BookObject.h"
#import "HMSegmentedControl.h"
#import "ASize.h"
#import "CarwashComplex.h"
#import "AdminBookSetCarViewController.h"
#import "NSDate+Utilities.h"

@interface AdminCarwashBoxScheduleViewController ()
@end

@implementation AdminCarwashBoxScheduleViewController {
    BoxesGridView *boxesGridView;
    AAButton *bookButton;
    AAButton *todayButton;
    AAButton *tomorrowButton;
    HMSegmentedControl *segmentedControl;
    CarwashBoxesTimeDay currentTableDay;
    
    NSArray *boxes;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.bookObject = [[BookObject alloc] init];
    
    currentTableDay = CarwashBoxesTimeDayToday;
    self.currentCarwash = [CarwashComplex cashedCarwash];
    self.currentCarwash.boxSettings > 0 ? self.currentBox = self.currentCarwash.boxSettings.firstObject : nil;
    
    NSMutableArray *titles = [NSMutableArray new];
    for (BoxSetting *box in self.currentCarwash.boxSettings) {
        [titles addObject:box.boxName];
    }
    boxes = [NSArray arrayWithArray:titles];
    
    [self configUI];
    [self loadCarwashTimetable];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setTabBarVisible:YES animated:YES completion:nil];
    [self loadCarwashTimetable];
}

- (void)loadCarwashTimetable
{
    [Toast showHudWithTitle:@"Загрузка таблицы"];
    [CarwashApi timeTableWithCarwashId:self.currentCarwash.carwashId day:currentTableDay success:^(id response) {
        [self onTimeTableLoaded:response];
    } failure:^(NSInteger code, NSString *message) {

    }];
}

- (void)onTimeTableLoaded:(id)response
{
    if(boxesGridView) {
        [boxesGridView removeFromSuperview];
    }
    
    if (bookButton) {
        [bookButton removeFromSuperview];
    }

    NSArray *responseArray = (NSArray *)response;

    if(responseArray.count > 0)
    {
        for(BoxTimeTable *boxTimeTable in responseArray)
        {
            // If it is the selected box
            if([boxTimeTable.uid isEqual:self.currentBox.uid])
            {
                NSMutableArray *timeStatuses = [[NSMutableArray alloc] init];

                for(NSInteger i=0; i<boxTimeTable.slots.count; i += 2) {
                    [timeStatuses addObject:@NO];
                }

                //for(BoxTimeTable *timeTable in responseArray)
                //{
                    NSArray *slots = boxTimeTable.slots;
                    NSUInteger index = 0;
                    for(NSInteger i=0; i<slots.count; i += 2) {
                        NSString *status1 = slots[i];
                        NSString *status2 = slots[i + 1];
                        if([status1 isEqual:kBoxTimeTableAvailableSign] && [status2 isEqual:kBoxTimeTableAvailableSign]) timeStatuses[index] = @YES;
                        ++index;
                    }
                //}

                [self buildTableWithTimeStatuses:timeStatuses];
                break;
            }
        }
    }
}

- (void)buildTableWithTimeStatuses:(NSArray *)timeStatuses
{
    boxesGridView = [[BoxesGridView alloc] initWithTimeStatuses:timeStatuses day:currentTableDay];
    boxesGridView.delegate = self;
    boxesGridView.userInteractionEnabled = YES;
    boxesGridView.y = segmentedControl.bottom + 15;
    boxesGridView.centerX = self.view.middleX;
    [sv addSubview:boxesGridView];
    
    if(currentTableDay == CarwashBoxesTimeDayToday)
    {
        boxesGridView.bookDate = [NSDate date];
    }
    else
    {
        boxesGridView.bookDate = [NSDate dateTomorrow];
    }
    
//    __weak AdminCarwashBoxScheduleViewController *wSelf = self;
//    bookButton = [[AAButton alloc] initWithWidth:200 onTap:^(UIView *_self) {
//        [wSelf bookButtonTapped];
//    }];
//    [bookButton commonStyleButtonWithTitle:@"БРОНИРОВАТЬ"];
//    
//    [bookButton setTitleFont:[UIFont robotoRegular:18]];
//    bookButton.centerX = self.view.centerX;
//    bookButton.y = boxesGridView.bottom + 10;
//    bookButton.height = 40;
//    [sv addSubview:bookButton];
//
//    [sv setContentSizeHeight:bookButton.bottom + 20];
    [sv setContentSizeHeight:boxesGridView.bottom + 20];
}

#pragma mark -
#pragma mark Actions

- (void)todayTapped {
    if(currentTableDay != CarwashBoxesTimeDayToday) {
        currentTableDay = CarwashBoxesTimeDayToday;
        [self selectTodayTab];
        [self loadCarwashTimetable];
    }
}

- (void)tomorrowTapped {
    if(currentTableDay != CarwashBoxesTimeDayTomorrow) {
        currentTableDay = CarwashBoxesTimeDayTomorrow;
        [self selectTomorrowTab];
        [self loadCarwashTimetable];
    }
}


-(void)bookButtonTapped
{
    __weak AdminCarwashBoxScheduleViewController * weakSelf = self;
    [self setTabBarVisible:NO animated:YES completion:^(BOOL finished) {
        if([weakSelf validatePrepareBookAction])
        {
            AdminBookSetCarViewController *v = [[AdminBookSetCarViewController alloc] init];
            v.carwash = weakSelf.currentCarwash;
            v.bookObject = weakSelf.bookObject;
            v.boxSetting = weakSelf.currentBox;
            [weakSelf.navigationController pushViewController:v animated:YES];
        }
    }];
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

#pragma mark -
#pragma mark BoxGrid

- (void)boxesGridViewTimeSelected:(BoxesGridView *)gridView
{
    _bookObject.bookDate = gridView.bookDate;
    _bookObject.bookTime = [gridView bookTime];
    
    __weak AdminCarwashBoxScheduleViewController * weakSelf = self;
    [self setTabBarVisible:NO animated:YES completion:^(BOOL finished) {
        if([weakSelf validatePrepareBookAction])
        {
            AdminBookSetCarViewController *v = [[AdminBookSetCarViewController alloc] init];
            v.carwash = weakSelf.currentCarwash;
            v.bookObject = weakSelf.bookObject;
            v.boxSetting = weakSelf.currentBox;
            [weakSelf.navigationController pushViewController:v animated:YES];
        }
    }];
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
    [self setNavigationTitle:@"Таблица броней"];
    [self showMenuButton];
    [self setNavigationBarTransparent];
    [sv setFrame:CGRectMake(0, 64, [ASize screenWidth], [ASize screenHeightWithoutStatusBarAndNavigationBarAndTabBar])];
    
    CGFloat buttonWidth = (CGFloat) ([ASize screenWidth] * 0.5);
    __weak AdminCarwashBoxScheduleViewController * weakSelf = self;
    UIFont *font = [UIFont robotoCondensedLight:16];

    todayButton = [[AAButton alloc] initWithWidth:buttonWidth onTap:^(UIView *_self) {
        [weakSelf todayTapped];
    }];
    todayButton.height = 30;
    [todayButton noBorderStyleButtonWithTitle:@"Сегодня"];
    [todayButton setTitleFont:font];
    [todayButton.button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    todayButton.y = 5.f;
    [sv addSubview:todayButton];

    tomorrowButton = [[AAButton alloc] initWithWidth:buttonWidth onTap:^(UIView *_self) {
        [weakSelf tomorrowTapped];
    }];
    tomorrowButton.height = todayButton.height;
    [tomorrowButton noBorderStyleButtonWithTitle:@"Завтра"];
    [tomorrowButton setTitleFont:font];
    [tomorrowButton.button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    tomorrowButton.x = todayButton.right;
    tomorrowButton.y = todayButton.y;
    tomorrowButton.alpha = 0.5;
    [sv addSubview:tomorrowButton];
    
    segmentedControl = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(0, todayButton.bottom, [ASize screenWidth], 30)];
    if (boxes.count>0) segmentedControl.sectionTitles = boxes;
    segmentedControl.selectedSegmentIndex = 0;
    segmentedControl.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.25];
    segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor colorWithWhite:1.f alpha:0.25f], NSFontAttributeName: [UIFont robotoBold:14.f]};
    segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    segmentedControl.selectionIndicatorColor = [UIColor whiteColor];
    segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
    segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    segmentedControl.selectionIndicatorHeight = 2.f;
    segmentedControl.segmentEdgeInset = UIEdgeInsetsMake(0, 20, 0, 20);
    [segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    [sv addSubview:segmentedControl];

}

- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    if (boxes.count > 0){
        self.currentBox = self.currentCarwash.boxSettings[segmentedControl.selectedSegmentIndex];
        [self loadCarwashTimetable];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc {

}

@end
