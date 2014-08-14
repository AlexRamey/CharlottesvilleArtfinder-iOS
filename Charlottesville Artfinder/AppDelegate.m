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
#import "Flurry.h"

@implementation AppDelegate

NSString * const ART_IS_FIRST_LAUNCH_KEY = @"ART_IS_FIRST_LAUNCH_KEY";

NSString * const ART_LAST_REFRESH_KEY = @"ART_LAST_REFRESH_KEY";

NSString * const ART_DANCE_TOGGLE_KEY = @"ART_DANCE_TOGGLE_KEY";
NSString * const ART_GALLERY_TOGGLE_KEY = @"ART_GALLERY_TOGGLE_KEY";
NSString * const ART_MUSIC_TOGGLE_KEY = @"ART_MUSIC_TOGGLE_KEY";
NSString * const ART_THEATRE_TOGGLE_KEY = @"ART_THEATRE_TOGGLE_KEY";
NSString * const ART_VENUE_TOGGLE_KEY = @"ART_VENUE_TOGGLE_KEY";

NSString * const ART_PCA_DESCRIPTION_KEY = @"ART_PCA_DESCRIPTION_KEY";

+(void)initialize
{
    //Register Factory Defaults, which will be created and temporarily stored in the registration
    //domain of NSUserDefaults. In the application domain, if no value has been assigned yet to a
    //specified key, then the application will look in the registration domain. The application domain
    //persists, so once a value has been set, factory defaults will always be ignored
    
    NSString *defaultPCADescription = @"Piedmont Council for the Arts (PCA) is the designated arts agency of Charlottesville and Albemarle. PCA encourages community-wide access to and appreciation for the arts through programs and services for artists, arts organizations, and their audiences. The PCA website provides the most comprehensive arts-related information in the area as we work to inform residents and visitors about cultural resources and to showcase the Charlottesville region as an arts destination.";
    
    NSDictionary *defaults = @{
                               ART_IS_FIRST_LAUNCH_KEY : @YES,
                               ART_LAST_REFRESH_KEY : @0,
                               ART_DANCE_TOGGLE_KEY : @YES,
                               ART_GALLERY_TOGGLE_KEY : @YES,
                               ART_MUSIC_TOGGLE_KEY : @YES,
                               ART_THEATRE_TOGGLE_KEY : @YES,
                               ART_VENUE_TOGGLE_KEY : @YES,
                               ART_PCA_DESCRIPTION_KEY : defaultPCADescription
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
    
    [Flurry setCrashReportingEnabled:YES];
    
    [Flurry startSession:@"85F7M5858KHZ4W4C3YBK"];
    
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

#pragma mark - Toggle Key Helper
+(NSString *)toggleKeyForCategory:(NSString *)category
{
    if ([category caseInsensitiveCompare:@"Dance"] == NSOrderedSame)
    {
        return ART_DANCE_TOGGLE_KEY;
    }
    else if ([category caseInsensitiveCompare:@"Gallery"] == NSOrderedSame)
    {
        return ART_GALLERY_TOGGLE_KEY;
    }
    else if ([category caseInsensitiveCompare:@"Music"] == NSOrderedSame)
    {
        return ART_MUSIC_TOGGLE_KEY;
    }
    else if ([category caseInsensitiveCompare:@"Theatre"] == NSOrderedSame)
    {
        return ART_THEATRE_TOGGLE_KEY;
    }
    else
    {
        return ART_VENUE_TOGGLE_KEY;
    }
}

#pragma mark - Background App Refresh

-(BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UIApplication sharedApplication] setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    return YES;
}

-(void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    __block NSError *error = nil;
    
    ARTObjectStore *sharedStore = [ARTObjectStore sharedStore];
    [sharedStore loadLatestVenuesWithCompletion:^(NSError *err) {
        if (err)
        {
            error = err;
        }
        [sharedStore loadAllEventsWithCompletion:^(NSError *e) {
            if (e)
            {
                error = e;
            }
            [sharedStore loadPCAInformationWithCompletion:^(NSError *ARTError) {
                if (ARTError)
                {
                    error = ARTError;
                }
                if (error)
                {
                    completionHandler(UIBackgroundFetchResultFailed);
                }
                else
                {
                    NSInteger UNIX = [[NSDate date] timeIntervalSince1970];
                    NSInteger lastRefresh = [[[NSUserDefaults standardUserDefaults] objectForKey:ART_LAST_REFRESH_KEY] intValue];
                    if (UNIX - lastRefresh < 24 * 60 * 60)
                    {
                        completionHandler(UIBackgroundFetchResultNoData);
                    }
                    else
                    {
                        completionHandler(UIBackgroundFetchResultNewData);
                    }
                    
                    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:UNIX] forKey:ART_LAST_REFRESH_KEY];
                }
            }];
        }];
    }];
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
