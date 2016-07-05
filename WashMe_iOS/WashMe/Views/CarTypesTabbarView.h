//
//  CarTypesTabbarView.h
//  WashMe
//
//  Created by Almas Adilbek on 10/5/14.
//  Copyright (c) 2014 Almas Adilbek. All rights reserved.
//

typedef NS_ENUM(NSInteger , CarType) {
    CarTypeSedan = 1,
    CarTypeSmallJeep = 2,
    CarTypeJeep = 3,
    CarTypeMinibus = 4
};

@protocol CarTypesTabbarViewDelegate
@optional
- (void)carTypesTabbarViewDidChangeTabWithType:(CarType)carType;
@end

@interface CarTypesTabbarView : UIView

@property(nonatomic, assign) CarType carType;
@property(nonatomic, weak) id <CarTypesTabbarViewDelegate> delegate;

- (id)initWithCarTypeIds:(NSArray *)carTypesIds;

@end
