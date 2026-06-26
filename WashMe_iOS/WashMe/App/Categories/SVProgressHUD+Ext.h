//
//  SVProgressHUD+Ext.h
//  BAF
//
//  Created by Almas Adilbek on 1/26/15.
//
//

#import "SVProgressHUD.h"

@interface SVProgressHUD (Ext)

+ (void)showLoading;
+ (void)showLoadingMaskNone;

+ (void)showWait;
+ (void)showLoadingWithMaskType:(SVProgressHUDMaskType)type;
+ (void)showDisabledWithStatus:(NSString *)status;

@end
