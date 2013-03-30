//
//  spSingleEvent.m
//  Siivouspaiva
//
//  Created by Fabian on 29.03.13.
//  Copyright (c) 2013 Fabian. All rights reserved.
//

#import "spSingleEvent.h"

@implementation spSingleEvent

+ (id) eventWithName:(NSString*)inName address:(NSString *)inAddress description:(NSString*)inDescription beginHour:(int)inBeginHour beginMinute:(int)inBeginMinute endHour:(int)inEndHour endMinute:(int)inEndMinute idNumber:(int)inIDNumber link:(NSURL*)inLink tags:(NSString*)inTags latitude:(float)inLatitude longitude:(float)inLongitude
{
    spSingleEvent *singleEvent = [[spSingleEvent alloc] init];
    
    singleEvent.name = inName;
    singleEvent.address = inAddress;
    singleEvent.description = inDescription;
    singleEvent.beginHour = inBeginHour;
    singleEvent.beginMinute = inBeginMinute;
    singleEvent.endHour = inEndHour;
    singleEvent.endMinute = inEndMinute;
    singleEvent.idNumber = inIDNumber;
    singleEvent.link = inLink;
    singleEvent.latitude = inLatitude;
    singleEvent.longitude = inLongitude;
    
    return singleEvent;
}

@end
