//
//  FirstViewController.m
//  Siivouspaiva
//
//  Created by Fabian on 23.03.13.
//  Copyright (c) 2013 Fabian Häusler. All rights reserved.
//

//#define mBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#import "FirstViewController.h"
#import "eventSpot.h"

@interface FirstViewController ()

@end

@implementation FirstViewController
@synthesize _mapView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    //[self prepareForSegue:[UIStoryboardSegue segueWithIdentifier:@"second" source:self destination:self performHandler:nil] sender:self];
    
    self._mapView.delegate = self;
    
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = 60.170208;
    zoomLocation.longitude= 24.938965;
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 800, 800);
    [_mapView setRegion:viewRegion animated:YES];
    

}
- (void)viewWillAppear:(BOOL)animated {

    
    //[super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    //[super viewDidAppear:animated];
}


- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    currentUserLocation = userLocation;
    NSLog(@"UserLocation: %f", currentUserLocation.coordinate.longitude);
    
}

- (IBAction)refreshButton:(id)sender
{
    NSLog(@"Refresh Triggered");
    [self getData];
}

- (IBAction)updateUserLocation:(id)sender{
    NSLog(@"buttontoupdate");
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(currentUserLocation.coordinate, 800, 800);
    [_mapView setRegion:viewRegion animated:YES];
}

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
    
    //all data: @"um=-90&uM=90&vm=-180&vM=180";
    NSString *jsonData = [NSString stringWithFormat:@"um=%f&uM=%f&vm=%f&vM=%f", userCoordinateLat1, userCoordinateLat2, userCoordinateLon1, userCoordinateLon2];
    NSLog(@"jsonString: %@", jsonData);
    
    NSData *requestData = [jsonData dataUsingEncoding:NSUTF8StringEncoding];
    NSString* requestDataLengthString = [[NSString alloc] initWithFormat:@"%d", [requestData length]];
    [request setValue:requestDataLengthString forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:requestData];
    
    NSLog(@"Sending Content: %@", requestDataLengthString);
    
    NSURLResponse *response = NULL;
    NSError *requestError = NULL;
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&requestError];
    //NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    NSError* error;
    NSArray* eventLocations = [NSJSONSerialization
                               JSONObjectWithData:responseData
                               options:kNilOptions
                               error:&error];
    //NSLog(@"locations: %@", eventLocations);
    
    [self plotEventLocations:eventLocations];
    
    
    /*
     // 1) Get the latest event
     NSDictionary* singleEvent = [eventLocations objectAtIndex:0];
     
     // 2) Get the funded amount and loan amount
     NSNumber* coordinateUdata = [singleEvent objectForKey:@"u"];
     NSNumber* coordinateVdata = [singleEvent objectForKey:@"v"];
     float eventCooU = [coordinateUdata floatValue];
     float eventCooV = [coordinateVdata floatValue];
     
     3) Set the label appropriately
     finalTextLabel.text = [NSString stringWithFormat:@"Event: %@ is here: %f , %f",
     [singleEvent objectForKey:@"name"],
     eventCooU, eventCooV];
     */
    
}
- (void)plotEventLocations:(NSArray *)responseData {
    for (id<MKAnnotation> annotation in _mapView.annotations) {
        [_mapView removeAnnotation:annotation];
    }
    
    for (int i = 0; i < [responseData count]; i++) {
        NSDictionary* singleEvent = [responseData objectAtIndex:i];
        
        NSNumber * latitude = [singleEvent objectForKey:@"u"];
        NSNumber * longitude = [singleEvent objectForKey:@"v"];
        NSString * name =[singleEvent objectForKey:@"name"];
        NSString * address = [singleEvent objectForKey:@"address"];
        NSNumber * identifier = [singleEvent objectForKey:@"id"];
        
        //NSLog(@"finished %i", i);
        
        CLLocationCoordinate2D coordinate;
        coordinate.latitude = latitude.doubleValue;
        coordinate.longitude = longitude.doubleValue;
        eventSpot *annotation = [[eventSpot alloc] initWithName:name address:address coordinate:coordinate identifier:identifier];
        [_mapView addAnnotation:annotation];
        NSLog(@"Annotation ident: %@", annotation.identi);
    }
    NSLog(@"finished");
    /*
     for (NSArray * row in responseData) {
     
     //NSDictionary* singleEvent = [responseData row];
     
     
     NSNumber * latitude = [row objectAtIndex:12];
     NSNumber * longitude = [row objectAtIndex:13];
     NSString * name =[row objectAtIndex:8];
     NSString * address = [row objectAtIndex:1];
     
     CLLocationCoordinate2D coordinate;
     coordinate.latitude = latitude.doubleValue;
     coordinate.longitude = longitude.doubleValue;
     MyLocation *annotation = [[MyLocation alloc] initWithName:name address:address coordinate:coordinate] ;
     [mapView addAnnotation:annotation];
     
     
     } */
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
                
                UIButton *btnViewVenue = [UIButton buttonWithType: UIButtonTypeDetailDisclosure];
                
                [btnViewVenue addTarget:self action:@selector(showDetails:) forControlEvents:UIControlEventTouchUpInside];
                
                //NSInteger annotationV = [self._mapView.annotations indexOfObject:annotation];
                NSNumber *annotationV = [self._mapView.annotations[[self._mapView.annotations indexOfObject:annotation]] identi];
                NSLog(@"annotationValue: %@", annotationV);
                btnViewVenue.tag = [annotationV intValue];
                
                annotationView.rightCalloutAccessoryView = btnViewVenue;
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

-(void)showDetails:(id)sender
{
    NSLog(@"button clicked, sender-id: %i", [sender tag]);
    
    [self performSegueWithIdentifier: @"goToSecondView" sender: self];


}

- (IBAction)backToMapScreen:(id)sender
{
    NSLog(@"BackButton has been clicked");
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
