//
//  ARTKMLParser.m
//  Charlottesville Artfinder
//
//  Created by Alex Ramey on 8/13/14.
//  Copyright (c) 2014 HooApps. All rights reserved.
//

#import "ARTKMLParser.h"
#import <MapKit/MapKit.h>
#import "DDXML.h"

@implementation ARTKMLParser

+(NSDictionary *)overlaysFromKMLAtPath:(NSURL *)path
{
    NSError *error = [[NSError alloc] init];
    
    NSString *data = [NSString stringWithContentsOfURL:path encoding:NSUTF8StringEncoding error:&error];
    
    if (!data)
    {
        //bad path . . .
        return nil;
    }
    
    //option 1 << 10 is for NSXMLDocumentTidyXML
    DDXMLDocument *growmarkRegionsXML = [[DDXMLDocument alloc] initWithXMLString:data options:1 << 10 error:nil];
    
    DDXMLElement *root = [growmarkRegionsXML rootElement];
    
    NSArray *documentArray = [root elementsForName:@"Document"];
    
    NSArray *folderArray = [documentArray[0] elementsForName:@"Folder"];
    
    NSArray *placemarkArray = [folderArray[0] elementsForName:@"Placemark"];
    
    NSMutableArray *regionNames = [[NSMutableArray alloc] init];
    
    NSMutableArray *regionCoordinates = [[NSMutableArray alloc] init];
    
    for (DDXMLElement *element in placemarkArray)
    {
        [regionNames addObject:[[element elementsForName:@"name"][0] stringValue]];
        [regionCoordinates addObject:[[[[[[element elementsForName:@"Polygon"][0] elementsForName:@"outerBoundaryIs"][0] elementsForName:@"LinearRing"][0] elementsForName:@"coordinates"][0] stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    }
    
    NSMutableDictionary *overlays = [[NSMutableDictionary alloc] init];
    
    int loopCounter = 0;
    
    for (NSString *coordinateSet in regionCoordinates)
    {
        NSArray *points = [coordinateSet componentsSeparatedByString:@" "];
        
        NSMutableArray *pointsWithoutAltitude = [[NSMutableArray alloc] init];
        
        for (NSString *coordinatePoint in points)
        {
            NSString *trimmedAltitudePoint = [coordinatePoint substringToIndex:[coordinatePoint rangeOfString:@"," options: NSBackwardsSearch].location];
            [pointsWithoutAltitude addObject: trimmedAltitudePoint];
        }
        
        //Subtract 1 b/c the last point is the same as the first point
        int numPoints = [[NSNumber numberWithUnsignedLong:[pointsWithoutAltitude count]] intValue] - 1;
        CLLocationCoordinate2D mapPoints[numPoints];
        
        int indexCounter = 0;
        for (NSString *coordinatePointWithoutAltitude in pointsWithoutAltitude)
        {
            if (indexCounter < numPoints) //Ensures that last point is left off
            {
                NSArray *latLng = [coordinatePointWithoutAltitude componentsSeparatedByString:@","];
                mapPoints[indexCounter++] = CLLocationCoordinate2DMake([latLng[1] doubleValue], [latLng[0] doubleValue]);
            }
        }
        
        MKPolygon *polygon = [MKPolygon polygonWithCoordinates:mapPoints count:numPoints];
        [overlays setObject:polygon forKey:[regionNames objectAtIndex:loopCounter++]];
    }
    
    //overlays is an NSMutableDictionary that maps regionNames to MKPolygons
    return overlays;
}

@end
