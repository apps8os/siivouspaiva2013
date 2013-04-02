//
//  SecondViewController.m
//  Siivouspaiva
//
//  Created by Fabian on 23.03.13.
//  Copyright (c) 2013 Fabian Häusler. All rights reserved.
//

#import "SecondViewController.h"
#import "AppDelegate.h"

@interface SecondViewController ()

@property (strong) NSMutableArray *eventsData;
@end

@implementation SecondViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSNotificationCenter *note = [NSNotificationCenter defaultCenter];
    [note addObserver:self selector:@selector(eventDidFire:) name:@"finishedDataLoading" object:nil];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //NSMutableArray *eventsData = appDelegate.events;
    self.eventsData = [NSMutableArray array];
    if (appDelegate.events) {
        self.eventsData = appDelegate.events;
        NSLog(@"eventsData count: %lu", (unsigned long)[self.eventsData count]);
    }
    
    /*
    UIImage *i3 = [UIImage imageNamed:@"icon-list"];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:i3
                                                      forState:UIControlStateNormal
                                                    barMetrics:UIBarMetricsDefault];
    
    UIImage *i4 = [UIImage imageNamed:@"icon-list-active"];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:i4
                                                      forState:UIControlStateSelected
                                                    barMetrics:UIBarMetricsDefault];
     */
}

-(UITableViewCell*)tableView:(UITableView *)eventListTable cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    return cell;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) eventDidFire:(NSNotification *)note {
    id obj = [note object];
    NSLog(@"Data loaded in Second %@", obj);
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //NSMutableArray *eventsData = appDelegate.events;
    self.eventsData = [NSMutableArray array];
    self.eventsData = appDelegate.events;
    NSLog(@"eventsData count: %lu", (unsigned long)[self.eventsData count]);
    //NSLog(@"Eventsdata total: %@", self.eventsData);
    
    //[self updateAnnotations];
}

@end
