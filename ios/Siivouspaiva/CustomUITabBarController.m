//
//  CustomUITabBarController.m
//  Siivouspaiva
//
//  Created by Fabian on 25.03.13.
//  Copyright (c) 2013 Fabian. All rights reserved.
//

#import "CustomUITabBarController.h"

@interface CustomUITabBarController ()

@end

@implementation CustomUITabBarController
@synthesize myTabBar;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [myTabBar setBackgroundImage:[UIImage imageNamed:@"navigation-controller.png"]];
    [myTabBar setSelectionIndicatorImage:[UIImage imageNamed:@"empty.png"]];
    
    [[myTabBar.items objectAtIndex:0] setFinishedSelectedImage:[UIImage imageNamed:@"tabicon-map-active.png"]  withFinishedUnselectedImage:[UIImage imageNamed:@"tabicon-map.png"]];
    [[myTabBar.items objectAtIndex:1] setFinishedSelectedImage:[UIImage imageNamed:@"tabicon-list-active.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"tabicon-list.png"]];
    [[myTabBar.items objectAtIndex:2] setFinishedSelectedImage:[UIImage imageNamed:@"tabicon-star-active.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"tabicon-star.png"]];
    [[myTabBar.items objectAtIndex:3] setFinishedSelectedImage:[UIImage imageNamed:@"tabicon-info-active.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"tabicon-info.png"]];
    for (int i = 0; i < 4; i++) {
        [[myTabBar.items objectAtIndex:i] setImageInsets:UIEdgeInsetsMake(5, 0, -5, 0)];
        [[myTabBar.items objectAtIndex:i] setTitle:nil];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
