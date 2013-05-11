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
	// Do any additional setup after loading the view, typically from a nib.
    //[self prepareForSegue:[UIStoryboardSegue segueWithIdentifier:@"second" source:self destination:self performHandler:nil] sender:self];

    NSNotificationCenter *note = [NSNotificationCenter defaultCenter];
    [note addObserver:self selector:@selector(eventDidFire:) name:@"finishedDataLoading" object:nil];

    
    self._mapView.delegate = self;
    self.didFinishLoadingMap = NO;
    
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = 60.170208;
    zoomLocation.longitude= 24.938965;
    self.lastUpdateLocation = zoomLocation;
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 800, 800);
    [_mapView setRegion:viewRegion animated:YES];
    
    
    // Siivouspaiva logo as Navigation Bar Title
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-siivouspaiva.png"]];

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
    self.navigationItem.rightBarButtonItem = locateButtonItem;

    
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
    
    //NSMutableArray *eventsData = appDelegate.events;
    self.eventsData = [NSMutableArray array];
    self.eventsData = appDelegate.events;
    NSLog(@"eventsData count: %lu", (unsigned long)[self.eventsData count]);
    //NSLog(@"Eventsdata total: %@", self.eventsData);
    
    if (self.didFinishLoadingMap == YES) {
        [self updateAnnotations];
    }
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
        [self updateAnnotations];
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
    NSLog(@"Got to my location");
    
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
    } else if (tempDistance*4 < self.lastUpdateSpan) {
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
    float mapLatMin = centerLocation.latitude - mapRegion.span.latitudeDelta;
    float mapLatMax = centerLocation.latitude + mapRegion.span.latitudeDelta;
    float mapLonMin = centerLocation.longitude - mapRegion.span.longitudeDelta;
    float mapLonMax = centerLocation.longitude + mapRegion.span.longitudeDelta;
    
    self.lastUpdateLocation = centerLocation;
    self.lastUpdateSpan = (float) mapRegion.span.latitudeDelta;
    
    //search through data for events on current map view
    //if (self.eventsData) {
        NSArray *tempEvents = [self.eventsData copy];
        
        
        NSMutableArray *mapSpots = [[NSMutableArray alloc] init];
        for (int i = 0; i < [tempEvents count]; i++) {
            float eventLat = [[[tempEvents objectAtIndex:i] latitude] floatValue];
            float eventLon = [[[tempEvents objectAtIndex:i] longitude] floatValue];
            
            if (eventLat>mapLatMin && eventLat<mapLatMax && eventLon>mapLonMin && eventLon<mapLonMax) {
                //NSLog(@"Map match");
                [mapSpots addObject:[tempEvents objectAtIndex:i]];
            }
            //NSLog(@"eventsData data: %@", [[self.eventsData objectAtIndex:i] longitude]);
        }
        [self plotEventLocations:mapSpots];
        NSLog(@"mapspots count: %lu", (unsigned long)[mapSpots count]);
   // }
     
    
}
/*
// old getting Data
- (void)getData
{
    // get user map view
    MKCoordinateRegion mapRegion = [_mapView region];
    CLLocationCoordinate2D centerLocation = mapRegion.center;
    float userCoordinateLat1 = centerLocation.latitude - mapRegion.span.latitudeDelta;
    float userCoordinateLat2 = centerLocation.latitude + mapRegion.span.latitudeDelta;
    float userCoordinateLon1 = centerLocation.longitude - mapRegion.span.longitudeDelta;
    float userCoordinateLon2 = centerLocation.longitude + mapRegion.span.longitudeDelta;
    
    
    NSURL *url = [NSURL URLWithString:@"http://siivouspaiva.com/data.php?query=load"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    
    NSString *jsonData = [NSString stringWithFormat:@"um=%f&uM=%f&vm=%f&vM=%f", userCoordinateLat1, userCoordinateLat2, userCoordinateLon1, userCoordinateLon2];
    NSData *requestData = [jsonData dataUsingEncoding:NSUTF8StringEncoding];
    NSString* requestDataLengthString = [[NSString alloc] initWithFormat:@"%d", [requestData length]];
    [request setValue:requestDataLengthString forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:requestData];
    NSLog(@"Sending Content: %@", requestDataLengthString);
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
    dispatch_async(queue, ^{
        NSURLResponse *response = nil;
        NSError *error = nil;
        
        NSData *responseData = [NSURLConnection sendSynchronousRequest:request
                                                     returningResponse:&response
                                                                 error:&error];
        
        NSArray* eventLocations = [NSJSONSerialization
                                   JSONObjectWithData:responseData
                                   options:kNilOptions
                                   error:&error];
        
        //[self plotEventLocations:eventLocations];
    });
    

    //NSURL *url = [NSURL URLWithString:@"http://siivouspaiva.com/data.php?query=load"];
    
    //NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    //[request setHTTPMethod:@"POST"];
    
    //all data: @"um=-90&uM=90&vm=-180&vM=180";
    //NSString *jsonData = [NSString stringWithFormat:@"um=%f&uM=%f&vm=%f&vM=%f", userCoordinateLat1, userCoordinateLat2, userCoordinateLon1, userCoordinateLon2];
    //NSLog(@"jsonString: %@", jsonData);
    
    //NSData *requestData = [jsonData dataUsingEncoding:NSUTF8StringEncoding];
    //NSString* requestDataLengthString = [[NSString alloc] initWithFormat:@"%d", [requestData length]];
    //[request setValue:requestDataLengthString forHTTPHeaderField:@"Content-Length"];
    //[request setHTTPBody:requestData];
    
    
    
    //NSURLResponse *response = NULL;
    //NSError *requestError = NULL;
    
    //NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&requestError];
    //NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    //NSError* error;
    //NSArray* eventLocations = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    //NSLog(@"locations: %@", eventLocations);
    
     
     
    //[self plotEventLocations:eventLocations];
    

} */


// plotting Events
- (void)plotEventLocations:(NSArray *)responseData {
    for (id<MKAnnotation> annotation in _mapView.annotations) {
        if ( [annotation isKindOfClass:[ MKUserLocation class]] ) {
        }
        else {
            [_mapView removeAnnotation:annotation];
        }
        
    }
    
    for (int i = 0; i < [responseData count]; i++) {
        //NSDictionary* singleEvent = [[responseData objectAtIndex:i] ];
        
        NSNumber * latitude = [[responseData objectAtIndex:i] latitude];
        NSNumber * longitude = [[responseData objectAtIndex:i] longitude];
        NSString * name = [[responseData objectAtIndex:i] eventName];
        NSString * address = [[responseData objectAtIndex:i] eventAddress];
        NSNumber * identifier = [[responseData objectAtIndex:i] idNumber];
        
        //NSLog(@"finished %i", i);
        
        CLLocationCoordinate2D coordinate;
        coordinate.latitude = latitude.doubleValue;
        coordinate.longitude = longitude.doubleValue;
        eventSpot *annotation = [[eventSpot alloc] initWithName:name address:address coordinate:coordinate identifier:identifier];
        [_mapView addAnnotation:annotation];
        //NSLog(@"Annotation ident: %@", annotation.identi);
    }
    NSLog(@"finished");
    
    for (NSArray * row in responseData) {
    }
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
        pinView.image = [UIImage imageNamed:@"map-marker.png"];
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
                annotationView.image = [UIImage imageNamed:@"map-marker.png"];
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
/*
-(void)showDetails:(id)sender
{
    NSLog(@"button clicked, sender-id: %@", sender );
    
    //[self performSegueWithIdentifier: @"goToDetailView" sender: self];
}
 */

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
