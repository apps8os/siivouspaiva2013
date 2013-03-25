//
//  FirstViewController.h
//  Siivouspaiva
//
//  Created by Fabian on 23.03.13.
//  Copyright (c) 2013 Fabian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface FirstViewController : UIViewController <MKMapViewDelegate>
{
    IBOutlet UIBarButtonItem *refreshButton;
    MKUserLocation *currentUserLocation;
}
@property (nonatomic, strong) IBOutlet MKMapView *_mapView;

- (IBAction)refreshButton:(id)sender;
- (IBAction)updateUserLocation:(id)sender;
@end
