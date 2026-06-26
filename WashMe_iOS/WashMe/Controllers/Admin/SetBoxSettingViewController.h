//
//  SetBoxSettingViewController.h
//  WashMe
//
//  Created by Ivan Korotkikh on 25.09.16.
//  Copyright © 2016 Almas Adilbek. All rights reserved.
//

#import "ScrollViewControllerOld.h"

@protocol SetBoxSettingViewControllerDelegate <NSObject>
- (void)boxSettingUpdated;
@end

@class BoxSetting;
@class CarwashComplex;
@interface SetBoxSettingViewController : ScrollViewControllerOld
@property (nonatomic, weak) id <SetBoxSettingViewControllerDelegate> delegate;
@property (nonatomic, assign) BOOL editMode;
@property (nonatomic, strong) BoxSetting *box;
@property (nonatomic, strong) CarwashComplex *carwash;
@end
