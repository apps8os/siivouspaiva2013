//
//  APManager.h
//  AskingPointLib
//
//  Copyright (c) 2012 KnowFu Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AskingPoint/APCommand.h>

@class CLLocation;

// Return YES if the command was processed, NO to use the default handler
typedef BOOL (^APManagerCommandHandler)(APCommand *command);
typedef void (^APManagerAlertResponse)(APCommand *command, APAlertButton *pressed);

@interface APManager : NSObject

// System root view controller
// defaults to [[[UIApplication sharedApplication] keyWindow] rootViewController]
@property(nonatomic,retain) UIViewController *rootViewController;

@property(nonatomic,copy) APManagerCommandHandler commandHandler;
@property(nonatomic,copy) APManagerAlertResponse alertResponse;

+(APManager *)sharedManager;
+(void)startup:(NSString *)apiKey;
+(void)setLocalizedAppName:(NSString*)localizedAppName;
+(NSString*)localizedAppName;

+(void)setAppVersion:(NSString*)appVersion;

+(void)addEventWithName:(NSString *)name;
+(void)addEventWithName:(NSString *)name andData:(NSDictionary *)data;

+(void)startTimedEventWithName:(NSString *)name;
+(void)startTimedEventWithName:(NSString *)name andData:(NSDictionary *)data;
+(void)stopTimedEventWithName:(NSString *)name;
+(void)stopTimedEventWithName:(NSString *)name andData:(NSDictionary *)data;

+(void)setGender:(NSString *)gender;     // M or F
+(void)setAge:(int)age;
+(void)setLocation:(CLLocation *)location;

+(void)requestCommandsWithTag:(NSString*)tag;
+(void)reportAlertResponseForCommand:(APCommand*)command button:(APAlertButton*)pressed;

+(void)sendIfNeeded;

+(void)setOptedOut:(BOOL)optedOut;
+(BOOL)optedOut;

// System root view controller
// defaults to [[[UIApplication sharedApplication] keyWindow] rootViewController]
+(void)setRootViewController:(UIViewController*)rootViewController;

@end
