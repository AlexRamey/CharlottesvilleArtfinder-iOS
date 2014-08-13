//
//  ARTKMLParser.h
//  Charlottesville Artfinder
//
//  Created by Alex Ramey on 8/13/14.
//  Copyright (c) 2014 HooApps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ARTKMLParser : NSObject

+(NSDictionary *)overlaysFromKMLAtPath:(NSURL *)path;

@end
