//
//  ARTTransportationAnnotation.h
//  Charlottesville Artfinder
//
//  Created by Alex Ramey on 8/6/14.
//  Copyright (c) 2014 HooApps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ARTTransportationAnnotation : NSObject <MKAnnotation>

// A new designated initializer
-(id)initWithCoordinate:(CLLocationCoordinate2D)c title:(NSString *)t;

//Required property from MKAnnotation
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

//Optional property from MKAnnotation
@property (nonatomic, copy) NSString *title;

@end
