//
//  WebLinkViewController.m
//  Siivouspaiva
//
//  Created by Fabian on 04.04.13.
//  Copyright (c) 2013 Fabian. All rights reserved.
//

#import "WebLinkViewController.h"

@interface WebLinkViewController ()
- (void)configureView;

@property (weak, nonatomic)
    IBOutlet UIWebView *webView;
@end

@implementation WebLinkViewController

- (void)configureView {
    if (self.eventWithLink) {
        NSURLRequest *request = [NSURLRequest requestWithURL:self.eventWithLink.link];
        NSLog(@"Web address: %@", self.eventWithLink.link);
        [self.webView loadRequest:request];
    }
}

- (void)setNewEvent:(spSingleEvent*)inEvent
{
    if (self.eventWithLink != inEvent)
    {
        self.eventWithLink = inEvent;
        NSLog(@"Data loaded for Web View");
        [self configureView];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.webView.delegate = self;
    [self configureView];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *backBtnImage = [UIImage imageNamed:@"icon-back"]  ;
    [backBtn setBackgroundImage:backBtnImage forState:UIControlStateNormal];
    UIImage *backBtnActiveImage = [UIImage imageNamed:@"icon-back-active"]  ;
    [backBtn setBackgroundImage:backBtnActiveImage forState:UIControlStateHighlighted];
    [backBtn addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, 0, 40, 44);
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn] ;
    self.navigationItem.leftBarButtonItem = backButton;
}

- (void)goback
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setWebView:nil];
    [super viewDidUnload];
}

@end
