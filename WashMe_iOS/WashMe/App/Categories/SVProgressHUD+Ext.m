//
//  SVProgressHUD+Ext.m
//  BAF
//
//  Created by Almas Adilbek on 1/26/15.
//
//

#import "SVProgressHUD+Ext.h"
#import "SVProgressHUD.h"

@implementation SVProgressHUD (Ext)

+ (void)showLoading {
    [self showLoadingWithMaskType:SVProgressHUDMaskTypeClear];
}

+ (void)showLoadingMaskNone {
    [self showLoadingWithMaskType:SVProgressHUDMaskTypeNone];
}

+ (void)showWait {
    [SVProgressHUD showWithStatus:@"Пожалуйста ожидайте" maskType:SVProgressHUDMaskTypeClear];
}

+ (void)showLoadingWithMaskType:(SVProgressHUDMaskType)type {
    [SVProgressHUD showWithStatus:@"Загрузка" maskType:type];
}

+ (void)showDisabledWithStatus:(NSString *)status {
    [SVProgressHUD showWithStatus:status maskType:SVProgressHUDMaskTypeClear];
}


@end
