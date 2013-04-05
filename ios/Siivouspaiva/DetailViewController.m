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
@synthesize _mapViewDetail;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
    self._mapViewDetail.delegate = self;
    
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
        eventDescriptionField.text = self.detailEvent.description;
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
        [_mapViewDetail setRegion:viewRegion animated:NO];
        
        // Add Event Annotation
        eventSpot *annotation = [[eventSpot alloc] initWithName:self.detailEvent.eventName address:nil coordinate:eventLocation identifier:nil];
        [_mapViewDetail addAnnotation:annotation];
        
    }
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

#pragma mark - Seque

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"goToWebView"]) {
        ((WebLinkViewController*)segue.destinationViewController).eventWithLink = self.detailEvent;
    }
}


@end
