//
//  BasicNavigationBar.m
//  Siivouspaiva
//
//  Created by Fabian on 02.04.13.
//  Copyright (c) 2013 Fabian. All rights reserved.
//

#import "BasicNavigationBar.h"

@implementation BasicNavigationBar
@synthesize myMainNavigationBar;


- (id)initWithFrame:(CGRect)frame
{

    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
- (void)drawRect:(CGRect)rect {
    UIImage *image = [UIImage imageNamed: @"tab-bar.png"];
    [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
}
*/
@end
