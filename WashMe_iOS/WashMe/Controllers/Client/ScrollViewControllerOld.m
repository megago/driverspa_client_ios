//
// Created by Almas Adilbek on 9/7/14.
// Copyright (c) 2014 Almas Adilbek. All rights reserved.
//

#import "ScrollViewControllerOld.h"
#import "InputTextField.h"

@interface ScrollViewControllerOld () {}

@property (nonatomic, strong) BSKeyboardControls *keyboardControls;

@end

@implementation ScrollViewControllerOld {
    NSMutableArray *textFields;
}

- (void)addKeyboardControlFields:(NSArray *)fields
{
    textFields = [[NSMutableArray alloc] init];

    for(id field in fields)
    {
        if([field isKindOfClass:[InputTextField class]]) {
            UITextField *tf = [(InputTextField *)field textField];
            tf.delegate = self;
            [textFields addObject:tf];
        } else if([field isKindOfClass:[UITextField class]]) {
            UITextField *tf = field;
            tf.delegate = self;
            [textFields addObject:tf];
        } else if([field isKindOfClass:[UITextView class]]) {
            UITextView *tf = field;
            tf.delegate = self;
            [textFields addObject:tf];
        } else {
            continue;
        }
    }

    if(self.keyboardControls) {
        self.keyboardControls = nil;
    }
    self.keyboardControls = [[BSKeyboardControls alloc] initWithFields:textFields];
    self.keyboardControls.delegate = self;
    self.keyboardControls.doneTitle = @"Готово";
}

-(void)setScrollContentHeight:(CGFloat)height {
    CGSize size = sv.contentSize;
    size.height = height + 40;
    [sv setContentSize:size];
}


#pragma mark -
#pragma mark BSKeyboardControls

- (void)keyboardControlsDonePressed:(BSKeyboardControls *)keyboardControls {
    [keyboardControls.activeField resignFirstResponder];
}

//-(void)configFieldOnFocus:(TitledTextField *)field
//{
//    __weak PushScrollView *wSelf = self;
//    [field onFocus:^(TitledTextField *_field) {
//        [wSelf onFieldFocus:_field.textField];
//    }];
//}

-(void)onFieldFocus:(id)field {
    [self.keyboardControls setActiveField:field];
}

- (void)keyboardControls:(BSKeyboardControls *)keyboardControls selectedField:(UIView *)field inDirection:(BSKeyboardControlsDirection)direction
{
    [sv scrollToActiveTextField];

    for (id _field in textFields)
    {
        if([_field isEqual:field])
        {
            [_field becomeFirstResponder];
            break;
        }
    }
}

#pragma mark -
#pragma mark UITextField

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.keyboardControls setActiveField:textField];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {

}

#pragma mark -
#pragma mark UITextView

-(void)textViewDidBeginEditing:(UITextView *)textView {
    [self.keyboardControls setActiveField:textView];
}

#pragma mark -

- (void)configUI
{
    self.view.backgroundColor = [UIColor whiteColor];

    //if (self.tabBarController.tabBar.hidden){
        sv = [[TPKeyboardAvoidingScrollView alloc] initWithFrame:CGRectMake(0, 64, [ASize screenWidth], [ASize screenHeightWithoutStatusBarAndNavigationBar])];
    //} else {
    //    sv = [[TPKeyboardAvoidingScrollView alloc] initWithFrame:CGRectMake(0, 64, [ASize screenWidth], [ASize screenHeightWithoutStatusBarAndNavigationBarAndTabBar])];
    //}
    sv.alwaysBounceVertical = YES;
    sv.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:sv];
}

@end