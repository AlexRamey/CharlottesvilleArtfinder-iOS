//
//  AppDelegate.h
//  Charlottesville Artfinder
//
//  Created by Alex Ramey on 7/10/14.
//  Copyright (c) 2014 HooApps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>

extern NSString * const ART_IS_FIRST_LAUNCH_KEY;

extern NSString * const ART_LAST_REFRESH_KEY;

extern NSString * const ART_DANCE_TOGGLE_KEY;
extern NSString * const ART_GALLERY_TOGGLE_KEY;
extern NSString * const ART_MUSIC_TOGGLE_KEY;
extern NSString * const ART_THEATRE_TOGGLE_KEY;
extern NSString * const ART_VENUE_TOGGLE_KEY;

extern NSString * const ART_PCA_DESCRIPTION_KEY;

extern NSString * const ART_SELECTED_TAB_KEY;

@property (strong, nonatomic) UIWindow *window;

+(NSString *)toggleKeyForCategory:(NSString *)category;

- (NSURL *)applicationDocumentsDirectory;

@end
