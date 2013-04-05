//
//  DetailViewController.m
//  Siivouspaiva
//
//  Created by Fabian on 26.03.13.
//  Copyright (c) 2013 Fabian Häusler. All rights reserved.
//

#import "DetailViewController.h"
#import "WebLinkViewController.h"
#import "eventSpot.h"

@interface DetailViewController ()

@end

@implementation DetailViewController
@synthesize tableView = _tableView;
@synthesize headerView;
@synthesize mapView = _mapView;
@synthesize infoContainer;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [headerView removeFromSuperview];
    self.tableView.tableHeaderView = headerView;
    
    self.mapView.delegate = self;
    
    
    //infoContainer.height = descriptionLabel.y+descriptionLabel.height+20;
    //headerView.frame.size.height = infoContainer.frame.origin.y+infoContainer.frame.size.height;
    
    self.tableView.tableHeaderView = headerView;
    
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
     
    
    if (self.detailEvent) {
        // text fields
        titleText.text = self.detailEvent.eventName;
        NSString *addressString = self.detailEvent.eventAddress;
        addressString = [addressString stringByReplacingOccurrencesOfString:@", Suomi"
                                                                 withString:@""];
        addressString = [addressString stringByReplacingOccurrencesOfString:@", Finland"
                                                                 withString:@""];
        addressText.text = addressString;
        //addressText.adjustsFontSizeToFitWidth = YES;
        //addressText.font = [UIFont fontWithName:@"Colaborate Bold" size:15];
        
        // Event Discription
        eventDescriptionField.text = self.detailEvent.description;
        //eventDescriptionField.font = [UIFont fontWithName:@"Colaborate Regular" size:15];
        
        mainNaviagtionTitle.title = @" ";
        
        // link setting
        if ([self.detailEvent.link.absoluteString isEqual: @""]) {
            [buttonLinkToEvent setEnabled:NO];
        } else {
            [buttonLinkToEvent setEnabled:YES];
        }
        
        
        
        // Share Button
        /*
        NSString *textToShare = @"your text";
        UIImage *yourImage = [UIImage imageNamed:@"siivouspaiva-logo.png"];
        NSArray *itemsToShare = @[textToShare, yourImage];
        UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:itemsToShare applicationActivities:nil];
        activityVC.excludedActivityTypes = @[UIActivityTypePostToWeibo, UIActivityTypePrint, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll]; //or whichever you don't need
        [self presentViewController:activityVC animated:YES completion:nil];
        */
         
        
        // Center Map to Event-Location
        CLLocationCoordinate2D eventLocation = CLLocationCoordinate2DMake([self.detailEvent.latitude doubleValue], [self.detailEvent.longitude doubleValue]);
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(eventLocation, 400, 400);
        [self.mapView setRegion:viewRegion animated:NO];
        
        // Add Event Annotation
        eventSpot *annotation = [[eventSpot alloc] initWithName:self.detailEvent.eventName address:nil coordinate:eventLocation identifier:nil];
        [self.mapView addAnnotation:annotation];
        
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

// set custom annotation image
- (MKAnnotationView *)mapView:(MKMapView *)newMapView viewForAnnotation:(id )newAnnotation {
    MKAnnotationView *a = [ [ MKAnnotationView alloc ] initWithAnnotation:newAnnotation reuseIdentifier:@"currentloc"];
    if ( a == nil )
        a = [ [ MKAnnotationView alloc ] initWithAnnotation:newAnnotation reuseIdentifier: @"currentloc" ];
    a.image = [ UIImage imageNamed:@"map-marker.png" ];
    return a;
}

// share sheet
- (IBAction)sendPost:(id)sender
{
    NSArray *activityItems;
    NSString *shareText = [NSString stringWithFormat:@"Join the Siivouspäivä event: %@ in %@", self.detailEvent.eventName, self.detailEvent.eventAddress];
    UIImage *shareImage = [UIImage imageNamed:@"siivouspaiva-logo.png"];
    activityItems = @[shareText, shareImage];
    
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    activityController.excludedActivityTypes = @[UIActivityTypePostToWeibo, UIActivityTypePrint, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll];
    [self presentViewController:activityController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.tableView) {
        CGFloat mapViewBaselineY = -(self.mapView.frame.size.height-150)/2+500;
        CGFloat y = mapViewBaselineY + scrollView.contentOffset.y/2;
        self.mapView.frame = CGRectMake(0, y, self.mapView.frame.size.width, self.mapView.frame.size.height);
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return nil;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return ([self tableView:tableView titleForHeaderInSection:section] != nil) ? 20 : 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [[UIView alloc] init];
    
    return header;
}


 

#pragma mark - Seque

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"goToWebView"]) {
        ((WebLinkViewController*)segue.destinationViewController).eventWithLink = self.detailEvent;
    }
}


@end
