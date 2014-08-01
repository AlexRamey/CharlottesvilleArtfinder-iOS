//
//  ARTGoogleCalendarClient.h
//  Charlottesville Artfinder
//
//  Created by Alex Ramey on 7/23/14.
//  Copyright (c) 2014 HooApps. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface ARTGoogleCalendarClient : AFHTTPSessionManager

+(ARTGoogleCalendarClient *)sharedClient;

-(void)getAllEventsStartingWithDate:(NSDate *)date completion:(void(^)(NSArray*,NSArray*,NSError*))completion;

@end
