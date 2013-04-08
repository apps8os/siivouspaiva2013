//
//  AppDelegate.m
//  Siivouspaiva
//
//  Created by Fabian on 23.03.13.
//  Copyright (c) 2013 Fabian Häusler. All rights reserved.
//

#import "AppDelegate.h"
#import "spSingleEvent.h"

@interface AppDelegate (private)

-(void)reachabilityChanged:(NSNotification*)note;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    NSLog(@"Finished launching");
    self.events = [NSMutableArray array];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    
    Reachability * reach = [Reachability reachabilityWithHostname:@"www.google.com"];
    
    reach.reachableBlock = ^(Reachability * reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            //blockLabel.text = @"Block Says Reachable";
            NSLog(@"Block Says Reachable");
            [self getData];
        });
    };
    
    reach.unreachableBlock = ^(Reachability * reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            //blockLabel.text = @"Block Says Unreachable";
            NSLog(@"Block Says Unreachable");
        });
    };
    
    [reach startNotifier];
    
    
    return YES;    
}


-(void)reachabilityChanged:(NSNotification*)note
{
    Reachability * reach = [note object];
    
    if([reach isReachable])
    {
    }
    else
    {
    }
}


							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)getData
{
    //only activate if network data connection is available
    // if not load local data!!!!

    NSURL *url = [NSURL URLWithString:@"http://siivouspaiva.com/data.php?query=load"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    
    NSString *jsonData = [NSString stringWithFormat:@"um=-90&uM=90&vm=-180&vM=180"];
    NSData *requestData = [jsonData dataUsingEncoding:NSUTF8StringEncoding];
    NSString* requestDataLengthString = [[NSString alloc] initWithFormat:@"%d", [requestData length]];
    [request setValue:requestDataLengthString forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:requestData];
    NSLog(@"Sending Content: %@", requestDataLengthString);
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
    dispatch_async(queue, ^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        NSURLResponse *response = nil;
        NSError *error = nil;
        
        NSData *responseData = [NSURLConnection sendSynchronousRequest:request
                                                     returningResponse:&response
                                                                 error:&error];
        
        NSArray* eventLocations = [NSJSONSerialization
                                   JSONObjectWithData:responseData
                                   options:kNilOptions
                                   error:&error];
        // initialize objects
        [self convertDataToEvents:eventLocations];
    });
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)convertDataToEvents:(NSArray *)responseData
{
    for (int i = 0; i < [responseData count]; i++) {
        NSDictionary* singleEvent = [responseData objectAtIndex:i];
        
        NSNumber *latitude = [singleEvent objectForKey:@"u"];
        NSNumber *longitude = [singleEvent objectForKey:@"v"];
        NSString *name = [singleEvent objectForKey:@"name"];
        NSString *address = [singleEvent objectForKey:@"address"];
        NSNumber *identifier = [singleEvent objectForKey:@"id"];
        NSString *description = [singleEvent objectForKey:@"description"];
        NSString *tags = [singleEvent objectForKey:@"tags"];
        NSURL *link = [NSURL URLWithString:[singleEvent objectForKey:@"link"]];
        
        NSNumber *startHour = [singleEvent objectForKey:@"start_hour"];
        NSNumber *startMinute = [singleEvent objectForKey:@"start_minute"];
        NSNumber *endHour = [singleEvent objectForKey:@"end_hour"];
        NSNumber *endMinute = [singleEvent objectForKey:@"end_minute"];
        
        spSingleEvent *newEvent = [spSingleEvent eventWithName:name
                                                       address:address
                                                   description:description
                                                     beginHour:startHour
                                                   beginMinute:startMinute
                                                       endHour:endHour
                                                     endMinute:endMinute
                                                      idNumber:identifier
                                                          link:link
                                                          tags:tags
                                                      latitude:latitude
                                                     longitude:longitude];
        [self.events addObject:newEvent];
        //NSLog(@"Event added with ID: %@",newEvent.idNumber);
    }
    
    NSLog(@"Last Event ext ID: %@", [self.events.lastObject idNumber]);
    
    NSNotificationCenter *note = [NSNotificationCenter defaultCenter];

    [note postNotificationName:@"finishedDataLoading" object:@"Done dude."];

}


/*

#pragma mark Persitent State
- (NSURL*)applicationDataDirectory {
    NSFileManager* sharedFM = [NSFileManager defaultManager];
    NSArray* possibleURLs = [sharedFM URLsForDirectory:NSApplicationSupportDirectory
                                             inDomains:NSUserDomainMask];
    NSURL* appSupportDir = nil;
    NSURL* appDirectory = nil;
    
    if ([possibleURLs count] >= 1) {
        // Use the first directory (if multiple are returned)
        appSupportDir = [possibleURLs objectAtIndex:0];
    }
    
    // If a valid app support directory exists, add the
    // app's bundle ID to it to specify the final directory.
    if (appSupportDir) {
        NSString* appBundleID = [[NSBundle mainBundle] bundleIdentifier];
        appDirectory = [appSupportDir URLByAppendingPathComponent:appBundleID];
    }
    
    return appDirectory;
}

- (NSString*) pathToSavedEvents{
    NSURL *applicationSupportURL = [self applicationDataDirectory];
    
    if (! [[NSFileManager defaultManager] fileExistsAtPath:[applicationSupportURL path]]){
        
        NSError *error = nil;
        
        [[NSFileManager defaultManager] createDirectoryAtPath:[applicationSupportURL path]
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:&error];
        
        if (error){
            NSLog(@"error creating app support dir: %@", error);
        }
        
    }
    NSString *path = [[applicationSupportURL path] stringByAppendingPathComponent:@"savedEvents.plist"];
    
    return path;
}

- (void) loadEvents{
    
    NSString *path = [self pathToSavedEvents];
    NSLog(@"loadFeeds: %@", path);
    
    //self.feeds = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
}


- (void) saveEvents{
    //[NSKeyedArchiver archiveRootObject:self.feeds toFile:[self pathToSavedEvents]];
}


*/
@end
