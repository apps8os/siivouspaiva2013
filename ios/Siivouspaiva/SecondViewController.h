//
//  SecondViewController.h
//  Siivouspaiva
//
//  Created by Fabian on 23.03.13.
//  Copyright (c) 2013 Fabian Häusler. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface SecondViewController : UIViewController <CLLocationManagerDelegate>
{
    IBOutlet UITableView *eventListTable;
    CLLocationManager *locationManager;
}

@end
