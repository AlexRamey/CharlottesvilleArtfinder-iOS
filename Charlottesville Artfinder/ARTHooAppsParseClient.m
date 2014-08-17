//
//  ARTHooAppsParseClient.m
//  Charlottesville Artfinder
//
//  Created by Alex Ramey on 8/16/14.
//  Copyright (c) 2014 HooApps. All rights reserved.
//

#import "ARTHooAppsParseClient.h"
#import "AppDelegate.h"

@implementation ARTHooAppsParseClient

+(ARTHooAppsParseClient *)sharedClient
{
    static ARTHooAppsParseClient *sharedClient = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:@"https://api.parse.com/"]];
    });
    
    return sharedClient;
}

-(id)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    
    if (self)
    {
        AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
        [requestSerializer setValue: @"myPYEL3FtHj0mlQm8jlFfbiEsoZHxW3dos9c2UdR" forHTTPHeaderField:@"X-Parse-Application-Id"];
        [requestSerializer setValue: @"B9T1wZXXjFPn7bXhDLrDPD0BPBx4kcEVjhhFoKwl" forHTTPHeaderField:@"X-Parse-REST-API-Key"];
        self.requestSerializer = requestSerializer;
        self.responseSerializer = [AFJSONResponseSerializer serializer];
    }
    
    return self;
}

-(void)loadAttributionURLWithCompletion:(void (^)(NSError *))completion
{
    [self GET:@"/1/classes/WebPageURL" parameters: nil
      success:^(NSURLSessionDataTask *task, id responseObject)
     {
         if (completion)
         {
             NSDictionary *parseResponse = (NSDictionary *)responseObject;
             
             if ([parseResponse objectForKey:@"error"])
             {
                 NSError *err = [[NSError alloc] initWithDomain:NSPOSIXErrorDomain code:555 userInfo: @{NSLocalizedDescriptionKey : [NSString stringWithFormat:@"Parse JobListing Fetch Error: %@", [parseResponse objectForKey:@"error"]]}];
                 completion(err);
             }
             else
             {
                 NSArray *results = [parseResponse objectForKey:@"results"];
                 NSDictionary *firstResult = results[0];
                 NSString *url = [firstResult objectForKey:@"URL"];
                 [[NSUserDefaults standardUserDefaults] setObject:url forKey:ART_ATTRIBUTION_URL_KEY];
                 completion(nil);
             }
         }
     }
      failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         if (completion)
         {
             completion(error);
         }
     }];
}


@end
