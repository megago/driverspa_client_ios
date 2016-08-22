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

@interface AboutUsViewController () {
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
    [UtilsApi aboutUs:^(id response) {
        [SVProgressHUD dismiss];
        [_webView loadHTMLString:response baseURL:nil];
    } failure:^(NSInteger code, NSString *message) {
        
    }];
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
