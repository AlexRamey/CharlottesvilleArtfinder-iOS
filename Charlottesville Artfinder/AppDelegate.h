//
//  AppDelegate.h
//  Charlottesville Artfinder
//
//  Created by Alex Ramey on 7/10/14.
//  Copyright (c) 2014 HooApps. All rights reserved.
//

#import <UIKit/UIKit.h>

#warning - Incomplete Implementation

/*
 TODO:
 1. Implement Background App Refresh for the Events and Venues
 2. Put Images in App Bundle (hard-code a date)
 3. If First Launch, still download everything
*/


@interface AppDelegate : UIResponder <UIApplicationDelegate>

extern NSString * const ART_IS_FIRST_LAUNCH_KEY;

@property (strong, nonatomic) UIWindow *window;

- (NSURL *)applicationDocumentsDirectory;

@end
