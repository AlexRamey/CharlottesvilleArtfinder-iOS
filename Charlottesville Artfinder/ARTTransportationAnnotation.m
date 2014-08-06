//
//  ARTTransportationAnnotation.m
//  Charlottesville Artfinder
//
//  Created by Alex Ramey on 8/6/14.
//  Copyright (c) 2014 HooApps. All rights reserved.
//

#import "ARTTransportationAnnotation.h"

@implementation ARTTransportationAnnotation

-(id)initWithCoordinate:(CLLocationCoordinate2D)c title:(NSString *)t
{
    self = [super init];
    
    if (self)
    {
        _coordinate = c;
        _title = t;
    }
    return self;
}

@end
