//
//  BoxesGridView.m
//  WashMe
//
//  Created by Almas Adilbek on 10/7/14.
//  Copyright (c) 2014 Almas Adilbek. All rights reserved.
//

#import "BoxesGridView.h"
#import "GridBoxView.h"
#import "NSDate+Ext.h"
#import "NSDate+Utilities.h"

@implementation BoxesGridView {
    UIImageView *borderView;
    GridBoxView *currentSelectedGridBoxView;
}

- (id)initWithTimeStatuses:(NSArray *)timeStatuses day:(CarwashBoxesTimeDay)currentDay
{
    CGFloat padding = 15;
    self = [super initWithFrame:CGRectMake(0, 0, [ASize screenWidth] - 2 * padding, 200)];
    if(self) {
        borderView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        borderView.image = [[UIImage imageWithName:@"border-button-pattern"] stretchableImageWithLeftCapWidth:15 topCapHeight:15];
        [self addSubview:borderView];
        
        NSMutableArray *newTimeStatuses = [[NSMutableArray alloc] init];
        int disableCount = 0;
        if (currentDay == CarwashBoxesTimeDayToday){
            NSCalendar *calendar = [NSCalendar currentCalendar];
            NSDateComponents *components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:[NSDate date]];
            NSInteger hour = [components hour];
            NSInteger minute = [components minute];
            
            disableCount = (int)hour * 2;
            if (minute < 29) disableCount++;
            if (minute > 30) disableCount = disableCount + 2;
            
            
            for (int i = disableCount; i < timeStatuses.count; i++){
                [newTimeStatuses addObject:timeStatuses[i]];
            }
        }
        
        NSInteger n = (currentDay == CarwashBoxesTimeDayToday) ? newTimeStatuses.count : timeStatuses.count;

        NSInteger cols = 5;
        CGFloat rowsFloat = (CGFloat)n / (CGFloat)cols;
        NSUInteger rows = (NSUInteger) ceil(rowsFloat);

        CGFloat dimension = self.width / cols;

        CGFloat bottomY = 0;
        NSUInteger j = 0;
        
        for(NSInteger i=0; i<n; ++i)
        {
            BOOL timeAvailable = (currentDay == CarwashBoxesTimeDayToday) ? [newTimeStatuses[i] boolValue] : [timeStatuses[i] boolValue];


            if(i > 0 && (i % cols) == 0) {
                ++j;
            }
            GridBoxView *box = [[GridBoxView alloc] initWithDimension:dimension];
            box.delegate = self;
            box.x = (i % cols) * dimension;
            box.y = (j % rows) * dimension;
            [self addSubview:box];

            if(timeAvailable) {
                NSInteger minutes = (currentDay == CarwashBoxesTimeDayToday) ? (disableCount * 30) + (i * 30) : i * 30;
                NSInteger hour = (NSInteger) floor((minutes / 60));
                NSInteger minute = minutes % 60;

                [box setHour:hour minute:minute];
            } else {
                [box setBusy];
            }

            bottomY = box.bottom > bottomY?box.bottom:bottomY;
        }

        borderView.height = bottomY;
        self.height = bottomY;

        // Lines
        for(NSUInteger i = 1; i<cols; ++i) {
            UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, borderView.height)];
            [line setBackgroundColor:[UIColor whiteColor]];
            line.x = i * dimension;
            line.alpha = 0.5;
            [self addSubview:line];
        }

        for(NSUInteger i = 1; i<rows; ++i) {
            UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, borderView.width, 1)];
            [line setBackgroundColor:[UIColor whiteColor]];
            line.y = i * dimension;
            line.alpha = 0.5;
            [self addSubview:line];
        }

    }
    return self;
}

#pragma mark -
#pragma mark Methods

- (void)setBookDate:(NSDate *)bookDate {
    _bookDate = bookDate;

    NSInteger hour = [bookDate hour];
    NSInteger minute = [bookDate minute];
    NSInteger minutesGone = hour * 60 + minute;

    // If today
    if([bookDate isToday])
    {
        // Set box disabled if time is gone
        for(id subview in self.subviews) {
            if([subview isKindOfClass:[GridBoxView class]]) {
                GridBoxView *gridBoxView = (GridBoxView *)subview;
                NSInteger boxMinutesGone = gridBoxView.hours * 60 + gridBoxView.minutes;
                if(boxMinutesGone <= minutesGone) {
                    [gridBoxView setDisabled];
                    //[gridBoxView removeFromSuperview];
                }
            }
        }
    }
    else if([bookDate isInPast])
    {
        // Set all boxes disabled
        for(id subview in self.subviews) {
            if([subview isKindOfClass:[GridBoxView class]]) {
                GridBoxView *gridBoxView = (GridBoxView *)subview;
                [gridBoxView setDisabled];
                //[gridBoxView removeFromSuperview];
            }
        }
    }
}

-(NSString *)bookDateString {
    if(_timeSelected) {
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"yyyy-MM-dd"];
        NSString *dateString = [NSString stringWithFormat:@"%@T%@:00%@", [df stringFromDate:self.bookDate], [currentSelectedGridBoxView time], [[NSDate date] timezone]];
        return dateString;
    }
    return nil;
}

- (void)setBookTime:(NSString *)bookTime
{
    for(id subview in self.subviews)
    {
        if([subview isKindOfClass:[GridBoxView class]])
        {
            GridBoxView *gridBoxView = (GridBoxView *)subview;

            if([[gridBoxView time] isEqual:bookTime])
            {
                self.timeSelected = YES;
                currentSelectedGridBoxView = gridBoxView;
                [gridBoxView setSelected:YES];
                break;
            }
        }
    }
}

- (NSString *)bookTime {
    if(_timeSelected) {
        return [currentSelectedGridBoxView time];
    }
    return @"";
}

#pragma mark -
#pragma mark Actions

-(void)gridBoxViewTapped:(GridBoxView *)gridBoxView {
    if(currentSelectedGridBoxView) {
        currentSelectedGridBoxView.selected = NO;
    }
    currentSelectedGridBoxView = gridBoxView;
    self.timeSelected = YES;

    [self.delegate boxesGridViewTimeSelected:self];
}

@end
