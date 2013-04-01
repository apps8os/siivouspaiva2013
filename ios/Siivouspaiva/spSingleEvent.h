//
//  spSingleEvent.h
//  Siivouspaiva
//
//  Created by Fabian on 29.03.13.
//  Copyright (c) 2013 Fabian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface spSingleEvent : NSObject

@property (strong) NSString *eventName;
@property (strong) NSString *eventAddress;
@property (strong) NSString *description;

@property (strong) NSNumber *beginHour;
@property (strong) NSNumber *beginMinute;
@property (strong) NSNumber *endHour;
@property (strong) NSNumber *endMinute;
@property (strong) NSNumber *idNumber;

@property (strong) NSString *tags;
@property (strong) NSURL *link;

@property (strong) NSNumber *latitude;
@property (strong) NSNumber *longitude;

+ (id) eventWithName:(NSString*)inName address:(NSString *)inAddress description:(NSString*)inDescription beginHour:(NSNumber*)inBeginHour beginMinute:(NSNumber*)inBeginMinute endHour:(NSNumber*)inEndHour endMinute:(NSNumber*)inEndMinute idNumber:(NSNumber*)inIDNumber link:(NSURL*)inLink tags:(NSString*)inTags latitude:(NSNumber*)inLatitude longitude:(NSNumber*)inLongitude;

@end
