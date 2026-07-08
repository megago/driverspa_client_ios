//
//  WhatsAppLoginViewController.h
//  WashMe
//
//  WhatsApp login screen — mirrors Android DriverSpa's ClientWhatsappFragment.
//  Requests a short token + wa_link, deep-links the user into WhatsApp, then polls
//  whatsapp_status until the backend matches the sender number and signs the user in.
//

#import <Foundation/Foundation.h>
#import "ScrollViewControllerOld.h"


@interface WhatsAppLoginViewController : ScrollViewControllerOld

@property(nonatomic, copy) NSString *phoneNumber;
@property(nonatomic, copy) NSString *email; // optional

@end
