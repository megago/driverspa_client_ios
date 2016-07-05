//
//  TitleInputFieldView.m
//  WashMe
//
//  Created by Almas Adilbek on 10/25/14.
//  Copyright (c) 2014 Almas Adilbek. All rights reserved.
//

#import "TitleInputFieldView.h"
#import "InputTextField.h"

@implementation TitleInputFieldView {

    UILabel *titleLabel;
}

-(id)initWithTitle:(NSString *)title fieldPlaceholder:(NSString *)placeholder {
    return [self initWithTitle:title fieldPlaceholder:placeholder width:[ASize screenWidth]];
}

- (id)initWithTitle:(NSString *)title fieldPlaceholder:(NSString *)placeholder width:(CGFloat)width
{
    self = [super initWithFrame:CGRectMake(0, 0, width, 1)];
    if(self) {
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kViewControllerPadding, 0, self.width - 2 * kViewControllerPadding, 1)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont robotoRegular:14];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        titleLabel.numberOfLines = 0;
        titleLabel.text = title;
        [titleLabel sizeToFit];
        [self addSubview:titleLabel];

        self.inputTextField = [[InputTextField alloc] initWithWidth:(self.width - 2 * kViewControllerPadding) height:40];
        _inputTextField.x = kViewControllerPadding;
        _inputTextField.y = titleLabel.bottom;
        [_inputTextField setPlaceholder:placeholder];
        [self addSubview:_inputTextField];

        self.height = _inputTextField.bottom;
    }
    return self;
}


- (NSString *)value {
    return [_inputTextField value];
}

- (void)setValue:(NSString *)value {
    [_inputTextField setValue:value];
}

- (void)enabled:(BOOL)enabled {
    [_inputTextField enabled:enabled];
}

- (void)setTitleFont:(UIFont *)font {
    titleLabel.font = font;
    titleLabel.width = self.width - 2 * kViewControllerPadding;
    [titleLabel sizeToFit];

    _inputTextField.y = titleLabel.bottom;
    self.height = _inputTextField.bottom;
}


- (void)setRightText:(NSString *)text {
    [_inputTextField setRightText:text];
}

- (void)focus {
    [_inputTextField focus];
}

- (void)setUserData:(id)userData {
    _inputTextField.userData = userData;
}

- (id)userData {
    return _inputTextField.userData;
}


@end
