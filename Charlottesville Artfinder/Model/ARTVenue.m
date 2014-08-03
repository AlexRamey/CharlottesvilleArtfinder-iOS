#import "ARTVenue.h"
#import "ARTObjectStore.h"
#import <CoreLocation/CoreLocation.h>

@interface ARTVenue ()

// Private interface goes here.

@end


@implementation ARTVenue

// Custom logic goes here.

-(void)createThumbnailData
{
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.localImagePath]];
    
    UIImage *image = [UIImage imageWithData:imageData];
    
    CGSize origImageSize = [image size];
    
    //The rectangle of the thumbnail
    CGRect newRect = CGRectMake(0,0,65,65);
    
    //Figure out a scaling ratio to make sure we maintain the same aspect ratio
    float ratio = MAX(newRect.size.width / origImageSize.width,
                      newRect.size.height / origImageSize.height);
    
    //Create a transparent bitmap context with a scaling factor
    //equal to that of the screen
    UIGraphicsBeginImageContextWithOptions(newRect.size,NO,0.0);
    
    //Create a path that is a rounded rectangle
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:newRect cornerRadius:5.0];
    
    //Make all subsequent drawing clip to this rounded rectangle
    [path addClip];
    
    //Center the image in the thumbnail rectangle
    CGRect projectRect;
    projectRect.size.width = ratio * origImageSize.width;
    projectRect.size.height = ratio * origImageSize.height;
    projectRect.origin.x = (newRect.size.width - projectRect.size.width) / 2.0;
    projectRect.origin.y = (newRect.size.height - projectRect.size.height) / 2.0;
    
    //Draw the image on it
    [image drawInRect:projectRect];
    
    //Get the image from the image context, keep it as our thumbnail
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //Get the PNG representation of the image and save it to Core Data
    NSData *data = UIImagePNGRepresentation(smallImage);
    
    self.thumbnailData = data;
    
    //Cleanup image context resources, we're done
    UIGraphicsEndImageContext();

}

-(NSData *)getThumbnailData
{
    NSData *data = self.thumbnailData;
    
    if (!data)
    {
        NSString *category = [self getPrimaryCategory];
        
        if ([category caseInsensitiveCompare:@"Dance"] == NSOrderedSame)
        {
            data = UIImageJPEGRepresentation([UIImage imageNamed:@"dancedefault"], .5);
        }
        else if ([category caseInsensitiveCompare:@"Gallery"] == NSOrderedSame)
        {
            data = UIImageJPEGRepresentation([UIImage imageNamed:@"gallerydefault"], .5);
        }
        else if ([category caseInsensitiveCompare:@"Music"] == NSOrderedSame)
        {
            data = UIImageJPEGRepresentation([UIImage imageNamed:@"musicdefault"], .5);
        }
        else if ([category caseInsensitiveCompare:@"Theatre"] == NSOrderedSame)
        {
            data = UIImageJPEGRepresentation([UIImage imageNamed:@"theatredefault"], .5);
        }
        else
        {
            data = UIImageJPEGRepresentation([UIImage imageNamed:@"venuedefault"], .5);
        }
    }
    
    return data;
}

-(NSString *)getPrimaryCategory
{
    NSString *category = self.primaryCategory;
    
    if ([category caseInsensitiveCompare:@"Theater"] == NSOrderedSame)
    {
        return @"Theatre";
    }
    
    NSArray *primaryCategories = [ARTObjectStore primaryCategories];
    
    for (NSString *str in primaryCategories)
    {
        if ([category caseInsensitiveCompare:str] == NSOrderedSame)
        {
            return str;
        }
    }
    
    return @"Venue";
}

#pragma mark - MKAnnotation Protocol Properties

-(CLLocationCoordinate2D)coordinate
{
    return CLLocationCoordinate2DMake(self.latitudeValue, self.longitudeValue);
}

-(NSString *)title
{
    return self.organizationName;
}

-(NSString *)subtitle
{
    return self.primaryCategory;
}

-(void)setSubtitle:(NSString *)subtitle
{
    return;
}

@end
