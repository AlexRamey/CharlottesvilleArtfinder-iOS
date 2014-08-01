//
//  ARTURLCache.m
//  Charlottesville Artfinder
//
//  Created by Alex Ramey on 7/23/14.
//  Copyright (c) 2014 HooApps. All rights reserved.
//

#import "ARTURLCache.h"

@implementation ARTURLCache

-(void)storeCachedResponse:(NSCachedURLResponse *)cachedResponse forRequest:(NSURLRequest *)request
{
    //do nothing (prevents automatic caching)
}

@end
