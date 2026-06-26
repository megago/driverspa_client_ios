//
//  AAButton+Styles.m
//  AstanaKzPublicControl
//
//  Created by Almas Adilbek on 5/20/13.
//  Copyright (c) 2013 Astana.kz. All rights reserved.
//

#import "AAButton.h"
#import "UIFont+Custom.h"

@implementation AAButton (Styles)

-(void)commonStyleButtonWithTitle:(NSString *)title {
    [self noBorderStyleButtonWithTitle:title];
    [self setImageWithPattern:@"border-button-pattern.png" leftWidth:15 topHeight:20 forState:UIControlStateNormal];
    [self setImageWithPattern:@"border-button-pattern-highlighed.png" leftWidth:15 topHeight:20 forState:UIControlStateHighlighted];
}

- (void)noBorderStyleButtonWithTitle:(NSString *)title {
    [self setTitle:title forState:UIControlStateNormal];
    [self setTitleFont:[UIFont robotoRegular:18]];
    [self setTitleShadowOffset:CGSizeMake(0, -1)];
    [self setTitleColor:[UIColor fromRGB:0xbbbbbb] forState:UIControlStateHighlighted];
}


@end
