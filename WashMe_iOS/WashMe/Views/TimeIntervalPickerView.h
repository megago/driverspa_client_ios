//
//  TimeIntervalPickerView.h
//  WashMe
//
//  Created by Almas Adilbek on 10/26/14.
//  Copyright (c) 2014 Almas Adilbek. All rights reserved.
//

@protocol TimeIntervalPickerViewDelegate;

@interface TimeIntervalPickerView : UIView

@property(nonatomic, weak) id <TimeIntervalPickerViewDelegate> delegate;
@property(nonatomic, copy) NSString *timesSeparator;

- (void)setTitle:(NSString *)title left:(BOOL)left;
- (void)setDatePickerDate:(NSDate *)date left:(BOOL)left;

- (void)updateDatePickerDatesFromTextFieldText:(NSString *)text;

- (void)show;
- (void)hide;

+ (NSString *)timesSeparator;

@end

@protocol TimeIntervalPickerViewDelegate<NSObject>
- (void)timeIntervalPickerViewDidChange:(NSString *)timeIntervalString;
@end
