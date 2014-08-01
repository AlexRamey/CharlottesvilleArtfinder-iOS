//
//  ARTObjectStore.h
//  Charlottesville Artfinder
//
//  Created by Alex Ramey on 7/23/14.
//  Copyright (c) 2014 HooApps. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ARTParseRESTClient, ARTGoogleCalendarClient;

@interface ARTObjectStore : NSObject

@property (nonatomic) ARTParseRESTClient* parseClient;
@property (nonatomic) ARTGoogleCalendarClient* googleClient;

+(ARTObjectStore *)sharedStore;

+(NSArray *)primaryCategories;

+(NSURL *)filePathForKey:(NSString *)key;

-(void)loadLatestVenuesWithCompletion:(void (^)(NSError *))completion;

-(void)loadAllEventsWithCompletion:(void (^)(NSError *))completion;

-(NSArray *)allVenues;

-(NSArray *)allVenuesOfPrimaryCategory:(NSString *)category;

-(NSArray *)allEventsOnDate:(NSDate *)date;

-(NSArray *)eventsWithEventID:(NSString *)eventID;

-(void)cleanUp;

@end
