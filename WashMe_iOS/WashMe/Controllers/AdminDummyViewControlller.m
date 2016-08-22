//
//  AdminDummyViewControlller.m
//  WashMe
//
//  Created by Ivan Korotkikh on 06.08.16.
//  Copyright © 2016 Almas Adilbek. All rights reserved.
//

#import "AdminDummyViewControlller.h"
#import "UIViewController+NavigationBar.h"
#import "UIViewController+Ext.h"
#import "ASize.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface AdminDummyViewControlller () {
    UIWebView *_webView;
}
@end

@implementation AdminDummyViewControlller

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configUI];
    [self loadDummy];
}

- (void)loadDummy
{
    [SVProgressHUD showWithStatus:@"Загрузка"];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"ios_admin_dummy" ofType:@"html"];
    NSURL *url = [NSURL fileURLWithPath:path];
    [_webView loadRequest:[NSURLRequest requestWithURL:url]];
}

-(void)configUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    [self setBlueBackground];
    [self setBackButton];
    [self setNavigationBarTransparent];
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64.f, [ASize screenWidth], [ASize screenHeight] - 64.f)];
    _webView.delegate = self;
    _webView.backgroundColor = [UIColor clearColor];
    _webView.hidden = YES;
    _webView.scalesPageToFit = NO;
    [self.view addSubview:_webView];}

#pragma mark - WebView delegate\

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if ([request.URL.description rangeOfString:@"washme.kz"].location != NSNotFound) {
        [[UIApplication sharedApplication] openURL:request.URL];
        return NO;
    }
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [SVProgressHUD dismiss];
    _webView.hidden = NO;
}

@end
