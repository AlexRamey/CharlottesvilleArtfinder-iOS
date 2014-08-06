//
//  ARTParseRESTClient.m
//  Charlottesville Artfinder
//
//  Created by Alex Ramey on 7/23/14.
//  Copyright (c) 2014 HooApps. All rights reserved.
//

#import "ARTParseRESTClient.h"

@implementation ARTParseRESTClient

+(ARTParseRESTClient *)sharedClient
{
    static ARTParseRESTClient *sharedClient = nil;
    
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
        [requestSerializer setValue: @"u6ZoFcQQN1ZIa9YHj8GAQyzifHJpf2xVpifaJxQZ" forHTTPHeaderField:@"X-Parse-Application-Id"];
        [requestSerializer setValue: @"ThokAo7zg4FzoEba6YSuTpaLblRTxxcvtgKBQ96K" forHTTPHeaderField:@"X-Parse-REST-API-Key"];
        self.requestSerializer = requestSerializer;
        self.responseSerializer = [AFJSONResponseSerializer serializer];
    }
    
    return self;
}

-(void)getAllVenuesUpdatedSinceDate:(NSDate *)date completion:(void (^)(NSDictionary *, NSError *))completion
{
    NSMutableDictionary *params = [self defaultParams];
    
    if (date)
    {
        NSString *JSONQueryArgument = [NSString stringWithFormat:@"{%@}",[self paramsForRecordsSinceDate:date]];
        [params setObject:JSONQueryArgument forKey:@"where"];
    }
    
    [self GET:@"/1/classes/ArtVenue" parameters: params
      success:^(NSURLSessionDataTask *task, id responseObject)
     {
         if (completion)
         {
             NSDictionary *parseResponse = (NSDictionary *)responseObject;
             
             if ([parseResponse objectForKey:@"error"])
             {
                 NSError *err = [[NSError alloc] initWithDomain:NSPOSIXErrorDomain code:555 userInfo: @{NSLocalizedDescriptionKey : [NSString stringWithFormat:@"Parse JobListing Fetch Error: %@", [parseResponse objectForKey:@"error"]]}];
                 completion(nil, err);
             }
             else
             {
                 completion(responseObject, nil);
             }
         }
     }
      failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         if (completion)
         {
             completion(nil, error);
         }
     }];
}

-(void)getPCAInformationWithCompletion:(void (^)(NSDictionary *, NSError *))completion
{
    [self GET:@"1/classes/PCA" parameters:nil
      success:^(NSURLSessionDataTask *task, id responseObject) {
          if (completion)
          {
              NSDictionary *parseResponse = (NSDictionary *)responseObject;
              
              if ([parseResponse objectForKey:@"error"])
              {
                  NSError *err = [[NSError alloc] initWithDomain:NSPOSIXErrorDomain code:555 userInfo: @{NSLocalizedDescriptionKey : [NSString stringWithFormat:@"Parse JobListing Fetch Error: %@", [parseResponse objectForKey:@"error"]]}];
                  completion(nil, err);
              }
              else
              {
                  completion(responseObject, nil);
              }
          }
      }
      failure:^(NSURLSessionDataTask *task, NSError *error) {
          if (completion)
          {
              completion(nil, error);
          }
      }];
}

-(void)downloadFileFromURL:(NSURL *)remoteURL toPath:(NSURL *)localURL completion:(void (^)(NSURLResponse *, NSURL *, NSError *))completion
{
    NSURLRequest *request = [NSURLRequest requestWithURL:remoteURL];
    
    NSURLSessionDownloadTask *task = [self downloadTaskWithRequest:request progress:nil
                                                       destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
                                                           return localURL;
                                                       }
                                                 completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
                                                     if (completion)
                                                     {
                                                         if (error)
                                                         {
                                                             completion(nil,nil,error);
                                                         }
                                                         else
                                                         {
                                                             completion(response, filePath, nil);
                                                         }
                                                     }
                                                 }];
    
    [task resume];

}

-(NSString *)paramsForRecordsSinceDate:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    
    NSString *ISO8601Date = [formatter stringFromDate:date];
    
    NSString *JSONQueryArgument = [NSString stringWithFormat:@"\"updatedAt\" : {\"$gt\" : {\"__type\":\"Date\",\"iso\":\"%@\"}}", ISO8601Date];
    
    return JSONQueryArgument;
}

-(NSMutableDictionary *)defaultParams
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    [params setObject:@"1000" forKey:@"limit"];
    
    return params;
}

@end
