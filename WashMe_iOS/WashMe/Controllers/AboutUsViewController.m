//
//  AboutUsViewController.m
//  WashMe
//
//  Created by Ivan Korotkikh on 25.07.16.
//  Copyright © 2016 Almas Adilbek. All rights reserved.
//

#import "AboutUsViewController.h"
#import "UIViewController+NavigationBar.h"
#import "UIViewController+Ext.h"
#import "ASize.h"
#import "UtilsApi.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface AboutUsViewController () <MFMailComposeViewControllerDelegate>{
    UIWebView *_webView;
}
@end

@implementation AboutUsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configUI];
    [self loadAbouUs];
}

- (void)loadAbouUs
{
    [SVProgressHUD showWithStatus:@"Загрузка"];
//    [UtilsApi aboutUs:^(id response) {
//        [_webView loadHTMLString:response baseURL:nil];
//    } failure:^(NSInteger code, NSString *message) {
//        
//    }];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"aboutme" ofType:@"html"];
    NSURL *url = [NSURL fileURLWithPath:path];
    [_webView loadRequest:[NSURLRequest requestWithURL:url]];
}

-(void)configUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    [self setBlueBackground];
    [self showMenuButton];
    [self setNavigationBarTransparent];
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, [ASize screenWidth], [ASize screenHeight])];
    _webView.delegate = self;
    _webView.backgroundColor = [UIColor clearColor];
    _webView.hidden = YES;
    _webView.scalesPageToFit = NO;
    [self.view addSubview:_webView];
}

#pragma mark - WebView delegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if ([request.URL.description rangeOfString:@"washme.kz"].location != NSNotFound) {
        [[UIApplication sharedApplication] openURL:request.URL];
        return NO;
    }
    if ([request.URL.scheme isEqualToString:@"inapp"]) {
        if ([request.URL.host isEqualToString:@"appstore"]) {
            // do capture action
        } else if ([request.URL.host isEqualToString:@"idea"]) {
            [self sendMessageWithSubject:@"Поделиться идеей" to:@[@"info@washme.kz"]];
        } else if ([request.URL.host isEqualToString:@"support"]) {
            [self sendMessageWithSubject:@"В техническую поддержку" to:@[@"info@washme.kz"]];
        }
        return NO;
    }
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [SVProgressHUD dismiss];
    _webView.hidden = NO;
}

#pragma mark - Message methods

- (void)sendMessageWithSubject:(NSString *)subject to:(NSArray *)recipients {
    if([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailCont = [[MFMailComposeViewController alloc] init];
        mailCont.mailComposeDelegate = self;        // Required to invoke mailComposeController when send
        
        [mailCont setSubject:subject];
        [mailCont setToRecipients:recipients];
        //[mailCont setMessageBody:@"Email message" isHTML:NO];
        
        [self presentViewController:mailCont animated:YES completion:nil];
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [controller dismissViewControllerAnimated:YES completion:nil];
}

@end
