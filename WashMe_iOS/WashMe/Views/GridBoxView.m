//
//  GridBoxView.m
//  WashMe
//
//  Created by Almas Adilbek on 10/8/14.
//  Copyright (c) 2014 Almas Adilbek. All rights reserved.
//

#import "GridBoxView.h"

@implementation GridBoxView {
    UIImageView *carView;
    UIButton *button;
    UIView *selectionView;
    UIView *disabledSelectionView;
}

-(id)initWithDimension:(CGFloat)dimension {
    self = [super initWithFrame:CGRectMake(0, 0, dimension, dimension)];
    if (self) {
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = self.bounds;
        [button addTarget:self action:@selector(tapped) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
    return self;
}

#pragma mark -
#pragma mark Methods

- (void)setHour:(NSInteger)hour minute:(NSInteger)minute
{
    self.hours = hour;
    self.minutes = minute;

    NSString *hourStr = [NSString stringWithFormat:@"%@%i", hour < 10?@"0":@"", hour];
    NSString *minuteStr = [NSString stringWithFormat:@"%@%i", minute < 10?@"0":@"", minute];

    self.userInteractionEnabled = YES;

    if(carView) {
        [carView removeFromSuperview];
        carView = nil;
    }

    if(!self.timeLabel) {
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeLabel.userInteractionEnabled = NO;
        _timeLabel.backgroundColor = [UIColor clearColor];
        _timeLabel.font = [UIFont robotoRegular:14];
        _timeLabel.textColor = [UIColor whiteColor];
        [self addSubview:_timeLabel];
    }
    _timeLabel.text = [NSString stringWithFormat:@"%@:%@", hourStr, minuteStr];
    [_timeLabel sizeToFit];
    _timeLabel.centerX = (CGFloat) (self.width * 0.5);
    _timeLabel.centerY = (CGFloat) (self.height * 0.5);
}


-(void)setBusy
{
    self.userInteractionEnabled = NO;
    
    if(_timeLabel) {
        [_timeLabel removeFromSuperview];
        _timeLabel = nil;
    }

    carView = [[UIImageView alloc] initWithImage:[UIImage imageWithName:@"icon-car"]];
    carView.centerX = (CGFloat) (self.width * 0.5);
    carView.centerY = (CGFloat) (self.height * 0.5);
    carView.alpha = 0.3;
    [self insertSubview:carView atIndex:0];
}

- (void)setDisabled {
    if(_timeLabel) {
        _timeLabel.alpha = 0.5;

        disabledSelectionView = [[UIView alloc] initWithFrame:self.bounds];
        disabledSelectionView.backgroundColor = [UIColor blackColor];
        disabledSelectionView.alpha = 0.25;
        [self addSubview:disabledSelectionView];

        button.userInteractionEnabled = NO;
    }
}


- (NSString *)time {
    if(_timeLabel) {
        return _timeLabel.text;
    }
    return nil;
}


- (void)setSelected:(BOOL)selected {
    _selected = selected;
    if(_selected)
    {
        if(!selectionView) {
            selectionView = [[UIView alloc] initWithFrame:self.bounds];
            [selectionView setBackgroundColor:[UIColor orangeColor]];
            selectionView.alpha = 0.0;
            [self insertSubview:selectionView atIndex:0];
        }

        [UIView animateWithDuration:0.2 animations:^{
            selectionView.alpha = 0.85;
        } completion:^(BOOL finished) {

        }];
    }
    else
    {
        if(selectionView) {
            [UIView animateWithDuration:0.2 animations:^{
                selectionView.alpha = 0;
            } completion:^(BOOL finished) {
                [selectionView removeFromSuperview];
                selectionView = nil;
            }];
        }
    }
}

#pragma mark -
#pragma mark ACtions

- (void)tapped
{
    if(!_selected) {
        self.selected = YES;
        [self.delegate gridBoxViewTapped:self];
    }
}

@end
