//
// Created by Almas Adilbek on 10/1/14.
// Copyright (c) 2014 Almas Adilbek. All rights reserved.
//

#import "TextareaField.h"
#import "UIFont+Custom.h"
#import "Version.h"

#define kPadding 5

@implementation TextareaField {
}

-(id)initWithWidth:(CGFloat)width height:(CGFloat)height
{
    self = [super initWithFrame:CGRectMake(0, 0, width, height)];
    if(self) {
        UIImageView *borderView = [[UIImageView alloc] initWithFrame:self.bounds];
        borderView.image = [[UIImage imageWithName:@"border-button-bg"] stretchableImageWithLeftCapWidth:15 topCapHeight:15];
        [self addSubview:borderView];

        self.textarea = [[LPlaceholderTextView alloc] initWithFrame:CGRectMake(kPadding, kPadding, self.width - 2 * kPadding, self.height - 2 * kPadding)];
        _textarea.backgroundColor = [UIColor clearColor];
        _textarea.font = [UIFont robotoRegular:16];
        _textarea.textColor = [UIColor whiteColor];
        _textarea.autocapitalizationType = UITextAutocapitalizationTypeSentences;
        _textarea.placeholderColor  = [UIColor fromRGB:0x84beec];
        [self addSubview:_textarea];

        if([Version iOS7]) {
            [_textarea setTintColor:[UIColor whiteColor]];
        }
    }
    return self;
}

- (NSString *)value {
    return [_textarea.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}


- (void)focus {
    [_textarea becomeFirstResponder];
}

@end