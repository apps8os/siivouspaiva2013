//
//  SecondViewController.m
//  Siivouspaiva
//
//  Created by Fabian on 23.03.13.
//  Copyright (c) 2013 Fabian Häusler. All rights reserved.
//

#import "SecondViewController.h"
#import "AppDelegate.h"
#import "spSingleEvent.h"
#import "DetailViewController.h"
#import "MainListCell.h"


@interface SecondViewController () {
    CLLocation *userLocation;
}

@property (strong) NSMutableArray *eventsData;
@end

@implementation SecondViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController.navigationBar setTranslucent:NO];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSNotificationCenter *note = [NSNotificationCenter defaultCenter];
    [note addObserver:self selector:@selector(eventDidFire:) name:@"finishedDataLoading" object:nil];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //NSMutableArray *eventsData = appDelegate.events;
    self.eventsData = [NSMutableArray array];
    if (appDelegate.events) {
        self.eventsData = appDelegate.events;
        NSLog(@"eventsDataCopy count: %lu", (unsigned long)[self.eventsData count]);
    }
    NSLog(@"eventsData:List: %lu", (unsigned long)[self.eventsData count]);
    
    // Title bar image
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-siivouspaiva"]];
    
    // locationManager update as location
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    [locationManager startUpdatingLocation];
     userLocation = [locationManager location];
    [locationManager stopUpdatingLocation];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [eventListTable deselectRowAtIndexPath:[eventListTable indexPathForSelectedRow] animated:YES];
    
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
    
    self.eventsData = [NSMutableArray array];
    self.eventsData = appDelegate.events;
    NSLog(@"eventsDataCopy count: %lu", (unsigned long)[self.eventsData count]);
    //NSLog(@"Eventsdata total: %@", self.eventsData);
    
    //[self updateAnnotations];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.eventsData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MainListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EventCell" forIndexPath:indexPath];
    spSingleEvent *event = self.eventsData[indexPath.row];
    
    // Cell Title
    cell.titleLabel.text = event.eventName;
    cell.titleLabel.font = [UIFont fontWithName:@"colaborate-bold" size:17];
    
    // Category tags
    NSString* eventTagsString = event.tags;
    if ([eventTagsString isEqualToString:@""]) {
        eventTagsString = @"Other";
    } else {
        eventTagsString = [eventTagsString stringByReplacingOccurrencesOfString:@"n" withString:@"Other"];
        //eventTagsString = [eventTagsString stringByReplacingOccurrencesOfString:@"r" withString:@"Recycling center"];
        eventTagsString = [eventTagsString stringByReplacingOccurrencesOfString:@"0" withString:@"Clothes,"];
        eventTagsString = [eventTagsString stringByReplacingOccurrencesOfString:@"1" withString:@"Children's clothing,"];
        eventTagsString = [eventTagsString stringByReplacingOccurrencesOfString:@"2" withString:@"Furniture,"];
        eventTagsString = [eventTagsString stringByReplacingOccurrencesOfString:@"3" withString:@"Household accessories,"];
        eventTagsString = [eventTagsString stringByReplacingOccurrencesOfString:@"4" withString:@"Toys and games,"];
        eventTagsString = [eventTagsString stringByReplacingOccurrencesOfString:@"5" withString:@"Technology,"];
        eventTagsString = [eventTagsString stringByReplacingOccurrencesOfString:@"6" withString:@"Music,"];
        eventTagsString = [eventTagsString stringByReplacingOccurrencesOfString:@"7" withString:@"Movies,"];
        eventTagsString = [eventTagsString stringByReplacingOccurrencesOfString:@"8" withString:@"Books,"];
        eventTagsString = [eventTagsString stringByReplacingOccurrencesOfString:@"9" withString:@"Repair services,"];
    }
    cell.tagsLabel.text = eventTagsString;
    cell.tagsLabel.font = [UIFont fontWithName:@"colaborate-regular" size:14];
    
    // Opening Time Label
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setPositiveFormat:@"00.#"];
    NSString* openingTimes = @"Open ";
    openingTimes = [openingTimes stringByAppendingString:[NSString stringWithFormat:@"%i", [event.beginHour intValue]]];
    openingTimes = [openingTimes stringByAppendingString:@":"];
    openingTimes = [openingTimes stringByAppendingString:[numberFormatter stringFromNumber: [NSNumber numberWithInt:[event.beginMinute intValue]]]];
    openingTimes = [openingTimes stringByAppendingString:@" to "];
    openingTimes = [openingTimes stringByAppendingString:[NSString stringWithFormat:@"%i", [event.endHour intValue]]];
    openingTimes = [openingTimes stringByAppendingString:@":"];
    openingTimes = [openingTimes stringByAppendingString:[numberFormatter stringFromNumber: [NSNumber numberWithInt:[event.endMinute intValue]]]];
    cell.timeLabel.text = openingTimes;
    cell.timeLabel.font = [UIFont fontWithName:@"colaborate-regular" size:14];
    
    
    // Distance Label
    CLLocationCoordinate2D eventCoordinate;
    eventCoordinate.longitude = (CLLocationDegrees)[event.longitude doubleValue];
    eventCoordinate.latitude = (CLLocationDegrees)[event.latitude doubleValue];
    CLLocation* eventLocation = [[CLLocation alloc] initWithLatitude:eventCoordinate.latitude longitude:eventCoordinate.longitude];
    CLLocationDistance eventDistance = [eventLocation distanceFromLocation: userLocation];
    //NSLog(@"eventDistance: %f", round(eventDistance));
    //NSLog(@"eventDistance: %f", round(eventDistance/50)*50);
    if (eventDistance > 950) {
        cell.distanceLabel.text = [NSString stringWithFormat:@"%.1f km", round(eventDistance/100)/10];
    } else {
        cell.distanceLabel.text = [NSString stringWithFormat:@"%.0f m", round(eventDistance/50)*50];
    }
    cell.distanceLabel.font = [UIFont fontWithName:@"colaborate-regular" size:14];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.eventsData removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"PushToDetailsView"]) {
        NSIndexPath *indexPath = [eventListTable indexPathForSelectedRow];
        NSLog(@"indexPath: %@", indexPath);
        spSingleEvent *eventToSend = self.eventsData[indexPath.row];
        NSLog(@"SendingEvent.id: %@", eventToSend.idNumber);
        //        [segue.destinationViewController setFeed:feed];
        ((DetailViewController*)segue.destinationViewController).detailEvent = eventToSend;
    }
}

@end
