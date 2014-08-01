//
//  AppDelegate.m
//  Charlottesville Artfinder
//
//  Created by Alex Ramey on 7/10/14.
//  Copyright (c) 2014 HooApps. All rights reserved.
//

#import "AppDelegate.h"
#import "ARTTheme.h"
#import "ARTObjectStore.h"
#import "ARTURLCache.h"

@implementation AppDelegate

NSString * const ART_IS_FIRST_LAUNCH_KEY = @"ART_IS_FIRST_LAUNCH_KEY";

+(void)initialize
{
    //Register Factory Defaults, which will be created and temporarily stored in the registration
    //domain of NSUserDefaults. In the application domain, if no value has been assigned yet to a
    //specified key, then the application will look in the registration domain. The application domain
    //persists, so once a value has been set, factory defaults will always be ignored
    
    NSDictionary *defaults = @{
                               ART_IS_FIRST_LAUNCH_KEY : @YES,
                               };
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaults];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    //Prevent automatic caching
    ARTURLCache *uc = [[ARTURLCache alloc] init];
    [NSURLCache setSharedURLCache:uc];
    
    [ARTTheme setupTheme];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
    UIViewController *viewController = [storyboard instantiateInitialViewController];
    self.window.rootViewController = viewController;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
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
    // Clean up before application terminates
    ARTObjectStore *sharedStore = [ARTObjectStore sharedStore];
    [sharedStore cleanUp];
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end