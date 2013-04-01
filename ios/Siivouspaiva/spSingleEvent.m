//
//  spSingleEvent.m
//  Siivouspaiva
//
//  Created by Fabian on 29.03.13.
//  Copyright (c) 2013 Fabian. All rights reserved.
//

#import "spSingleEvent.h"

@implementation spSingleEvent

+ (id) eventWithName:(NSString*)inName address:(NSString *)inAddress description:(NSString*)inDescription beginHour:(NSNumber*)inBeginHour beginMinute:(NSNumber*)inBeginMinute endHour:(NSNumber*)inEndHour endMinute:(NSNumber*)inEndMinute idNumber:(NSNumber*)inIDNumber link:(NSURL*)inLink tags:(NSString*)inTags latitude:(NSNumber*)inLatitude longitude:(NSNumber*)inLongitude
{
    spSingleEvent *singleEvent = [[spSingleEvent alloc] init];
    
    singleEvent.eventName = inName;
    singleEvent.eventAddress = inAddress;
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
