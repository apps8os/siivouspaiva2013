//
//  FirstViewController.m
//  Siivouspaiva
//
//  Created by Fabian on 23.03.13.
//  Copyright (c) 2013 Fabian. All rights reserved.
//

#import "FirstViewController.h"
#import "MyLocation.h"

@interface FirstViewController ()

@end

@implementation FirstViewController
@synthesize _mapView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self._mapView.delegate = self;
}
- (void)viewWillAppear:(BOOL)animated {

    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = 60.170208;
    zoomLocation.longitude= 24.938965;
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 800, 800);
    [_mapView setRegion:viewRegion animated:YES];
    
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    currentUserLocation = userLocation;
    NSLog(@"UserLocation: %f", currentUserLocation.coordinate.longitude);
    
    
    //Add a annotation
    //MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    //point.coordinate = userLocation.coordinate;
    //point.title = @"You are here";
    
    //[self.mapView addAnnotation:point];
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
        
        //NSLog(@"finished %i", i);
        
        CLLocationCoordinate2D coordinate;
        coordinate.latitude = latitude.doubleValue;
        coordinate.longitude = longitude.doubleValue;
        MyLocation *annotation = [[MyLocation alloc] initWithName:name address:address coordinate:coordinate];
        [_mapView addAnnotation:annotation];
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

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    static NSString *identifier = @"MyLocation";
    if ([annotation isKindOfClass:[MyLocation class]]) {
        
        MKAnnotationView *annotationView = (MKAnnotationView *) [mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            annotationView.enabled = YES;
            annotationView.canShowCallout = YES;
            annotationView.image = [UIImage imageNamed:@"arrest.png"];//here we use a nice image instead of the default pins
        } else {
            annotationView.annotation = annotation;
        }
        
        return annotationView;
    }
    
    return nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
