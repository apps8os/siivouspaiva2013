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
        NSLog(@"eventsDataCopy count: %lu", (unsigned long)[self.eventsData count]);
    }
    NSLog(@"eventsData:List: %lu", (unsigned long)[self.eventsData count]);
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-siivouspaiva.png"]];

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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EventCell" forIndexPath:indexPath];
    
    
    spSingleEvent *event = self.eventsData[indexPath.row];
    
    cell.textLabel.text = event.eventName;
    cell.detailTextLabel.text = event.eventAddress;
    
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
