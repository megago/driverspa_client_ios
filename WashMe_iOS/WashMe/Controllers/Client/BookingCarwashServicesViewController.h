//
//  BookingCarwashServicesViewController.h
//  WashMe
//
//  Created by Almas Adilbek on 10/5/14.
//  Copyright (c) 2014 Almas Adilbek. All rights reserved.
//


@protocol WashParamsViewControllerDelegate;

@interface BookingCarwashServicesViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, weak) id <WashParamsViewControllerDelegate> delegate;
@property(nonatomic, strong) NSArray *carwashServices;
@property(nonatomic, copy) NSMutableArray *checkedServices;

- (void)applyTap;
@end


@protocol WashParamsViewControllerDelegate<NSObject>
-(void)carwashServicesViewControllerSelectedServices:(NSArray *)_checkedServices;
@end