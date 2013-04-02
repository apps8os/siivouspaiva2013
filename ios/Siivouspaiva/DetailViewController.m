//
//  DetailViewController.m
//  Siivouspaiva
//
//  Created by Fabian on 26.03.13.
//  Copyright (c) 2013 Fabian Häusler. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // star Button
    UIButton *starButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *starButtonImage = [UIImage imageNamed:@"icon-star"];
    UIImage *starButtonImagePressed = [UIImage imageNamed:@"icon-star-active"];
    [starButton setBackgroundImage:starButtonImage forState:UIControlStateNormal];
    [starButton setBackgroundImage:starButtonImagePressed forState:UIControlStateHighlighted];
    [starButton addTarget:self action:@selector(self) forControlEvents:UIControlEventTouchUpInside]; // add staring function!
    starButton.frame = CGRectMake(0, 0, 45, 44);
    UIView *starButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 45, 44)];
    starButtonView.bounds = CGRectOffset(starButtonView.bounds, -5, 0);
    [starButtonView addSubview:starButton];
    UIBarButtonItem *starButtonItem = [[UIBarButtonItem alloc] initWithCustomView:starButtonView];
    self.navigationItem.rightBarButtonItem = starButtonItem;
     

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
