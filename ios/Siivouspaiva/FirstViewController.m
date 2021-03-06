//
//  FirstViewController.m
//  Siivouspaiva
//
//  Created by Fabian on 23.03.13.
//  Copyright (c) 2013 Fabian Häusler. All rights reserved.
//

//#define mBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#import "FirstViewController.h"
#import "DetailViewController.h"
#import "eventSpot.h"
#import "AppDelegate.h"
#import "spSingleEvent.h"

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

@interface FirstViewController ()
@property (strong) NSMutableArray *eventsData;
@property CLLocationCoordinate2D lastUpdateLocation;
@property float lastUpdateSpan;
@property BOOL didFinishLoadingMap;

@end

@implementation FirstViewController
@synthesize _mapView;



- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController.navigationBar setTranslucent:NO];
    
	// Do any additional setup after loading the view, typically from a nib.
    //[self prepareForSegue:[UIStoryboardSegue segueWithIdentifier:@"second" source:self destination:self performHandler:nil] sender:self];

    NSNotificationCenter *note = [NSNotificationCenter defaultCenter];
    [note addObserver:self selector:@selector(eventDidFire:) name:@"finishedDataLoading" object:nil];

    
    self._mapView.delegate = self;
    self.didFinishLoadingMap = NO;
    
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = 60.170108;
    zoomLocation.longitude= 24.938865;
    self.lastUpdateLocation = zoomLocation;
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 800, 800);
    [_mapView setRegion:viewRegion animated:YES];
    
    
    // Siivouspaiva logo as Navigation Bar Title
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-siivouspaiva"]];

    // locate Button
    UIButton *locateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *locateButtonImage = [UIImage imageNamed:@"icon-locate"];
    UIImage *locateButtonImagePressed = [UIImage imageNamed:@"icon-locate-active"];
    [locateButton setBackgroundImage:locateButtonImage forState:UIControlStateNormal];
    [locateButton setBackgroundImage:locateButtonImagePressed forState:UIControlStateHighlighted];
    [locateButton addTarget:self action:@selector(updateUserLocation:) forControlEvents:UIControlEventTouchUpInside];
    locateButton.frame = CGRectMake(0, 0, 45, 44);
    UIView *locateButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 45, 44)];
    locateButtonView.bounds = CGRectOffset(locateButtonView.bounds, -5, 0);
    [locateButtonView addSubview:locateButton];
    UIBarButtonItem *locateButtonItem = [[UIBarButtonItem alloc] initWithCustomView:locateButtonView];
    
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        self.navigationItem.rightBarButtonItem = locateButtonItem;
    } else {
        // Create a negative spacer to go to the left of our custom back button, and pull it right to the edge:
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSpacer.width = -10;
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, locateButtonItem, nil];
    }

    
    
    // customize Back button image
    UIImage *i1 = [UIImage imageNamed:@"icon-back"];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:i1
                                                      forState:UIControlStateNormal
                                                    barMetrics:UIBarMetricsDefault];
    
    UIImage *i2 = [UIImage imageNamed:@"icon-back-active"];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:i2
                                                      forState:UIControlStateHighlighted
                                                    barMetrics:UIBarMetricsDefault];
    
    /* Fonts Working
    UIFont* font1 = [UIFont fontWithName:@"colaborate-medium" size:20];
    UIFont* font2 = [UIFont fontWithName:@"colaboratelight" size:20];
    UIFont* font3 = [UIFont fontWithName:@"colaborate-bold" size:20];
    UIFont* font4 = [UIFont fontWithName:@"colaborate-regular" size:20];
    UIFont* font5 = [UIFont fontWithName:@"colaborate-thin" size:20];
    */
    
    
    
}


- (void) eventDidFire:(NSNotification *)note {
    id obj = [note object];
    NSLog(@"Data loaded in First %@", obj);
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    self.eventsData = [NSMutableArray array];
    self.eventsData = appDelegate.events;
    NSLog(@"eventsData count: %lu", (unsigned long)[self.eventsData count]);
    //NSLog(@"Eventsdata total: %@", self.eventsData);
    
    //if (self.didFinishLoadingMap == YES) {
        [self updateAnnotations];
    //}
}

- (void)viewWillAppear:(BOOL)animated {
    
    if (!self.eventsData) {
        // wait for data
        //NSLog(@"Wait for Data");
    } else {
        //NSLog(@"Run Pins ");
        //[self updateAnnotations];
    }
    
}

- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView
{
    NSLog(@"Finished map loading");
    if (self.didFinishLoadingMap == NO) {
        self.didFinishLoadingMap = YES;
        //[self updateAnnotations];
    }
    
}

- (void)viewDidAppear:(BOOL)animated
{

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    currentUserLocation = userLocation;
    //NSLog(@"UserLocation: %f", currentUserLocation.coordinate.longitude);
}

- (IBAction)refreshButton:(id)sender
{
    NSLog(@"Refresh Triggered");
    
}

- (IBAction)updateUserLocation:(id)sender{
    NSLog(@"Go to my location");
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(currentUserLocation.coordinate, 800, 800);
    [_mapView setRegion:viewRegion animated:YES];
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    MKCoordinateRegion region = [mapView region];
    
    NSLog(@"Region DID change.   Center is now %f,%f,  Deltas=%f,%f", region.center.latitude, region.center.longitude, region.span.latitudeDelta, region.span.longitudeDelta);
    CLLocation *lastUpdate = [[CLLocation alloc] initWithLatitude:self.lastUpdateLocation.latitude longitude:self.lastUpdateLocation.longitude];
    CLLocation *tempLocation = [[CLLocation alloc] initWithLatitude:region.center.latitude longitude:region.center.longitude];
    CLLocationDistance tempDistance = [lastUpdate distanceFromLocation: tempLocation];
    NSLog(@"DistanceLocation: %f", tempDistance);
    double currentMapVisible = region.span.latitudeDelta*111000/2;
    float tempMapSpan = region.span.latitudeDelta;
    //NSLog(@"My map shows: %f", currentMapVisible);
    
    if (tempDistance > currentMapVisible) {
        if (self.eventsData) {
            [self updateAnnotations];
        }
    } else if (tempMapSpan > (self.lastUpdateSpan*2) ) {
        if (self.eventsData) {
            [self updateAnnotations];
        }
    } else if (tempDistance*2 < self.lastUpdateSpan) {
        if (self.eventsData) {
            [self updateAnnotations];
        }
    }
    
    

}


-(void)updateAnnotations
{
    // get current map view coordinates
    MKCoordinateRegion mapRegion = [_mapView region];
    CLLocationCoordinate2D centerLocation = mapRegion.center;
    float mapLatMin = centerLocation.latitude - mapRegion.span.latitudeDelta/1.5;
    float mapLatMax = centerLocation.latitude + mapRegion.span.latitudeDelta/1.5;
    float mapLonMin = centerLocation.longitude - mapRegion.span.longitudeDelta/1.5;
    float mapLonMax = centerLocation.longitude + mapRegion.span.longitudeDelta/1.5;
    
    self.lastUpdateLocation = centerLocation;
    self.lastUpdateSpan = (float) mapRegion.span.latitudeDelta;
    
    //search through data for events on current map view
    //NSArray *tempEvents = [self.eventsData copy];
    
    NSMutableArray *mapSpots = [[NSMutableArray alloc] init];
    for (int i = 0; i < [self.eventsData count]; i++) {
        float eventLat = [[[self.eventsData objectAtIndex:i] latitude] floatValue];
        float eventLon = [[[self.eventsData objectAtIndex:i] longitude] floatValue];
        
        if (eventLat>mapLatMin && eventLat<mapLatMax && eventLon>mapLonMin && eventLon<mapLonMax) {
            //NSLog(@"Map match");
            [mapSpots addObject:[self.eventsData objectAtIndex:i]];
        }
        //NSLog(@"eventsData data: %@", [[self.eventsData objectAtIndex:i] longitude]);
    }
    NSLog(@"mapspots count: %lu", (unsigned long)[mapSpots count]);
    [self plotEventLocations:mapSpots];
    
}

// plotting Events
- (void)plotEventLocations:(NSArray *)responseData {
    for (id<MKAnnotation> annotation in _mapView.annotations) {
        if ( [annotation isKindOfClass:[ MKUserLocation class]] ) {
        }
        else {
            [_mapView removeAnnotation:annotation];
        }
        
    }
    
    for (int i = 0; i < MIN(130, [responseData count]); i++) {
        //NSDictionary* singleEvent = [[responseData objectAtIndex:i] ];
        
        NSNumber * latitude = [[responseData objectAtIndex:i] latitude];
        NSNumber * longitude = [[responseData objectAtIndex:i] longitude];
        NSString * name = [[responseData objectAtIndex:i] eventName];
        NSString * address = [[responseData objectAtIndex:i] eventAddress];
        NSNumber * identifier = [[responseData objectAtIndex:i] idNumber];
        /*NSString * name = @"Hello";
        NSString * address = @"you";
        NSNumber * identifier = [NSNumber numberWithInt:i];
        NSNumber * latitude = [NSNumber numberWithFloat:(60.170208+(i/10))];
        NSNumber * longitude = [NSNumber numberWithFloat:(24.938965+(i/10))]; */

        
        //NSLog(@"finished %i", i);
        
        CLLocationCoordinate2D coordinate;
        coordinate.latitude = latitude.doubleValue;
        coordinate.longitude = longitude.doubleValue;
        eventSpot *annotation = [[eventSpot alloc] initWithName:name address:address coordinate:coordinate identifier:identifier];
        
        //MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        //annotation.coordinate = coordinate;
        
        [_mapView addAnnotation:annotation];
        //NSLog(@"Annotation ident: %@", annotation.identi);
    }
    NSLog(@"finished");
}

/* Uising the MKPinAnnotationView animates PINs but breaks the image replacement
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation: (id <MKAnnotation>)annotation {
    MKPinAnnotationView *pinView = nil;
    if(annotation != _mapView.userLocation)
    {
        static NSString *defaultPinID = @"com.event.pin";
        pinView = (MKPinAnnotationView *)[_mapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
        if ( pinView == nil ) pinView = [[MKPinAnnotationView alloc]
                                          initWithAnnotation:annotation reuseIdentifier:defaultPinID];
        pinView.canShowCallout = YES;
        pinView.animatesDrop = YES;
        pinView.enabled = YES;
        pinView.image = [UIImage imageNamed:@"map-marker"];
        pinView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        
        return pinView;
    }
    else {
        [_mapView.userLocation setTitle:@"I am here"];
    }
    
    return pinView;
}
*/

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    static NSString *identifier = @"com.annotation.pin";
    
    if(annotation !=mapView.userLocation) {
        if ([annotation isKindOfClass:[eventSpot class]]) {
            
            MKAnnotationView *annotationView = (MKAnnotationView *) [mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
            if (annotationView == nil) {
                annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
                annotationView.enabled = YES;
                annotationView.canShowCallout = YES;
                annotationView.centerOffset = CGPointMake(0,-20);
                annotationView.calloutOffset = CGPointMake(0, 0);
                
                UIButton *btnDetailRight = [UIButton buttonWithType: UIButtonTypeDetailDisclosure];
                
                [btnDetailRight addTarget:self
                                 action:@selector(self)
                       forControlEvents:UIControlEventTouchUpInside];
                
                //NSInteger annotationV = [self._mapView.annotations indexOfObject:annotation];
                //NSNumber *annotationV = [self._mapView.annotations[[self._mapView.annotations indexOfObject:annotation]] identi];
                //NSLog(@"annotationValue: %@", annotationV);
                //btnDetailRight.tag = [annotationV intValue];
                
                
                annotationView.rightCalloutAccessoryView = btnDetailRight;
                //[annotationView bringSubviewToFront:annotationView.rightCalloutAccessoryView];
                annotationView.image = [UIImage imageNamed:@"map-marker"];
            } else {
                annotationView.annotation = annotation;
            }
            
            return annotationView;
        }
    }
    
    return nil;
}
/*
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view
calloutAccessoryControlTapped:(UIControl *)control
{    
    //DetailView *detail = (DetailView *)view.annotation;
    //[detail loadDetailView];
    //NSLog(@"detail button clicked %@", [[_mapView.annotations objectAtIndex:1] identifier]);
}*/


#pragma mark - Segues

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    eventSpot *annotationClicked = (eventSpot *)view.annotation;
    NSLog(@"evenSpot identifier: %@", annotationClicked.identi);
    //NSNumber *artist = artPiece.idNumber;
    
    spSingleEvent *transferEvent =  [[spSingleEvent alloc] init];
    for (int i = 0; i < [self.eventsData count]; i++) {
        if ([[self.eventsData objectAtIndex:i] idNumber] == annotationClicked.identi ) {
            transferEvent = [self.eventsData objectAtIndex:i];
        }
    }
    [self performSegueWithIdentifier: @"goToDetailView" sender: transferEvent];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"goToDetailView"]) {
        // get Detail ID
        // Video 7 minute 31
        
        spSingleEvent *eventClicked = sender;
        ((DetailViewController*)segue.destinationViewController).detailEvent = eventClicked;
    }
}





@end
