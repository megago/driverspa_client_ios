//
// Created by Almas Adilbek on 9/7/14.
// Copyright (c) 2014 Almas Adilbek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AAButton.h"

@interface UIViewController (Ext)

-(void)setBlueBackground;
-(void)createWashMeWhiteLogo;

-(UIImageView *)whiteLogo;
- (void)setNavigationTitle:(NSString *)title;
- (void)setBackButton;

-(UIButton *)createBarButtonAtLeft:(BOOL)atLeft buttonImage:(NSString *)imageName target:(id)target selector:(SEL)_selector;

- (void)goBackTapped;

- (void)hideKeyboard;

// Moda VC
-(void)closeModalViewController;

@end