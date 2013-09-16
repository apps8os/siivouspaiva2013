//
//  InfoScreenViewController.m
//  Siivouspaiva
//
//  Created by Fabian on 08.05.13.
//  Copyright (c) 2013 Fabian. All rights reserved.
//

#import "InfoScreenViewController.h"

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

@interface InfoScreenViewController ()

@end

@implementation InfoScreenViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController.navigationBar setTranslucent:NO];
	// Do any additional setup after loading the view.
    
    [contentScrollView setScrollEnabled:YES];
    [contentScrollView setContentSize:CGSizeMake(320, 550)];
    
    
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        InfoTextView.contentInset = UIEdgeInsetsMake(-4,-8,0,0);
    }
    
    InfoTextView.font = [UIFont fontWithName:@"colaborate-regular" size:15];
    LabelAaltoF.font = [UIFont fontWithName:@"colaborate-regular" size:15];
    Labeldev1.font = [UIFont fontWithName:@"colaborate-regular" size:15];
    Labeldev2.font = [UIFont fontWithName:@"colaborate-regular" size:15];
    Labelothers.font = [UIFont fontWithName:@"colaborate-regular" size:15];
    Labelothers2.font = [UIFont fontWithName:@"colaborate-regular" size:15];
    LabelSWD.font = [UIFont fontWithName:@"colaborate-bold" size:15];
    LabelTHT.font = [UIFont fontWithName:@"colaborate-bold" size:15];
    LabelUID.font = [UIFont fontWithName:@"colaborate-bold" size:15];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
