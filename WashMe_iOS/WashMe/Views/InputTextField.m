//
// Created by Almas Adilbek on 9/7/14.
// Copyright (c) 2014 Almas Adilbek. All rights reserved.
//

#import "InputTextField.h"
#import "UIFont+Custom.h"
#import "Version.h"

#define kTfPadding 5

@implementation InputTextField {

}
- (id)initWithWidth:(CGFloat)width
{
    return [self initWithWidth:width height:40];
}

- (id)initWithWidth:(CGFloat)width height:(CGFloat)height {
    self = [super initWithFrame:CGRectMake(0, 0, width, height)];
    if(self) {
        self.textField = [[UITextField alloc] initWithFrame:CGRectMake(kTfPadding, 0, self.width - 2 * kTfPadding, self.height)];
        _textField.font = [UIFont robotoThin:20];
        _textField.textColor = [UIColor whiteColor];
        _textField.autocorrectionType = UITextAutocorrectionTypeNo;
        _textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [self addSubview:_textField];

        if([Version iOS7]) {
            [_textField setTintColor:[UIColor whiteColor]];
        }

        UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - 1, self.width, 1)];
        [line setBackgroundColor:[UIColor whiteColor]];
        line.alpha = 0.2;
        [self addSubview:line];
    }
    return self;
}

- (NSString *)value {
    if(_textField) {
        return [_textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    }
    return @"";
}

- (void)setValue:(NSString *)value {
    if(_textField) {
        _textField.text = value;
    }
}

- (void)setPlaceholder:(NSString *)placeholder {
    if(_textField) {
        _textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder attributes:@{NSForegroundColorAttributeName: [UIColor fromRGB:0x87B5DF]}];
    }
}


- (void)enabled:(BOOL)enabled {
    if(_textField) {
        _textField.enabled = enabled;
    }
}

- (void)setRightText:(NSString *)text
{
    if(_textField) {
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        textLabel.backgroundColor = [UIColor clearColor];
        textLabel.font = _textField.font;
        textLabel.textColor = _textField.textColor;
        textLabel.text = text;
        [textLabel sizeToFit];
        textLabel.x = self.width - kTfPadding - textLabel.width;
        textLabel.centerY = _textField.centerY;
        [self addSubview:textLabel];

        _textField.width = self.width - 3 * kTfPadding - textLabel.width;
    }
}


- (void)focus {
    if(_textField) {
        [_textField becomeFirstResponder];
    }
}

- (void)blur {
    if(_textField) {
        [_textField resignFirstResponder];
    }
}


@end