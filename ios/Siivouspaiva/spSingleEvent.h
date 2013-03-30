//
//  spSingleEvent.h
//  Siivouspaiva
//
//  Created by Fabian on 29.03.13.
//  Copyright (c) 2013 Fabian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface spSingleEvent : NSObject

@property (strong) NSString *name; 
@property (strong) NSString *address;
@property (strong) NSString *description;

@property (readwrite) int beginHour;
@property (readwrite) int beginMinute;
@property (readwrite) int endHour;
@property (readwrite) int endMinute;
@property (readwrite) int idNumber;

@property (strong) NSString *tags;
@property (strong) NSURL *link;

@property (readwrite) float latitude;
@property (readwrite) float longitude;

+ (id) eventWithName:(NSString*)inName address:(NSString *)inAddress description:(NSString*)inDescription beginHour:(int)inBeginHour beginMinute:(int)inBeginMinute endHour:(int)inEndHour endMinute:(int)inEndMinute idNumber:(int)inIDNumber link:(NSURL*)inLink tags:(NSString*)inTags latitude:(float)inLatitude longitude:(float)inLongitude;

@end
