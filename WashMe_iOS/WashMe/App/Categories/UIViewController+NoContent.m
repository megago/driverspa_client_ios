//
// Created by Almas Adilbek on 11/25/14.
//

#import "UIViewController+NoContent.h"
#import "PureLayout.h"
#import "UIView+ConcisePureLayout.h"

#define kNoContentContainerTag 404

@implementation UIViewController (NoContent)

#pragma mark -
#pragma mark No content message

- (UIView *)showNoContentMessage:(NSString *)message {
    return [self showNoContentMessage:message withButton:nil selector:nil];
}

- (UIView *)showNoContentMessage:(NSString *)message icon:(NSString *)iconName {
    return [self showNoContentMessage:message icon:iconName withButton:nil selector:nil];
}

- (UIView *)showNoContentMessage:(NSString *)message withButton:(NSString *)buttonTitle selector:(SEL)_selector {
    return [self showNoContentMessage:message icon:nil withButton:buttonTitle selector:_selector];
}

- (UIView *)showNoContentMessage:(NSString *)message icon:(NSString *)iconName withButton:(NSString *)buttonTitle selector:(SEL)_selector
{
    [self removeNoContentMessageIfExists];

    UIView *container = [UIView newAutoLayoutView];
    container.tag = kNoContentContainerTag;
    [self.view addSubview:container];
    [container autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.view];
    [container aa_centerInSuperview];
    
    // If icon exists
    UIImageView *iconView;
    if (iconName) {
        iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:iconName]];
        [container addSubview:iconView];
        [iconView aa_superviewTop:10];
        [iconView aa_centerHorizontal];
    }
    
    UILabel *messageLabel = [UILabel newAutoLayoutView];
    messageLabel.backgroundColor = [UIColor clearColor];
    messageLabel.font = [UIFont systemFontOfSize:18];
    messageLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
    messageLabel.numberOfLines = 0;
    messageLabel.textAlignment = NSTextAlignmentCenter;
    [container addSubview:messageLabel];
    [messageLabel aa_setWidth:260];
    
    // pin messageLabel to iconView if exits one
    if (iconName) {
        [messageLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:iconView withOffset:20];
    } else {
        [messageLabel aa_superviewTop:10];
    }
    
    [messageLabel aa_centerHorizontal];
    messageLabel.text = message;

    UIView *lastView = messageLabel;
    
    if(buttonTitle && _selector) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:_selector forControlEvents:UIControlEventTouchUpInside];
        
        NSMutableAttributedString *btnString = [[NSMutableAttributedString alloc] initWithString:buttonTitle];
        [btnString addAttributes:@{
          NSUnderlineStyleAttributeName : [NSNumber numberWithInteger:NSUnderlineStyleSingle],
          NSFontAttributeName : [UIFont robotoRegular:12],
          NSForegroundColorAttributeName : [UIColor whiteColor]
          } range:NSMakeRange(0, [btnString length])];
        [button setAttributedTitle:btnString forState:UIControlStateNormal];
        
        [container addSubview:button];
        [button aa_setWidth:260];
        [button aa_setHeight:30];
        [button aa_pinUnderView:messageLabel offset:0];
        [button aa_centerHorizontal];
        
        lastView = button;
    }

    [lastView aa_superviewBottom:10];

    return container;
}


- (void)removeNoContentMessageIfExists {
    id container = [self.view viewWithTag:kNoContentContainerTag];
    if(container) {
        [container removeFromSuperview];
    }
}

@end
