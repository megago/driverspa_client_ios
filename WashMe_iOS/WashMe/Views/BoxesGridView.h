//
//  BoxesGridView.h
//  WashMe
//
//  Created by Almas Adilbek on 10/7/14.
//  Copyright (c) 2014 Almas Adilbek. All rights reserved.
//


#import "GridBoxView.h"

@class BoxesGridView;

@protocol BoxesGridViewDelegate
- (void)boxesGridViewTimeSelected:(BoxesGridView *)gridView;
@end

@interface BoxesGridView : UIView <GridBoxViewDelegate>

@property(nonatomic, weak) id <BoxesGridViewDelegate> delegate;
@property(nonatomic, copy) NSDate *bookDate;
@property(nonatomic, assign, getter=isTimeSelected) BOOL timeSelected;
@property(nonatomic, copy, readonly) NSString *bookDateString;

-(id)initWithTimeStatuses:(NSArray *)timeStatuses;

-(NSString *)bookTime;
-(void)setBookTime:(NSString *)bookTime;

@end
