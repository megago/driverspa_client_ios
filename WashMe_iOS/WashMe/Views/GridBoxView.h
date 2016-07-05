//
//  GridBoxView.h
//  WashMe
//
//  Created by Almas Adilbek on 10/8/14.
//  Copyright (c) 2014 Almas Adilbek. All rights reserved.
//

@protocol GridBoxViewDelegate;

@interface GridBoxView : UIView

@property(nonatomic, weak) id <GridBoxViewDelegate> delegate;
@property(nonatomic, assign, getter=isSelected) BOOL selected;

@property(nonatomic, strong) UILabel *timeLabel;

@property(nonatomic, assign) NSInteger hours;
@property(nonatomic, assign) NSInteger minutes;

- (id)initWithDimension:(CGFloat)dimension;
- (void)setHour:(NSInteger)hour minute:(NSInteger)minute;
- (void)setBusy;
- (void)setDisabled;

- (NSString *)time;

@end

@protocol GridBoxViewDelegate<NSObject>
-(void)gridBoxViewTapped:(GridBoxView *)gridBoxView;
@end
