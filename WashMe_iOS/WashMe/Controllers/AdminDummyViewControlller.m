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

@interface AdminDummyViewControlller () <UIWebViewDelegate> {
    UIWebView *webView;
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
    [self configUI];

    NSString *path = [[NSBundle mainBundle] pathForResource:@"ios_admin_dummy" ofType:@"html"];
    NSURL *url = [NSURL fileURLWithPath:path];
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
}

-(void)configUI
{
    [self setBlueBackground];
    [self setBackButton];
    [self setNavigationBarTransparent];
    
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64.f, [ASize screenWidth], [ASize screenHeight]-64.f)];
    webView.delegate = self;
    webView.backgroundColor = [UIColor clearColor];
    webView.scalesPageToFit = NO;
    [self.view addSubview:webView];
}

#pragma mark - WebView delegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSLog(@"%@", request);
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"start");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"finish");
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error {
    NSLog(@"failed");
}

@end
