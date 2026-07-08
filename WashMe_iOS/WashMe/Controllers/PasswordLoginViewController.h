//
//  PasswordLoginViewController.h
//  WashMe
//
//  Password login for returning users (check_phone -> has_password == true),
//  mirrors Android DriverSpa's ClientPasswordLoginFragment. Asks only for the
//  password — no WhatsApp for these users.
//

#import <Foundation/Foundation.h>
#import "ScrollViewControllerOld.h"


@interface PasswordLoginViewController : ScrollViewControllerOld

@property(nonatomic, copy) NSString *phoneNumber;

@end
