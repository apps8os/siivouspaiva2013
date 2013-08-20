//
//  APCommand.h
//  AskingPointLib
//
//  Created by Kevin Koltzau on 5/29/13.
//  Copyright (c) 2013 KnowFu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum APCommandType {
    APCommandWeb,                   // Set for pop-ups using the WebView. E.g. survey
    APCommandAlert                  // Set for pop-up widgets. E.g. messages, Rating Booster
} APCommandType;

typedef enum APAlertType {
    APAlertUnknown,
    APAlertRating,                  // Ratings Booster widget
    APAlertMessage                  // Pull Message widget
} APAlertType;

typedef enum APAlertRatingButtonType {
    APAlertRatingNone,
    APAlertRatingYes,               // Will rate it
    APAlertRatingNo,                // Will not rate it
    APAlertRatingRemindMe           // Remind me to rate it later
} APAlertRatingButtonType;

@interface APCommand : NSObject
@property(nonatomic,readonly) APCommandType type;
@property(nonatomic,readonly) id commandId;
@property(nonatomic,readonly) BOOL test;                // YES, if showing as a result of a Dashboard Test being fired.
@property(nonatomic,readonly) NSSet *tags;              // List of all Tags set in the widgets dashboard Tag Editor.
@property(nonatomic,readonly) NSString *requestedTag;   // Tag that triggered this command response.
@end

@interface APCommand (Web)
@property(nonatomic,readonly) NSURL *url;               // URL the pop-up web view will take the user to.
@end

@interface APCommand (Alert)
@property(nonatomic,readonly) APAlertType alertType;
@property(nonatomic,copy) NSString *language;           // BCP 47 Language code (wikipedia.org/wiki/BCP_47).
@property(nonatomic,copy) NSString *title;              // Text to show in widget title bar.
@property(nonatomic,copy) NSString *message;            // Text to show in widget message body.
@property(nonatomic,readonly) NSArray *buttons;         // Array of APAlertButton items to show on widget.
@end

@interface APAlertButton : NSObject
@property(nonatomic,readonly) id buttonId;
@property(nonatomic,readonly) BOOL cancel;  // Follows Apple usability guidelines for Cancel buttons.
@property(nonatomic,readonly) NSURL *url;   // On Rating widget, the "Rate It" button contains a URL to the App's app store page. On a Message widget, Custom buttons have this set to URL added to button, else nil
@property(nonatomic,copy) NSString *text;   // Text that is shown on button, will be in language implied by APCommand language property.
@end

@interface APAlertButton (Rating)
@property(nonatomic,readonly) APAlertRatingButtonType ratingType;
@end
