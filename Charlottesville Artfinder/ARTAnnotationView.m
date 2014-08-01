//
//  ARTAnnotationView.m
//  Charlottesville Artfinder
//
//  Created by Alex Ramey on 7/27/14.
//  Copyright (c) 2014 HooApps. All rights reserved.
//

#import "ARTAnnotationView.h"
#import "ARTVenue.h"

@implementation ARTAnnotationView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithAnnotation:(id<MKAnnotation>)annotationParam reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotationParam reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        [self setAnnotation:annotationParam];
        [self setCanShowCallout:YES];
        
        if ([reuseIdentifier caseInsensitiveCompare:@"parking"] == NSOrderedSame)
        {
            [self setImage:[UIImage imageNamed:@"parking"]];
        }
        else
        {
            ARTVenue *venue = (ARTVenue *)annotationParam;
            
            //Left Thumbnail Accessory
            UIImageView *leftCalloutAccessoryThumbnail = [[UIImageView alloc] initWithFrame:CGRectMake(0.0,0.0,40.0,40.0)];
            [leftCalloutAccessoryThumbnail setContentMode:UIViewContentModeScaleAspectFill];
            [leftCalloutAccessoryThumbnail setImage:[UIImage imageWithData:[venue getThumbnailData]]];
            [self setLeftCalloutAccessoryView:leftCalloutAccessoryThumbnail];
            
            //Set the rightCalloutAccessoryView property to a Detail Disclosure Button
            UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            [self setRightCalloutAccessoryView:infoButton];
            
            //set image based on reuseIdentifier, which is just encoding the primary category
            if ([reuseIdentifier caseInsensitiveCompare:@"Dance"] == NSOrderedSame)
            {
                [self setImage:[UIImage imageNamed:@"dancemarker"]];
            }
            else if ([reuseIdentifier caseInsensitiveCompare:@"Gallery"] == NSOrderedSame)
            {
                [self setImage:[UIImage imageNamed:@"gallerymarker"]];
            }
            else if ([reuseIdentifier caseInsensitiveCompare:@"Music"] == NSOrderedSame)
            {
                [self setImage:[UIImage imageNamed:@"musicmarker"]];
            }
            else if ([reuseIdentifier caseInsensitiveCompare:@"Theatre"] == NSOrderedSame)
            {
                [self setImage:[UIImage imageNamed:@"theatremarker"]];
            }
            else
            {
                [self setImage:[UIImage imageNamed:@"venuemarker"]];
            }
        }
        
    }
    
    return self;
}

@end
