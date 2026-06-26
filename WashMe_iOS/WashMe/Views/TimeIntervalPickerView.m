//
//  TimeIntervalPickerView.m
//  WashMe
//
//  Created by Almas Adilbek on 10/26/14.
//  Copyright (c) 2014 Almas Adilbek. All rights reserved.
//

#import "TimeIntervalPickerView.h"

@implementation TimeIntervalPickerView {
    UIDatePicker *datePicker1;
    UIDatePicker *datePicker2;
    UIView *fader;
    UIView *verticalSeparatorLine;
}

-(id)init
{
    CGSize screenSize = [UIScreen mainScreen].bounds.size;

    self = [super initWithFrame:CGRectMake(0, 0, screenSize.width, 1)];
    if(self) {

        self.backgroundColor = [UIColor whiteColor];
        self.timesSeparator = [TimeIntervalPickerView timesSeparator];

        // Date pickers
        datePicker1 = [[UIDatePicker alloc] init];
        datePicker1.width = (CGFloat) (self.width * 0.5);
        datePicker1.datePickerMode = UIDatePickerModeTime;
        [datePicker1 addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"da_DK"];
        [datePicker1 setLocale:locale];

        datePicker2 = [[UIDatePicker alloc] init];
        datePicker2.width = (CGFloat) (self.width * 0.5);
        datePicker2.x = datePicker1.right;
        datePicker2.datePickerMode = UIDatePickerModeTime;
        [datePicker2 addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
        [datePicker2 setLocale:locale];

        [self addSubview:datePicker1];
        [self addSubview:datePicker2];

        verticalSeparatorLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0.5, datePicker1.height - 20)];
        verticalSeparatorLine.centerY = datePicker1.middleY;
        verticalSeparatorLine.centerX = self.middleX;
        [verticalSeparatorLine setBackgroundColor:[UIColor fromRGB:0xeeeeee]];
        [self addSubview:verticalSeparatorLine];

        self.height = datePicker1.height;
        self.y = screenSize.height;

    }
    return self;
}

- (void)setTitle:(NSString *)title left:(BOOL)left
{
    CGFloat topPadding = 10;
    CGFloat sidePadding = kViewControllerPadding;

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont robotoRegular:14];
    titleLabel.textColor = [UIColor grayColor];
    titleLabel.text = title;
    [titleLabel sizeToFit];
    titleLabel.x = left ? sidePadding : self.middleX + sidePadding;
    titleLabel.y = topPadding;
    [self addSubview:titleLabel];

    datePicker1.y = datePicker2.y = titleLabel.bottom + topPadding;
    self.height = datePicker1.bottom;

    verticalSeparatorLine.height = self.height - 20;
    verticalSeparatorLine.centerY = self.middleY;
}

- (void)show
{
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    CGSize size = [UIScreen mainScreen].bounds.size;

    fader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    fader.alpha = 0.0;
    fader.backgroundColor = [UIColor blackColor];
    [window addSubview:fader];

    [window addSubview:self];

    UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(faderTapped)];
    [fader addGestureRecognizer:ges];

    [UIView animateWithDuration:0.25 animations:^{
        fader.alpha = 0.15;
        self.y = size.height - self.height;
    } completion:^(BOOL finished) {
    }];
}

- (void)hide
{
    CGSize size = [UIScreen mainScreen].bounds.size;

    [UIView animateWithDuration:0.25 animations:^{
        fader.alpha = 0.0;
        self.y = size.height;
    } completion:^(BOOL finished) {
        [fader removeFromSuperview];
        [self removeFromSuperview];
    }];
}

+ (NSString *)timesSeparator {
    return @" - ";
}


- (void)setDatePickerDate:(NSDate *)date left:(BOOL)left
{
    if(left) datePicker1.date = date;
    else datePicker2.date = date;
}

- (void)updateDatePickerDatesFromTextFieldText:(NSString *)text
{
    NSString *timeString = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSArray *times = [timeString componentsSeparatedByString:@" - "];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"HH:mm"];

    if(times.count < 2) return;

    NSDate *date1 = [df dateFromString:times[0]];
    NSDate *date2 = [df dateFromString:times[1]];

    if(!date1 || !date2) return;

    [self setDatePickerDate:date1 left:YES];
    [self setDatePickerDate:date2 left:NO];
}


#pragma mark -
#pragma mark Actions

- (void)datePickerValueChanged:(UIDatePicker *)datePicker
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"HH:mm"];

    [self.delegate timeIntervalPickerViewDidChange:[NSString stringWithFormat:@"%@ - %@", [df stringFromDate:[datePicker1 date]], [df stringFromDate:[datePicker2 date]]]];
}

- (void)faderTapped {
    [self hide];
}

@end
