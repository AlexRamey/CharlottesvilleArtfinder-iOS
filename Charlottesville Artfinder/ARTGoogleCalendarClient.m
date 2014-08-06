//
//  ARTGoogleCalendarClient.m
//  Charlottesville Artfinder
//
//  Created by Alex Ramey on 7/23/14.
//  Copyright (c) 2014 HooApps. All rights reserved.
//

#import "ARTGoogleCalendarClient.h"

#warning - Hard-Coded API Key

@implementation ARTGoogleCalendarClient

NSString *const danceURL = @"charlottesvillearts.org_6j3aq5pd2t3ikhm4ms563h5hrs%40group.calendar.google.com/events";

NSString *const galleryURL = @"charlottesvillearts.org_fci03o8i70o7ugjtchqll39ck0%40group.calendar.google.com/events";

NSString *const musicURL = @"charlottesvillearts.org_9oapvu67eckm7hkbm22p8debtc%40group.calendar.google.com/events";

NSString *const theatreURL = @"charlottesvillearts.org_ob2g1r475vou79aa2piljkivm0%40group.calendar.google.com/events";

NSString *const familyURL = @"charlottesvillearts.org_1d75dtbvjd8adgei0borv0dp30@group.calendar.google.com/events";

NSString *const filmURL = @"charlottesvillearts.org_gmbfku7u83glhstgll6p4ikeh4%40group.calendar.google.com/events";

NSString *const literaryURL = @"charlottesvillearts.org_1nvlsks9klme3evsf1cqhe2i64@group.calendar.google.com/events";

+(ARTGoogleCalendarClient *)sharedClient
{
    static ARTGoogleCalendarClient *sharedClient = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:@"https://www.googleapis.com/calendar/v3/calendars"]];
    });
    
    return sharedClient;
}

-(id)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    
    if (self)
    {
        AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
        self.requestSerializer = requestSerializer;
        self.responseSerializer = [AFJSONResponseSerializer serializer];
    }
    
    return self;
}

-(void)getAllEventsStartingWithDate:(NSDate *)date completion:(void (^)(NSArray*, NSArray*, NSError*))completion
{
    dispatch_queue_t queue = dispatch_queue_create("Event_Fetch_Dispatcher", NULL);

    NSDictionary *params = nil;
    
    if (date)
    {
        params = [self defaultParamsForDate:date];
    }
    else
    {
        params = [self defaultParamsForDate:[NSDate date]];
    }
    
    NSMutableArray *eventDictionaries =[[NSMutableArray alloc] init];
    NSArray *ARTCategories = @[@"Dance", @"Gallery", @"Music", @"Theatre", @"Venue"];
    NSMutableArray *eventCategories = [[NSMutableArray alloc] init];
    
    __block int batchCounter = 0;
    
    NSArray *urls = @[danceURL, galleryURL, musicURL, theatreURL, familyURL, filmURL, literaryURL];
    
    __weak ARTGoogleCalendarClient *weakSelf = self;
    
//retain cycle is broken below by nilling out block in recursive base case . . .
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-retain-cycles"

    
    __block void (^block)() = [^(){
        ARTGoogleCalendarClient *strongSelf = weakSelf;
        
        if (strongSelf)
        {
            [strongSelf getEventsAtURL:urls[batchCounter++] params:params completion:^(NSDictionary *result, NSError *error) {
                if (error)
                {
                    completion(nil, nil, error);
                    block = nil; //breaks the retain cycle
                }
                else
                {
                    //Prevent simultaneous access of the same array . . .
                    
                    //1.First add objects to array
                    dispatch_async(queue, ^{
                        [eventDictionaries addObjectsFromArray:[result objectForKey:@"items"]];
                        for (int i = 0; i < [[result objectForKey:@"items"] count]; i++)
                        {
                            if (batchCounter < 5)
                            {
                                [eventCategories addObject:ARTCategories[batchCounter - 1]];
                            }
                            else
                            {
                                [eventCategories addObject:ARTCategories[4]];
                            }
                        }
                    });
                    
                    //2.Then fire off next request
                    dispatch_async(queue, ^{
                        
                        if (batchCounter < 7)
                        {
                            block();
                        }
                        else
                        {
                            completion(eventDictionaries,eventCategories, nil);
                            
                            block = nil; //breaks the retain cycle
                        }
                         
                    });
                    
                }
                
            }];
        }
        else
        {
            NSError *e = [[NSError alloc] init];
            completion(nil, nil, e);
            
            block = nil; //breaks the retain cycle
        }
        
    } copy];
    
#pragma clang diagnostic pop

    block();
}

-(void)getEventsAtURL:(NSString *)url params:(NSDictionary *)params completion:(void (^)(NSDictionary *, NSError *)) completion
{
    [self GET:url parameters:params success:^(NSURLSessionDataTask *task, NSDictionary *responseObject){
        
        NSDictionary *googleResponse = (NSDictionary *)responseObject;
        
        if ([googleResponse objectForKey:@"error"])
        {
            NSError *err = [[NSError alloc] initWithDomain:NSPOSIXErrorDomain code:555 userInfo: @{NSLocalizedDescriptionKey : [NSString stringWithFormat:@"Event Fetch Error: %@", [googleResponse objectForKey:@"error"]]}];
            completion(nil, err);
        }
        else
        {
            completion(responseObject, nil);
        }
    }
      failure:^(NSURLSessionDataTask *task, NSError *error){
          completion(nil, error);
      }];
}


-(NSDictionary *)defaultParamsForDate:(NSDate *)date
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *currentDate = [NSDate date];
    NSDate *sixtyDaysLater = [NSDate dateWithTimeIntervalSince1970:([currentDate timeIntervalSince1970] + 60 * 60 * 24 * 60)];
    
    [params setObject:[[formatter stringFromDate:currentDate] stringByAppendingString:@"T00:00:00Z"] forKey:@"timeMin"];
    [params setObject:[[formatter stringFromDate:sixtyDaysLater] stringByAppendingString:@"T11:59:00Z"] forKey:@"timeMax"];
    [params setObject:@"true" forKey:@"singleEvents"];
    [params setObject:@"AIzaSyAhxSV0GM51VrCEWChB2fC5VnX_NvMpCBs" forKey:@"key"];
    
    return params;
    
}

@end
