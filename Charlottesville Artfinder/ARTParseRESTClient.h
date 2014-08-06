//
//  ARTParseRESTClient.h
//  Charlottesville Artfinder
//
//  Created by Alex Ramey on 7/23/14.
//  Copyright (c) 2014 HooApps. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface ARTParseRESTClient : AFHTTPSessionManager

+(ARTParseRESTClient *)sharedClient;

-(void)getAllVenuesUpdatedSinceDate:(NSDate *)date completion:(void(^)(NSDictionary*, NSError*))completion;

-(void)getPCAInformationWithCompletion:(void(^)(NSDictionary*, NSError*))completion;

-(void)downloadFileFromURL:(NSURL *)remoteURL toPath:(NSURL *)localURL completion:(void (^)(NSURLResponse *response, NSURL *filePath, NSError *error)) completion;

@end
