//
//  WebLinkViewController.h
//  Siivouspaiva
//
//  Created by Fabian on 04.04.13.
//  Copyright (c) 2013 Fabian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "spSingleEvent.h"

@interface WebLinkViewController : UIViewController <UIWebViewDelegate>

@property (strong, nonatomic) spSingleEvent *eventWithLink;

- (void)setNewEvent:(spSingleEvent*)inEvent;

@end
