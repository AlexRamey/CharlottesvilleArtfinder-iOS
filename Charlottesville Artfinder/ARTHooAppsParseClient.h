//
//  ARTHooAppsParseClient.h
//  Charlottesville Artfinder
//
//  Created by Alex Ramey on 8/16/14.
//  Copyright (c) 2014 HooApps. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface ARTHooAppsParseClient : AFHTTPSessionManager

+(ARTHooAppsParseClient *)sharedClient;

-(void)loadAttributionURLWithCompletion:(void (^)(NSError *))completion;

@end
