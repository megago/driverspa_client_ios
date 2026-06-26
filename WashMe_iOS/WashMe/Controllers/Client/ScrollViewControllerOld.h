//
// Created by Almas Adilbek on 9/7/14.
// Copyright (c) 2014 Almas Adilbek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TPKeyboardAvoidingScrollView.h"
#import "BSKeyboardControls.h"


@interface ScrollViewControllerOld : UIViewController <BSKeyboardControlsDelegate, UITextFieldDelegate, UITextViewDelegate, UITextViewDelegate> {
    TPKeyboardAvoidingScrollView *sv;
}

-(void)configUI;
-(void)addKeyboardControlFields:(NSArray *)fields;
-(void)setScrollContentHeight:(CGFloat)height;

- (void)textFieldDidBeginEditing:(UITextField *)textField;
- (void)textFieldDidEndEditing:(UITextField *)textField;

@end