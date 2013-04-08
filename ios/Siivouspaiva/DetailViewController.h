//
//  DetailViewController.h
//  Siivouspaiva
//
//  Created by Fabian on 26.03.13.
//  Copyright (c) 2013 Fabian Häusler. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "spSingleEvent.h"

@interface DetailViewController : UIViewController <UITableViewDelegate, MKMapViewDelegate>
{
    IBOutlet UIButton *buttonLinkToEvent;
    IBOutlet UIButton *buttonShareEvent;
    IBOutlet UILabel *titleText;
    IBOutlet UILabel *addressText;
    IBOutlet UINavigationItem *mainNaviagtionTitle;
    IBOutlet UILabel *eventDescriptionField;
    IBOutlet UIImageView *timeSlider;
    
    
}
@property (strong) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) spSingleEvent *detailEvent;
@property (strong) IBOutlet UITableView *tableView;
@property (strong) IBOutlet UIView *headerView;
@property (strong) IBOutlet UIView *infoContainer;
@property (strong) IBOutlet UIView *timeInfoView;

- (IBAction)sendPost:(id)sender;

@end
