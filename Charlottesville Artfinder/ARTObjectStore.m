//
//  ARTObjectStore.m
//  Charlottesville Artfinder
//
//  Created by Alex Ramey on 7/23/14.
//  Copyright (c) 2014 HooApps. All rights reserved.
//

#import "ARTObjectStore.h"
#import "ARTParseRESTClient.h"
#import "ARTGoogleCalendarClient.h"
#import "ARTVenue.h"
#import "ARTEvent.h"

@implementation ARTObjectStore

+(ARTObjectStore *)sharedStore
{
    static ARTObjectStore *sharedStore = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedStore = [[ARTObjectStore alloc] init];
    });
    
    return sharedStore;
}

+(NSArray *)primaryCategories
{
    return @[@"Dance", @"Gallery", @"Music", @"Theatre", @"Venue"];
}

-(id)init
{
    self = [super init];
    
    if (self)
    {
        [MagicalRecord setupCoreDataStackWithStoreNamed:@"Artfinder.sqlite"];
        
        _parseClient = [ARTParseRESTClient sharedClient];
        _googleClient = [ARTGoogleCalendarClient sharedClient];
    }
    
    return self;
}

-(void)loadLatestVenuesWithCompletion:(void (^)(NSError *))completion
{
    ARTVenue *newestListing = [ARTVenue MR_findFirstOrderedByAttribute:@"updatedAt" ascending:NO];
    
    NSDate *date;
    
    if (newestListing)
    {
        date = newestListing.updatedAt;
    }
    else
    {
        date = [NSDate dateWithTimeIntervalSince1970:0.0];
    }
    
    [_parseClient getAllVenuesUpdatedSinceDate:date completion:^(NSDictionary *result, NSError *error){
         if (result)
         {
             NSArray *venues = [result objectForKey:@"results"];
             
             if ([venues count] > 0)
             {
                 //overwrite the old ones with their updated version
                 
                 NSMutableDictionary *newVenues = [[NSMutableDictionary alloc] init];
                 
                 [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
                     
                     NSMutableArray *parseObjectIDs = [[NSMutableArray alloc] init];
                     
                     for (NSDictionary *venue in venues)
                     {
                         [parseObjectIDs addObject:[venue objectForKey:@"objectId"]];
                     }
                     
                     NSPredicate *venueFilter = [NSPredicate predicateWithFormat:@"parseObjectID IN %@", parseObjectIDs];
                     
                     NSArray *duplicateVenues = [ARTVenue MR_findAllWithPredicate:venueFilter inContext:localContext];
                     
                     if(duplicateVenues)
                     {
                         for (ARTVenue *duplicate in duplicateVenues)
                         {
                             [duplicate MR_deleteEntity];
                         }
                     }
                     
                     NSArray *newImports = [ARTVenue MR_importFromArray:venues inContext:localContext];
                     //TODO: SAVE BASED ON PARSE OBJECT ID
                     for (ARTVenue *venue in newImports)
                     {
                         venue.localImagePath = [[ARTObjectStore filePathForKey:venue.organizationName] absoluteString];
                         
                         if (venue.imageURL && [[venue.imageURL stringByReplacingOccurrencesOfString:@" " withString:@""] length] > 0)
                         {
                             [newVenues setObject:[NSURL URLWithString:venue.imageURL] forKey:[NSURL URLWithString:venue.localImagePath]];
                         }
                     }
                     
                 } completion:^(BOOL success, NSError *error) {
                     if (success)
                     {
                         [self fetchImageDataForVenues:newVenues completion:^(NSError *error) {
                             if (!error)
                             {
                                 //create thubmnails
                                 [self loadThumbnailsForVenues:newVenues completion:completion];
                             }
                             else
                             {
                                 completion(error);
                             }
                         }];
                     }
                     else if (!error)
                     {
                         NSError *err = [[NSError alloc] initWithDomain:NSPOSIXErrorDomain code:555 userInfo: @{NSLocalizedDescriptionKey : @"Magical Error"}];
                         completion(err);
                     }
                     else
                     {
                         completion(error);
                     }
                 }];
             }
             else
             {
                 completion(nil);
             }
         }
         else
         {
             completion(error);
         }
     }];
}

-(void)fetchImageDataForVenues:(NSDictionary *)venues completion:(void (^)(NSError *))completion
{
    dispatch_queue_t queue = dispatch_queue_create("Image_Fetch_Handler", NULL);
    
    NSArray *keys = [venues allKeys];
    
    if ([keys count] == 0)
    {
        completion(nil);
        return;
    }
    
    __block int downloadCounter = [keys count];
    __block NSError *err = nil;
    
    for (NSURL *localURL in keys)
    {
        [_parseClient downloadFileFromURL:[venues objectForKey:localURL] toPath:localURL completion:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
            
            if (error)
            {
                dispatch_async(queue, ^{
                    err = error;
                });
            }
            
            dispatch_async(queue, ^{
                if (--downloadCounter == 0)
                {
                    completion(err);
                }
            });
            
        }];
    }
    
}

-(void)loadThumbnailsForVenues:(NSDictionary *)venues completion:(void (^)(NSError *))completion
{
    NSArray *keySet = [venues allKeys];
    
    if ([keySet count] == 0)
    {
        completion(nil);
        return;
    }
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"localImagePath IN %@", keySet];
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        
        NSArray *artVenues = [ARTVenue MR_findAllWithPredicate:predicate inContext:localContext];
        
        for (ARTVenue *venue in artVenues)
        {
            [venue createThumbnailData];
        }
        
    } completion:^(BOOL success, NSError *error) {
        if (success)
        {
            NSLog(@"Data created and saved");
            completion(nil);
        }
        else if (!error)
        {
            NSError *err = [[NSError alloc] initWithDomain:NSPOSIXErrorDomain code:555 userInfo: @{NSLocalizedDescriptionKey : @"Magical Error"}];
            completion(err);
        }
        else
        {
            completion(error);
        }
    }];
}

-(void)loadAllEventsWithCompletion:(void (^)(NSError *))completion
{
    [_googleClient getAllEventsStartingWithDate:nil completion:^(NSArray *result, NSArray *eventCategories, NSError *error){
        if (result)
        {
            if ([result count] > 0)
            {
                //delete all the old events, save all the new events
                
                [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
                    
                    NSArray *oldEvents = [ARTEvent MR_findAllInContext:localContext];
                    
                    for (ARTEvent *e in oldEvents)
                    {
                        [e MR_deleteEntity];
                    }
                    
                    NSArray *newEvents = [ARTEvent MR_importFromArray:result inContext:localContext];
                    
                    for (int i = 0; i < [newEvents count]; i++)
                    {
                        ((ARTEvent *)newEvents[i]).category = eventCategories[i];
                    }
                    
                } completion:^(BOOL success, NSError *error) {
                    if (success)
                    {
                        completion(nil);
                    }
                    else if (!error)
                    {
                        NSError *err = [[NSError alloc] initWithDomain:NSPOSIXErrorDomain code:555 userInfo: @{NSLocalizedDescriptionKey : @"Magical Error"}];
                        completion(err);
                    }
                    else
                    {
                        completion(error);
                    }
                    
                }];
            }
            else
            {
                completion(nil);
            }
            
        }
        else
        {
            completion(error);
        }
        
    }];
}

#pragma mark - Incomplete Implementation
//TODO: Filter out venues for which isDeleted == YES

-(NSArray *)allVenues
{
    return [ARTVenue MR_findAll];
}

-(NSArray *)allVenuesOfPrimaryCategory:(NSString *)category
{
    NSPredicate *predicate = nil;
    
    NSMutableArray *primaryCategoriesWithoutVenue = [[ARTObjectStore primaryCategories] mutableCopy];
    [primaryCategoriesWithoutVenue removeLastObject];
    
    for (NSString *str in primaryCategoriesWithoutVenue)
    {
        if ([str caseInsensitiveCompare:category] == NSOrderedSame)
        {
            if ([str caseInsensitiveCompare:@"Theatre"] == NSOrderedSame)
            {
                predicate = [NSPredicate predicateWithFormat:@"primaryCategory IN %@", @[str, @"Theater"]];
            }
            else
            {
                 predicate = [NSPredicate predicateWithFormat:@"primaryCategory IN %@", @[str]];
            }
        }
    }
    
    if (!predicate)
    {
        predicate = [NSPredicate predicateWithFormat:@"NOT (primaryCategory IN %@)", primaryCategoriesWithoutVenue];
    }
    
    return [ARTVenue MR_findAllWithPredicate:predicate];
}

-(NSArray *)allEventsOnDate:(NSDate *)date
{
    //Note: You can only trust the day, month, year components of this date
    //ALSO: You have to get the day, month, year of this date in the current locale
    
    uint32_t UNIX = (int)[date timeIntervalSince1970];
    uint32_t extraSeconds = UNIX % (24 * 60 * 60);
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:UNIX - extraSeconds];
    
    //MBCalendarKit uses current locale
    //since the current locale is eastern time (-04:00 offset from GMT)
    //we have to know that MBCalendarKit wants events for the previous day
    //if the GMT is less than 4 hours into the day
    if (extraSeconds < 4 * 60 * 60)
    {
        startDate = [NSDate dateWithTimeIntervalSince1970:[startDate timeIntervalSince1970] - 24 * 60 * 60];
    }
    
    //Now that we've determined the eastern time date, we have to adjust our query to account for the fact that our venues are stored as GMT
    NSDate *queryStartDate = [NSDate dateWithTimeIntervalSince1970:[startDate timeIntervalSince1970] + 4 * 60 * 60];
    
    NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:([queryStartDate timeIntervalSince1970] + 24 * 60 * 60 - 1)];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(startDate >= %@) AND (startDate <= %@)", queryStartDate, endDate];
    
    NSArray *nonSpanningEvents = [ARTEvent MR_findAllWithPredicate:predicate];
    
    NSPredicate *spanPredicate = [NSPredicate predicateWithFormat:@"(spanStartDate <= %@) AND (spanEndDate > %@)",startDate,startDate];
    
    NSArray *spanningEvents = [ARTEvent MR_findAllWithPredicate:spanPredicate];
    
    NSMutableArray *results = [NSMutableArray arrayWithArray:nonSpanningEvents];
    [results addObjectsFromArray:spanningEvents];
    
    return results;
}

-(NSArray *)eventsWithEventID:(NSString *)eventID
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"eventID IN %@", @[eventID]];
    return [ARTEvent MR_findAllWithPredicate:predicate];
}

+(NSURL *)filePathForKey:(NSString *)key
{
    NSArray *cacheDirectories = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    
    NSString *cacheDirectory = [cacheDirectories objectAtIndex:0];
    
    return [NSURL fileURLWithPath:[cacheDirectory stringByAppendingPathComponent:key]];
}

-(void)cleanUp
{
    // Clean up before application terminates
    [MagicalRecord cleanUp];
}

@end