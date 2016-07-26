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

@interface AboutUsViewController () {
    UIWebView *webView;
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
    [Toast showHudLoading];
    
    [UtilsApi aboutUs:^(id response) {
        [webView loadHTMLString:response baseURL:nil];
        webView.hidden = NO;
    } failure:^(NSInteger code, NSString *message) {
        
    }];
}

-(void)configUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    [self setBlueBackground];
    [self showMenuButton];
    [self setNavigationBarTransparent];
    
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, [ASize screenWidth], [ASize screenHeight])];
    webView.delegate = self;
    webView.backgroundColor = [UIColor clearColor];
    webView.hidden = YES;
    webView.scalesPageToFit = NO;
    [self.view addSubview:webView];
}


@end
