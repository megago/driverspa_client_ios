//
//  AddBoxViewController.h
//  WashMe
//
//  Created by Ivan Korotkikh on 23.09.16.
//  Copyright © 2016 Almas Adilbek. All rights reserved.
//

#import "ScrollViewControllerOld.h"

@class BoxSetting;
@interface AddBoxViewController : ScrollViewControllerOld
@property (nonatomic, assign) BOOL editMode;
@property (nonatomic, strong) BoxSetting *boxSetting;
@end
