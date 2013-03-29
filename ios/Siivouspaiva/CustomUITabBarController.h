//
//  CustomUITabBarController.h
//  Siivouspaiva
//
//  Created by Fabian on 25.03.13.
//  Copyright (c) 2013 Fabian Häusler. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomUITabBarController : UITabBarController
{
    IBOutlet UITabBar *myTabBar;
}
@property(nonatomic, strong) UITabBar *myTabBar;
@end
