//
//  AdminCarwashBoxScheduleViewController.m
//  WashMe
//
//  Created by Almas Adilbek on 3/28/15.
//  Copyright (c) 2015 Almas Adilbek. All rights reserved.
//

#import "AdminCarwashBoxScheduleViewController.h"
#import "UIViewController+Ext.h"
#import "CarwashApi.h"
#import "AAButton+Styles.h"
#import "BoxTimeTable.h"
#import "BoxSetting.h"

@interface AdminCarwashBoxScheduleViewController ()
@end

@implementation AdminCarwashBoxScheduleViewController {
    BoxesGridView *boxesGridView;
    AAButton *todayButton;
    AAButton *tomorrowButton;
    CarwashBoxesTimeDay currentTableDay;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configUI];

    currentTableDay = CarwashBoxesTimeDayToday;
    [self loadCarwashTimetable];
}

- (void)loadCarwashTimetable
{
    [Toast showHudWithTitle:@"Загрузка таблицы"];
    [CarwashApi timeTableWithCarwashId:self.carwashId day:currentTableDay success:^(id response) {
        [self onTimeTableLoaded:response];
    } failure:^(NSInteger code, NSString *message) {

    }];
}

- (void)onTimeTableLoaded:(id)response
{
    if(boxesGridView) {
        [boxesGridView removeFromSuperview];
    }

    NSArray *responseArray = (NSArray *)response;

    if(responseArray.count > 0)
    {
        for(BoxTimeTable *boxTimeTable in responseArray)
        {
            // If it is the selected box
            if([boxTimeTable.uid isEqual:self.boxSetting.uid])
            {
                NSMutableArray *timeStatuses = [[NSMutableArray alloc] init];

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
                break;
            }
        }
    }
}

- (void)buildTableWithTimeStatuses:(NSArray *)timeStatuses
{
    boxesGridView = [[BoxesGridView alloc] initWithTimeStatuses:timeStatuses];
    boxesGridView.delegate = self;
    boxesGridView.userInteractionEnabled = NO;
    boxesGridView.y = todayButton.bottom + 15;
    boxesGridView.centerX = self.view.middleX;
    [sv addSubview:boxesGridView];

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

#pragma mark -
#pragma mark BoxGrid

- (void)boxesGridViewTimeSelected:(BoxesGridView *)gridView
{

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
    [self setNavigationTitle:[NSString stringWithFormat:@"Бокс #%li", (long)self.boxIndex]];
    [self setBackButtonInNavigation];

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
    todayButton.y = 5;
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc {

}

@end