//
//  APContext.h
//  AskingPoint
//
//  Copyright (c) 2012 KnowFu Inc. All rights reserved.
//
#import <Foundation/Foundation.h>

#define AP_VERSION @"2.1"
extern NSString * const APVersion;

#if defined(__cplusplus)
#define ASKINGPOINT_EXTERN extern "C"
#else
#define ASKINGPOINT_EXTERN extern
#endif

@class APAnalytics;
@class APCommandManager;

@interface APContext : NSObject

@property(nonatomic,copy) NSString *localizedAppName;
@property(nonatomic,copy) NSString *appVersion;

+(void)startup:(NSString *)appKey;
+(APContext *)sharedContext;

@end

@interface APContext (APAnalytics)
@property(nonatomic,readonly) APAnalytics *analytics;
+(APAnalytics *)sharedAnalytics;
@end

@interface APContext (APCommandManager)
@property(nonatomic,readonly) APCommandManager *commandManager;
+(APCommandManager *)sharedCommandManager;
@end