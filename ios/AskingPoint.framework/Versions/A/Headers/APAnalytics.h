//
//  APAnalytics.h
//  AskingPoint
//
//  Copyright (c) 2012 KnowFu Inc. All rights reserved.
//
#import <AskingPoint/APContext.h>

ASKINGPOINT_EXTERN NSString * const APUserGender;   // @"M" or @"F"
ASKINGPOINT_EXTERN NSString * const APUserAge;
ASKINGPOINT_EXTERN NSString * const APUserLocation; // CLLocation

typedef enum APEventType {
    APEventStartup      = 1,
    APEventShutdown     = 2,
    APEventEnvironment  = 3,
    APEventCustom       = 4,
    APEventUserData     = 7, // User info: age, gender, location
    APEventCommand      = 8, // Events triggered by user actions on a command (eg. webview)
    APEventCustomStart  = 9,
    APEventCustomStop   = 10
} APEventType;

@interface APEvent : NSObject
@property(nonatomic,readonly) APEventType type;
@property(nonatomic,readonly) NSString *name;
@property(nonatomic,readonly) NSDictionary *data;

+(id)eventWithName:(NSString*)name;
+(id)eventWithName:(NSString *)name andData:(NSDictionary*)data;

// Dictionary with APUser* fields
+(id)eventWithUserData:(NSDictionary*)userData;

@end

// Timed event start event. Call stopEvent to create a matching stop event.
@interface APTimedStartEvent : APEvent
@property(nonatomic,readonly) NSString *timedEventId;

-(APEvent*)stopEvent;
-(APEvent*)stopEventWithData:(NSDictionary*)data;

@end

@protocol APAnalyticsDelegate <NSObject>
@optional
- (void)analytics:(APAnalytics*)analytics willSendEvent:(APEvent*)event;
@end

@interface APAnalytics : NSObject

@property(nonatomic) BOOL optedOut;
@property(nonatomic,assign) id<APAnalyticsDelegate> delegate;

-(void)addEvent:(APEvent *)event;
-(void)sendIfNeeded;

@end
