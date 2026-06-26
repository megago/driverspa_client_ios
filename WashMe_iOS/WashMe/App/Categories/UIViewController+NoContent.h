//
// Created by Almas Adilbek on 11/25/14.
//

#import <Foundation/Foundation.h>

@interface UIViewController (NoContent)

- (UIView *)showNoContentMessage:(NSString *)message;
- (UIView *)showNoContentMessage:(NSString *)message icon:(NSString *)iconName;
- (UIView *)showNoContentMessage:(NSString *)message withButton:(NSString *)buttonTitle selector:(SEL)_selector;
- (UIView *)showNoContentMessage:(NSString *)message icon:(NSString *)iconName withButton:(NSString *)buttonTitle selector:(SEL)_selector;
- (void)removeNoContentMessageIfExists;

@end