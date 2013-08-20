//
//  APCommandType.h
//  AskingPointLib
//
//  Created by AskingPoint on 3/27/12.
//  Copyright (c) 2012 KnowFu Inc. All rights reserved.
//
#import <AskingPoint/APContext.h>
#import <AskingPoint/APCommand.h>

@protocol APCommandManagerDelegate
@required
-(void)commandManager:(APCommandManager*)commandManager executeCommand:(APCommand*)command;
-(void)commandManager:(APCommandManager*)commandManager reportAlertResponseForCommand:(APCommand*)command button:(APAlertButton*)pressed;
@end

@interface APCommandManager : NSObject

@property(nonatomic,assign) id<APCommandManagerDelegate> commandDelegate;

-(void)requestCommandsWithTag:(NSString*)tag;
-(void)reportAlertResponseForCommand:(APCommand*)command button:(APAlertButton*)button;

@end
